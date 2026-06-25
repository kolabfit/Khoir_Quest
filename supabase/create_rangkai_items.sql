create table if not exists public.rangkai_items (
  id text primary key,
  type text not null check (type in ('abjad', 'kata')),
  title text not null default '',
  target text not null default '',
  pieces text[] not null default '{}',
  units jsonb not null default '[]'::jsonb,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create or replace function public.set_rangkai_items_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

drop trigger if exists set_rangkai_items_updated_at on public.rangkai_items;
create trigger set_rangkai_items_updated_at
before update on public.rangkai_items
for each row execute function public.set_rangkai_items_updated_at();

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

alter table public.rangkai_items enable row level security;

drop policy if exists "rangkai_items_read_all_authenticated" on public.rangkai_items;
create policy "rangkai_items_read_all_authenticated"
on public.rangkai_items
for select
to authenticated
using (true);

drop policy if exists "rangkai_items_teacher_insert" on public.rangkai_items;
create policy "rangkai_items_teacher_insert"
on public.rangkai_items
for insert
to authenticated
with check (public.is_teacher() and (created_by is null or auth.uid() = created_by));

drop policy if exists "rangkai_items_teacher_update" on public.rangkai_items;
create policy "rangkai_items_teacher_update"
on public.rangkai_items
for update
to authenticated
using (public.is_teacher())
with check (public.is_teacher() and (created_by is null or auth.uid() = created_by));

drop policy if exists "rangkai_items_teacher_delete" on public.rangkai_items;
create policy "rangkai_items_teacher_delete"
on public.rangkai_items
for delete
to authenticated
using (public.is_teacher());

notify pgrst, 'reload schema';
