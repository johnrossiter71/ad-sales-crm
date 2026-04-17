-- ============================================================
-- Row Level Security — permissive for the team to start
-- ============================================================

ALTER TABLE opportunities ENABLE ROW LEVEL SECURITY;
ALTER TABLE forecast_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE revenue_actuals ENABLE ROW LEVEL SECURITY;
ALTER TABLE advertisers ENABLE ROW LEVEL SECURITY;
ALTER TABLE activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE stage_settings ENABLE ROW LEVEL SECURITY;

-- Permissive policies: any authenticated user can read/write all data
-- Tighten these later as roles are defined

CREATE POLICY "Authenticated users can read opportunities"
  ON opportunities FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert opportunities"
  ON opportunities FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update opportunities"
  ON opportunities FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users can delete opportunities"
  ON opportunities FOR DELETE TO authenticated USING (true);

CREATE POLICY "Authenticated users can read forecasts"
  ON forecast_entries FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert forecasts"
  ON forecast_entries FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update forecasts"
  ON forecast_entries FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users can delete forecasts"
  ON forecast_entries FOR DELETE TO authenticated USING (true);

CREATE POLICY "Authenticated users can read actuals"
  ON revenue_actuals FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert actuals"
  ON revenue_actuals FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update actuals"
  ON revenue_actuals FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Authenticated users can read advertisers"
  ON advertisers FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert advertisers"
  ON advertisers FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update advertisers"
  ON advertisers FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Authenticated users can read activities"
  ON activities FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert activities"
  ON activities FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Anyone can read stage settings"
  ON stage_settings FOR SELECT TO authenticated USING (true);
