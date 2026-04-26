-- ============================================================
-- Multi-Role Deal Routing
-- Adds secondary owner, planner, yield, and BPI roles to deals
-- Run in Supabase SQL editor.
-- ============================================================

ALTER TABLE opportunities
  ADD COLUMN IF NOT EXISTS secondary_owner text,
  ADD COLUMN IF NOT EXISTS planner text,
  ADD COLUMN IF NOT EXISTS yield_contact text,
  ADD COLUMN IF NOT EXISTS bpi_contact text;

CREATE INDEX IF NOT EXISTS idx_opportunities_planner ON opportunities(planner);
CREATE INDEX IF NOT EXISTS idx_opportunities_yield ON opportunities(yield_contact);
CREATE INDEX IF NOT EXISTS idx_opportunities_bpi ON opportunities(bpi_contact);
