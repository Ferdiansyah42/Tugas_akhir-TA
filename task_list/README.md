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

## 📂 Struktur Dokumen Task List

Detail rincian tugas untuk setiap bidang dapat dilihat pada berkas berikut:

1. [**01_model_fuzzy.md**](file:///c:/TA-saya/task_list/01_model_fuzzy.md)  
   Rincian perancangan fungsi keanggotaan, 27 aturan, logika deviasi suhu adaptif, serta formulasi Mamdani dan Sugeno.

2. [**02_arsitektur_dan_aplikasi_python.md**](file:///c:/TA-saya/task_list/02_arsitektur_dan_aplikasi_python.md)  
   Rincian teknis modul Python murni (`fuzzy_engine.py`), database SQLite (`database.py`), arsitektur web mobile Flask 5 layar (`app.py`), dan sistem peringatan dini.

3. [**03_pengujian_dan_validasi_pakar.md**](file:///c:/TA-saya/task_list/03_pengujian_dan_validasi_pakar.md)  
   Rincian pembuatan skenario data uji, protokol wawancara pakar, metrik statistik (MAE, Kappa), uji performa komputasi, dan SUS.

4. [**04_penulisan_laporan_ta.md**](file:///c:/TA-saya/task_list/04_penulisan_laporan_ta.md)  
   Rincian isi dan sistematika penulisan laporan ilmiah Bab 1 sampai Bab 5.

