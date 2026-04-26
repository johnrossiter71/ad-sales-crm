-- ============================================================
-- Configurable markets reference table
-- Replaces the hard-coded CHECK constraint on opportunities.market.
-- Run in Supabase SQL editor.
-- ============================================================

CREATE TABLE IF NOT EXISTS markets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  market_name text UNIQUE NOT NULL,
  region text,
  currency text,
  is_active boolean DEFAULT true,
  sort_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_markets_active ON markets(is_active, sort_order);

ALTER TABLE markets ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read markets"
  ON markets FOR SELECT TO authenticated USING (true);

CREATE POLICY "Admins can insert markets"
  ON markets FOR INSERT TO authenticated
  WITH CHECK (current_user_role() = 'admin');

CREATE POLICY "Admins can update markets"
  ON markets FOR UPDATE TO authenticated
  USING (current_user_role() = 'admin')
  WITH CHECK (current_user_role() = 'admin');

CREATE POLICY "Admins can delete markets"
  ON markets FOR DELETE TO authenticated
  USING (current_user_role() = 'admin');

-- Drop the legacy CHECK constraint on opportunities.market.
-- Find the actual constraint name dynamically (Postgres auto-names it as opportunities_market_check by default).
ALTER TABLE opportunities DROP CONSTRAINT IF EXISTS opportunities_market_check;

-- Seed data
INSERT INTO markets (market_name, region, currency, sort_order) VALUES
  ('Miami', 'North America', 'USD', 1),
  ('Brazil', 'South America', 'BRL', 2),
  ('Mexico', 'North America', 'MXN', 3),
  ('Chile', 'South America', 'CLP', 4),
  ('Colombia', 'South America', 'COP', 5),
  ('Argentina', 'South America', 'ARS', 6),
  ('Peru', 'South America', 'PEN', 7),
  ('Ecuador', 'South America', 'USD', 8),
  ('Panama', 'Central America', 'USD', 9),
  ('Dominican Republic', 'Caribbean', 'DOP', 10),
  ('Central America', 'Central America', 'USD', 11)
ON CONFLICT (market_name) DO NOTHING;
