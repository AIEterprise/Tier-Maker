-- Drop previous anonymous RLS policies
DROP POLICY IF EXISTS "tier_images_public_read" ON public.tier_images;
DROP POLICY IF EXISTS "tier_images_anon_insert" ON public.tier_images;
DROP POLICY IF EXISTS "tier_images_anon_delete" ON public.tier_images;

-- 1. Only authenticated users can read image records
CREATE POLICY "tier_images_auth_read" ON public.tier_images
  FOR SELECT TO authenticated
  USING (true);

-- 2. Only authenticated users can upload images (requiring session_id)
CREATE POLICY "tier_images_auth_insert" ON public.tier_images
  FOR INSERT TO authenticated
  WITH CHECK (session_id IS NOT NULL);

-- 3. Only authenticated users can delete their session images
CREATE POLICY "tier_images_auth_delete" ON public.tier_images
  FOR DELETE TO authenticated
  USING (session_id IS NOT NULL);
