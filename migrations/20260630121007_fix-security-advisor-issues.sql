-- Fix Issue 1: Split permissive 'Enable all for everyone' policy on public.tier_images
DROP POLICY IF EXISTS "Enable all for everyone" ON public.tier_images;
DROP POLICY IF EXISTS "Enable select for everyone" ON public.tier_images;
DROP POLICY IF EXISTS "Enable insert for everyone" ON public.tier_images;
DROP POLICY IF EXISTS "tier_images_public_read" ON public.tier_images;
DROP POLICY IF EXISTS "tier_images_anon_insert" ON public.tier_images;

-- 1. Anyone (signed-in or anonymous) can read the image catalog
CREATE POLICY "tier_images_public_read" ON public.tier_images
  FOR SELECT TO anon, authenticated
  USING (true);

-- 2. Anyone can upload images anonymously (requiring session_id)
CREATE POLICY "tier_images_anon_insert" ON public.tier_images
  FOR INSERT TO anon
  WITH CHECK (session_id IS NOT NULL);

-- 3. Redefine delete_session_images_delayed as SECURITY INVOKER
CREATE OR REPLACE FUNCTION delete_session_images_delayed(sess_id TEXT)
RETURNS void LANGUAGE plpgsql SECURITY INVOKER AS $$
BEGIN
  PERFORM pg_catalog.pg_sleep(30);
  DELETE FROM public.tier_images WHERE session_id = sess_id;
END;
$$;
