-- ============================================================
-- Forecast period management
-- Per-month forecast cycle status with deadlines and close approval.
-- Run in Supabase SQL editor.
-- ============================================================

CREATE TABLE IF NOT EXISTS forecast_periods (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  month text UNIQUE NOT NULL,
  status text DEFAULT 'open'
    CHECK (status IN ('open','actuals_due','forecast_due','pending_approval','closed')),
  actuals_deadline date,
  forecast_deadline date,
  approved_by text,
  approved_at timestamptz,
  closed_at timestamptz,
  notes text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_forecast_periods_status ON forecast_periods(status);

ALTER TABLE forecast_periods ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read forecast_periods"
  ON forecast_periods FOR SELECT TO authenticated USING (true);

CREATE POLICY "Admins/leads can insert forecast_periods"
  ON forecast_periods FOR INSERT TO authenticated
  WITH CHECK (current_user_role() IN ('admin','sales_lead'));

CREATE POLICY "Admins/leads can update forecast_periods"
  ON forecast_periods FOR UPDATE TO authenticated
  USING (current_user_role() IN ('admin','sales_lead'))
  WITH CHECK (current_user_role() IN ('admin','sales_lead'));

CREATE POLICY "Admins/leads can delete forecast_periods"
  ON forecast_periods FOR DELETE TO authenticated
  USING (current_user_role() IN ('admin','sales_lead'));
