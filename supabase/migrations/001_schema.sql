-- ============================================================
-- Ad Sales CRM — Database Schema
-- Run this in Supabase SQL Editor (or as a migration)
-- ============================================================

-- 1. Stage Settings (reference table — create first)
CREATE TABLE stage_settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  stage_name text UNIQUE NOT NULL,
  probability numeric NOT NULL DEFAULT 0,
  entry_criteria text,
  exit_criteria text,
  max_days_stall integer,
  sort_order integer NOT NULL DEFAULT 0
);

-- 2. Opportunities
CREATE TABLE opportunities (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  opportunity_name text NOT NULL,
  market text CHECK (market IN ('Brazil','Mexico','Argentina','Colombia')),
  sales_rep text,
  opportunity_type text CHECK (opportunity_type IN ('Spots','Sponsorship')),
  tier integer CHECK (tier IN (1,2,3)),
  business_type text CHECK (business_type IN ('New','Existing')),
  advertiser_child text,
  advertiser_parent text,
  agency_child text,
  agency_parent text,
  contact_name text,
  category text,
  platform_mix text,
  currency text DEFAULT 'USD',
  amount numeric DEFAULT 0,
  stage text NOT NULL DEFAULT 'Initial Contact',
  probability numeric DEFAULT 0.2,
  client_deadline date,
  proposal_deadline date,
  fiscal_start date,
  fiscal_end date,
  next_action text,
  next_action_date date,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES auth.users(id)
);

-- 3. Forecast Entries
CREATE TABLE forecast_entries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  opportunity_id uuid REFERENCES opportunities(id) ON DELETE CASCADE,
  month text NOT NULL,  -- '2026-07' format
  forecast_amount numeric DEFAULT 0,
  actual_amount numeric,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- 4. Revenue Actuals
CREATE TABLE revenue_actuals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  month text NOT NULL,
  market text,
  platform text,
  opportunity_type text,
  tier integer,
  booked_revenue numeric DEFAULT 0,
  billed_revenue numeric DEFAULT 0,
  collected numeric DEFAULT 0,
  source text DEFAULT 'Landmark',
  created_at timestamptz DEFAULT now()
);

-- 5. Advertisers
CREATE TABLE advertisers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  advertiser_child text UNIQUE NOT NULL,
  advertiser_parent text,
  agency_child text,
  agency_parent text,
  holding_company text,
  category text,
  primary_contact text,
  contact_email text,
  historical_annual_spend numeric DEFAULT 0,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- 6. Activities
CREATE TABLE activities (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  opportunity_id uuid REFERENCES opportunities(id) ON DELETE CASCADE,
  activity_type text CHECK (activity_type IN ('Call','Meeting','Email')),
  activity_date date NOT NULL DEFAULT CURRENT_DATE,
  sales_rep text,
  notes text,
  created_at timestamptz DEFAULT now()
);

-- ============================================================
-- INDEXES
-- ============================================================
CREATE INDEX idx_opportunities_stage ON opportunities(stage);
CREATE INDEX idx_opportunities_market ON opportunities(market);
CREATE INDEX idx_opportunities_rep ON opportunities(sales_rep);
CREATE INDEX idx_opportunities_type ON opportunities(opportunity_type);
CREATE INDEX idx_forecast_opp ON forecast_entries(opportunity_id);
CREATE INDEX idx_forecast_month ON forecast_entries(month);
CREATE INDEX idx_activities_opp ON activities(opportunity_id);
CREATE INDEX idx_activities_date ON activities(activity_date);
CREATE INDEX idx_actuals_month ON revenue_actuals(month);
