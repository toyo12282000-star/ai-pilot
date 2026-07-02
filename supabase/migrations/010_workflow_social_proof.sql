-- Sprint 16.0: Workflow Social Proof RPCs
-- Aggregate favorites / run histories for public workflow detail page.

CREATE INDEX IF NOT EXISTS workflow_run_histories_workflow_id_idx
  ON public.workflow_run_histories (workflow_id);

CREATE INDEX IF NOT EXISTS workflow_run_histories_workflow_completed_idx
  ON public.workflow_run_histories (workflow_id, is_completed);

-- ---------------------------------------------------------------------------
-- Social proof counts
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.get_workflow_social_proof_counts(
  p_workflow_id uuid
)
RETURNS TABLE (
  favorite_count bigint,
  started_user_count bigint,
  completed_user_count bigint
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    (
      SELECT COUNT(*)::bigint
      FROM public.favorites
      WHERE workflow_id = p_workflow_id
    ) AS favorite_count,
    (
      SELECT COUNT(*)::bigint
      FROM public.workflow_run_histories
      WHERE workflow_id = p_workflow_id
    ) AS started_user_count,
    (
      SELECT COUNT(*)::bigint
      FROM public.workflow_run_histories
      WHERE workflow_id = p_workflow_id
        AND is_completed = true
    ) AS completed_user_count;
$$;

-- ---------------------------------------------------------------------------
-- Recent creations (started / completed activity)
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.get_workflow_recent_creations(
  p_workflow_id uuid,
  p_limit int DEFAULT 5
)
RETURNS TABLE (
  user_id uuid,
  display_name text,
  activity_at timestamptz
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    h.user_id,
    COALESCE(NULLIF(TRIM(p.display_name), ''), 'ユーザー') AS display_name,
    COALESCE(h.completed_at, h.started_at) AS activity_at
  FROM public.workflow_run_histories h
  JOIN public.profiles p ON p.id = h.user_id
  WHERE h.workflow_id = p_workflow_id
  ORDER BY activity_at DESC
  LIMIT GREATEST(p_limit, 0);
$$;

GRANT EXECUTE ON FUNCTION public.get_workflow_social_proof_counts(uuid)
  TO anon, authenticated;

GRANT EXECUTE ON FUNCTION public.get_workflow_recent_creations(uuid, int)
  TO anon, authenticated;
