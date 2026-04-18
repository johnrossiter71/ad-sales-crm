-- ============================================================
-- User roles + RLS hardening for the Ad Sales CRM
-- Run in Supabase SQL editor. Assumes auth.users already exists.
-- ============================================================

CREATE TABLE IF NOT EXISTS user_roles (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role text NOT NULL DEFAULT 'sales_rep'
    CHECK (role IN ('admin','sales_lead','sales_rep','finance')),
  sales_rep_name text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;

-- Anyone authenticated can read roles (needed so the app knows the
-- current user's role); only admins can write.
CREATE POLICY "Anyone authenticated can read roles"
  ON user_roles FOR SELECT TO authenticated USING (true);

CREATE POLICY "Admins can insert roles"
  ON user_roles FOR INSERT TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'admin'));

CREATE POLICY "Admins can update roles"
  ON user_roles FOR UPDATE TO authenticated
  USING (EXISTS (SELECT 1 FROM user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'admin'))
  WITH CHECK (EXISTS (SELECT 1 FROM user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'admin'));

CREATE POLICY "Admins can delete roles"
  ON user_roles FOR DELETE TO authenticated
  USING (EXISTS (SELECT 1 FROM user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'admin'));

-- Helper: current user's role
CREATE OR REPLACE FUNCTION current_user_role()
RETURNS text LANGUAGE sql SECURITY DEFINER AS $$
  SELECT role FROM user_roles WHERE user_id = auth.uid()
$$;

-- ============================================================
-- Tighten opportunities RLS:
-- - admin / sales_lead: full access
-- - finance: read-only
-- - sales_rep: read everything (so the team view works) but
--   write only on opportunities where sales_rep matches their
--   sales_rep_name
-- ============================================================

DROP POLICY IF EXISTS "Authenticated users can insert opportunities" ON opportunities;
DROP POLICY IF EXISTS "Authenticated users can update opportunities" ON opportunities;
DROP POLICY IF EXISTS "Authenticated users can delete opportunities" ON opportunities;

CREATE POLICY "Roles control opportunity insert"
  ON opportunities FOR INSERT TO authenticated
  WITH CHECK (
    current_user_role() IN ('admin','sales_lead')
    OR (current_user_role() = 'sales_rep'
        AND sales_rep = (SELECT sales_rep_name FROM user_roles WHERE user_id = auth.uid()))
  );

CREATE POLICY "Roles control opportunity update"
  ON opportunities FOR UPDATE TO authenticated
  USING (
    current_user_role() IN ('admin','sales_lead')
    OR (current_user_role() = 'sales_rep'
        AND sales_rep = (SELECT sales_rep_name FROM user_roles WHERE user_id = auth.uid()))
  )
  WITH CHECK (
    current_user_role() IN ('admin','sales_lead')
    OR (current_user_role() = 'sales_rep'
        AND sales_rep = (SELECT sales_rep_name FROM user_roles WHERE user_id = auth.uid()))
  );

CREATE POLICY "Roles control opportunity delete"
  ON opportunities FOR DELETE TO authenticated
  USING (current_user_role() IN ('admin','sales_lead'));

-- Bootstrap the first admin manually:
-- INSERT INTO user_roles (user_id, role, sales_rep_name)
-- VALUES ('<your-auth-user-id>','admin', NULL);
