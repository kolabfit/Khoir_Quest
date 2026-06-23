create extension if not exists "pgcrypto";

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null unique,
  role text not null default 'child' check (role in ('teacher', 'child')),
  avatar_url text,
  created_at timestamptz not null default timezone('utc', now())
);

alter table public.profiles
  add column if not exists child_name text not null default 'Teman',
  add column if not exists gender text not null default 'boy' check (gender in ('boy', 'girl')),
  add column if not exists theme_id text not null default 'default',
  add column if not exists stars integer not null default 12,
  add column if not exists iqra_streak integer not null default 0,
  add column if not exists progress jsonb not null default '{"membaca":0,"angka":0,"benda":0,"iqra":0}'::jsonb,
  add column if not exists iqra_mastered text[] not null default '{}',
  add column if not exists iqra_history text[] not null default '{}',
  add column if not exists hurf_mastered text[] not null default '{}',
  add column if not exists angka_mastered text[] not null default '{}',
  add column if not exists benda_mastered text[] not null default '{}',
  add column if not exists favorite_material_ids text[] not null default '{}',
  add column if not exists updated_at timestamptz not null default timezone('utc', now());

create table if not exists public.learning_histories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  material_id text not null,
  category text not null check (category in ('huruf', 'angka', 'benda', 'iqra', 'lagu')),
  duration integer not null default 0,
  score integer not null default 0,
  played_at timestamptz not null default timezone('utc', now())
);

create unique index if not exists learning_histories_user_material_category_played_at_idx
on public.learning_histories (user_id, material_id, category, played_at);

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

alter table public.learning_materials
  add column if not exists version integer not null default 1,
  add column if not exists deleted_at timestamptz,
  add column if not exists image_storage_path text,
  add column if not exists audio_storage_path text,
  add column if not exists video_storage_path text,
  add column if not exists media_version integer not null default 1;

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
    case
      when coalesce(new.raw_user_meta_data ->> 'username', split_part(new.email, '@', 1)) ilike 'pengajar%'
        or coalesce(new.raw_user_meta_data ->> 'username', split_part(new.email, '@', 1)) ilike 'guru%'
      then 'teacher'
      else 'child'
    end,
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

create or replace function public.set_profiles_updated_at()
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

drop trigger if exists set_profiles_updated_at on public.profiles;
create trigger set_profiles_updated_at
before update on public.profiles
for each row execute function public.set_profiles_updated_at();

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

create or replace function public.upsert_learning_material_if_current(
  expected_version integer,
  payload jsonb
)
returns public.learning_materials
language plpgsql
security definer
set search_path = public
as $$
declare
  existing public.learning_materials%rowtype;
  saved public.learning_materials%rowtype;
begin
  if not public.is_teacher() then
    raise exception 'teacher role required' using errcode = '42501';
  end if;

  select * into existing
  from public.learning_materials
  where id = payload ->> 'id'
  for update;

  if existing.id is null then
    if coalesce(expected_version, 0) <> 0 then
      raise exception 'stale learning material version' using errcode = 'P0001';
    end if;

    insert into public.learning_materials (
      id, category, symbol, label, image_path, audio_path, video_path,
      image_storage_path, audio_storage_path, video_storage_path,
      media_version, created_by, created_at, updated_at, version, deleted_at
    )
    values (
      payload ->> 'id',
      payload ->> 'category',
      coalesce(payload ->> 'symbol', ''),
      coalesce(payload ->> 'label', ''),
      nullif(payload ->> 'image_path', ''),
      nullif(payload ->> 'audio_path', ''),
      nullif(payload ->> 'video_path', ''),
      nullif(payload ->> 'image_storage_path', ''),
      nullif(payload ->> 'audio_storage_path', ''),
      nullif(payload ->> 'video_storage_path', ''),
      coalesce((payload ->> 'media_version')::integer, 1),
      auth.uid(),
      coalesce((payload ->> 'created_at')::timestamptz, timezone('utc', now())),
      timezone('utc', now()),
      1,
      null
    )
    returning * into saved;
    return saved;
  end if;

  if existing.version <> expected_version then
    raise exception 'stale learning material version' using errcode = 'P0001';
  end if;

  update public.learning_materials
  set
    category = payload ->> 'category',
    symbol = coalesce(payload ->> 'symbol', ''),
    label = coalesce(payload ->> 'label', ''),
    image_path = nullif(payload ->> 'image_path', ''),
    audio_path = nullif(payload ->> 'audio_path', ''),
    video_path = nullif(payload ->> 'video_path', ''),
    image_storage_path = nullif(payload ->> 'image_storage_path', ''),
    audio_storage_path = nullif(payload ->> 'audio_storage_path', ''),
    video_storage_path = nullif(payload ->> 'video_storage_path', ''),
    media_version = greatest(coalesce((payload ->> 'media_version')::integer, existing.media_version), 1),
    created_by = auth.uid(),
    deleted_at = null,
    version = existing.version + 1
  where id = existing.id
  returning * into saved;

  return saved;
end;
$$;

create or replace function public.soft_delete_learning_material_if_current(
  material_id text,
  expected_version integer
)
returns public.learning_materials
language plpgsql
security definer
set search_path = public
as $$
declare
  existing public.learning_materials%rowtype;
  saved public.learning_materials%rowtype;
begin
  if not public.is_teacher() then
    raise exception 'teacher role required' using errcode = '42501';
  end if;

  select * into existing
  from public.learning_materials
  where id = material_id
  for update;

  if existing.id is null then
    raise exception 'learning material not found' using errcode = 'P0002';
  end if;

  if existing.version <> expected_version then
    raise exception 'stale learning material version' using errcode = 'P0001';
  end if;

  update public.learning_materials
  set deleted_at = timezone('utc', now()),
      version = existing.version + 1
  where id = material_id
  returning * into saved;

  return saved;
end;
$$;

alter table public.profiles enable row level security;
alter table public.learning_materials enable row level security;
alter table public.learning_histories enable row level security;

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

drop policy if exists "learning_histories_select_self" on public.learning_histories;
create policy "learning_histories_select_self"
on public.learning_histories
for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "learning_histories_insert_self" on public.learning_histories;
create policy "learning_histories_insert_self"
on public.learning_histories
for insert
to authenticated
with check (auth.uid() = user_id);

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
