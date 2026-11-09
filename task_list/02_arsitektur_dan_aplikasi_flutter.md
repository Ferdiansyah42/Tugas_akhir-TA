# Task List 02: Arsitektur Sistem & Aplikasi Mobile Flutter (Offline-First)

Dokumen ini memuat daftar tugas dan spesifikasi implementasi sistem pendukung keputusan (SPK) berbasis **Flutter (Android/Dart)** dengan tampilan antarmuka *FuzzyBroiler IP* yang berjalan 100% offline di perangkat seluler sesuai ketetapan **Blueprint Tugas Akhir**.

---

## 🏗️ Struktur Arsitektur Modul Flutter (`flutter_app/lib/`)

```
flutter_app/lib/
├── fuzzy/
│   └── fuzzy_engine.dart       # Mesin inferensi Fuzzy murni Dart (Mamdani Centroid & Sugeno Weighted Avg)
└── main.dart                   # Antarmuka Flutter lengkap: Top AppBar, 5 Screen Views, & Bottom Navigation Bar
```

---

## 📋 Status Implementasi Modul Flutter

- [x] **Task 2.1: Modul Mesin Fuzzy Pure Dart (`lib/fuzzy/fuzzy_engine.dart`)**
  - Implementasi fungsi kurva keanggotaan trapesium dan segitiga tanpa ketergantungan UI (*zero-dependency pure Dart*).
  - Perhitungan deviasi suhu adaptif $\Delta T = T_{\text{aktual}} - T_{\text{target}}(Umur)$ berbasis pedoman strain broiler komersial (Cobb 500 / Ross 308).
  - Implementasi 27 aturan If-Then lengkap dengan penyesuaian kepekaan biologis (Starter peka kedinginan, Finisher peka kepanasan).
  - Implementasi defuzzifikasi **Mamdani (Centroid / COG)** dan **Sugeno Zero-Order (Weighted Average)**.
  - Penentuan kategori skor potensi performa, status variabel mikroklimat, dan deteksi tren peringatan dini.

- [x] **Task 2.2: Antarmuka Flutter Lengkap 5 Layar (`lib/main.dart`)**
  - **Layar 1: Beranda (Home Dashboard)**
    - *Top App Bar*: Logo FuzzyBroiler IP, badge DSS, pill status Offline, avatar pengguna, dan sub-header "Kandang Blok A (Hari ke-21) - Siap Pakai Tanpa Kuota".
    - *Early Warning Alert Banner*: Peringatan dini interaktif berwarna amber ("Perhatian untuk Kandang Blok B: Suhu agak sedikit naik dalam 2 hari ini...") dengan tombol aksi "Lihat Cara Penanganan" dan "Nanti Saja".
    - *Hero Score Card*: Status "KONDISI BAIK SEKALI", skor kesehatan **86 / 100**, progress bar hijau emerald, dan label "Prediksi Panen: Sangat Memuaskan (Aman & Nyaman)".
    - *Micro-Climate 3-Card Telemetri*: Umur 21 Hari (Grower), Suhu Ruangan 28.8°C (Target 27°C, Agak Hangat, Masih Aman), Kelembaban 68% (Pas & Nyaman).
    - *Priority Actionable Widget*: Kartu hijau tua dengan rekomendasi pembukaan tirai 30% dan kipas blower nomor 2.
    - *Info Siklus Kandang Aktif*: Closed House 01 (Cobb 500, populasi 10.000 ekor, panen 21 hari lagi).
    - *Tombol Floating CTA*: "➕ Cek Kondisi Kandang Hari Ini".
  - **Layar 2: Input Evaluasi**
    - Form interaktif dengan deteksi otomatis fase umur (*Starter / Grower / Finisher*) dan pratinjau target temperatur strain secara *real-time*.
    - Tombol "Jalankan Inferensi Fuzzy" yang mengevaluasi parameter baru secara offline.
  - **Layar 3: Hasil Evaluasi**
    - Kartu komparasi berdampingan: Skor Mamdani (Centroid) vs Skor Sugeno (Weighted Average).
    - Rincian parameter status dan estimasi Indeks Performa (IP).
  - **Layar 4: Rekomendasi Solusi Tindakan**
    - Daftar langkah korektif berurutan prioritas: pengaturan kipas/blower, bukaan tirai, dan manajemen air minum dingin.
  - **Layar 5: Riwayat Evaluasi**
    - Riwayat evaluasi tersimpan secara kronologis dengan indikator warna kategori.
  - **Bottom Navigation Bar (5 Tab)**: Beranda, Input, Hasil, Solusi, dan Riwayat.
