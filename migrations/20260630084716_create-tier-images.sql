CREATE TABLE IF NOT EXISTS tier_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id TEXT NOT NULL,
  image_data TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE tier_images ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Enable all for everyone" ON tier_images;
CREATE POLICY "Enable all for everyone" ON tier_images FOR ALL USING (true) WITH CHECK (true);

CREATE OR REPLACE FUNCTION delete_session_images_delayed(sess_id TEXT) RETURNS void LANGUAGE plpgsql AS $$
BEGIN
  PERFORM pg_sleep(30);
  DELETE FROM tier_images WHERE session_id = sess_id;
END;
$$;
