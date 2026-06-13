-- Jalankan sekali jika akun lama tidak bisa login karena email auth tidak cocok dengan format app.
-- App login username memakai email sintetis: u.<sha256 username 24 chars>@example.com.

create extension if not exists "pgcrypto" with schema extensions;

update auth.users as users
set
  email = expected.email,
  raw_user_meta_data = coalesce(users.raw_user_meta_data, '{}'::jsonb) || jsonb_build_object('username', expected.username),
  updated_at = timezone('utc', now())
from (
  select
    profiles.id,
    lower(trim(profiles.username)) as username,
    'u.' || substring(encode(extensions.digest(lower(trim(profiles.username)), 'sha256'), 'hex') from 1 for 24) || '@example.com' as email
  from public.profiles
) as expected
where users.id = expected.id
  and users.email is distinct from expected.email;
