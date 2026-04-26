-- ============================================================
-- Contact management
-- Structured contact records linked to advertisers/agencies and deals.
-- Run in Supabase SQL editor.
-- ============================================================

CREATE TABLE IF NOT EXISTS contacts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name text NOT NULL,
  last_name text NOT NULL,
  email text,
  phone text,
  title text,
  advertiser_id uuid REFERENCES advertisers(id) ON DELETE SET NULL,
  agency_id uuid,
  agency_name text,
  is_primary boolean DEFAULT false,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_contacts_advertiser ON contacts(advertiser_id);
CREATE INDEX IF NOT EXISTS idx_contacts_name ON contacts(last_name, first_name);
CREATE INDEX IF NOT EXISTS idx_contacts_email ON contacts(email);

CREATE TABLE IF NOT EXISTS deal_contacts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  opportunity_id uuid REFERENCES opportunities(id) ON DELETE CASCADE,
  contact_id uuid REFERENCES contacts(id) ON DELETE CASCADE,
  role text DEFAULT 'Primary',
  created_at timestamptz DEFAULT now(),
  UNIQUE(opportunity_id, contact_id)
);

CREATE INDEX IF NOT EXISTS idx_deal_contacts_opp ON deal_contacts(opportunity_id);
CREATE INDEX IF NOT EXISTS idx_deal_contacts_contact ON deal_contacts(contact_id);

ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE deal_contacts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read contacts"
  ON contacts FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert contacts"
  ON contacts FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update contacts"
  ON contacts FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users can delete contacts"
  ON contacts FOR DELETE TO authenticated USING (true);

CREATE POLICY "Authenticated users can read deal_contacts"
  ON deal_contacts FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert deal_contacts"
  ON deal_contacts FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update deal_contacts"
  ON deal_contacts FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users can delete deal_contacts"
  ON deal_contacts FOR DELETE TO authenticated USING (true);
