-- ============================================================
-- Programmatic columns on opportunities (Tier 3 PMP deals)
-- Run this against Supabase before relying on the columns.
-- All columns are nullable so existing rows are unaffected.
-- ============================================================

ALTER TABLE opportunities
  ADD COLUMN IF NOT EXISTS pmp_name text,
  ADD COLUMN IF NOT EXISTS cpm_floor numeric,
  ADD COLUMN IF NOT EXISTS cpm_actual numeric,
  ADD COLUMN IF NOT EXISTS impressions_target bigint,
  ADD COLUMN IF NOT EXISTS impressions_delivered bigint,
  ADD COLUMN IF NOT EXISTS programmatic_status text
    CHECK (programmatic_status IS NULL OR programmatic_status IN ('Active','Paused','Ended'));

COMMENT ON COLUMN opportunities.cpm_floor IS 'Tier 3 only — minimum CPM in deal currency';
COMMENT ON COLUMN opportunities.cpm_actual IS 'Tier 3 only — current realised CPM';
COMMENT ON COLUMN opportunities.impressions_target IS 'Tier 3 only — committed impressions';
COMMENT ON COLUMN opportunities.impressions_delivered IS 'Tier 3 only — delivered impressions to date';
COMMENT ON COLUMN opportunities.programmatic_status IS 'Tier 3 only — Active/Paused/Ended';
