-- AI Pilot outcome foundation (Sprint 12.2)
-- Adds Outcome / Tool Options / Prompt Variants / AI Tool Alternatives.
-- Extends workflows, workflow_steps, ai_tools, prompt_templates.

-- ---------------------------------------------------------------------------
-- Extend existing tables
-- ---------------------------------------------------------------------------

ALTER TABLE public.workflows
  ADD COLUMN outcome_summary text,
  ADD COLUMN difficulty text CHECK (difficulty IN ('easy', 'normal', 'hard')),
  ADD COLUMN required_time_minutes int,
  ADD COLUMN target_user_label text;

ALTER TABLE public.workflow_steps
  ADD COLUMN goal text,
  ADD COLUMN output_example text,
  ADD COLUMN completion_criteria text,
  ADD COLUMN tips text[] NOT NULL DEFAULT '{}',
  ADD COLUMN common_mistakes text[] NOT NULL DEFAULT '{}';

ALTER TABLE public.ai_tools
  ADD COLUMN pricing_type text CHECK (pricing_type IN ('free', 'freemium', 'paid', 'unknown')),
  ADD COLUMN difficulty text CHECK (difficulty IN ('easy', 'normal', 'hard')),
  ADD COLUMN strengths text[] NOT NULL DEFAULT '{}',
  ADD COLUMN weaknesses text[] NOT NULL DEFAULT '{}',
  ADD COLUMN best_for text[] NOT NULL DEFAULT '{}',
  ADD COLUMN tutorial_url text;

ALTER TABLE public.prompt_templates
  ADD COLUMN expected_output text,
  ADD COLUMN usage_tips text;

-- ---------------------------------------------------------------------------
-- workflow_outcomes
-- ---------------------------------------------------------------------------

CREATE TABLE public.workflow_outcomes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workflow_id uuid NOT NULL REFERENCES public.workflows (id) ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  outcome_type text NOT NULL CHECK (
    outcome_type IN ('video', 'article', 'image', 'slide', 'sns_post', 'app', 'other')
  ),
  preview_image_url text,
  preview_url text,
  expected_result text,
  target_users text[] NOT NULL DEFAULT '{}',
  use_cases text[] NOT NULL DEFAULT '{}',
  sort_order int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX workflow_outcomes_workflow_id_idx
  ON public.workflow_outcomes (workflow_id);

CREATE INDEX workflow_outcomes_outcome_type_idx
  ON public.workflow_outcomes (outcome_type);

CREATE TRIGGER workflow_outcomes_set_updated_at
  BEFORE UPDATE ON public.workflow_outcomes
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- ---------------------------------------------------------------------------
-- workflow_step_tool_options
-- ---------------------------------------------------------------------------

CREATE TABLE public.workflow_step_tool_options (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workflow_step_id uuid NOT NULL REFERENCES public.workflow_steps (id) ON DELETE CASCADE,
  ai_tool_id uuid NOT NULL REFERENCES public.ai_tools (id) ON DELETE CASCADE,
  is_recommended boolean NOT NULL DEFAULT false,
  recommendation_reason text,
  difficulty text CHECK (difficulty IN ('easy', 'normal', 'hard')),
  pricing_note text,
  sort_order int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (workflow_step_id, ai_tool_id)
);

CREATE INDEX workflow_step_tool_options_workflow_step_id_idx
  ON public.workflow_step_tool_options (workflow_step_id);

CREATE INDEX workflow_step_tool_options_ai_tool_id_idx
  ON public.workflow_step_tool_options (ai_tool_id);

CREATE TRIGGER workflow_step_tool_options_set_updated_at
  BEFORE UPDATE ON public.workflow_step_tool_options
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- ---------------------------------------------------------------------------
-- prompt_variants
-- ---------------------------------------------------------------------------

CREATE TABLE public.prompt_variants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workflow_step_id uuid NOT NULL REFERENCES public.workflow_steps (id) ON DELETE CASCADE,
  prompt_template_id uuid REFERENCES public.prompt_templates (id) ON DELETE SET NULL,
  title text NOT NULL,
  variant_type text NOT NULL CHECK (
    variant_type IN (
      'beginner',
      'high_quality',
      'short_time',
      'viral',
      'professional',
      'seo',
      'sns'
    )
  ),
  content text NOT NULL,
  expected_output text,
  usage_tips text,
  variables text[] NOT NULL DEFAULT '{}',
  sort_order int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX prompt_variants_workflow_step_id_idx
  ON public.prompt_variants (workflow_step_id);

CREATE INDEX prompt_variants_variant_type_idx
  ON public.prompt_variants (variant_type);

CREATE TRIGGER prompt_variants_set_updated_at
  BEFORE UPDATE ON public.prompt_variants
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- ---------------------------------------------------------------------------
-- ai_tool_alternatives
-- ---------------------------------------------------------------------------

CREATE TABLE public.ai_tool_alternatives (
  ai_tool_id uuid NOT NULL REFERENCES public.ai_tools (id) ON DELETE CASCADE,
  alternative_ai_tool_id uuid NOT NULL REFERENCES public.ai_tools (id) ON DELETE CASCADE,
  reason text,
  sort_order int NOT NULL DEFAULT 0,
  PRIMARY KEY (ai_tool_id, alternative_ai_tool_id),
  CHECK (ai_tool_id <> alternative_ai_tool_id)
);

CREATE INDEX ai_tool_alternatives_ai_tool_id_idx
  ON public.ai_tool_alternatives (ai_tool_id);

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------

ALTER TABLE public.workflow_outcomes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workflow_step_tool_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.prompt_variants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_tool_alternatives ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read access"
  ON public.workflow_outcomes
  FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Public read access"
  ON public.workflow_step_tool_options
  FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Public read access"
  ON public.prompt_variants
  FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Public read access"
  ON public.ai_tool_alternatives
  FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Admins can manage workflow_outcomes"
  ON public.workflow_outcomes
  FOR ALL
  TO authenticated
  USING (public.is_admin(auth.uid()))
  WITH CHECK (public.is_admin(auth.uid()));

CREATE POLICY "Admins can manage workflow_step_tool_options"
  ON public.workflow_step_tool_options
  FOR ALL
  TO authenticated
  USING (public.is_admin(auth.uid()))
  WITH CHECK (public.is_admin(auth.uid()));

CREATE POLICY "Admins can manage prompt_variants"
  ON public.prompt_variants
  FOR ALL
  TO authenticated
  USING (public.is_admin(auth.uid()))
  WITH CHECK (public.is_admin(auth.uid()));

CREATE POLICY "Admins can manage ai_tool_alternatives"
  ON public.ai_tool_alternatives
  FOR ALL
  TO authenticated
  USING (public.is_admin(auth.uid()))
  WITH CHECK (public.is_admin(auth.uid()));
