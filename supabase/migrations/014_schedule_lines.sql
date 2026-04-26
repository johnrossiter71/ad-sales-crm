-- ============================================================
-- Schedule lines (VisualForce-style revenue schedule)
-- Represents per-channel/per-region revenue lines beneath an opportunity.
-- Run in Supabase SQL editor.
-- ============================================================

CREATE TABLE IF NOT EXISTS schedule_lines (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  opportunity_id uuid REFERENCES opportunities(id) ON DELETE CASCADE,
  schedule_name text NOT NULL,
  channel text,
  region text,
  currency text DEFAULT 'USD',
  notes text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_schedule_lines_opp ON schedule_lines(opportunity_id);

ALTER TABLE forecast_entries
  ADD COLUMN IF NOT EXISTS schedule_line_id uuid REFERENCES schedule_lines(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_forecast_schedule ON forecast_entries(schedule_line_id);

ALTER TABLE schedule_lines ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read schedule_lines"
  ON schedule_lines FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert schedule_lines"
  ON schedule_lines FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update schedule_lines"
  ON schedule_lines FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users can delete schedule_lines"
  ON schedule_lines FOR DELETE TO authenticated USING (true);
