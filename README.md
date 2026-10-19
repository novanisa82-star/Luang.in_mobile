# 💜 Luang.In — Mobile Application

**Luang.In** adalah aplikasi mobile pencarian lowongan kerja yang membantu pelamar menemukan peluang pekerjaan, melengkapi profil keterampilan, dan memantau proses lamaran melalui satu aplikasi.

Aplikasi ini dikembangkan menggunakan Flutter dan terhubung dengan backend Laravel melalui REST API.

## ✨ Fitur Utama

- **Autentikasi Pengguna** — Registrasi dan login akun pelamar.
- **Beranda Lowongan** — Menjelajahi informasi pekerjaan yang tersedia.
- **Pencarian dan Filter** — Menemukan lowongan berdasarkan kebutuhan pengguna.
- **Detail Lowongan** — Melihat informasi pekerjaan sebelum melamar.
- **Profil Keterampilan** — Melengkapi keterampilan dan pengalaman pelamar.
- **Riwayat Lamaran** — Memantau perkembangan status lamaran pekerjaan.
- **AI Chatbot** — Membantu pengguna memperoleh informasi dan panduan seputar pencarian kerja melalui percakapan dengan AI.
- **Profil Pengguna** — Melihat dan mengelola informasi akun.


*Fitur yang ditampilkan mengikuti tahap pengembangan dan integrasi backend.*

## 🛠️ Teknologi

| Teknologi | Kegunaan |
|---|---|
| Flutter | Framework aplikasi mobile |
| Dart | Bahasa pemrograman |
| GetX | State management dan navigasi |
| GetStorage | Penyimpanan token dan sesi |
| HTTP | Komunikasi dengan REST API |
| Laravel | Backend API |
| MySQL | Database aplikasi |

## 📋 Persyaratan

- Flutter SDK
- Dart SDK
- Android Studio atau Visual Studio Code
- Emulator Android atau perangkat Android fisik
- Backend Laravel Luang.In yang telah dikonfigurasi

## 🚀 Instalasi

### 1. Clone Repository

```bash
git clone https://github.com/novanisa82-star/Luang.in_mobile.git
```

Masuk ke direktori proyek:

```bash
cd Luang.in_mobile
```

### 2. Instal Dependensi

```bash
flutter pub get
```

### 3. Konfigurasi API

Sesuaikan alamat backend pada konfigurasi API aplikasi.

Untuk Android Emulator:

```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

Untuk perangkat Android fisik, gunakan IP lokal komputer yang menjalankan Laravel:

```dart
static const String baseUrl = 'http://ALAMAT-IP-KOMPUTER:8000/api';
```

Ganti `ALAMAT-IP-KOMPUTER` dengan IP komputer yang sebenarnya. Pastikan perangkat dan komputer berada di jaringan yang sama.

### 4. Jalankan Aplikasi

Pastikan server Laravel sudah berjalan, kemudian jalankan:

```bash
flutter run
```

Pilih emulator atau perangkat Android yang tersedia.

## 🔗 Backend

Aplikasi mobile Luang.In menggunakan backend Laravel untuk menangani autentikasi, pertukaran data, dan penyimpanan informasi pengguna.

Pastikan alamat API pada aplikasi sesuai dengan alamat server backend yang digunakan.

## 🔒 Pengelolaan Sesi

Aplikasi menggunakan GetStorage untuk membantu menyimpan token autentikasi dan informasi sesi pengguna. Akses ke endpoint yang membutuhkan autentikasi dilakukan melalui token yang diperoleh dari backend.

## 🎯 Tujuan

Luang.In dikembangkan untuk memberikan pengalaman pencarian kerja yang praktis dan mudah digunakan melalui perangkat mobile, sehingga pelamar dapat menemukan informasi pekerjaan dan mengelola proses lamaran secara lebih terorganisasi.

## 📌 Status Proyek

**Luang.In Mobile Application** — dikembangkan menggunakan Flutter dengan integrasi backend Laravel.

---

**Luang.In — Temukan Peluang, Bangun Masa Depan.** 💜
