-- Drop the previous permissive RLS policies
DROP POLICY IF EXISTS "Enable select for everyone" ON public.tier_images;
DROP POLICY IF EXISTS "Enable insert for everyone" ON public.tier_images;
DROP POLICY IF EXISTS "Enable all for everyone" ON public.tier_images;

-- 1. Anyone (signed-in or anonymous) can read the image catalog
CREATE POLICY "tier_images_public_read" ON public.tier_images
  FOR SELECT TO anon, authenticated
  USING (true);

-- 2. Anyone can upload images anonymously (requiring session_id)
CREATE POLICY "tier_images_anon_insert" ON public.tier_images
  FOR INSERT TO anon
  WITH CHECK (session_id IS NOT NULL);
