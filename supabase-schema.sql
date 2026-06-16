-- ============================================================
-- Experimax ITAD – Supabase Schema
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

DO $$
DECLARE t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'devices','repairs','inspections','reinspections',
    'sales','parts','customers','employees','history'
  ] LOOP
    EXECUTE format('
      CREATE TABLE IF NOT EXISTS %I (
        id          TEXT PRIMARY KEY,
        data        JSONB NOT NULL,
        created_at  TIMESTAMPTZ DEFAULT NOW(),
        updated_at  TIMESTAMPTZ DEFAULT NOW()
      )', t);

    -- Enable Row Level Security
    EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', t);

    -- Allow full access via the anon key (app enforces access via PIN login)
    EXECUTE format('DROP POLICY IF EXISTS "allow_all" ON %I', t);
    EXECUTE format(
      'CREATE POLICY "allow_all" ON %I FOR ALL USING (true) WITH CHECK (true)', t
    );
  END LOOP;
END $$;
