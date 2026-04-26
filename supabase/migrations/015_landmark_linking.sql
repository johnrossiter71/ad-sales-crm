-- ============================================================
-- Landmark linking
-- Adds a campaign-level link from opportunities to Landmark + advertiser_name on actuals.
-- Run in Supabase SQL editor.
-- ============================================================

ALTER TABLE opportunities
  ADD COLUMN IF NOT EXISTS landmark_campaign_id text;

ALTER TABLE revenue_actuals
  ADD COLUMN IF NOT EXISTS advertiser_name text,
  ADD COLUMN IF NOT EXISTS landmark_campaign_id text;

CREATE INDEX IF NOT EXISTS idx_opportunities_landmark ON opportunities(landmark_campaign_id);
CREATE INDEX IF NOT EXISTS idx_actuals_landmark ON revenue_actuals(landmark_campaign_id);
CREATE INDEX IF NOT EXISTS idx_actuals_advertiser ON revenue_actuals(advertiser_name);
