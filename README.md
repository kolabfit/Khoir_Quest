<p align="center">
   <img width="300" height="300" alt="Logo_Aplikasi" src="https://github.com/user-attachments/assets/0a147627-fd09-469d-95ab-9c4895498e52"/>
<p>
<h1 align="center">
   Khoir Quets
</h1>


> Aplikasi Flutter pembelajaran anak bertema petualangan edukatif untuk membantu anak usia dini belajar sambil bermain, dengan pengalaman yang ramah anak, interaktif, dan tetap dapat dipakai secara offline.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-4CAF50)
![Supabase](https://img.shields.io/badge/Supabase-Optional-3ECF8E?logo=supabase&logoColor=white)
![Status](https://img.shields.io/badge/Status-Active%20Development-F59E0B)
![License](https://img.shields.io/badge/License-TBD-lightgrey)

## Daftar Isi

- [Ringkasan Aplikasi](#ringkasan-aplikasi)
- [Fitur Utama](#fitur-utama)
- [Teknologi yang Digunakan](#teknologi-yang-digunakan)
- [Arsitektur Aplikasi](#arsitektur-aplikasi)
- [Struktur Folder](#struktur-folder)
- [Instalasi dan Menjalankan Proyek](#instalasi-dan-menjalankan-proyek)
- [Konfigurasi Environment](#konfigurasi-environment)
- [Fitur Aplikasi Secara Detail](#fitur-aplikasi-secara-detail)
- [Role Pengguna](#role-pengguna)
- [Database dan Penyimpanan](#database-dan-penyimpanan)
- [Screenshot / Preview](#screenshot--preview)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Kontak / Author](#kontak--author)

## Ringkasan Aplikasi

**Khoir Quest** adalah aplikasi pembelajaran PAUD berbasis Flutter yang membawa pengalaman belajar ke dalam nuansa petualangan edukatif. Anak tidak hanya melihat materi, tetapi juga diajak berinteraksi melalui visual, suara, progress, badge, serta mode bermain yang mendorong rasa penasaran.

Tujuan utama aplikasi ini adalah membuat proses belajar menjadi:

- lebih menyenangkan untuk anak usia dini,
- lebih mudah dipantau oleh orang tua,
- lebih mudah dikelola oleh pengajar,
- dan tetap dapat berjalan stabil walau koneksi internet terbatas.

Target pengguna aplikasi:

- **Anak usia dini / PAUD** untuk belajar huruf, angka, benda, Iqra 1, dan lagu anak.
- **Pengajar** untuk mengelola materi belajar, media, serta pengalaman belajar anak.
- **Orang tua** untuk mendampingi dan memantau progres belajar anak.

Konsep yang diusung adalah **belajar sambil bermain**: materi disajikan dengan tampilan ramah anak, audio interaktif, mode seru berbasis suara, sistem progres, dan badge pencapaian agar belajar terasa seperti petualangan yang menyenangkan.

## Fitur Utama

- 🔐 **Login & Registrasi** untuk memulai sesi belajar secara personal.
- 👤 **Role-based access** untuk membedakan akses anak/user biasa dan pengajar.
- 🧭 **Pusat Belajar** sebagai hub utama untuk memilih materi pembelajaran.
- 🔤 **Belajar Huruf A-Z** dengan tampilan visual dan bantuan suara.
- 🔢 **Belajar Angka 1-10** dengan interaksi yang sederhana dan mudah dipahami.
- 🧸 **Belajar Benda** untuk mengenal objek di sekitar anak.
- 📖 **Belajar Iqra 1** untuk pengenalan dasar membaca huruf hijaiyah.
- 🎵 **Lagu Anak** dengan dukungan audio/video pembelajaran.
- 🎙️ **Mode Seru** berbasis suara/mikrofon untuk latihan interaktif.
- 📈 **Progress Belajar** untuk memantau perkembangan setiap kategori.
- 🏅 **Badge & Achievement** untuk meningkatkan motivasi belajar anak.
- 🎨 **Ganti Tema Aplikasi** termasuk dukungan mode malam.
- 🧑‍🏫 **Dashboard Pengajar** untuk kelola materi, media, dan tampilan.
- ⬆️ **Upload Materi** gambar, audio, dan video pembelajaran.
- 💾 **Offline-first experience** dengan local storage untuk penggunaan harian.
- ☁️ **Integrasi Cloud Opsional** melalui Supabase untuk sinkronisasi akun, profil, materi, dan media.

## Teknologi yang Digunakan

Berikut stack utama yang digunakan di proyek ini beserta perannya:

| Teknologi | Fungsi |
| --- | --- |
| **Flutter** | Framework UI utama untuk membangun aplikasi mobile dari satu codebase. |
| **Dart** | Bahasa pemrograman yang digunakan untuk seluruh logika aplikasi. |
| **flutter_riverpod** | State management untuk mengelola state aplikasi secara lebih rapi dan terukur. |
| **go_router** | Navigasi modern untuk pengelolaan route dan alur halaman. |
| **Isar Database** | Database lokal utama untuk menyimpan akun, progres, badge, tema, histori, dan materi penting. |
| **Sembast / sembast_web** | Penyimpanan lokal tambahan/legacy untuk kompatibilitas data dan kebutuhan migrasi/cache. |
| **Shared Preferences** | Menyimpan preferensi ringan seperti status onboarding dan tema. |
| **Supabase** | Backend opsional untuk autentikasi, database Postgres, dan sinkronisasi cloud. |
| **Supabase Storage** | Penyimpanan file media seperti gambar, audio, dan video pembelajaran di cloud. |
| **just_audio** | Memutar audio pembelajaran dan lagu anak. |
| **flutter_tts** | Text-to-speech untuk membacakan huruf, angka, kata benda, dan Iqra. |
| **speech_to_text** | Pengenalan suara untuk Mode Seru berbasis mikrofon. |
| **vosk_flutter** | Dependensi pendukung untuk pengembangan speech recognition offline/lokal. |
| **image_picker** | Mengambil gambar dari galeri saat pengajar mengelola materi. |
| **file_picker** | Memilih file media seperti gambar/video dari perangkat. |
| **cached_network_image** | Menampilkan dan meng-cache gambar dari sumber remote. |
| **path_provider** | Menentukan lokasi penyimpanan file lokal aplikasi. |
| **video_player** | Memutar video materi, terutama untuk lagu anak. |
| **flutter_animate** | Menambahkan animasi UI agar pengalaman lebih hidup dan ramah anak. |
| **confetti** | Efek visual saat anak mencapai progress atau pencapaian tertentu. |
| **connectivity_plus** | Memantau koneksi internet untuk kebutuhan sync cloud. |

## Arsitektur Aplikasi

Khoir Quest dirancang dengan pendekatan **offline-first**, sehingga aplikasi tetap nyaman digunakan walau perangkat sedang tidak terhubung internet.

Gambaran arsitektur umumnya:

```text
UI / Screen
   -> AppState / Riverpod
   -> Repository Layer
   -> Local DB (Isar) + Local File Storage
   -> Cloud Sync Service (opsional)
   -> Supabase Auth + Postgres + Storage
```

Prinsip utama arsitektur:

- **Offline-first**: data penting tetap tersedia secara lokal.
- **Local database**: akun lokal, progres, badge, tema, histori, dan katalog materi disimpan di perangkat.
- **Local storage**: file gambar, audio, dan video dapat disimpan ke direktori aplikasi agar tetap bisa dipakai offline.
- **Cloud sync bila tersedia**: jika Supabase dikonfigurasi, profil, histori, materi, dan media dapat disinkronkan.
- **Role-based UI**: tampilan dan akses dibedakan antara anak/user biasa dan pengajar.
- **Separation of responsibility**: repository dan service memisahkan logika data, sync, auth, dan penyimpanan media dari layer UI.

## Struktur Folder

Berikut struktur folder utama proyek:

```text
.
├── assets/
│   ├── fonts/
│   └── images/
├── lib/
│   ├── core/
│   │   ├── config/
│   │   ├── constants/
│   │   └── utils/
│   ├── database/
│   │   ├── collections/
│   │   └── isar_database_service.dart
│   ├── features/
│   │   └── offline/
│   ├── models/
│   ├── repositories/
│   ├── services/
│   ├── src/
│   ├── storage/
│   └── main.dart
├── supabase/
│   └── schema.sql
└── test/
```

Penjelasan singkat:

- `assets/`  
  Menyimpan aset statis seperti gambar ilustrasi, ikon, background, dan font aplikasi.

- `lib/core/`  
  Berisi konfigurasi inti, konstanta aplikasi, dan utilitas umum.

- `lib/database/`  
  Lapisan database lokal berbasis Isar, termasuk definisi collection/entity.

- `lib/features/offline/`  
  Provider dan alur pendukung untuk pengalaman offline-first.

- `lib/models/`  
  Model data domain seperti profil cloud, badge, dan materi pembelajaran.

- `lib/repositories/`  
  Lapisan akses data untuk auth, progress, badge, user, materi, tema, dan storage.

- `lib/services/`  
  Service untuk auth, upload, cache, konektivitas, bootstrap offline, migrasi, dan sinkronisasi cloud.

- `lib/src/`  
  Saat ini menjadi layer presentasi utama yang berisi screen, widget, theme, state aplikasi, dashboard pengajar, dan modul pembelajaran.

- `lib/storage/`  
  Service penyimpanan file lokal untuk gambar, audio, video, dan cache.

- `supabase/schema.sql`  
  Skema SQL untuk tabel, bucket storage, trigger, dan policy Supabase.

- `test/`  
  Berisi pengujian dasar aplikasi.

## Instalasi dan Menjalankan Proyek

### 1. Clone repository

```bash
git clone https://github.com/kolabfit/Khoir_Quest
cd App_Paud_Sentrakreasi
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Siapkan konfigurasi cloud (opsional)

Jika ingin memakai Supabase, siapkan URL dan anon key saat menjalankan aplikasi.

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

Jika ingin menjalankan aplikasi dalam mode lokal/offline saja, aplikasi tetap bisa dijalankan tanpa setup cloud tambahan.

### 4. Setup schema Supabase (opsional)

Import file SQL berikut ke Supabase SQL Editor:

```text
supabase/schema.sql
```

Schema ini mencakup:

- tabel `profiles`
- tabel `learning_histories`
- tabel `learning_materials`
- trigger bootstrap profil
- RLS policy
- bucket storage `learning-assets`

### 5. Setup database lokal

Database lokal akan dibangun otomatis saat aplikasi pertama kali dijalankan. Tidak ada langkah manual wajib untuk penggunaan normal.

Jika ada perubahan model Isar di masa pengembangan, jalankan:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 6. Pastikan asset tersedia

Asset gambar dan font sudah dideklarasikan di `pubspec.yaml`. Setelah menambah asset baru, jalankan:

```bash
flutter pub get
```

### 7. Jalankan di emulator atau device

```bash
flutter run
```

Contoh command tambahan:

```bash
flutter devices
flutter analyze
flutter test
```

## Konfigurasi Environment

Proyek ini **saat ini membaca konfigurasi Supabase melalui compile-time environment** dengan `String.fromEnvironment`, bukan paket `.env` runtime.

### Konfigurasi yang dibutuhkan

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

### Opsi 1 - Langsung via `--dart-define`

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

### Opsi 2 - Via file environment JSON

```json
{
  "SUPABASE_URL": "https://your-project.supabase.co",
  "SUPABASE_ANON_KEY": "your-anon-key"
}
```

Jalankan dengan:

```bash
flutter run --dart-define-from-file=.env.json
```

### Supabase config

Pastikan project Supabase memiliki:

- Auth **tidak** aktif untuk email/password
- tabel dan policy dari `supabase/schema.sql`
- bucket storage `learning-assets`

### Setup assets

Asset utama berada di:

- `assets/images/`
- `assets/fonts/`

Jika menambah asset baru, daftarkan juga di `pubspec.yaml`.

### Permission Android

Permission yang saat ini dipakai:

- `android.permission.INTERNET`
- `android.permission.RECORD_AUDIO`

### Permission iOS

Permission yang saat ini dipakai:

- `NSMicrophoneUsageDescription`
- `NSSpeechRecognitionUsageDescription`

Catatan:

- jika menambah upload kamera, izin kamera/photo library mungkin perlu ditambahkan,
- jika hanya memakai konfigurasi lokal, bagian cloud bisa dilewati.

## Fitur Aplikasi Secara Detail

### 1. Pusat Belajar

Pusat Belajar adalah hub utama petualangan anak. Dari sini anak bisa memilih jalur materi yang ingin dipelajari tanpa navigasi yang rumit. Manfaatnya adalah membuat anak lebih mandiri saat mulai belajar.

### 2. Huruf

Modul huruf membantu anak mengenal huruf A-Z melalui tampilan visual yang cerah, bantuan suara, dan interaksi sederhana. Fitur ini mendukung pengenalan alfabet secara bertahap dan menyenangkan.

### 3. Angka

Modul angka mengenalkan angka 1-10 dengan pendekatan yang ringan untuk anak usia dini. Cocok untuk membangun dasar berhitung dan pengenalan simbol angka sejak awal.

### 4. Benda

Modul benda membantu anak mengenali objek di sekitar mereka. Materi ini memperkuat kosakata, pengamatan visual, dan keterhubungan antara gambar dengan nama benda.

### 5. Iqra

Modul Iqra 1 difokuskan pada pengenalan dasar huruf hijaiyah dan pembacaan awal. Fitur ini bermanfaat untuk membangun kebiasaan belajar mengaji secara santai namun konsisten.

### 6. Lagu Anak

Bagian lagu anak menyediakan media audio/video yang membuat proses belajar lebih hidup. Lagu membantu meningkatkan fokus, daya ingat, dan keterlibatan emosional anak saat belajar.

### 7. Mode Seru

Mode Seru memanfaatkan mikrofon dan pengenalan suara agar anak bisa menjawab materi dengan suara mereka sendiri. Ini membuat pengalaman belajar terasa seperti permainan interaktif, sekaligus melatih keberanian dan respon aktif.

### 8. Badge

Sistem badge memberi penghargaan atas pencapaian belajar tertentu. Badge membantu menjaga motivasi anak karena setiap progress terasa dihargai.

### 9. Progress

Progress belajar menampilkan perkembangan anak pada tiap kategori materi. Orang tua dan pengajar bisa lebih mudah melihat bagian mana yang sudah dikuasai dan mana yang masih perlu pendampingan.

### 10. Dashboard Pengajar

Dashboard pengajar memberi ruang khusus untuk mengelola materi pembelajaran, media, storage, dan pengaturan tampilan. Dengan dashboard ini, pengajar dapat menyesuaikan isi aplikasi agar tetap relevan dengan kebutuhan belajar anak.

### 11. Tema Aplikasi

Khoir Quest mendukung pergantian tema agar pengalaman belajar terasa lebih personal dan nyaman. Implementasi saat ini sudah menyediakan **tema default** dan **mode malam**, serta mudah diperluas untuk varian tema lain.

## Role Pengguna

Khoir Quest membedakan dua role utama:

### User Biasa / Anak

User biasa berfokus pada pengalaman belajar, yaitu:

- mengakses pusat belajar,
- membuka materi huruf, angka, benda, Iqra, dan lagu anak,
- menjalankan mode seru,
- melihat progress,
- mengumpulkan badge.

### Pengajar

Role pengajar memiliki akses tambahan untuk:

- mengelola konten pembelajaran,
- menambah atau memperbarui gambar,
- mengunggah audio dan video,
- mengelola materi huruf, angka, benda, dan lagu,
- memantau storage media,
- mengatur tema dan pengalaman penggunaan.

## Database dan Penyimpanan

Penyimpanan data di Khoir Quest dibagi menjadi beberapa lapisan:

### Data akun

- akun dan sesi lokal dapat disimpan di database perangkat,
- jika Supabase aktif, autentikasi dilakukan melalui Supabase Auth,
- metadata profil pengguna disimpan pada tabel `profiles`.

### Progress belajar

- progress kategori belajar disimpan lokal agar tetap tersedia offline,
- jika cloud aktif, progress dapat ikut disinkronkan ke profil cloud.

### Badge

- status badge disimpan di database lokal,
- badge dibuka berdasarkan perkembangan belajar anak.

### Materi pembelajaran

- metadata materi seperti kategori, label, simbol, dan referensi media disimpan lokal,
- bila Supabase aktif, metadata materi dapat disimpan pada tabel `learning_materials`.

### Gambar / audio / video

- file media dapat disimpan di local storage aplikasi untuk akses offline,
- jika Supabase digunakan, file media dapat diunggah ke **Supabase Storage** bucket `learning-assets`,
- metadata file tetap direlasikan ke data materi.

### Cache offline

- cache lokal membantu aplikasi memuat konten lebih cepat,
- media yang sudah pernah diunduh atau disalin ke storage lokal tetap bisa dipakai saat offline.

### Catatan Supabase

Jika Supabase digunakan:

- **gambar/audio/video** disimpan di **Supabase Storage**,
- **metadata** seperti profil, histori, dan materi disimpan di **Postgres**,
- akses data dilindungi oleh **Row Level Security (RLS)**.

## Screenshot / Preview

-

## Roadmap

- [x] **Tahap 1 - Fondasi offline-first**  
  Materi dasar, auth lokal, progress, badge, tema, dan dashboard pengajar lokal.

- [ ] **Tahap 2 - Sinkronisasi cloud yang lebih matang**  
  Penyempurnaan sync akun, progress, materi, dan media melalui Supabase.

- [ ] **Tahap 3 - Realtime update materi**  
  Perubahan materi dari pengajar langsung tersinkron ke perangkat pengguna.

- [ ] **Tahap 4 - Analytics dan laporan belajar**  
  Ringkasan performa anak, histori aktivitas, dan insight untuk pendamping belajar.

- [ ] **Tahap 5 - Fitur pengajar lanjutan**  
  Manajemen kelas, kurasi materi, rekomendasi belajar, dan pengelolaan konten yang lebih kaya.

## Contributing

Kontribusi sangat terbuka untuk pengembangan Khoir Quest. Jika ingin membantu:

1. Fork repository ini.
2. Buat branch baru:

   ```bash
   git checkout -b feature/nama-fitur
   ```

3. Lakukan perubahan yang diperlukan.
4. Commit perubahan:

   ```bash
   git commit -m "feat: tambah nama fitur"
   ```

5. Push branch:

   ```bash
   git push origin feature/nama-fitur
   ```

6. Buka Pull Request dan jelaskan perubahan yang dibuat.

Agar proses review lebih mudah, usahakan:

- perubahan fokus pada satu tujuan,
- mengikuti struktur kode yang sudah ada,
- menambahkan catatan pengujian bila relevan.

## License

Saat ini proyek ini **belum memiliki lisensi publik resmi**.

## Kontak / Author

Silakan ganti placeholder berikut sesuai identitas proyek:

- **Nama**: `Andi Bayu Hanggoro`
- **Email**: `andibayuhanggoro28@gmail.com`
- **GitHub**: `https://github.com/adbayu`

---

Jika README ini dipakai untuk presentasi, demo, atau publikasi GitHub, Anda bisa menambahkan:

- logo aplikasi di bagian atas,
- GIF demo penggunaan,
- link APK / TestFlight / web preview,
- changelog versi,
- dan dokumentasi API/backend bila integrasi cloud dipakai penuh.
