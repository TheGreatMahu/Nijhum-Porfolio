-- Run this in the Supabase SQL Editor.
create table if not exists public.portfolio_content (
  id text primary key check (id = 'main'),
  content jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.portfolio_content enable row level security;
grant select, insert, update on public.portfolio_content to anon, authenticated;

drop policy if exists "Portfolio is publicly readable" on public.portfolio_content;
create policy "Portfolio is publicly readable"
  on public.portfolio_content for select
  to anon, authenticated
  using (true);

drop policy if exists "Only admin role can edit portfolio" on public.portfolio_content;
create policy "Only admin role can edit portfolio"
  on public.portfolio_content for all
  to authenticated
  using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
  with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

insert into storage.buckets (id, name, public)
values ('portfolio-assets', 'portfolio-assets', true)
on conflict (id) do nothing;

drop policy if exists "Portfolio images are public" on storage.objects;
create policy "Portfolio images are public"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'portfolio-assets');

drop policy if exists "Admin can upload portfolio images" on storage.objects;
create policy "Admin can upload portfolio images"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'portfolio-assets' and (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');

drop policy if exists "Admin can update portfolio images" on storage.objects;
create policy "Admin can update portfolio images"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'portfolio-assets' and (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin')
  with check (bucket_id = 'portfolio-assets' and (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin');
