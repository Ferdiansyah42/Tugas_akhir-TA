# 🐔 FuzzyBroiler IP: Decision Support System Mikroklimat Broiler Adaptif Umur

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white)](https://python.org)
[![Fuzzy Logic](https://img.shields.io/badge/Method-Mamdani%20%26%20Sugeno-005C55)](#)
[![Status](https://img.shields.io/badge/Build-Passing-brightgreen)](#)
[![License](https://img.shields.io/badge/License-Academic-blue)](#)

> **Sistem Pendukung Keputusan (DSS) Berbasis Fuzzy Inference System Adaptif Umur untuk Evaluasi Potensi Indeks Performa (IP) Ayam Broiler Berjalan 100% Offline pada Perangkat Bergerak (Mobile Android).**

---

## 📌 Ringkasan Proyek

Proyek ini merupakan implementasi riset Tugas Akhir (TA) di bidang Rekayasa Sistem Cerdas dan Informatika Pertanian. Sistem mengevaluasi kondisi mikroklimat kandang *closed house* secara harian dengan mempertimbangkan dinamika biologis ayam broiler berdasarkan umur (fase *Starter*, *Grower*, dan *Finisher*), bukan menggunakan batas suhu statis seperti sistem konvensional.

### Fitur Utama:
1. **Target Suhu Dinamis (Adaptif Umur)**: Mengikuti kurva resmi strain komersial *Cobb 500* dan *Ross 308* (Day 1: 33°C hingga Day 42: 20°C).
2. **27 Aturan Logika Biologis (If-Then)**: Memodelkan kepekaan fase starter terhadap kedinginan (*chilling sensitivity*) dan kepekaan fase finisher terhadap stres panas (*heat stress sensitivity*).
3. **Komparasi Dual-Engine**: Mengimplementasikan dan membandingkan **Mamdani (Centroid Defuzzification)** sebagai skor primer dengan **Sugeno Orde-Nol (Weighted Average)** sebagai pembanding komputasi cepat.
4. **Offline-First Android App**: Berjalan 100% mandiri di kandang tanpa ketergantungan koneksi internet maupun server *cloud*.
5. **Early Warning System (EWS)**: Mendeteksi tren penurunan performa atau anomali kenaikan suhu 2–3 hari beruntun dan menerbitkan rekomendasi prioritas.
6. **SOP Mitigasi Tindakan Nyata**: Checklist langkah praktis (pembukaan tirai samping, penyesuaian *blower fan*, kabut evaporasi) yang dapat dicentang langsung oleh peternak di kandang.

---

## 📊 Hasil Benchmark Komputasi (50 Skenario Uji)

Pengujian empiris dilakukan pada 50 skenario mikroklimat ekstrem dan normal:

| Parameter Evaluasi | Metode Mamdani (Centroid) | Metode Sugeno (Weighted Avg) | Keterangan / Analisis |
| :--- | :---: | :---: | :--- |
| **Rata-rata Waktu Inferensi** | 0.4959 ms | **0.0054 ms** | Sugeno **92.5x lebih cepat** |
| **Korelasi Pearson ($r$)** | - | **0.9987** | Tingkat konkordansi linear sangat tinggi |
| **Mean Absolute Error (MAE)** | Acuan Utama | **3.88 Poin** | Deviasi sangat kecil pada skala 0–100 |
| **Kesesuaian Kategori (Concordance)** | 100% | **98.0%** | Hanya 1 skenario di batas ambang yang berbeda tipis |

---

## 🏛️ Arsitektur Perangkat Lunak

### 1. Struktur Direktori Proyek
```
c:\TA-saya/
│
├── flutter_app/                        # Aplikasi Mobile Flutter (Android/Web)
│   ├── lib/
│   │   ├── core/                       # Design tokens, warna, konstanta, preset
│   │   │   ├── app_colors.dart
│   │   │   ├── app_constants.dart
│   │   │   └── app_decorations.dart
│   │   ├── fuzzy/                      # Pure Dart Fuzzy Inference Engine
│   │   │   └── fuzzy_engine.dart       # 27 rules, Mamdani & Sugeno
│   │   ├── widgets/                    # Reusable UI Components
│   │   │   ├── custom_app_bar.dart
│   │   │   ├── early_warning_banner.dart
│   │   │   ├── hero_score_card.dart
│   │   │   ├── telemetry_card.dart
│   │   │   ├── recommendation_card.dart
│   │   │   ├── flock_banner_card.dart
│   │   │   ├── action_checklist_tile.dart
│   │   │   ├── trend_chart.dart
│   │   │   └── evaluation_detail_modal.dart
│   │   ├── screens/                    # 5 Halaman Tab Utama
│   │   │   ├── beranda_screen.dart     # Dashboard utama
│   │   │   ├── input_screen.dart       # Form slider input & preset cepat
│   │   │   ├── hasil_screen.dart       # Komparasi Mamdani vs Sugeno & IP
│   │   │   ├── solusi_screen.dart      # SOP checklist mitigasi
│   │   │   └── riwayat_screen.dart     # Riwayat evaluasi & grafik tren
│   │   └── main.dart                   # Entry point aplikasi
│   └── test/
│       ├── cross_validation_test.dart  # Unit test logika fuzzy adaptif
│       └── widget_test.dart            # Smoke test antarmuka pengguna
│
├── fuzzy_engine.py                     # Prototipe Python FIS (scikit-fuzzy & pure)
├── benchmark.py                        # Runner pengujian 50 skenario komparasi
├── data_skenario_uji_50.csv            # Dataset skenario uji (format CSV)
├── data_skenario_uji_50.json           # Dataset skenario uji (format JSON)
│
├── laporan_ta/                         # Draf Naskah Buku Skripsi Lengkap
│   ├── ABSTRAK.md                      # Abstrak dwibahasa (ID & EN)
│   ├── BAB_1_PENDAHULUAN.md            # Bab 1: Pendahuluan
│   ├── BAB_2_TINJAUAN_PUSTAKA.md       # Bab 2: Tinjauan Pustaka
│   ├── BAB_3_METODOLOGI_PENELITIAN.md  # Bab 3: Metodologi Penelitian
│   ├── BAB_4_HASIL_DAN_PEMBAHASAN.md   # Bab 4: Hasil dan Pembahasan
│   └── BAB_5_PENUTUP.md                # Bab 5: Kesimpulan dan Saran
│
├── task_list/                          # Roadmap Kerja & Instrumen Pengujian
│   ├── 01_model_fuzzy.md
│   ├── 02_arsitektur_dan_aplikasi_flutter.md
│   ├── 03_pengujian_dan_validasi_pakar.md
│   ├── 04_penulisan_laporan_ta.md
│   ├── 05_spesifikasi_detail_27_aturan_dan_strain.md
│   ├── 06_instrumen_kuesioner_validasi_pakar.md
│   ├── 07_instrumen_kuesioner_sus.md
│   ├── 08_arsitektur_modular_class_flutter.md
│   └── README.md
│
└── PANDUAN_PENGGUNAAN_APLIKASI.md      # Manual operasional & skenario demo sidang TA
```

---

## 🚀 Panduan Menjalankan Sistem

### A. Menjalankan Aplikasi Flutter (Mobile / Chrome)

1. Pastikan Flutter SDK sudah terpasang di komputer Anda.
2. Masuk ke direktori `flutter_app`:
   ```bash
   cd flutter_app
   ```
3. Unduh dependensi:
   ```bash
   flutter pub get
   ```
4. Jalankan pengujian otomatis untuk memastikan sistem siap:
   ```bash
   flutter test
   ```
5. Jalankan aplikasi pada Chrome atau Emulator Android:
   ```bash
   flutter run -d chrome
   ```
   *atau*
   ```bash
   flutter run
   ```

---

### B. Menjalankan Prototipe Python & Benchmark

1. Masuk ke direktori root:
   ```bash
   cd c:\TA-saya
   ```
2. Jalankan engine fuzzy Python untuk uji coba konsol:
   ```bash
   python fuzzy_engine.py
   ```
3. Jalankan pengujian 50 skenario perbandingan Mamdani vs Sugeno:
   ```bash
   python benchmark.py
   ```

---

## 📐 Landasan Matematis Model Fuzzy

### 1. Kurva Target Suhu Adaptif Umur
Suhu target ($T_{\text{target}}$) dihitung secara dinamis berdasarkan fungsi tangga biologis strain Cobb 500:
$$T_{\text{target}}(t) = \begin{cases} 
33.0^\circ\text{C}, & 1 \le t \le 3 \\
31.5^\circ\text{C}, & 4 \le t \le 7 \\
29.0^\circ\text{C}, & 8 \le t \le 14 \\
27.0^\circ\text{C}, & 15 \le t \le 21 \\
24.5^\circ\text{C}, & 22 \le t \le 28 \\
22.5^\circ\text{C}, & 29 \le t \le 35 \\
21.0^\circ\text{C}, & 36 \le t \le 42 
\end{cases}$$

### 2. Variabel Deviasi Suhu ($\Delta T$)
$$\Delta T = T_{\text{aktual}} - T_{\text{target}}(t)$$
- $\text{Dingin}: (-\infty, -3.0, -1.0)$
- $\text{Normal}: (-1.5, 0.0, 1.5)$
- $\text{Panas}: (1.0, 3.0, +\infty)$

### 3. Variabel Kelembaban Udara (RH)
- $\text{Kering}: (-\infty, 40, 60)\%$
- $\text{Ideal}: (55, 65, 75)\%$
- $\text{Lembab}: (70, 85, 100)\%$

### 4. Defuzifikasi
- **Mamdani (Center of Gravity / Centroid)**:
  $$z^* = \frac{\int z \cdot \mu_C(z) \, dz}{\int \mu_C(z) \, dz}$$
- **Sugeno (Weighted Average Orde-0)**:
  $$z^* = \frac{\sum_{i=1}^{27} w_i \cdot z_i}{\sum_{i=1}^{27} w_i}$$

---

## 📄 Instrumen & Naskah Tugas Akhir

- **Naskah Buku TA**: Seluruh naskah tersimpan rapi pada direktori [`laporan_ta/`](file:///c:/TA-saya/laporan_ta/) mulai dari Abstrak hingga Bab 5.
- **Instrumen Validasi Pakar**: 30 skenario kuisioner penilaian pakar untuk dokter hewan dan ahli nutrisi ternak unggas tersedia di [`task_list/06_instrumen_kuesioner_validasi_pakar.md`](file:///c:/TA-saya/task_list/06_instrumen_kuesioner_validasi_pakar.md).
- **Instrumen Uji Kegunaan Pengguna (SUS)**: 10 pertanyaan standar System Usability Scale dengan skala Likert 1–5 tersedia di [`task_list/07_instrumen_kuesioner_sus.md`](file:///c:/TA-saya/task_list/07_instrumen_kuesioner_sus.md).
- **Panduan Sidang**: Panduan demonstrasi live di depan dosen penguji tersedia di [`PANDUAN_PENGGUNAAN_APLIKASI.md`](file:///c:/TA-saya/PANDUAN_PENGGUNAAN_APLIKASI.md).

---

## 👤 Pengembang / Peneliti
- **Peneliti**: Mahasiswa Tugas Akhir
- **Repositori Resmi**: [https://github.com/Ferdiansyah42/Tugas_akhir-TA.git](https://github.com/Ferdiansyah42/Tugas_akhir-TA.git)
- **Lisensi**: Hak Cipta Akademik © 2026.
