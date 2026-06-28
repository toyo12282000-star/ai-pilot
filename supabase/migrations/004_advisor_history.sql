-- AI Pilot advisor history (Sprint 11.3)
-- Stores past Advisor queries and suggested workflow IDs per user.

-- ---------------------------------------------------------------------------
-- advisor_histories
-- ---------------------------------------------------------------------------

CREATE TABLE public.advisor_histories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  query text NOT NULL,
  suggested_workflow_ids uuid[] NOT NULL DEFAULT '{}',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX advisor_histories_user_id_idx
  ON public.advisor_histories (user_id);

CREATE INDEX advisor_histories_created_at_idx
  ON public.advisor_histories (created_at DESC);

-- ---------------------------------------------------------------------------
-- Row Level Security (authenticated user own data only; guests cannot save)
-- ---------------------------------------------------------------------------

ALTER TABLE public.advisor_histories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own advisor histories"
  ON public.advisor_histories
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own advisor histories"
  ON public.advisor_histories
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own advisor histories"
  ON public.advisor_histories
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);
