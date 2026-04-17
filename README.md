# P6 Ad Sales CRM

Salesforce-style ad sales CRM for P6 — Ad Sales In-House Optimisation. Built with Supabase (PostgreSQL) + Express + Railway.

## Setup

### 1. Supabase

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to **SQL Editor** and run these files in order:
   - `supabase/migrations/001_schema.sql` — tables and indexes
   - `supabase/migrations/002_triggers_views.sql` — triggers and views
   - `supabase/migrations/003_rls.sql` — Row Level Security policies
   - `supabase/migrations/004_seed.sql` — sample data (10 deals, activities, forecasts, advertisers)
3. Copy your project URL and anon key from **Settings → API**

### 2. Local Development

```bash
cd ad-sales-crm
npm install
cp .env.example .env
# Edit .env with your Supabase credentials
npm start
# Open http://localhost:3000
```

### 3. Railway Deployment

1. Push this repo to GitHub as `ad-sales-crm`
2. Connect the repo in [Railway](https://railway.app)
3. Add environment variables:
   - `SUPABASE_URL` — your Supabase project URL
   - `SUPABASE_ANON_KEY` — your Supabase anon/public key
   - `SUPABASE_SERVICE_KEY` — your Supabase service role key
4. Railway auto-deploys on push

### 4. First Login

1. Open the app and click **Create an account**
2. Enter your email and a password (min 6 characters)
3. Check your email for the confirmation link (Supabase sends it)
4. Sign in

## Features

- **Dashboard** — KPIs, pipeline charts, top deals, upcoming actions, activity feed
- **Pipeline** — Kanban board with drag-and-drop stage changes + table view with filters
- **Forecast** — Monthly forecast vs actuals, quarterly roll-ups, variance tracking
- **Team** — Rep scorecards, stalled deals, next action tracker
- **Activity** — Chronological log with filters, add new activities
- **Clients** — Advertiser directory with hierarchy, pipeline by category/holding company
- **Deal Detail** — Slide-in panel with all fields, edit, stage change, activity history
- **Forms** — Create/edit deals with naming convention helper, auto-tier, business rule validation
- **Search** — Global search across deals, clients, reps, notes
- **Keyboard shortcuts** — `/` to search, `Escape` to close panels

## Business Rules

- Two opportunity types: Spots (pure media) or Sponsorship (branded content) — never mix
- Tier auto-assigned: Tier 1 ($500K+), Tier 2 ($50K-$500K), Tier 3 (<$50K)
- Stage probabilities fixed via database trigger
- Closed Lost cannot be reverted
- Stall thresholds: Initial Contact 14d, Negotiation 21d, Close to Close 14d, Closed No Order 10d
- Naming convention: MARKET CLIENT YEAR TYPE [PROGRAM]

## Architecture

```
ad-sales-crm/
├── server.js              # Express server
├── public/
│   └── index.html         # Full SPA (Supabase JS client from CDN)
├── supabase/
│   └── migrations/
│       ├── 001_schema.sql
│       ├── 002_triggers_views.sql
│       ├── 003_rls.sql
│       └── 004_seed.sql
├── package.json
├── railway.toml
├── Procfile
└── .env.example
```

## Markets

Brazil, Mexico, Argentina, Colombia (Latin America)
