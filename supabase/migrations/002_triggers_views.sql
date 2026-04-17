-- ============================================================
-- Triggers and Views
-- ============================================================

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_opportunities_updated
  BEFORE UPDATE ON opportunities
  FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trg_forecast_updated
  BEFORE UPDATE ON forecast_entries
  FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER trg_advertisers_updated
  BEFORE UPDATE ON advertisers
  FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- Auto-set probability when stage changes
CREATE OR REPLACE FUNCTION sync_stage_probability()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.stage IS DISTINCT FROM OLD.stage THEN
    SELECT probability INTO NEW.probability
    FROM stage_settings
    WHERE stage_name = NEW.stage;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_stage_probability
  BEFORE UPDATE ON opportunities
  FOR EACH ROW EXECUTE FUNCTION sync_stage_probability();

-- Also set probability on INSERT based on stage
CREATE OR REPLACE FUNCTION set_initial_probability()
RETURNS TRIGGER AS $$
BEGIN
  SELECT probability INTO NEW.probability
  FROM stage_settings
  WHERE stage_name = NEW.stage;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_initial_probability
  BEFORE INSERT ON opportunities
  FOR EACH ROW EXECUTE FUNCTION set_initial_probability();

-- ============================================================
-- Views
-- ============================================================

-- Enriched opportunities view with computed fields
CREATE OR REPLACE VIEW opportunities_enriched AS
SELECT
  o.*,
  o.amount * o.probability AS weighted_value,
  EXTRACT(DAY FROM now() - o.created_at)::integer AS opportunity_age,
  EXTRACT(DAY FROM now() - o.updated_at)::integer AS days_in_stage,
  ss.max_days_stall,
  CASE
    WHEN ss.max_days_stall IS NOT NULL
     AND EXTRACT(DAY FROM now() - o.updated_at)::integer > ss.max_days_stall
     AND o.stage NOT IN ('Closed Won','Closed Lost')
    THEN true
    ELSE false
  END AS is_stalled
FROM opportunities o
LEFT JOIN stage_settings ss ON ss.stage_name = o.stage;

-- Pipeline summary view
CREATE OR REPLACE VIEW pipeline_summary AS
SELECT
  COUNT(*) FILTER (WHERE stage NOT IN ('Closed Won','Closed Lost')) AS active_deals,
  COALESCE(SUM(amount) FILTER (WHERE stage NOT IN ('Closed Won','Closed Lost')), 0) AS total_pipeline,
  COALESCE(SUM(amount * probability) FILTER (WHERE stage NOT IN ('Closed Won','Closed Lost')), 0) AS weighted_pipeline,
  COUNT(*) FILTER (WHERE stage = 'Closed Won') AS won_count,
  COALESCE(SUM(amount) FILTER (WHERE stage = 'Closed Won'), 0) AS won_revenue,
  COUNT(*) FILTER (WHERE stage = 'Closed Lost') AS lost_count,
  COALESCE(SUM(amount) FILTER (WHERE stage = 'Closed Lost'), 0) AS lost_revenue
FROM opportunities;

-- Monthly forecast aggregation view
CREATE OR REPLACE VIEW forecast_monthly AS
SELECT
  fe.month,
  SUM(fe.forecast_amount) AS total_forecast,
  SUM(fe.actual_amount) AS total_actual,
  SUM(fe.actual_amount) - SUM(fe.forecast_amount) AS variance,
  COUNT(DISTINCT fe.opportunity_id) AS deal_count
FROM forecast_entries fe
GROUP BY fe.month
ORDER BY fe.month;

-- Rep performance view
CREATE OR REPLACE VIEW rep_performance AS
SELECT
  o.sales_rep,
  COUNT(*) FILTER (WHERE o.stage NOT IN ('Closed Won','Closed Lost')) AS active_deals,
  COALESCE(SUM(o.amount) FILTER (WHERE o.stage NOT IN ('Closed Won','Closed Lost')), 0) AS pipeline_value,
  COALESCE(SUM(o.amount * o.probability) FILTER (WHERE o.stage NOT IN ('Closed Won','Closed Lost')), 0) AS weighted_pipeline,
  COUNT(*) FILTER (WHERE o.stage = 'Closed Won') AS deals_won,
  COALESCE(SUM(o.amount) FILTER (WHERE o.stage = 'Closed Won'), 0) AS revenue_won,
  COUNT(*) FILTER (WHERE o.stage = 'Closed Lost') AS deals_lost
FROM opportunities o
WHERE o.sales_rep IS NOT NULL
GROUP BY o.sales_rep;
