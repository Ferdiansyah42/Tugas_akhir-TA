# Task List 02: Arsitektur Sistem & Aplikasi Mobile Flutter

Dokumen ini memuat daftar tugas untuk perancangan arsitektur perangkat lunak dan implementasi aplikasi Android menggunakan Flutter berbasis prinsip offline-first.

---

## 🏗️ Struktur Modul yang Ditetapkan Blueprint

```
lib/
├── fuzzy/          # Mesin fuzzy (pure Dart tanpa dependensi UI)
│   ├── membership/ # Fungsi kurva keanggotaan (segitiga, trapesium)
│   ├── rules/      # 27 basis aturan fuzzy & penyesuaian umur
│   ├── inference/  # Engine Mamdani (centroid) & Sugeno (weighted average)
│   └── target_temp/# Fungsi kalkulator suhu target adaptif strain broiler
├── data/           # Layer persistensi lokal SQLite
│   ├── database/   # Helper SQLite (sqflite, migrasi tabel)
│   ├── models/     # Model evaluasi kandang & mapping DTO
│   └── repository/ # Query CRUD riwayat evaluasi
├── service/        # Logika bisnis dan analitik keputusan
│   ├── recommendation/ # Algoritma rekomendasi tindakan prioritas
│   └── early_warning/  # Deteksi penurunan performa berturut-turut
└── ui/             # 5 Layar antarmuka pengguna
    ├── screens/
    │   ├── home/           # Beranda ringkasan & peringatan dini
    │   ├── input/          # Form input umur, suhu, kelembaban
    │   ├── result/         # Visualisasi skor 0–100 & status variabel
    │   ├── recommendation/ # Panduan tindakan korektif hierarkis
    │   └── history/        # Riwayat tabel & grafik tren (FL Chart)
    └── widgets/            # Komponen UI reusable (gauge, cards, badges)
```

---

## 📋 Daftar Tugas Utama

- [ ] **Task 2.1: Modul Mesin Fuzzy Pure Dart (`lib/fuzzy/`)**
  - Membuat class representasi fungsi keanggotaan (`TriangularMF`, `TrapezoidalMF`).
  - Mengimplementasikan penghitung deviasi suhu adaptif:
    $$\Delta T = T_{aktual} - \text{TargetTemp}(umur)$$
  - Mengimplementasikan mesin inferensi Mamdani:
    - Fuzzifikasi 3 variabel input.
    - Evaluasi firing strength 27 rule ($\alpha$-predicate).
    - Agregasi komposisi aturan (Max).
    - Defuzzifikasi diskrit Centroid numerik.
  - Mengimplementasikan mesin inferensi Sugeno:
    - Evaluasi konsekuen konstanta ($z_i$).
    - Defuzzifikasi rata-rata berbobot ($\sum w_i z_i / \sum w_i$).
  - Membuat Unit Test lengkap di `test/fuzzy_test.dart` untuk memastikan tidak ada eror matematis.

- [ ] **Task 2.2: Modul Basis Data SQLite (`lib/data/`)**
  - Menyiapkan paket `sqflite` dan `path`.
  - Membuat skema tabel `evaluasi`:
    ```sql
    CREATE TABLE evaluasi (
      id TEXT PRIMARY KEY,
      tanggal TEXT NOT NULL,
      umur INTEGER NOT NULL,
      suhu REAL NOT NULL,
      kelembaban REAL NOT NULL,
      skor REAL NOT NULL,
      kategori TEXT NOT NULL,
      synced INTEGER DEFAULT 0
    );
    ```
  - Menyediakan fungsi CRUD (Insert hasil evaluasi, Get history terurut tanggal, Delete, Get statistik 7 hari terakhir).

- [ ] **Task 2.3: Modul Servis Rekomendasi & Peringatan Dini (`lib/service/`)**
  - **Engine Rekomendasi Bertingkat (Prioritas Tindakan)**:
    - Jika Panas & Lembab Tinggi $\rightarrow$ Prioritas: Kipas/Blower maksimal, buka ventilasi atas, periksa pendingin evaporatif/cooling pad, pastikan debit air minum dingin lancar.
    - Jika Dingin & Lembab Tinggi $\rightarrow$ Prioritas: Tutup tirai, kurangi kelembaban melalui sirkulasi udara berkala tanpa memicu *wind chill*, nyalakan pemanas (brooder heater).
    - Jika Lembab Rendah (Kering/Berdebu) $\rightarrow$ Semprot kabut air / misting, atur ventilasi agar sekam tidak berdebu.
  - **Sistem Peringatan Dini (Early Warning System)**:
    - Membaca tren data 3 hari berturut-turut dari SQLite.
    - Jika skor performa menunjukkan penurunan terus-menerus selama 3 evaluasi berturut-turut, trigger *alert banner* di Beranda: `"Peringatan: Tren kondisi kandang menurun selama 3 hari berturut-turut! Lakukan tindakan korektif."`

- [ ] **Task 2.4: Implementasi 5 Layar UI Flutter (`lib/ui/`)**
  - **Layar 1: Beranda**
    - Kartu skor evaluasi terakhir dengan indikator warna (Hijau: Tinggi, Kuning: Sedang, Merah: Rendah).
    - Status ringkas kondisi mikroklimat kandang (Suhu, Kelembaban, Umur).
    - Banner Peringatan Dini jika kondisi memburuk 3 hari terakhir.
    - Tombol cepat untuk memulai evaluasi baru.
  - **Layar 2: Form Input Evaluasi**
    - Input angka: Umur ayam (hari), Suhu kandang (°C), Kelembaban relatif (%).
    - Deteksi otomatis fase pemeliharaan secara real-time saat umur diinput (Starter: 0–14 hari, Grower: 15–28 hari, Finisher: 29–42 hari).
    - Tampilan suhu target strain acuan sebagai panduan peternak di bawah kolom input suhu.
  - **Layar 3: Hasil Evaluasi**
    - Indikator skor numerik (0–100) menggunakan circular gauge / progress bar elegan.
    - Label kategori potensi performa: *Tinggi*, *Sedang*, atau *Rendah*.
    - Rincian status masing-masing variabel: Status Suhu (Dingin / Nyaman / Panas), Status RH (Rendah / Ideal / Tinggi).
    - Tombol navigasi menuju *Lihat Rekomendasi Tindakan*.
  - **Layar 4: Rekomendasi Tindakan Korektif**
    - Daftar saran langkah perbaikan yang diurutkan berdasarkan skala urgensi:
      1. Penanganan Tirai Kandang (buka/tutup sebagian/penuh).
      2. Pengaturan Ventilasi & Exhaust Fan (tingkatkan/kurangi kecepatan airflow).
      3. Penyesuaian Pemanas / Cooling Pad.
      4. Ketersediaan & Suhu Air Minum.
  - **Layar 5: Riwayat & Grafik Tren**
    - Grafik garis interaktif (menggunakan `fl_chart`) yang memperlihatkan histori skor potensi performa sepanjang hari pemeliharaan.
    - Daftar list riwayat log dengan timestamp, nilai parameter input, dan skor.

