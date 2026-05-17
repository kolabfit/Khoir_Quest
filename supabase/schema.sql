create extension if not exists "pgcrypto";

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null unique,
  role text not null default 'child' check (role in ('teacher', 'child')),
  avatar_url text,
  created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.learning_materials (
  id text primary key,
  category text not null check (category in ('huruf', 'angka', 'benda', 'iqra', 'lagu')),
  symbol text not null default '',
  label text not null default '',
  image_path text,
  audio_path text,
  video_path text,
  created_by uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create or replace function public.handle_profile_bootstrap()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, username, role, avatar_url)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'username', split_part(new.email, '@', 1)),
    'child',
    null
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_profile_bootstrap();

create or replace function public.set_learning_materials_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

drop trigger if exists set_learning_materials_updated_at on public.learning_materials;
create trigger set_learning_materials_updated_at
before update on public.learning_materials
for each row execute function public.set_learning_materials_updated_at();

alter table public.profiles enable row level security;
alter table public.learning_materials enable row level security;

drop policy if exists "profiles_select_self" on public.profiles;
create policy "profiles_select_self"
on public.profiles
for select
to authenticated
using (auth.uid() = id);

drop policy if exists "profiles_insert_self" on public.profiles;
create policy "profiles_insert_self"
on public.profiles
for insert
to authenticated
with check (auth.uid() = id);

drop policy if exists "profiles_update_self" on public.profiles;
create policy "profiles_update_self"
on public.profiles
for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);

create or replace function public.is_teacher()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role = 'teacher'
  );
$$;

drop policy if exists "learning_materials_read_all_authenticated" on public.learning_materials;
create policy "learning_materials_read_all_authenticated"
on public.learning_materials
for select
to authenticated
using (true);

drop policy if exists "learning_materials_teacher_insert" on public.learning_materials;
create policy "learning_materials_teacher_insert"
on public.learning_materials
for insert
to authenticated
with check (public.is_teacher() and auth.uid() = created_by);

drop policy if exists "learning_materials_teacher_update" on public.learning_materials;
create policy "learning_materials_teacher_update"
on public.learning_materials
for update
to authenticated
using (public.is_teacher())
with check (public.is_teacher() and auth.uid() = created_by);

drop policy if exists "learning_materials_teacher_delete" on public.learning_materials;
create policy "learning_materials_teacher_delete"
on public.learning_materials
for delete
to authenticated
using (public.is_teacher());

insert into storage.buckets (id, name, public)
values ('learning-assets', 'learning-assets', true)
on conflict (id) do nothing;

drop policy if exists "learning_assets_public_read" on storage.objects;
create policy "learning_assets_public_read"
on storage.objects
for select
to public
using (bucket_id = 'learning-assets');

drop policy if exists "learning_assets_teacher_insert" on storage.objects;
create policy "learning_assets_teacher_insert"
on storage.objects
for insert
to authenticated
with check (bucket_id = 'learning-assets' and public.is_teacher());

drop policy if exists "learning_assets_teacher_update" on storage.objects;
create policy "learning_assets_teacher_update"
on storage.objects
for update
to authenticated
using (bucket_id = 'learning-assets' and public.is_teacher())
with check (bucket_id = 'learning-assets' and public.is_teacher());

drop policy if exists "learning_assets_teacher_delete" on storage.objects;
create policy "learning_assets_teacher_delete"
on storage.objects
for delete
to authenticated
using (bucket_id = 'learning-assets' and public.is_teacher());
