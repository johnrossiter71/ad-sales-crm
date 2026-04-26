-- ============================================================
-- Yield approval workflow
-- Tracks deal approval state and history.
-- Run in Supabase SQL editor.
-- ============================================================

ALTER TABLE opportunities
  ADD COLUMN IF NOT EXISTS approval_status text DEFAULT 'not_required'
    CHECK (approval_status IN ('not_required','pending','approved','rejected')),
  ADD COLUMN IF NOT EXISTS approved_by text,
  ADD COLUMN IF NOT EXISTS approved_at timestamptz,
  ADD COLUMN IF NOT EXISTS approval_notes text;

CREATE INDEX IF NOT EXISTS idx_opportunities_approval ON opportunities(approval_status);
