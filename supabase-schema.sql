-- ============================================================
-- FEEL OS  ·  Supabase schema
-- Run this once in Supabase  ->  SQL Editor  ->  New query  ->  Run
-- ============================================================

-- Single generic table. Every record (b2b lead, influencer, note,
-- inventory line, etc.) is a row. The "collection" column says what
-- kind it is, and "data" (jsonb) holds the fields. This keeps the
-- whole FEEL OS in one clean table that is easy to back up.
create table if not exists public.feel_records (
  id          uuid primary key default gen_random_uuid(),
  collection  text not null,
  data        jsonb not null default '{}'::jsonb,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists feel_records_collection_idx
  on public.feel_records (collection);

-- Keep updated_at fresh on every change.
create or replace function public.feel_touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists feel_touch on public.feel_records;
create trigger feel_touch
  before update on public.feel_records
  for each row execute function public.feel_touch_updated_at();

-- ------------------------------------------------------------
-- Access. Row Level Security is ON. The policy below lets the
-- public anon key read and write. That is what makes the app
-- shared for you and Diana without a login.
--
-- TRADE-OFF: anyone who has the website link + anon key can edit.
-- For an internal tool on a private URL this is usually fine.
-- When you want real email/password login, tell Claude and we
-- replace this policy with an authenticated-only one.
-- ------------------------------------------------------------
alter table public.feel_records enable row level security;

drop policy if exists "feel_open_access" on public.feel_records;
create policy "feel_open_access"
  on public.feel_records
  for all
  using (true)
  with check (true);

-- Allow realtime so changes appear live on every device.
alter publication supabase_realtime add table public.feel_records;
