-- AI Pilot admin foundation (Sprint 10.2)
-- Adds profiles.role, workflows audit columns, is_admin(), admin RLS policies.
-- Existing public read policies are unchanged.

-- ---------------------------------------------------------------------------
-- profiles.role
-- ---------------------------------------------------------------------------

ALTER TABLE public.profiles
  ADD COLUMN role text NOT NULL DEFAULT 'user'
  CHECK (role IN ('user', 'admin'));

CREATE INDEX profiles_role_idx ON public.profiles (role);

-- Prevent authenticated users from self-promoting via profile UPDATE.
CREATE OR REPLACE FUNCTION public.protect_profiles_role()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  IF NEW.role IS DISTINCT FROM OLD.role AND auth.uid() IS NOT NULL THEN
    RAISE EXCEPTION 'profiles.role cannot be changed by authenticated users';
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER profiles_protect_role
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.protect_profiles_role();

-- ---------------------------------------------------------------------------
-- workflows audit columns
-- ---------------------------------------------------------------------------

ALTER TABLE public.workflows
  ADD COLUMN created_by uuid REFERENCES public.profiles (id) ON DELETE SET NULL,
  ADD COLUMN updated_by uuid REFERENCES public.profiles (id) ON DELETE SET NULL;

CREATE INDEX workflows_created_by_idx ON public.workflows (created_by);
CREATE INDEX workflows_updated_by_idx ON public.workflows (updated_by);

-- ---------------------------------------------------------------------------
-- workflows.updated_by auto-set on UPDATE
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.set_workflows_updated_by()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  NEW.updated_by = auth.uid();
  RETURN NEW;
END;
$$;

CREATE TRIGGER workflows_set_updated_by
  BEFORE UPDATE ON public.workflows
  FOR EACH ROW
  EXECUTE FUNCTION public.set_workflows_updated_by();

-- ---------------------------------------------------------------------------
-- admin check helper
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.is_admin(user_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles
    WHERE profiles.id = user_id
      AND profiles.role = 'admin'
  );
$$;

-- ---------------------------------------------------------------------------
-- Admin CRUD policies (content master tables)
-- Public read policies from 001_initial_schema.sql remain in effect.
-- ---------------------------------------------------------------------------

CREATE POLICY "Admins can manage categories"
  ON public.categories
  FOR ALL
  TO authenticated
  USING (public.is_admin(auth.uid()))
  WITH CHECK (public.is_admin(auth.uid()));

CREATE POLICY "Admins can manage ai_tools"
  ON public.ai_tools
  FOR ALL
  TO authenticated
  USING (public.is_admin(auth.uid()))
  WITH CHECK (public.is_admin(auth.uid()));

CREATE POLICY "Admins can manage prompt_templates"
  ON public.prompt_templates
  FOR ALL
  TO authenticated
  USING (public.is_admin(auth.uid()))
  WITH CHECK (public.is_admin(auth.uid()));

CREATE POLICY "Admins can manage workflows"
  ON public.workflows
  FOR ALL
  TO authenticated
  USING (public.is_admin(auth.uid()))
  WITH CHECK (public.is_admin(auth.uid()));

CREATE POLICY "Admins can manage workflow_steps"
  ON public.workflow_steps
  FOR ALL
  TO authenticated
  USING (public.is_admin(auth.uid()))
  WITH CHECK (public.is_admin(auth.uid()));

CREATE POLICY "Admins can manage recommendations"
  ON public.recommendations
  FOR ALL
  TO authenticated
  USING (public.is_admin(auth.uid()))
  WITH CHECK (public.is_admin(auth.uid()));

CREATE POLICY "Admins can manage recommendation_workflows"
  ON public.recommendation_workflows
  FOR ALL
  TO authenticated
  USING (public.is_admin(auth.uid()))
  WITH CHECK (public.is_admin(auth.uid()));

-- ---------------------------------------------------------------------------
-- Initial admin grant (run manually in SQL Editor with service role)
-- ---------------------------------------------------------------------------
--
-- 1. Register the target user in the app (or Supabase Auth).
-- 2. Find their UUID: select id, display_name, role from public.profiles;
-- 3. Grant admin (service role bypasses RLS and protect_profiles_role):
--
-- UPDATE public.profiles
-- SET role = 'admin'
-- WHERE id = 'YOUR_USER_ID';
--
-- Do NOT embed service_role key in the Flutter app.
-- Table Editor with service role also works for content CRUD until Web Admin exists.
