-- Seed materi dasar untuk public.learning_materials.
-- Ganti teacher_username sesuai username akun pengajar di table public.profiles.
-- Label sengaja hanya simbol/nama pendek: tidak memakai "Angka 1" / "Huruf A".

do $$
declare
  teacher_username text := 'pengajar';
  teacher_id uuid;
begin
  select id into teacher_id
  from public.profiles
  where username = teacher_username and role = 'teacher'
  limit 1;

  if teacher_id is null then
    select id into teacher_id
    from public.profiles
    where role = 'teacher'
    order by created_at
    limit 1;
  end if;

  if teacher_id is null then
    raise exception 'Akun teacher belum ada. Buat/login akun guru dulu, lalu jalankan seed ini.';
  end if;

  insert into public.learning_materials (id, category, symbol, label, image_path, audio_path, video_path, created_by)
  values
    ('angka_1', 'angka', '1', '1', null, null, null, teacher_id),
    ('angka_2', 'angka', '2', '2', null, null, null, teacher_id),
    ('angka_3', 'angka', '3', '3', null, null, null, teacher_id),
    ('angka_4', 'angka', '4', '4', null, null, null, teacher_id),
    ('angka_5', 'angka', '5', '5', null, null, null, teacher_id),
    ('angka_6', 'angka', '6', '6', null, null, null, teacher_id),
    ('angka_7', 'angka', '7', '7', null, null, null, teacher_id),
    ('angka_8', 'angka', '8', '8', null, null, null, teacher_id),
    ('angka_9', 'angka', '9', '9', null, null, null, teacher_id),
    ('angka_10', 'angka', '10', '10', null, null, null, teacher_id),
    ('huruf_a', 'huruf', 'A', 'A', null, null, null, teacher_id),
    ('huruf_b', 'huruf', 'B', 'B', null, null, null, teacher_id),
    ('huruf_c', 'huruf', 'C', 'C', null, null, null, teacher_id),
    ('huruf_d', 'huruf', 'D', 'D', null, null, null, teacher_id),
    ('huruf_e', 'huruf', 'E', 'E', null, null, null, teacher_id),
    ('huruf_f', 'huruf', 'F', 'F', null, null, null, teacher_id),
    ('huruf_g', 'huruf', 'G', 'G', null, null, null, teacher_id),
    ('huruf_h', 'huruf', 'H', 'H', null, null, null, teacher_id),
    ('huruf_i', 'huruf', 'I', 'I', null, null, null, teacher_id),
    ('huruf_j', 'huruf', 'J', 'J', null, null, null, teacher_id),
    ('huruf_k', 'huruf', 'K', 'K', null, null, null, teacher_id),
    ('huruf_l', 'huruf', 'L', 'L', null, null, null, teacher_id),
    ('huruf_m', 'huruf', 'M', 'M', null, null, null, teacher_id),
    ('huruf_n', 'huruf', 'N', 'N', null, null, null, teacher_id),
    ('huruf_o', 'huruf', 'O', 'O', null, null, null, teacher_id),
    ('huruf_p', 'huruf', 'P', 'P', null, null, null, teacher_id),
    ('huruf_q', 'huruf', 'Q', 'Q', null, null, null, teacher_id),
    ('huruf_r', 'huruf', 'R', 'R', null, null, null, teacher_id),
    ('huruf_s', 'huruf', 'S', 'S', null, null, null, teacher_id),
    ('huruf_t', 'huruf', 'T', 'T', null, null, null, teacher_id),
    ('huruf_u', 'huruf', 'U', 'U', null, null, null, teacher_id),
    ('huruf_v', 'huruf', 'V', 'V', null, null, null, teacher_id),
    ('huruf_w', 'huruf', 'W', 'W', null, null, null, teacher_id),
    ('huruf_x', 'huruf', 'X', 'X', null, null, null, teacher_id),
    ('huruf_y', 'huruf', 'Y', 'Y', null, null, null, teacher_id),
    ('huruf_z', 'huruf', 'Z', 'Z', null, null, null, teacher_id),
    ('iqra_1_alif', 'iqra', 'ا', 'ا', null, null, null, teacher_id),
    ('iqra_1_ba', 'iqra', 'ب', 'ب', null, null, null, teacher_id),
    ('iqra_1_ta', 'iqra', 'ت', 'ت', null, null, null, teacher_id),
    ('iqra_1_tsa', 'iqra', 'ث', 'ث', null, null, null, teacher_id),
    ('iqra_1_jim', 'iqra', 'ج', 'ج', null, null, null, teacher_id),
    ('iqra_1_ha', 'iqra', 'ح', 'ح', null, null, null, teacher_id),
    ('iqra_1_kha', 'iqra', 'خ', 'خ', null, null, null, teacher_id),
    ('iqra_1_dal', 'iqra', 'د', 'د', null, null, null, teacher_id),
    ('iqra_1_dzal', 'iqra', 'ذ', 'ذ', null, null, null, teacher_id),
    ('iqra_1_ra', 'iqra', 'ر', 'ر', null, null, null, teacher_id),
    ('iqra_1_zai', 'iqra', 'ز', 'ز', null, null, null, teacher_id),
    ('iqra_1_sin', 'iqra', 'س', 'س', null, null, null, teacher_id),
    ('iqra_1_syin', 'iqra', 'ش', 'ش', null, null, null, teacher_id),
    ('iqra_1_shad', 'iqra', 'ص', 'ص', null, null, null, teacher_id),
    ('iqra_1_dhad', 'iqra', 'ض', 'ض', null, null, null, teacher_id),
    ('iqra_1_tha', 'iqra', 'ط', 'ط', null, null, null, teacher_id),
    ('iqra_1_zha', 'iqra', 'ظ', 'ظ', null, null, null, teacher_id),
    ('iqra_1_ain', 'iqra', 'ع', 'ع', null, null, null, teacher_id),
    ('iqra_1_ghain', 'iqra', 'غ', 'غ', null, null, null, teacher_id),
    ('iqra_1_fa', 'iqra', 'ف', 'ف', null, null, null, teacher_id),
    ('iqra_1_qaf', 'iqra', 'ق', 'ق', null, null, null, teacher_id),
    ('iqra_1_kaf', 'iqra', 'ك', 'ك', null, null, null, teacher_id),
    ('iqra_1_lam', 'iqra', 'ل', 'ل', null, null, null, teacher_id),
    ('iqra_1_mim', 'iqra', 'م', 'م', null, null, null, teacher_id),
    ('iqra_1_nun', 'iqra', 'ن', 'ن', null, null, null, teacher_id),
    ('iqra_1_waw', 'iqra', 'و', 'و', null, null, null, teacher_id),
    ('iqra_1_ha2', 'iqra', 'ه', 'ه', null, null, null, teacher_id),
    ('iqra_1_lam_alif', 'iqra', 'لا', 'لا', null, null, null, teacher_id),
    ('iqra_1_ya', 'iqra', 'ي', 'ي', null, null, null, teacher_id)
  on conflict (id) do update set
    category = excluded.category,
    symbol = excluded.symbol,
    label = excluded.label,
    image_path = excluded.image_path,
    audio_path = excluded.audio_path,
    video_path = excluded.video_path,
    updated_at = timezone('utc', now());
end $$;