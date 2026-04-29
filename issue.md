# Perencanaan Pengembangan Aplikasi Mobile Ringan

## 1. Scope & MVP Definition (Minimum Viable Product)
**Batasan Aplikasi:**
Fokus pada satu fungsi utama yang menyelesaikan masalah pengguna. Hilangkan semua fitur "nice-to-have" pada tahap awal.

*   **HARUS ADA (Core):**
    *   Autentikasi sederhana (misal: hanya Email/Password atau tanpa login jika tidak ada data privat).
    *   Satu atau dua layar utama yang memuat fungsi inti aplikasi (misal: input data, lihat data).
    *   Navigasi bawah (Bottom Navigation) maksimal 3 menu.
    *   Koneksi ke database utama untuk simpan/ambil data secara *realtime* atau berkala.

*   **DITUNDA (Next Phase):**
    *   Notifikasi push yang kompleks.
    *   Animasi atau transisi antarmuka (UI) yang rumit.
    *   Mode offline penuh (*Full Offline Support*) dengan proses sinkronisasi data antar perangkat.
    *   Profil pengguna dengan banyak pengaturan preferensi.

## 2. Prinsip Utama Pengembangan
1.  **Keep It Stupid Simple (KISS):** Jika ada cara yang lebih mudah, pilih cara tersebut walau kurang "keren" secara teknologi.
2.  **Satu Sumber Kebenaran (Single Source of Truth):** Jangan menduplikasi data. Ambil data langsung dari sumbernya (database) dan tampilkan.
3.  **UI/UX Standar:** Gunakan komponen bawaan kerangka kerja (framework). Jangan buang waktu membuat komponen UI *custom* dari nol.
4.  **Tulis Kode yang Terbaca:** Kode harus mudah dipahami secara sekilas oleh *junior developer* tanpa perlu banyak menebak logikanya.
5.  **Jangan Optimasi Prematur:** Jangan pusingkan masalah efisiensi memori tingkat tinggi sampai masalah itu benar-benar terjadi.
6.  **Toleransi Kesalahan (Graceful Degradation):** Berikan pesan *error* yang jelas jika gagal mengambil data, bukan layar putih kosong.

## 3. Strategi Pemilihan Teknologi (Decision-Oriented)

**REKOMENDASI UTAMA:**
*   **Frontend (Aplikasi Mobile):** Flutter
*   **Backend & Database:** Firebase (Firebase Auth & Cloud Firestore)

**Alasan Sederhana:**
*   **Satu Kode untuk Semua:** Flutter memungkinkan penulisan satu kode (bahasa Dart) untuk membangun aplikasi Android dan iOS sekaligus. Sangat efisien untuk tim kecil.
*   **Tanpa Perlu Buat Server Sendiri:** Firestore adalah database *Serverless*. Kita tidak perlu repot menyewa server, membuat API, atau memelihara infrastruktur backend. Aplikasi bisa langsung "berbicara" dengan database dengan sangat mudah dan aman.
*   **Ekosistem Lengkap & Mudah:** Fitur standar seperti Login dan Database sudah tersedia dalam satu paket ekosistem (Firebase) yang sangat bersahabat untuk pemula.

## 4. Arsitektur Sederhana
Alur kerja sistem (App -> Database) dibuat seminimal mungkin tanpa perantara (Middleware) yang rumit:

1.  **Aplikasi Mobile (Client):** Menampilkan antarmuka, menerima *input* pengguna, dan memegang sedikit logika bisnis (karena skalanya kecil).
2.  **Direct Connection:** Aplikasi langsung meminta atau mengirim data ke Firestore tanpa melalui REST API kustom. Keamanan diatur melalui *Firebase Security Rules*.
3.  **Real-time Update:** Firestore secara otomatis mengirimkan data terbaru ke aplikasi jika ada perubahan di server.

## 5. Development Plan (Execution-Friendly)
Fokus pada pengerjaan bertahap agar developer junior tidak kewalahan.

*   **Fase 1: Setup & Persiapan (1-2 Hari)**
    *   Buat project Flutter baru.
    *   Buat project Firebase di console web.
    *   Hubungkan aplikasi Flutter dengan Firebase.
*   **Fase 2: Kerangka UI Dasar (3-4 Hari)**
    *   Buat kerangka layar kosong untuk fungsi utama (misal: Home, Input, Profil).
    *   Terapkan sistem navigasi antar halaman yang sederhana.
    *   Gunakan desain dan komponen bawaan Flutter (Material UI).
*   **Fase 3: Autentikasi (1-2 Hari)**
    *   Implementasi fitur Login/Register sederhana menggunakan Firebase Auth.
    *   Batasi akses ke halaman utama hanya untuk pengguna yang telah masuk (login).
*   **Fase 4: Integrasi Database CRUD (4-5 Hari)**
    *   Buat operasi CRUD (Create, Read, Update, Delete) sederhana ke Firestore.
    *   Tampilkan data dari database ke dalam daftar di aplikasi.
*   **Fase 5: Poles & Penanganan Error (2-3 Hari)**
    *   Tambahkan indikator "Loading" (putar-putar) saat mengambil data.
    *   Tambahkan *pop-up* atau teks pesan jika operasi gagal (seperti "Tidak ada koneksi").

## 6. Guideline Implementasi untuk Junior/AI

*   **YANG HARUS DILAKUKAN (Pola Aman):**
    *   Pisahkan tampilan antarmuka (UI) dengan logika pengambilan data/database dalam file yang berbeda agar kode tidak menumpuk di satu tempat.
    *   Gunakan pola "State Management" yang paling sederhana yang disediakan framework, misal `Provider` (jika di Flutter) untuk mengelola data sementara.
    *   Beri komentar pada bagian logika utama, jelaskan "Mengapa" logika itu ada, bukan sekadar "Apa" yang dilakukan.

*   **YANG HARUS DIHINDARI:**
    *   **JANGAN** menggunakan arsitektur tingkat lanjut (seperti Clean Architecture, BLoC, atau Redux) yang terlalu kompleks di awal.
    *   **JANGAN** menambahkan *package/library* pihak ketiga secara sembarangan jika fungsi tersebut bisa dikerjakan dengan fitur bawaan.
    *   **JANGAN** merancang struktur database yang dalam atau bersarang (nested). Buatlah se-*flat* (datar) mungkin agar mudah dibaca.

## 7. Strategi Scaling Sederhana
Kapan harus mulai mengubah arsitektur jika aplikasi meledak populer di masa depan?

*   **Kapan mulai memikirkan scaling?**
    Hanya ketika dirasa aplikasi mulai melambat parah, biaya Firebase melonjak tidak masuk akal, atau fitur mulai sangat kompleks membutuhkan perhitungan di server.
*   **Apa yang bisa ditunda (jangan dibuat sekarang)?**
    *   Pembuatan API/Backend Server kustom secara mandiri (misal menggunakan Node.js/Go).
    *   Sistem penyimpanan *cache* lokal tingkat lanjut.
    *   Otomatisasi pengujian (*Automated Testing*) yang terlalu ketat (lakukan pengujian manual untuk rilis awal).

## 8. Delivery & Maintenance
Cara menjaga sistem tetap stabil setelah rilis awal:

*   **Rilis Praktis:** Sebarkan aplikasi secara langsung jika bisa, atau melalui App Store/Play Store jika menargetkan jangkauan publik.
*   **Monitoring Sederhana:** Wajib memasang alat pelacak *crash* otomatis seperti **Firebase Crashlytics**. Ini agar developer tahu bila ada error di HP pengguna secara diam-diam.
*   **Menjaga Kesederhanaan:** Jika ada fitur baru, usahakan menambah tabel baru di database, bukan memodifikasi total tabel lama yang bisa merusak aplikasi pengguna versi sebelumnya (*Backward Compatibility*).
