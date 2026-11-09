# Roadmap & Master Task List: TA Fuzzy Adaptif Umur Broiler

Dokumen ini merupakan panduan kerja terstruktur (*work breakdown structure*) yang disusun berdasarkan **Blueprint Tugas Akhir: Fuzzy Inference System Adaptif Umur untuk Evaluasi Potensi Indeks Performa Ayam Broiler**.

---

## 🎯 Ringkasan Tujuan Proyek

1. **Pengembangan Model Fuzzy**:
   - Membangun model FIS dengan **3 input** (Umur, Deviasi Suhu, Kelembaban Relatif) dan **1 output** (Skor Potensi Performa 0–100).
   - Menggunakan **27 aturan If-Then** ($3 \times 3 \times 3$) dengan penyesuaian bobot/kepekaan per fase hidup ayam (Starter, Grower, Finisher).
   - Mengimplementasikan dan membandingkan metode **Mamdani** vs. **Sugeno**.

2. **Pengembangan Aplikasi Flutter (Android Offline)**:
   - Mesin fuzzy berjalan 100% offline di perangkat (*pure Dart engine* tanpa ketergantungan UI atau backend).
   - Penyimpanan lokal riwayat evaluasi dengan SQLite (`sqflite`).
   - Sistem rekomendasi tindakan korektif hierarkis & deteksi dini (*early warning system* jika skor turun 3 hari berturut-turut).
   - 5 Layar utama: Beranda, Form Input Evaluasi, Hasil Evaluasi, Rekomendasi Tindakan, Riwayat & Grafik Tren.

3. **Validasi & Penulisan Laporan Akademik**:
   - Prototipe pembanding Python vs Dart untuk uji konsistensi.
   - Validasi data skenario oleh 2–3 pakar (Akurasi, MAE, Cohen's Kappa).
   - Evaluasi kegunaan sistem (SUS) dan kinerja komputasi inferensi di Android.
   - Penyusunan Buku Laporan TA lengkap Bab 1 sampai Bab 5.

---

## 📅 Roadmap Pelaksanaan (10 Minggu)

| Minggu | Fokus Utama | Luaran / Deliverables |
| :---: | :--- | :--- |
| **M1** | Studi Pustaka, Standar Strain Broiler, Bab 1 & Bab 2 | Draft Bab 1 & 2, data tabel target suhu pedoman strain (misal Cobb 500 / Ross 308) |
| **M2** | Pemodelan Variabel Fuzzy & Basis 27 Aturan, Kontak Pakar | Tabel batas himpunan fuzzy, matriks 27 aturan, form kuesioner validasi pakar |
| **M3** | Prototipe Python (`scikit-fuzzy`) & Simulasi Data Skenario | Script Python FIS Mamdani & Sugeno, dataset skenario uji, benchmark awal |
| **M4** | Arsitektur Modul Pure Dart (`fuzzy/`) & Validasi Dart vs Python | Unit test Dart FIS, perbandingan hasil identik Dart vs Python |
| **M5** | Implementasi Database SQLite & Service Rekomendasi/Warning | Layer data (`sqflite`), model data evaluasi, service analitik tren skor 3 hari |
| **M6** | Pengembangan UI Flutter (5 Layar) & Integrasi Sistem | UI Beranda, Input, Hasil, Rekomendasi, Riwayat (grafik FL Chart) |
| **M7** | Pengujian Fungsional (Black-box), Profiling Kinerja, SUS | Hasil uji black-box, log waktu eksekusi inferensi Android, kuesioner SUS |
| **M8** | Rekapitulasi Validasi Pakar (Akurasi, MAE, Cohen's Kappa) | Matriks evaluasi pakar vs sistem, analisis komparasi Mamdani vs Sugeno |
| **M9** | Penulisan Draf Bab 3, 4, dan 5 | Draf lengkap Bab 3 (Metodologi), Bab 4 (Hasil & Pembahasan), Bab 5 (Penutup) |
| **M10** | Finalisasi Dokumen TA, Revisi Pembimbing, Persiapan Sidang | Naskah TA final, APK Android release, slide presentasi sidang |

---

## 📂 Struktur Dokumen Proyek & Naskah TA

### A. Rincian Perencanaan & Instrumen Pengujian (`task_list/`)
1. [**01_model_fuzzy.md**](file:///c:/TA-saya/task_list/01_model_fuzzy.md) — Rincian perancangan 27 aturan, fungsi keanggotaan, dan formulasi Mamdani/Sugeno.
2. [**02_arsitektur_dan_aplikasi_flutter.md**](file:///c:/TA-saya/task_list/02_arsitektur_dan_aplikasi_flutter.md) — Arsitektur Flutter offline-first, modularisasi Dart murni, dan 5 layar interaktif.
3. [**03_pengujian_dan_validasi_pakar.md**](file:///c:/TA-saya/task_list/03_pengujian_dan_validasi_pakar.md) — Metrik evaluasi empiris, latensi komputasi, dan MAE.
4. [**04_penulisan_laporan_ta.md**](file:///c:/TA-saya/task_list/04_penulisan_laporan_ta.md) — Struktur dan status penulisan buku TA Bab 1 s.d. Bab 5.
5. [**05_spesifikasi_detail_27_aturan_dan_strain.md**](file:///c:/TA-saya/task_list/05_spesifikasi_detail_27_aturan_dan_strain.md) — Matriks 27 aturan biologis dan kurva acuan strain Cobb 500/Ross 308.
6. [**06_instrumen_kuesioner_validasi_pakar.md**](file:///c:/TA-saya/task_list/06_instrumen_kuesioner_validasi_pakar.md) — Lembar instrumen validasi pakar untuk 30 skenario mikroklimat.
7. [**07_instrumen_kuesioner_sus.md**](file:///c:/TA-saya/task_list/07_instrumen_kuesioner_sus.md) — Lembar pengujian kegunaan *System Usability Scale* (10 butir Likert).
8. [**08_arsitektur_modular_class_flutter.md**](file:///c:/TA-saya/task_list/08_arsitektur_modular_class_flutter.md) — Rincian modularisasi class arsitektur Flutter (`core/`, `widgets/`, `screens/`).

### B. Naskah Buku Laporan Tugas Akhir (`laporan_ta/`)
* [**ABSTRAK.md**](file:///c:/TA-saya/laporan_ta/ABSTRAK.md) — Abstrak dwibahasa (Bahasa Indonesia & English).
* [**BAB 1: PENDAHULUAN**](file:///c:/TA-saya/laporan_ta/BAB_1_PENDAHULUAN.md) — Latar belakang, rumusan masalah, batasan, tujuan, manfaat.
* [**BAB 2: TINJAUAN PUSTAKA**](file:///c:/TA-saya/laporan_ta/BAB_2_TINJAUAN_PUSTAKA.md) — Mikroklimat, Indeks Performa (IP), logika fuzzy, sintesis riset terdahulu.
* [**BAB 3: METODOLOGI PENELITIAN**](file:///c:/TA-saya/laporan_ta/BAB_3_METODOLOGI_PENELITIAN.md) — Alur penelitian, pemodelan matematis, modularisasi arsitektur Flutter.
* [**BAB 4: HASIL DAN PEMBAHASAN**](file:///c:/TA-saya/laporan_ta/BAB_4_HASIL_DAN_PEMBAHASAN.md) — Hasil implementasi, benchmark 50 skenario (Sugeno 92.5x lebih cepat, korelasi 0.9987), uji black-box.
* [**BAB 5: KESIMPULAN DAN SARAN**](file:///c:/TA-saya/laporan_ta/BAB_5_PENUTUP.md) — Kesimpulan akademis dan rekomendasi integrasi IoT/ANFIS.
* [**DAFTAR_PUSTAKA.md**](file:///c:/TA-saya/laporan_ta/DAFTAR_PUSTAKA.md) — 20 Referensi ilmiah terstandarisasi APA 7th Edition.
* [**LAMPIRAN.md**](file:///c:/TA-saya/laporan_ta/LAMPIRAN.md) — 6 Lampiran lengkap (Matriks 27 Aturan, Tabel 50 Skenario, Instrumen Pakar & SUS).

### C. Panduan Penggunaan, Demo Sidang & Presentasi
* [**PANDUAN_PENGGUNAAN_APLIKASI.md**](file:///c:/TA-saya/PANDUAN_PENGGUNAAN_APLIKASI.md) — Petunjuk langkah-demi-langkah pengoperasian aplikasi, skenario demo sidang penguji, dan build APK Android.
* [**PANDUAN_SLIDE_PRESENTASI_SIDANG.md**](file:///c:/TA-saya/PANDUAN_SLIDE_PRESENTASI_SIDANG.md) — Struktur 16 slide presentasi sidang, naskah bicara lisan per slide, bank tanya-jawab dosen penguji, dan skenario demo.

