-- ============================================================
-- Seed Data — from Ad_Sales_CRM.xlsx
-- ============================================================

-- Stage Settings
INSERT INTO stage_settings (stage_name, probability, entry_criteria, exit_criteria, max_days_stall, sort_order) VALUES
  ('Initial Contact', 0.2, 'First outreach or brief received', 'Proposal requested or shared', 14, 1),
  ('Negotiation', 0.5, 'Proposal submitted', 'Pricing discussion or revision cycle', 21, 2),
  ('Close to Close', 0.75, 'Client signals strong intent', 'Verbal agreement or final negotiation', 14, 3),
  ('Closed (No Order Yet)', 0.9, 'Deal verbally agreed', 'IO/order received', 10, 4),
  ('Closed Won', 1.0, 'Order confirmed / campaign live', 'N/A', NULL, 5),
  ('Closed Lost', 0.0, 'Client declines or goes elsewhere', 'N/A', NULL, 6);

-- Advertisers
INSERT INTO advertisers (advertiser_child, advertiser_parent, agency_child, agency_parent, holding_company, category, primary_contact, contact_email, historical_annual_spend, notes) VALUES
  ('Coca-Cola Brazil', 'The Coca-Cola Company', 'WPP Brazil', 'WPP', 'WPP', 'Beverages', 'Ana Rodriguez', 'ana.r@wpp.com', 1200000, 'Tier 1 anchor partner, 3-year relationship'),
  ('Samsung Mexico', 'Samsung Electronics', 'Starcom Mexico', 'Publicis Groupe', 'Publicis', 'Technology', 'Jorge Herrera', 'jorge.h@starcom.com', 0, 'New client, first campaign'),
  ('Unilever Argentina', 'Unilever', 'Mindshare Argentina', 'GroupM', 'WPP', 'FMCG', 'Laura Fernandez', 'laura.f@mindshare.com', 480000, 'Strong upfront interest'),
  ('Ambev', 'AB InBev', 'Africa DDB Brazil', 'DDB Worldwide', 'Omnicom', 'Beverages', 'Pedro Almeida', 'pedro.a@africaddb.com', 550000, 'H2 heavy spender, wants bonus'),
  ('Nestle Mexico', 'Nestle SA', 'Zenith Mexico', 'Publicis Groupe', 'Publicis', 'Food', 'Isabella Morales', 'isabella.m@zenith.com', 0, 'New anchor prospect via Bake Off'),
  ('Bavaria', 'AB InBev', 'OMD Colombia', 'Omnicom', 'Omnicom', 'Beverages', 'Diego Ramirez', 'diego.r@omd.com', 0, 'Interest in Copa America adjacent inventory'),
  ('Google Brazil', 'Alphabet', 'Essence Brazil', 'GroupM', 'WPP', 'Technology', 'Marcos Silva', 'marcos.s@essence.com', 0, 'PMP deal, always-on digital'),
  ('P&G Mexico', 'Procter & Gamble', 'Carat Mexico', 'Dentsu', 'Dentsu', 'FMCG', 'Sofia Torres', 'sofia.t@carat.com', 0, 'Deal verbally agreed at $900K'),
  ('Toyota Argentina', 'Toyota Motor Corp', 'Dentsu Argentina', 'Dentsu', 'Dentsu', 'Automotive', 'Martin Gutierrez', 'martin.g@dentsu.com', 0, 'Client pushing for $10 CPM on digital'),
  ('L''Oreal Brazil', 'L''Oreal Group', 'Havas Brazil', 'Havas', 'Havas', 'Beauty', 'Camila Oliveira', 'camila.o@havas.com', 0, 'Lost to competitor - lower CPM offer');

-- Opportunities (use fixed UUIDs so we can reference them in forecasts/activities)
INSERT INTO opportunities (id, opportunity_name, market, sales_rep, opportunity_type, tier, business_type, advertiser_child, advertiser_parent, agency_child, agency_parent, contact_name, category, platform_mix, currency, amount, stage, probability, client_deadline, proposal_deadline, fiscal_start, fiscal_end, next_action, next_action_date, notes, created_at, updated_at) VALUES
  ('a0000001-0000-0000-0000-000000000001', 'BRA COCA COLA 2026 SPONSORSHIP THE VOICE', 'Brazil', 'Maria Santos', 'Sponsorship', 1, 'Existing', 'Coca-Cola Brazil', 'The Coca-Cola Company', 'WPP Brazil', 'WPP', 'Ana Rodriguez', 'Beverages', 'Linear + Digital', 'USD', 750000, 'Negotiation', 0.5, '2026-05-15', '2026-04-20', '2026-07-01', '2026-12-31', 'Send revised proposal with Q3 bonus spots', '2026-04-18', 'Final pricing review pending CMO approval', '2026-02-10', '2026-04-14'),
  ('a0000001-0000-0000-0000-000000000002', 'MEX SAMSUNG 2026 SPOTS Q1', 'Mexico', 'Carlos Mendez', 'Spots', 2, 'New', 'Samsung Mexico', 'Samsung Electronics', 'Starcom Mexico', 'Publicis Groupe', 'Jorge Herrera', 'Technology', 'Linear', 'USD', 120000, 'Close to Close', 0.75, '2026-04-30', '2026-04-10', '2026-05-01', '2026-06-30', 'Await IO signature', '2026-04-17', 'Legal reviewing IO terms', '2026-03-05', '2026-04-12'),
  ('a0000001-0000-0000-0000-000000000003', 'ARG UNILEVER 2026 SPONSORSHIP MASTERCHEF', 'Argentina', 'Maria Santos', 'Sponsorship', 1, 'Existing', 'Unilever Argentina', 'Unilever', 'Mindshare Argentina', 'GroupM', 'Laura Fernandez', 'FMCG', 'Linear + Digital + Social', 'USD', 520000, 'Initial Contact', 0.2, '2026-06-30', NULL, '2026-08-01', '2026-12-31', 'Schedule capabilities presentation', '2026-04-22', 'Client expressed interest at upfront event', '2026-04-01', '2026-04-10'),
  ('a0000001-0000-0000-0000-000000000004', 'BRA AMBEV 2026 SPOTS H2', 'Brazil', 'Rafael Lima', 'Spots', 2, 'Existing', 'Ambev', 'AB InBev', 'Africa DDB Brazil', 'DDB Worldwide', 'Pedro Almeida', 'Beverages', 'Linear + Digital', 'USD', 280000, 'Negotiation', 0.5, '2026-05-30', '2026-04-25', '2026-07-01', '2026-12-31', 'Revise package with added value spots', '2026-04-19', 'Client wants 15% bonus impressions', '2026-03-01', '2026-04-11'),
  ('a0000001-0000-0000-0000-000000000005', 'MEX NESTLE 2026 SPONSORSHIP BAKE OFF', 'Mexico', 'Carlos Mendez', 'Sponsorship', 1, 'New', 'Nestle Mexico', 'Nestle SA', 'Zenith Mexico', 'Publicis Groupe', 'Isabella Morales', 'Food', 'Linear + Digital + Social', 'USD', 650000, 'Close to Close', 0.75, '2026-05-15', '2026-03-30', '2026-06-01', '2026-11-30', 'Final contract review with legal', '2026-04-20', 'Verbal agreement received, awaiting formal IO', '2026-01-20', '2026-04-13'),
  ('a0000001-0000-0000-0000-000000000006', 'COL BAVARIA 2026 SPOTS FUTBOL', 'Colombia', 'Andrea Vargas', 'Spots', 2, 'New', 'Bavaria', 'AB InBev', 'OMD Colombia', 'Omnicom', 'Diego Ramirez', 'Beverages', 'Linear', 'USD', 95000, 'Initial Contact', 0.2, '2026-06-15', NULL, '2026-07-01', '2026-09-30', 'Prepare rate card and audience data', '2026-04-21', 'Interest in Copa America adjacent inventory', '2026-04-05', '2026-04-08'),
  ('a0000001-0000-0000-0000-000000000007', 'BRA GOOGLE 2026 SPOTS DIGITAL', 'Brazil', 'Rafael Lima', 'Spots', 3, 'Existing', 'Google Brazil', 'Alphabet', 'Essence Brazil', 'GroupM', 'Marcos Silva', 'Technology', 'Digital + YouTube', 'USD', 45000, 'Closed Won', 1.0, NULL, NULL, '2026-04-01', '2026-06-30', 'Campaign live - monitor delivery', NULL, 'PMP deal, $12 CPM floor, always-on', '2026-02-15', '2026-04-01'),
  ('a0000001-0000-0000-0000-000000000008', 'MEX PROCTER 2026 SPONSORSHIP ESTRELLA', 'Mexico', 'Carlos Mendez', 'Sponsorship', 1, 'Existing', 'P&G Mexico', 'Procter & Gamble', 'Carat Mexico', 'Dentsu', 'Sofia Torres', 'FMCG', 'Linear + Digital + Brand Integration', 'USD', 900000, 'Closed (No Order Yet)', 0.9, '2026-04-25', '2026-03-15', '2026-05-01', '2026-12-31', 'Chase IO from legal department', '2026-04-18', 'Deal verbally agreed at $900K, IO expected this week', '2025-11-01', '2026-04-15'),
  ('a0000001-0000-0000-0000-000000000009', 'ARG TOYOTA 2026 SPOTS Q3', 'Argentina', 'Andrea Vargas', 'Spots', 2, 'New', 'Toyota Argentina', 'Toyota Motor Corp', 'Dentsu Argentina', 'Dentsu', 'Martin Gutierrez', 'Automotive', 'Linear + Digital', 'USD', 180000, 'Negotiation', 0.5, '2026-05-20', '2026-04-15', '2026-07-01', '2026-09-30', 'Counter-proposal on CPM rates', '2026-04-18', 'Client pushing for $10 CPM on digital, our floor is $12', '2026-03-10', '2026-04-14'),
  ('a0000001-0000-0000-0000-000000000010', 'BRA LOREAL 2026 SPOTS BEAUTY', 'Brazil', 'Maria Santos', 'Spots', 2, 'Existing', 'L''Oreal Brazil', 'L''Oreal Group', 'Havas Brazil', 'Havas', 'Camila Oliveira', 'Beauty', 'Digital + Social', 'USD', 160000, 'Closed Lost', 0.0, '2026-03-31', '2026-03-20', '2026-05-01', '2026-08-31', 'Lost to competitor - lower CPM offer', NULL, 'Competitor offered $7 CPM on open exchange vs our $11 PMP floor', '2026-02-01', '2026-03-28');

-- Forecast Entries
INSERT INTO forecast_entries (opportunity_id, month, forecast_amount, actual_amount) VALUES
  ('a0000001-0000-0000-0000-000000000001', '2026-07', 125000, NULL),
  ('a0000001-0000-0000-0000-000000000001', '2026-08', 125000, NULL),
  ('a0000001-0000-0000-0000-000000000001', '2026-09', 125000, NULL),
  ('a0000001-0000-0000-0000-000000000001', '2026-10', 125000, NULL),
  ('a0000001-0000-0000-0000-000000000001', '2026-11', 125000, NULL),
  ('a0000001-0000-0000-0000-000000000001', '2026-12', 125000, NULL),
  ('a0000001-0000-0000-0000-000000000002', '2026-05', 40000, NULL),
  ('a0000001-0000-0000-0000-000000000002', '2026-06', 80000, NULL),
  ('a0000001-0000-0000-0000-000000000004', '2026-07', 46667, NULL),
  ('a0000001-0000-0000-0000-000000000004', '2026-08', 46667, NULL),
  ('a0000001-0000-0000-0000-000000000004', '2026-09', 46667, NULL),
  ('a0000001-0000-0000-0000-000000000004', '2026-10', 46667, NULL),
  ('a0000001-0000-0000-0000-000000000004', '2026-11', 46667, NULL),
  ('a0000001-0000-0000-0000-000000000004', '2026-12', 46667, NULL),
  ('a0000001-0000-0000-0000-000000000005', '2026-06', 108333, NULL),
  ('a0000001-0000-0000-0000-000000000005', '2026-07', 108333, NULL),
  ('a0000001-0000-0000-0000-000000000005', '2026-08', 108333, NULL),
  ('a0000001-0000-0000-0000-000000000005', '2026-09', 108333, NULL),
  ('a0000001-0000-0000-0000-000000000005', '2026-10', 108333, NULL),
  ('a0000001-0000-0000-0000-000000000005', '2026-11', 108333, NULL),
  ('a0000001-0000-0000-0000-000000000007', '2026-04', 15000, 14200),
  ('a0000001-0000-0000-0000-000000000007', '2026-05', 15000, NULL),
  ('a0000001-0000-0000-0000-000000000007', '2026-06', 15000, NULL),
  ('a0000001-0000-0000-0000-000000000008', '2026-05', 112500, NULL),
  ('a0000001-0000-0000-0000-000000000008', '2026-06', 112500, NULL),
  ('a0000001-0000-0000-0000-000000000008', '2026-07', 112500, NULL),
  ('a0000001-0000-0000-0000-000000000008', '2026-08', 112500, NULL),
  ('a0000001-0000-0000-0000-000000000008', '2026-09', 112500, NULL),
  ('a0000001-0000-0000-0000-000000000008', '2026-10', 112500, NULL),
  ('a0000001-0000-0000-0000-000000000008', '2026-11', 112500, NULL),
  ('a0000001-0000-0000-0000-000000000008', '2026-12', 112500, NULL);

-- Revenue Actuals
INSERT INTO revenue_actuals (month, market, platform, opportunity_type, tier, booked_revenue, billed_revenue, collected, source) VALUES
  ('2026-04', 'Brazil', 'Digital + YouTube', 'Spots', 3, 14200, 14200, 0, 'Landmark'),
  ('2026-03', 'Brazil', 'Linear', 'Spots', 2, 85000, 85000, 85000, 'Landmark'),
  ('2026-03', 'Mexico', 'Linear + Digital', 'Sponsorship', 1, 210000, 210000, 180000, 'Landmark'),
  ('2026-03', 'Argentina', 'Linear', 'Spots', 2, 62000, 62000, 62000, 'Landmark'),
  ('2026-02', 'Brazil', 'Linear + Digital', 'Sponsorship', 1, 195000, 195000, 195000, 'Landmark'),
  ('2026-02', 'Mexico', 'Linear', 'Spots', 2, 78000, 78000, 78000, 'Landmark'),
  ('2026-02', 'Colombia', 'Digital', 'Spots', 3, 12500, 12500, 12500, 'Landmark'),
  ('2026-01', 'Brazil', 'Linear + Digital', 'Sponsorship', 1, 180000, 180000, 180000, 'Landmark'),
  ('2026-01', 'Mexico', 'Linear + Digital', 'Spots', 2, 92000, 92000, 92000, 'Landmark');

-- Activities
INSERT INTO activities (opportunity_id, activity_type, activity_date, sales_rep, notes) VALUES
  ('a0000001-0000-0000-0000-000000000001', 'Meeting', '2026-04-14', 'Maria Santos', 'Presented revised package with Q3 bonus spots. CMO reviewing internally.'),
  ('a0000001-0000-0000-0000-000000000001', 'Email', '2026-04-10', 'Maria Santos', 'Sent updated rate card with digital bundle pricing.'),
  ('a0000001-0000-0000-0000-000000000002', 'Call', '2026-04-12', 'Carlos Mendez', 'Client confirmed intent. IO being routed through legal.'),
  ('a0000001-0000-0000-0000-000000000003', 'Meeting', '2026-04-10', 'Maria Santos', 'Initial meeting at upfront event. Strong interest in MasterChef integration.'),
  ('a0000001-0000-0000-0000-000000000004', 'Email', '2026-04-11', 'Rafael Lima', 'Client requested 15% bonus impressions on digital. Reviewing margin impact.'),
  ('a0000001-0000-0000-0000-000000000005', 'Call', '2026-04-13', 'Carlos Mendez', 'Verbal agreement at $650K. Contract being drafted.'),
  ('a0000001-0000-0000-0000-000000000008', 'Email', '2026-04-15', 'Carlos Mendez', 'Following up on IO. Legal team reviewing brand integration clauses.'),
  ('a0000001-0000-0000-0000-000000000009', 'Meeting', '2026-04-14', 'Andrea Vargas', 'Counter-proposal discussion. Client firm on $10 CPM digital, exploring linear-only package.'),
  ('a0000001-0000-0000-0000-000000000006', 'Email', '2026-04-08', 'Andrea Vargas', 'Sent Copa America inventory availability and rate card.'),
  ('a0000001-0000-0000-0000-000000000007', 'Call', '2026-04-01', 'Rafael Lima', 'PMP activated. Monitoring first week delivery and pacing.');
