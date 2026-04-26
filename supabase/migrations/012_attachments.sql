-- ============================================================
-- Deal attachments
-- File attachments per opportunity (rate cards, proposals, etc.).
-- Run in Supabase SQL editor.
-- Also create a Supabase Storage bucket called "deal-files" (public or private).
-- ============================================================

CREATE TABLE IF NOT EXISTS deal_attachments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  opportunity_id uuid REFERENCES opportunities(id) ON DELETE CASCADE,
  file_type text NOT NULL CHECK (file_type IN ('rate_card','proposal','presentation','contract','other')),
  file_name text NOT NULL,
  file_url text NOT NULL,
  file_size integer,
  uploaded_by text,
  notes text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_deal_attachments_opp ON deal_attachments(opportunity_id);
CREATE INDEX IF NOT EXISTS idx_deal_attachments_type ON deal_attachments(file_type);

ALTER TABLE deal_attachments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read deal_attachments"
  ON deal_attachments FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert deal_attachments"
  ON deal_attachments FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update deal_attachments"
  ON deal_attachments FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users can delete deal_attachments"
  ON deal_attachments FOR DELETE TO authenticated USING (true);
