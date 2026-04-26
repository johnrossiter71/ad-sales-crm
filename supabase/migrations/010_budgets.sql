-- ============================================================
-- Rep budgets / annual targets
-- Per-AE annual targets with monthly breakdown.
-- Run in Supabase SQL editor.
-- ============================================================

CREATE TABLE IF NOT EXISTS rep_budgets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  sales_rep text NOT NULL,
  fiscal_year text NOT NULL,
  annual_target numeric NOT NULL DEFAULT 0,
  jan numeric DEFAULT 0,
  feb numeric DEFAULT 0,
  mar numeric DEFAULT 0,
  apr numeric DEFAULT 0,
  may numeric DEFAULT 0,
  jun numeric DEFAULT 0,
  jul numeric DEFAULT 0,
  aug numeric DEFAULT 0,
  sep numeric DEFAULT 0,
  oct numeric DEFAULT 0,
  nov numeric DEFAULT 0,
  dec numeric DEFAULT 0,
  notes text,
  created_by uuid REFERENCES auth.users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(sales_rep, fiscal_year)
);

CREATE INDEX IF NOT EXISTS idx_rep_budgets_rep ON rep_budgets(sales_rep);
CREATE INDEX IF NOT EXISTS idx_rep_budgets_year ON rep_budgets(fiscal_year);

ALTER TABLE rep_budgets ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read rep_budgets"
  ON rep_budgets FOR SELECT TO authenticated USING (true);

CREATE POLICY "Admins/leads can insert rep_budgets"
  ON rep_budgets FOR INSERT TO authenticated
  WITH CHECK (current_user_role() IN ('admin','sales_lead'));

CREATE POLICY "Admins/leads can update rep_budgets"
  ON rep_budgets FOR UPDATE TO authenticated
  USING (current_user_role() IN ('admin','sales_lead'))
  WITH CHECK (current_user_role() IN ('admin','sales_lead'));

CREATE POLICY "Admins/leads can delete rep_budgets"
  ON rep_budgets FOR DELETE TO authenticated
  USING (current_user_role() IN ('admin','sales_lead'));
