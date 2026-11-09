# Arsitektur Modular & Desain Sistem Class Flutter

Dokumen ini menjelaskan restrukturisasi dan modularisasi kode aplikasi **FuzzyBroiler IP** dari satu file monolitik menjadi struktur *object-oriented* berlapis yang bersih, terstandarisasi, dan profesional sesuai kaidah rekayasa perangkat lunak modern untuk Tugas Akhir.

---

## 1. Diagram Struktur Folder & Paket

```
flutter_app/lib/
│
├── core/                               # Desain Sistem & Konstanta
│   ├── app_colors.dart                 # Color tokens resmi (Teal #005C55, Amber #D97706, Emerald #059669)
│   ├── app_constants.dart              # Konstanta aplikasi, daftar kandang, preset skenario pengujian
│   └── app_decorations.dart            # Box decorations, shadows, text styles standar
│
├── fuzzy/                              # Logika Domain & Matematika Inferensi
│   └── fuzzy_engine.dart               # Pure Dart FIS (27 rules, Mamdani Centroid, Sugeno Weighted Avg)
│
├── widgets/                            # Komponen UI Reusable
│   ├── action_checklist_tile.dart      # Tile SOP interaktif dengan checkbox & dynamic icon
│   ├── custom_app_bar.dart             # Header bar dengan status kandang, avatar profil & indikator offline
│   ├── early_warning_banner.dart       # Banner peringatan dini amber dengan aksi langsung
│   ├── evaluation_detail_modal.dart    # Bottom sheet modal rincian ilmiah inferensi
│   ├── flock_banner_card.dart          # Card metadata kandang closed house (Cobb 500, populasi)
│   ├── fuzzy_membership_dialog.dart   # Visualisator kurva fungsi keanggotaan fuzzy interaktif (vektor 4 tab)
│   ├── hero_score_card.dart            # Card skor hero 0–100, progress bar & prediksi panen
│   ├── recommendation_card.dart        # Card langkah prioritas hari ini
│   ├── telemetry_card.dart             # Card indikator mikroklimat (Umur, Suhu, Kelembaban)
│   └── trend_chart.dart                # Canvas grafik tren garis CustomPainter (ScoreTrendPainter)
│
├── screens/                            # Layar Halaman 4 Tab Utama & Modul Terpadu
│   ├── beranda_screen.dart             # Dashboard utama persis mockup visual 100% (+ Quick Access Pengaturan)
│   ├── evaluasi_screen.dart            # Layar terpadu Input & Hasil dengan Sub-tabs & Akses Kurva Fuzzy
│   ├── input_screen.dart               # Form evaluasi mikroklimat dengan slider & preset cepat
│   ├── hasil_screen.dart               # Komparasi Mamdani vs Sugeno, IP, FCR, mortalitas
│   ├── solusi_screen.dart              # Checklist SOP tindakan nyata & kontak hotline dokter hewan
│   ├── riwayat_screen.dart             # Arsip evaluasi harian, filter kategori & grafik tren
│   └── profil_screen.dart              # Profil peternak, pengaturan kandang, strain & sistem fuzzy (Akses via AppBar Avatar)
│
└── main.dart                           # Entry point ringkas (<250 baris) menghubungkan navigasi 4 tab ergonomis
```

---

## 2. Rincian Class dan Tanggung Jawab (Single Responsibility Principle)

### A. Lapisan Core (`lib/core/`)
1. **`AppColors`** (`app_colors.dart`):
   - Mengenkapsulasi seluruh palet warna agar konsisten di seluruh aplikasi.
   - Menggunakan warna dasar *Deep Teal* (`#005C55`), *Warm Amber* (`#D97706`), dan *Emerald Agri-Green* (`#059669`).
2. **`AppConstants` & `PresetScenario`** (`app_constants.dart`):
   - Menyediakan skenario pengujian preset instan: Kondisi Ideal, Panas (+3°C), Dingin (-4°C), Starter Kering, dan Finisher Kritis.
   - Memudahkan demonstrasi langsung di hadapan dosen penguji sidang TA.
3. **`AppDecorations`** (`app_decorations.dart`):
   - Menyediakan helper `cardBoxDecoration`, `tileBoxDecoration`, serta tipografi terstandarisasi.

---

### B. Lapisan Widgets Reusable (`lib/widgets/`)
1. **`CustomAppBar`**: Menampilkan nama aplikasi, badge DSS, tab aktif, selector kandang (Blok A, B, C), dan status *"Siap Pakai Tanpa Kuota"*.
2. **`EarlyWarningBanner`**: Banner cerdas yang muncul jika skor turun atau terjadi anomali mikroklimat. Memiliki tombol *Lihat Cara Penanganan* dan *Nanti Saja*.
3. **`HeroScoreCard`**: Komponen utama yang menampilkan kondisi ayam, badge skor lingkaran/kotak, progress bar status, dan prediksi panen.
4. **`TelemetryCard`**: Kartu pembacaan telemetri 3-grid: Umur (Hari), Suhu Ruangan (°C), dan Kelembaban Udara (RH%).
5. **`RecommendationCard`**: Kartu rekomendasi darurat "Langkah Penting Hari Ini" dengan highlight tindakan ventilasi/blower.
6. **`FlockBannerCard`**: Kartu siklus kandang aktif dengan badge closed house, strain, jumlah populasi, dan hari menuju panen.
7. **`ActionChecklistTile`**: Komponen checklist tindakan SOP kandang interaktif yang mencoret teks (*line-through*) saat dicentang peternak.
8. **`TrendChartWidget` & `ScoreTrendPainter`**: Engine grafik garis vektor CustomPaint native tanpa ketergantungan library pihak ketiga.
9. **`EvaluationDetailModal`**: Modal dialog rincian ilmiah lengkap yang menampilkan komparasi Mamdani, Sugeno, target suhu strain, dan $\Delta T$.

---

### C. Lapisan Layar (`lib/screens/`)
1. **`BerandaScreen`**: Mengorkestrasi seluruh komponen dashboard utama dengan indikator status dinamis (*Terpantau Baik / Perlu Dicek / Kritis*) dan tombol CTA terarah.
2. **`InputScreen`**: Form interaktif dengan tombol presisi steper `[-]` dan `[+]` serta slider untuk umur (1–42 hari), suhu (18–38°C), dan kelembaban (30–95%), memudahkan input peternak di lapangan.
3. **`HasilScreen`**: Menampilkan kartu penjelasan bahasa awam praktis untuk peternak, spektrum visual tolok ukur IP industri (<300 s.d. >400), komparasi Mamdani (Centroid) vs Sugeno (Weighted Average), tabel parameter biologis, estimasi IP, FCR, dan latensi komputasi.
4. **`SolusiScreen`**: Checklist interaktif mitigasi kandang dengan bilah kemajuan progres penyelesaian (0–100%), banner konfirmasi penyelesaian SOP mikroklimat, dan dialog bantuan teknis hotline dokter hewan.
5. **`RiwayatScreen`**: Tampilan historis evaluasi harian dengan kartu ringkasan KPI statistik (rata-rata skor, total hari, status terkini), filter kategori, dan grafik garis tren.
6. **`ProfilScreen`**: Pengelolaan identitas peternak, data kemitraan, pilihan strain ayam acuan (Cobb 500, Ross 308, Hubbard), konfigurasi mesin inferensi default (Mamdani vs Sugeno), notifikasi peringatan dini, alarm ekstrem, ekspor riwayat (CSV/JSON), dan panduan ujian sidang.

---

### D. Desain Navigasi Bawah Modern (Custom Bottom Navigation Bar)
1. **Active Capsule Pill**: Menggantikan bilah navigasi lama yang kaku dengan kapsul berlatar lembut (*Soft Mint* `#E0F2F1`) di belakang ikon aktif, selaras dengan standar Google Material 3.
2. **Ikon Modern & Representatif**:
   - `Beranda`: `Icons.space_dashboard_rounded` (Dasbor cerdas 4 kuadran menggantikan ikon grid generik).
   - `Evaluasi`: `Icons.analytics_rounded` (Analitik data inferensi ilmiah menggantikan ikon tune/audio).
   - `Solusi`: `Icons.assignment_turned_in_rounded` (Checklist SOP kandang tervalidasi menggantikan ikon checklist biasa).
   - `Riwayat`: `Icons.auto_graph_rounded` (Kurva tren performa futuristik menggantikan grafik zigzag sederhana).
3. **Elevasi & Tipografi Halus**: Bayangan lembut (*soft drop shadow*) `blurRadius: 16` tanpa garis pembatas kasar, serta tipografi `FontWeight.w700` dengan *letter-spacing* dinamis.

---

## 3. Keunggulan Akademik untuk Sidang Tugas Akhir
- **Clean Architecture**: Pemisahan yang jelas antara logika fuzzy murni (`fuzzy/`), representasi tampilan (`screens/` & `widgets/`), dan konfigurasi desain (`core/`).
- **High Testability**: Seluruh logika fuzzy dan widget telah divalidasi dengan unit test (`cross_validation_test.dart`) dan widget smoke test (`widget_test.dart`) dengan status kelulusan 100%.
- **Zero Visual Overflow**: Seluruh baris dan teks telah dilindungi dengan `Expanded`, `Flexible`, `Wrap`, dan `TextOverflow.ellipsis`, menjamin responsivitas di layar ponsel Android mana pun.

