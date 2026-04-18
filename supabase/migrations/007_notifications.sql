-- ============================================================
-- Notifications table for in-app alerts
-- Run in Supabase SQL editor.
-- ============================================================

CREATE TABLE IF NOT EXISTS notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  type text NOT NULL CHECK (type IN ('stalled','expiring','new_deal','closed_won','closed_lost','no_activity')),
  message text NOT NULL,
  deal_id uuid REFERENCES opportunities(id) ON DELETE CASCADE,
  is_read boolean DEFAULT false,
  -- dedupe key prevents the same condition from generating the same alert
  -- multiple times when the client re-runs its periodic check
  dedupe_key text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_dedupe ON notifications(user_id, dedupe_key);

ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own notifications"
  ON notifications FOR SELECT TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert their own notifications"
  ON notifications FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own notifications"
  ON notifications FOR UPDATE TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete own notifications"
  ON notifications FOR DELETE TO authenticated
  USING (user_id = auth.uid());
