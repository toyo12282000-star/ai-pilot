-- Sprint 17.0: Advisor session history enrichment + ranked suggestions

ALTER TABLE public.advisor_histories
  ADD COLUMN IF NOT EXISTS path text,
  ADD COLUMN IF NOT EXISTS selected_answers_json jsonb NOT NULL DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS primary_workflow_id uuid
    REFERENCES public.workflows (id) ON DELETE SET NULL;

-- ---------------------------------------------------------------------------
-- advisor_session_suggestions
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.advisor_session_suggestions (
  session_id uuid NOT NULL
    REFERENCES public.advisor_histories (id) ON DELETE CASCADE,
  workflow_id uuid NOT NULL
    REFERENCES public.workflows (id) ON DELETE CASCADE,
  rank int NOT NULL CHECK (rank > 0),
  PRIMARY KEY (session_id, workflow_id)
);

CREATE INDEX IF NOT EXISTS advisor_session_suggestions_session_id_idx
  ON public.advisor_session_suggestions (session_id);

CREATE INDEX IF NOT EXISTS advisor_session_suggestions_session_rank_idx
  ON public.advisor_session_suggestions (session_id, rank);

ALTER TABLE public.advisor_session_suggestions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own advisor session suggestions"
  ON public.advisor_session_suggestions
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.advisor_histories h
      WHERE h.id = session_id
        AND h.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own advisor session suggestions"
  ON public.advisor_session_suggestions
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.advisor_histories h
      WHERE h.id = session_id
        AND h.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own advisor session suggestions"
  ON public.advisor_session_suggestions
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.advisor_histories h
      WHERE h.id = session_id
        AND h.user_id = auth.uid()
    )
  );
