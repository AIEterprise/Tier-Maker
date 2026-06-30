-- 1. Drop old SECURITY DEFINER function
DROP FUNCTION IF EXISTS public.delete_session_images_delayed(text);

-- 2. Re-create delete_session_images_delayed as SECURITY INVOKER (the default)
CREATE OR REPLACE FUNCTION delete_session_images_delayed(sess_id TEXT)
RETURNS void LANGUAGE plpgsql SECURITY INVOKER AS $$
BEGIN
  PERFORM pg_catalog.pg_sleep(30);
  DELETE FROM public.tier_images WHERE session_id = sess_id;
END;
$$;

-- 3. Add DELETE policy for anonymous users so the invoker has permission to delete
DROP POLICY IF EXISTS "tier_images_anon_delete" ON public.tier_images;
CREATE POLICY "tier_images_anon_delete" ON public.tier_images
  FOR DELETE TO anon
  USING (session_id IS NOT NULL);
