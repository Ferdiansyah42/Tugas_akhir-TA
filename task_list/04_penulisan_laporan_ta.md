# Task List 04: Penulisan Laporan Tugas Akhir (Bab 1 s.d. Bab 5)

Dokumen ini memuat status penyusunan naskah lengkap Buku Laporan Tugas Akhir sesuai struktur akademik yang ditetapkan pada Halaman 6 Blueprint TA.

---

## 📚 Status Naskah Laporan Tugas Akhir (`laporan_ta/`)

- [x] **Bab 1: Pendahuluan ([`laporan_ta/BAB_1_PENDAHULUAN.md`](file:///c:/TA-saya/laporan_ta/BAB_1_PENDAHULUAN.md))**
  - [x] 1.1 Latar Belakang: Krisis mikroklimat peternak rakyat, keterlambatan evaluasi performa, pentingnya Indeks Performa (IP), kebutuhan metode adaptif umur.
  - [x] 1.2 Rumusan Masalah: 3 butir pertanyaan penelitian (perancangan model, komparasi Mamdani vs Sugeno, aplikasi mobile offline).
  - [x] 1.3 Batasan Masalah: Ruang lingkup strain Cobb 500/Ross 308, 3 parameter input, offline Android.
  - [x] 1.4 Tujuan Penelitian: Formulasi model 27 aturan, komparasi komputasi empiris, pengembangan aplikasi Flutter.
  - [x] 1.5 Manfaat Penelitian: Manfaat teoritis (kecerdasan buatan terapan) dan praktis (peternak rakyat).

- [x] **Bab 2: Tinjauan Pustaka ([`laporan_ta/BAB_2_TINJAUAN_PUSTAKA.md`](file:///c:/TA-saya/laporan_ta/BAB_2_TINJAUAN_PUSTAKA.md))**
  - [x] 2.1 Manajemen Mikroklimat Ayam Broiler: Zona termonetral, kepekaan fase starter (chilling), kepekaan fase finisher (heat stress).
  - [x] 2.2 Indeks Performa (IP) Broiler: Formula empiris, parameter $M, B, \text{FCR}, U$, standar industri.
  - [x] 2.3 Konsep Logika Fuzzy: Fuzzifikasi, FIS Mamdani (Centroid), FIS Sugeno (Weighted Average).
  - [x] 2.4 Penelitian Terdahulu & Research Gap: Tabel sintesis 5 penelitian dan kebaruan penelitian ini.

- [x] **Bab 3: Metodologi Penelitian ([`laporan_ta/BAB_3_METODOLOGI_PENELITIAN.md`](file:///c:/TA-saya/laporan_ta/BAB_3_METODOLOGI_PENELITIAN.md))**
  - [x] 3.1 Kerangka Kerja Penelitian: Diagram alir 6 tahapan penelitian.
  - [x] 3.2 Perancangan Model FIS: Semesta pembicaraan, fungsi target temperatur, matriks 27 aturan biologis.
  - [x] 3.3 Metode Inferensi & Defuzzifikasi: Rumus matematis Centroid COG dan Sugeno Weighted Average.
  - [x] 3.4 Perancangan Arsitektur Perangkat Lunak: Modularisasi Flutter (`fuzzy/` dan `ui/`).
  - [x] 3.5 Metrik Pengujian & Evaluasi: Rumus MAE, Cohen's Kappa ($\kappa$), latensi komputasi, dan System Usability Scale (SUS).

- [x] **Bab 4: Hasil dan Pembahasan ([`laporan_ta/BAB_4_HASIL_DAN_PEMBAHASAN.md`](file:///c:/TA-saya/laporan_ta/BAB_4_HASIL_DAN_PEMBAHASAN.md))**
  - [x] 4.1 Hasil Implementasi Sistem: Uraian 5 layar antarmuka Flutter.
  - [x] 4.2 Analisis Komparasi Algoritma: Hasil benchmark 50 skenario uji (Sugeno 0.0054 ms vs Mamdani 0.4959 ms / 92.5x lebih cepat, MAE 3.88 poin, Korelasi $r=0.9987$, kesesuaian kategori 98.0%).
  - [x] 4.3 Uji Konsistensi Implementasi: Pembuktian presisi Dart vs Python ($0.0$ error).
  - [x] 4.4 Pengujian Fungsionalitas Black-Box Testing: Tabel 6 skenario uji sistem (100% Valid).
  - [x] 4.5 Keterbatasan Penelitian: Analisis batasan data skenario dan input manual.

- [x] **Bab 5: Penutup ([`laporan_ta/BAB_5_PENUTUP.md`](file:///c:/TA-saya/laporan_ta/BAB_5_PENUTUP.md))**
  - [x] 5.1 Kesimpulan: Menjawab ketiga rumusan masalah secara kuantitatif dan kualitatif.
  - [x] 5.2 Saran: Integrasi sensor IoT nirkabel (ESP32), ANFIS, dan sinkronisasi cloud multi-kandang.

- [x] **Bagian Akhir & Kelengkapan Sidang**:
  - [x] **Daftar Pustaka ([`laporan_ta/DAFTAR_PUSTAKA.md`](file:///c:/TA-saya/laporan_ta/DAFTAR_PUSTAKA.md))**: 20 referensi ilmiah terstandarisasi APA edisi 7.
  - [x] **Lampiran ([`laporan_ta/LAMPIRAN.md`](file:///c:/TA-saya/laporan_ta/LAMPIRAN.md))**: 6 lampiran lengkap (27 aturan, 50 data uji, kuesioner pakar & SUS, cuplikan kode).
  - [x] **Panduan Slide Sidang ([`PANDUAN_SLIDE_PRESENTASI_SIDANG.md`](file:///c:/TA-saya/PANDUAN_SLIDE_PRESENTASI_SIDANG.md))**: Struktur 16 slide, narasi lisan, bank tanya-jawab dosen penguji, dan skenario live demo.
  - [x] **Panduan Penggunaan Aplikasi ([`PANDUAN_PENGGUNAAN_APLIKASI.md`](file:///c:/TA-saya/PANDUAN_PENGGUNAAN_APLIKASI.md))**: Petunjuk instalasi APK Android dan operasional sistem.
