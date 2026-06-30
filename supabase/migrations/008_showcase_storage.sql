-- AI Pilot showcase storage (Sprint 13.2)
-- Public bucket for completed-work sample images.

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'showcases',
  'showcases',
  true,
  10485760,
  ARRAY['image/webp', 'image/jpeg', 'image/png', 'image/gif']
)
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

CREATE POLICY showcases_public_read
  ON storage.objects
  FOR SELECT
  TO public
  USING (bucket_id = 'showcases');

CREATE POLICY showcases_admin_write
  ON storage.objects
  FOR ALL
  TO authenticated
  USING (
    bucket_id = 'showcases'
    AND public.is_admin(auth.uid())
  )
  WITH CHECK (
    bucket_id = 'showcases'
    AND public.is_admin(auth.uid())
  );

-- Replace legacy placeholder URLs with Storage paths.
UPDATE public.workflow_showcases SET
  thumbnail_url = 'youtube/wf_youtube_short/showcase_yt_1/thumbnail.webp',
  preview_image_url = 'youtube/wf_youtube_short/showcase_yt_1/preview.webp'
WHERE id = '90000000-0000-4000-8000-000000000001';

UPDATE public.workflow_showcases SET
  thumbnail_url = 'youtube/wf_youtube_short/showcase_yt_2/thumbnail.webp',
  preview_image_url = 'youtube/wf_youtube_short/showcase_yt_2/preview.webp'
WHERE id = '90000000-0000-4000-8000-000000000002';

UPDATE public.workflow_showcases SET
  thumbnail_url = 'youtube/wf_youtube_short/showcase_yt_3/thumbnail.webp',
  preview_image_url = 'youtube/wf_youtube_short/showcase_yt_3/preview.webp'
WHERE id = '90000000-0000-4000-8000-000000000003';

UPDATE public.workflow_showcases SET
  thumbnail_url = 'blog/wf_blog/showcase_blog_1/thumbnail.webp',
  preview_image_url = 'blog/wf_blog/showcase_blog_1/preview.webp'
WHERE id = '90000000-0000-4000-8000-000000000004';

UPDATE public.workflow_showcases SET
  thumbnail_url = 'blog/wf_blog/showcase_blog_2/thumbnail.webp',
  preview_image_url = 'blog/wf_blog/showcase_blog_2/preview.webp'
WHERE id = '90000000-0000-4000-8000-000000000005';

UPDATE public.workflow_showcases SET
  thumbnail_url = 'blog/wf_blog/showcase_blog_3/thumbnail.webp',
  preview_image_url = 'blog/wf_blog/showcase_blog_3/preview.webp'
WHERE id = '90000000-0000-4000-8000-000000000006';

UPDATE public.workflow_showcases SET
  thumbnail_url = 'instagram/wf_sns/showcase_sns_1/thumbnail.webp',
  preview_image_url = 'instagram/wf_sns/showcase_sns_1/preview.webp'
WHERE id = '90000000-0000-4000-8000-000000000007';

UPDATE public.workflow_showcases SET
  thumbnail_url = 'instagram/wf_sns/showcase_sns_2/thumbnail.webp',
  preview_image_url = 'instagram/wf_sns/showcase_sns_2/preview.webp'
WHERE id = '90000000-0000-4000-8000-000000000008';

UPDATE public.workflow_showcases SET
  thumbnail_url = 'instagram/wf_sns/showcase_sns_3/thumbnail.webp',
  preview_image_url = 'instagram/wf_sns/showcase_sns_3/preview.webp'
WHERE id = '90000000-0000-4000-8000-000000000009';

UPDATE public.showcase_assets SET
  url = 'youtube/wf_youtube_short/showcase_yt_2/thumbnail.webp'
WHERE id = '92000000-0000-4000-8000-000000000002';

UPDATE public.showcase_assets SET
  url = 'blog/wf_blog/showcase_blog_2/preview.webp'
WHERE id = '92000000-0000-4000-8000-000000000008';
