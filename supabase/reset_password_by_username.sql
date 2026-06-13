-- WARNING: Sengaja tidak aman sesuai kebutuhan lingkungan kecil.
-- Jalankan sekali di Supabase SQL Editor agar app bisa reset password hanya via username.
-- Function ini bisa dipanggil anon/authenticated; jangan pakai untuk aplikasi publik.

create extension if not exists "pgcrypto" with schema extensions;

create or replace function public.reset_password_by_username(
  target_username text,
  new_password text
)
returns void
language plpgsql
security definer
set search_path = public, auth, extensions
as $$
declare
  target_user_id uuid;
  normalized_username text;
  target_email text;
begin
  if length(trim(coalesce(target_username, ''))) < 3 then
    raise exception 'Username minimal 3 karakter';
  end if;

  if length(coalesce(new_password, '')) < 6 then
    raise exception 'Password minimal 6 karakter';
  end if;

  normalized_username := lower(trim(target_username));
  target_email := 'u.' || substring(encode(extensions.digest(normalized_username, 'sha256'), 'hex') from 1 for 24) || '@example.com';

  select id into target_user_id
  from public.profiles
  where username = normalized_username
  limit 1;

  if target_user_id is null then
    raise exception 'Akun belum terdaftar';
  end if;

  update auth.users
  set
    email = target_email,
    encrypted_password = extensions.crypt(new_password, extensions.gen_salt('bf')),
    raw_user_meta_data = coalesce(raw_user_meta_data, '{}'::jsonb) || jsonb_build_object('username', normalized_username),
    recovery_token = '',
    recovery_sent_at = null,
    updated_at = timezone('utc', now())
  where id = target_user_id;
end;
$$;

revoke all on function public.reset_password_by_username(text, text) from public;
grant execute on function public.reset_password_by_username(text, text) to anon, authenticated;
