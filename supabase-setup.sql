-- Replace the UUID below with the admin user's Auth UID from Supabase Dashboard > Authentication > Users.
-- This SQL creates one public-read site settings row, admin-only writes, and a public photo bucket.

create table if not exists public.iris_site_config (
  id integer primary key check (id = 1),
  payload jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.iris_site_config enable row level security;
grant select on public.iris_site_config to anon, authenticated;
grant update on public.iris_site_config to authenticated;

drop policy if exists "Public can read Iris site settings" on public.iris_site_config;
create policy "Public can read Iris site settings" on public.iris_site_config
  for select to anon, authenticated using (true);

drop policy if exists "Only Iris admin can update site settings" on public.iris_site_config;
create policy "Only Iris admin can update site settings" on public.iris_site_config
  for update to authenticated
  using (auth.uid() = 'REPLACE_WITH_ADMIN_USER_UUID'::uuid)
  with check (auth.uid() = 'REPLACE_WITH_ADMIN_USER_UUID'::uuid);

insert into public.iris_site_config (id, payload) values (1, $json$
{
  "businessHours": "12:00 PM–12:00 AM",
  "bookingPhone": "601139465648",
  "profiles": [
    {"id":"023","name":"jessy","price":75,"available":true,"photo":"assets/jessy.jpg"},
    {"id":"017","name":"Novi","price":75,"available":true},
    {"id":"661","name":"Mimi","price":75,"available":true},
    {"id":"021","name":"acha","price":75,"available":true},
    {"id":"012","name":"Elly","price":80,"available":true},
    {"id":"V1","name":"Sofie","price":75,"available":true},
    {"id":"016","name":"Caca","price":75,"available":true},
    {"id":"T22","name":"Wawa","price":75,"available":true},
    {"id":"020","name":"Arie","price":75,"available":true},
    {"id":"675","name":"KK","price":75,"available":true},
    {"id":"V32","name":"melody","price":75,"available":true},
    {"id":"011","name":"Sheron","price":80,"available":true},
    {"id":"028","name":"Sandra","price":75,"available":true},
    {"id":"928","name":"Lisa","price":75,"available":true},
    {"id":"018","name":"Fera","price":75,"available":true},
    {"id":"601","name":"Lela","price":75,"available":true},
    {"id":"V18","name":"Yumi","price":80,"available":true},
    {"id":"015","name":"Niya","price":75,"available":true},
    {"id":"C6","name":"Ke","price":80,"available":true},
    {"id":"T33","name":"Bella","price":75,"available":false},
    {"id":"T35","name":"Irin","price":75,"available":true},
    {"id":"037","name":"nova","price":75,"available":true},
    {"id":"036","name":"erni","price":75,"available":false}
  ]
}
$json$::jsonb)
on conflict (id) do nothing;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('iris-photos', 'iris-photos', true, 8388608, array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public = true, file_size_limit = 8388608,
  allowed_mime_types = array['image/jpeg','image/png','image/webp'];

-- Public visitors may view images in this public bucket.
drop policy if exists "Public can view Iris photos" on storage.objects;
create policy "Public can view Iris photos" on storage.objects
  for select to anon, authenticated using (bucket_id = 'iris-photos');

drop policy if exists "Only Iris admin can upload photos" on storage.objects;
create policy "Only Iris admin can upload photos" on storage.objects
  for insert to authenticated with check (
    bucket_id = 'iris-photos' and auth.uid() = 'REPLACE_WITH_ADMIN_USER_UUID'::uuid
  );

drop policy if exists "Only Iris admin can update photos" on storage.objects;
create policy "Only Iris admin can update photos" on storage.objects
  for update to authenticated using (
    bucket_id = 'iris-photos' and auth.uid() = 'REPLACE_WITH_ADMIN_USER_UUID'::uuid
  ) with check (
    bucket_id = 'iris-photos' and auth.uid() = 'REPLACE_WITH_ADMIN_USER_UUID'::uuid
  );

drop policy if exists "Only Iris admin can delete photos" on storage.objects;
create policy "Only Iris admin can delete photos" on storage.objects
  for delete to authenticated using (
    bucket_id = 'iris-photos' and auth.uid() = 'REPLACE_WITH_ADMIN_USER_UUID'::uuid
  );
