-- AI Pilot initial schema (Sprint 8.2)
-- Tables: profiles, categories, ai_tools, workflows, workflow_steps,
--         prompt_templates, favorites, workflow_run_histories,
--         recommendations, recommendation_workflows

-- ---------------------------------------------------------------------------
-- Shared trigger: auto-update updated_at
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- ---------------------------------------------------------------------------
-- profiles
-- ---------------------------------------------------------------------------

CREATE TABLE public.profiles (
  id uuid PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
  display_name text,
  avatar_url text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER profiles_set_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- ---------------------------------------------------------------------------
-- categories
-- ---------------------------------------------------------------------------

CREATE TABLE public.categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  icon_name text,
  sort_order int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER categories_set_updated_at
  BEFORE UPDATE ON public.categories
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- ---------------------------------------------------------------------------
-- ai_tools
-- ---------------------------------------------------------------------------

CREATE TABLE public.ai_tools (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  url text,
  type text,
  icon_name text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER ai_tools_set_updated_at
  BEFORE UPDATE ON public.ai_tools
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- ---------------------------------------------------------------------------
-- prompt_templates
-- ---------------------------------------------------------------------------

CREATE TABLE public.prompt_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  content text NOT NULL,
  description text,
  recommended_ai_tool_id uuid REFERENCES public.ai_tools (id) ON DELETE SET NULL,
  variable_names text[] NOT NULL DEFAULT '{}',
  tags text[] NOT NULL DEFAULT '{}',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER prompt_templates_set_updated_at
  BEFORE UPDATE ON public.prompt_templates
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- ---------------------------------------------------------------------------
-- workflows
-- ---------------------------------------------------------------------------

CREATE TABLE public.workflows (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  category_id uuid REFERENCES public.categories (id) ON DELETE SET NULL,
  estimated_minutes int,
  tags text[] NOT NULL DEFAULT '{}',
  is_published boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX workflows_category_id_idx ON public.workflows (category_id);

CREATE TRIGGER workflows_set_updated_at
  BEFORE UPDATE ON public.workflows
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- ---------------------------------------------------------------------------
-- workflow_steps
-- ---------------------------------------------------------------------------

CREATE TABLE public.workflow_steps (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workflow_id uuid NOT NULL REFERENCES public.workflows (id) ON DELETE CASCADE,
  step_order int NOT NULL,
  title text NOT NULL,
  instruction text,
  description text,
  ai_tool_id uuid REFERENCES public.ai_tools (id) ON DELETE SET NULL,
  prompt_template_id uuid REFERENCES public.prompt_templates (id) ON DELETE SET NULL,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX workflow_steps_workflow_id_idx ON public.workflow_steps (workflow_id);

CREATE TRIGGER workflow_steps_set_updated_at
  BEFORE UPDATE ON public.workflow_steps
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- ---------------------------------------------------------------------------
-- favorites
-- ---------------------------------------------------------------------------

CREATE TABLE public.favorites (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  workflow_id uuid NOT NULL REFERENCES public.workflows (id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, workflow_id)
);

CREATE INDEX favorites_user_id_idx ON public.favorites (user_id);
CREATE INDEX favorites_workflow_id_idx ON public.favorites (workflow_id);

-- ---------------------------------------------------------------------------
-- workflow_run_histories
-- ---------------------------------------------------------------------------

CREATE TABLE public.workflow_run_histories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  workflow_id uuid NOT NULL REFERENCES public.workflows (id) ON DELETE CASCADE,
  last_step_index int NOT NULL DEFAULT 0,
  is_completed boolean NOT NULL DEFAULT false,
  started_at timestamptz NOT NULL DEFAULT now(),
  completed_at timestamptz,
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, workflow_id)
);

CREATE INDEX workflow_run_histories_user_id_idx
  ON public.workflow_run_histories (user_id);

CREATE TRIGGER workflow_run_histories_set_updated_at
  BEFORE UPDATE ON public.workflow_run_histories
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- ---------------------------------------------------------------------------
-- recommendations
-- ---------------------------------------------------------------------------

CREATE TABLE public.recommendations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  icon text,
  color text,
  priority int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX recommendations_priority_idx ON public.recommendations (priority);

CREATE TRIGGER recommendations_set_updated_at
  BEFORE UPDATE ON public.recommendations
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- ---------------------------------------------------------------------------
-- recommendation_workflows
-- ---------------------------------------------------------------------------

CREATE TABLE public.recommendation_workflows (
  recommendation_id uuid NOT NULL
    REFERENCES public.recommendations (id) ON DELETE CASCADE,
  workflow_id uuid NOT NULL
    REFERENCES public.workflows (id) ON DELETE CASCADE,
  sort_order int NOT NULL DEFAULT 0,
  PRIMARY KEY (recommendation_id, workflow_id)
);

CREATE INDEX recommendation_workflows_recommendation_id_idx
  ON public.recommendation_workflows (recommendation_id);

-- ---------------------------------------------------------------------------
-- profiles auto-create on auth.users insert
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name)
  VALUES (
    NEW.id,
    COALESCE(
      NEW.raw_user_meta_data ->> 'display_name',
      NEW.raw_user_meta_data ->> 'full_name',
      NEW.raw_user_meta_data ->> 'name',
      split_part(NEW.email, '@', 1)
    )
  );
  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_tools ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workflows ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workflow_steps ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.prompt_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workflow_run_histories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recommendation_workflows ENABLE ROW LEVEL SECURITY;

-- Public read (anon + authenticated)
CREATE POLICY "Public read access"
  ON public.categories
  FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Public read access"
  ON public.ai_tools
  FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Public read access"
  ON public.workflows
  FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Public read access"
  ON public.workflow_steps
  FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Public read access"
  ON public.prompt_templates
  FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Public read access"
  ON public.recommendations
  FOR SELECT
  TO anon, authenticated
  USING (true);

CREATE POLICY "Public read access"
  ON public.recommendation_workflows
  FOR SELECT
  TO anon, authenticated
  USING (true);

-- Authenticated user own data: profiles
CREATE POLICY "Users can view own profile"
  ON public.profiles
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON public.profiles
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Authenticated user own data: favorites
CREATE POLICY "Users can view own favorites"
  ON public.favorites
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own favorites"
  ON public.favorites
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own favorites"
  ON public.favorites
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Authenticated user own data: workflow_run_histories
CREATE POLICY "Users can view own workflow run histories"
  ON public.workflow_run_histories
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own workflow run histories"
  ON public.workflow_run_histories
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own workflow run histories"
  ON public.workflow_run_histories
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own workflow run histories"
  ON public.workflow_run_histories
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);
