-- ============================================================
-- Exchange rate handling on opportunities
-- Tracks the local currency amount and FX rate used for USD conversion.
-- Run in Supabase SQL editor.
-- ============================================================

ALTER TABLE opportunities
  ADD COLUMN IF NOT EXISTS local_currency text,
  ADD COLUMN IF NOT EXISTS local_amount numeric,
  ADD COLUMN IF NOT EXISTS exchange_rate numeric,
  ADD COLUMN IF NOT EXISTS exchange_rate_date date;

CREATE INDEX IF NOT EXISTS idx_opportunities_local_currency ON opportunities(local_currency);
