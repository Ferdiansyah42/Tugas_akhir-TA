# Task List 02: Arsitektur Sistem & Aplikasi Web Python (Flask DSS)

Dokumen ini memuat daftar tugas dan spesifikasi implementasi sistem pendukung keputusan (SPK) berbasis **Python (Flask)** dengan tampilan web mobile responsif yang identik dengan desain antarmuka *FuzzyBroiler IP*.

---

## 🏗️ Struktur Arsitektur Modul Python

```
c:\TA-saya\
├── app.py                  # Entry-point server Flask, router endpoint web & REST API
├── fuzzy_engine.py         # Mesin inferensi Fuzzy pure Python (Mamdani Centroid & Sugeno)
├── database.py             # Layer persistensi SQLite lokal (offline-first database)
├── templates/
│   └── index.html          # Antarmuka web mobile responsif (Tailwind CSS, Material Symbols, 5 Tab)
├── test_app.py             # Unit testing fungsionalitas route dan mesin inferensi
├── requirements.txt        # Dependensi pustaka Python (Flask)
└── task_list/              # Dokumentasi lengkap perencanaan TA
```

---

## 📋 Status Implementasi Modul

- [x] **Task 2.1: Mesin Fuzzy Python Murni (`fuzzy_engine.py`)**
  - Implementasi fungsi kurva keanggotaan trapesium dan segitiga tanpa library eksternal.
  - Perhitungan deviasi suhu adaptif $\Delta T = T_{\text{aktual}} - T_{\text{target}}(Umur)$ berbasis strain Cobb 500 / Ross 308.
  - Implementasi 27 aturan If-Then lengkap dengan penyesuaian bobot biologis (Starter rentan kedinginan, Finisher rentan kepanasan).
  - Implementasi defuzzifikasi **Mamdani (Centroid / COG)** dan **Sugeno Zero-Order (Weighted Average)**.
  - Analisis status suhu, kelembaban, estimasi potensi Indeks Performa (IP), dan deteksi penurunan kondisi beruntun.

- [x] **Task 2.2: Basis Data SQLite Lokal (`database.py`)**
  - Inisialisasi tabel `evaluations` dengan skema umur, suhu, kelembaban, $\Delta T$, skor Mamdani, skor Sugeno, rekomendasi, dan status peringatan dini.
  - Penyemaian data awal (*seed data*) histori hari ke-19, 20, dan 21 untuk demonstrasi *early warning banner*.
  - Operasi query aman untuk penyimpanan evaluasi baru dan penarikan histori tren.

- [x] **Task 2.3: REST API & Server Flask (`app.py`)**
  - Endpoint `/`: Merender antarmuka dashboard mobile responsif.
  - Endpoint `/api/evaluate` (POST): Menerima parameter sensor/input peternak, menjalankan kalkulasi fuzzy ganda, menyimpan ke SQLite, dan mengembalikan respon JSON instan.
  - Endpoint `/api/history` (GET): Menyediakan histori evaluasi untuk grafik dan audit laporan.

- [x] **Task 2.4: Antarmuka Visual Beranda & 5 Tab Navigasi (`templates/index.html`)**
  - Mengadopsi template desain dan skema warna Tailwind (*Primary `#005c55`*, *Secondary Container `#b5ede7`*, *Hanken Grotesk*, dan *JetBrains Mono*).
  - **Tab 1: Beranda** — Banner Early Warning, Hero Score Card (skor 86/100, progress bar), Telemetry 3-Grid (Umur 21, Suhu 28.8°C, RH 68%), Widget Langkah Penting Hari Ini, Info Siklus Kandang Aktif, dan CTA Trigger.
  - **Tab 2: Input Evaluasi** — Form input interaktif dengan deteksi fase otomatis dan pratinjau deviasi suhu secara langsung.
  - **Tab 3: Hasil Evaluasi** — Kartu komparasi Mamdani vs Sugeno, breakdown variabel, dan status potensi IP.
  - **Tab 4: Solusi / Rekomendasi** — Panduan tindakan korektif prioritas (Kipas/Blower, Tirai, Air Minum).
  - **Tab 5: Riwayat** — Daftar histori evaluasi tersimpan di SQLite.

