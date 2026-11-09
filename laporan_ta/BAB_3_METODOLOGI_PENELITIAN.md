# BAB 3: METODOLOGI PENELITIAN

## 3.1 Kerangka Kerja Penelitian
Penelitian ini merupakan penelitian terapan (*applied research*) yang memadukan rekayasa perangkat lunak mobile dengan metode kecerdasan buatan (*soft computing*) logika fuzzy. Tahapan penelitian disusun secara sistematis sebagai berikut:
1. **Identifikasi Masalah & Studi Pustaka**: Pengumpulan data fisiologis ayam broiler dari *Cobb 500 Broiler Management Guide* dan *Ross 308*, perumusan indikator performa (IP), dan tinjauan penalaran fuzzy.
2. **Perancangan Model Logika Fuzzy**: Penentuan semesta pembicaraan, fungsi keanggotaan, formulasi deviasi suhu adaptif, perancangan 27 basis aturan, serta mekanisme defuzzifikasi Mamdani dan Sugeno.
3. **Pembangunan Prototipe & Simulasi**: Pembuatan skrip Python (`fuzzy_engine.py` dan `benchmark.py`) untuk mensimulasikan inferensi pada 50 skenario uji.
4. **Validasi Model oleh Pakar**: Pengujian kelayakan 27 aturan dan akurasi inferensi menggunakan instrumen kuesioner kepada dokter hewan dan penyuluh peternakan.
5. **Implementasi Aplikasi Mobile (Flutter/Dart)**: Menerjemahkan mesin fuzzy ke dalam *pure Dart* dan membangun 5 layar antarmuka pengguna berbasis *offline-first*.
6. **Pengujian Sistem & Analisis Kinerja**: Pengujian fungsionalitas (*black-box*), pengukuran konsistensi Dart vs Python, komparasi waktu komputasi Mamdani vs Sugeno, serta evaluasi kepuasan pengguna (*System Usability Scale* / SUS).

---

## 3.2 Perancangan Model Fuzzy Inference System (FIS)

### 3.2.1 Variabel Input dan Output
Model dirancang dengan 3 variabel masukan (*input*) dan 1 variabel keluaran (*output*):

| Variabel | Peran | Semesta Pembicaraan | Himpunan Fuzzy | Satuan |
| :--- | :---: | :---: | :--- | :---: |
| **Umur Ayam** | Input | $[0, 42]$ | Starter ($0–14$), Grower ($10–30$), Finisher ($27–50$) | Hari |
| **Deviasi Suhu ($\Delta T$)** | Input | $[-8, +8]$ | Dingin ($< -1.0$), Nyaman ($-2.5 \text{ s.d. } +3.0$), Panas ($> +1.5$) | $^\circ\text{C}$ |
| **Kelembaban Relatif (RH)** | Input | $[30, 90]$ | Rendah ($< 58$), Ideal ($55–75$), Tinggi ($> 72$) | $\%$ |
| **Skor Potensi Performa** | Output | $[0, 100]$ | Rendah ($0–50$), Sedang ($40–80$), Tinggi ($70–100$) | Poin |

### 3.2.2 Formulasi Deviasi Suhu Adaptif ($\Delta T$)
Deviasi suhu dihitung secara dinamis terhadap kurva target suhu harian strain komersial:
$$\Delta T = T_{\text{aktual}} - T_{\text{target}}(Umur)$$
Fungsi target suhu $T_{\text{target}}(u)$ mengacu pada standar strain:
$$T_{\text{target}}(u) = \begin{cases} 33.0^\circ\text{C}, & 1 \le u \le 3 \\ 31.5^\circ\text{C}, & 4 \le u \le 7 \\ 29.0^\circ\text{C}, & 8 \le u \le 14 \\ 27.0^\circ\text{C}, & 15 \le u \le 21 \\ 24.5^\circ\text{C}, & 22 \le u \le 28 \\ 22.5^\circ\text{C}, & 29 \le u \le 35 \\ 21.0^\circ\text{C}, & 36 \le u \le 42 \end{cases}$$

### 3.2.3 Basis 27 Aturan Fuzzy (Rule Base)
Kombinasi 3 variabel input ($3 \times 3 \times 3 = 27$ aturan) mencakup penyesuaian bobot biologis:
* **Fase Starter**: Penalti berat pada kondisi deviasi dingin (*chilling*) karena anak ayam belum berbulu lengkap dan sistem imun masih rentan.
* **Fase Finisher**: Penalti berat pada kondisi deviasi panas (*heat stress*) karena ayam dewasa berbobot tebal sangat rentan terhadap kematian mendadak akibat kegagalan pelepasan panas tubuh.

---

## 3.3 Metode Inferensi dan Defuzzifikasi

### 3.3.1 Metode Mamdani (Centroid / Center of Gravity)
* **Operator Fuzzy**: $\alpha_i = \min(\mu_{\text{Umur}}, \mu_{\text{Deviasi}}, \mu_{\text{Kelembaban}})$
* **Agregasi**: $\mu_{\text{agregat}}(z) = \max_{i=1}^{27} (\min(\alpha_i, \mu_{C_i}(z)))$
* **Defuzzifikasi Centroid**:
  $$z^* = \frac{\sum_{j=0}^{100} z_j \cdot \mu_{\text{agregat}}(z_j)}{\sum_{j=0}^{100} \mu_{\text{agregat}}(z_j)}$$

### 3.3.2 Metode Sugeno Orde-Nol (Weighted Average)
Menggunakan nilai skalar konstan (*singleton*): $z_{\text{Rendah}} = 30$, $z_{\text{Sedang}} = 65$, $z_{\text{Tinggi}} = 88$.
$$z^* = \frac{\sum_{i=1}^{27} \alpha_i \cdot z_i}{\sum_{i=1}^{27} \alpha_i}$$

---

## 3.4 Perancangan Arsitektur Perangkat Lunak Flutter
Aplikasi dirancang menggunakan framework Flutter (Dart) dengan prinsip pemisahan tanggung jawab (*separation of concerns*) dan pola arsitektur modular berlapis:
1. **Lapisan Core (`lib/core/`)**: Mengenkapsulasi token warna resmi (*Deep Teal* `#005C55`, *Warm Amber* `#D97706`, *Emerald* `#059669`), konstanta aplikasi, daftar kandang, dan preset skenario uji.
2. **Lapisan Fuzzy Engine (`lib/fuzzy/`)**: Mesin logika fuzzy murni (*pure Dart*) yang mandiri tanpa ketergantungan UI, mengeksekusi 27 basis aturan, pemetaan target adaptif strain (Cobb 500, Ross 308, Hubbard), serta defuzzifikasi Mamdani dan Sugeno secara instan (< 1 ms).
3. **Lapisan Komponen UI Reusable (`lib/widgets/`)**: Komponen modular seperti `HeroScoreCard`, `TelemetryCard`, `FlockBannerCard` dengan ilustrasi digital, `ActionChecklistTile`, `ScoreTrendPainter` (*CustomPaint* vektor), dan `FuzzyMembershipDialog` (visualisator kurva fungsi keanggotaan interaktif).
4. **Lapisan Layar Terpadu (`lib/screens/`) & Navigasi 4-Tab Ergonomis**:
   * **Beranda (`BerandaScreen`)**: Dashboard status mikroklimat, pembacaan telemetri 3-grid, banner peringatan dini, dan akses cepat pengaturan.
   * **Evaluasi (`EvaluasiScreen`)**: Modul terpadu ber-sub-tab yang menggabungkan formulir input parameter mikroklimat dengan penampil hasil inferensi ilmiah dan tombol akses kurva fuzzy.
   * **Solusi (`SolusiScreen`)**: Checklist interaktif mitigasi operasional closed-house (blower, tirai, cooling pad, pemanas) disertai indikator progres penyelesaian.
   * **Riwayat (`RiwayatScreen`)**: Arsip log evaluasi harian tersimpan lokal dengan filter kategori dan grafik garis tren performa.
   * **Profil & Pengaturan (`ProfilScreen`)**: Pengelolaan identitas peternak, data kemitraan, pilihan strain acuan, dan manajemen data offline/cloud sync yang diakses melalui avatar peternak di AppBar.
5. **Navigasi Bawah Modern (Material 3 Active Pill)**: Menggunakan bilah navigasi 4 tab lega (\~25% lebar layar) berlatar kapsul lembut (*Soft Mint* `#E0F2F1`) dan bayangan ambien melayang (*ambient drop shadow*).

---

## 3.5 Metrik Pengujian dan Evaluasi

1. **Mean Absolute Error (MAE)**:
   Mengukur selisih absolut rata-rata antara hasil keluaran sistem dengan penilaian pakar:
   $$\text{MAE} = \frac{1}{N} \sum_{i=1}^{N} |y_{\text{sistem}, i} - y_{\text{pakar}, i}|$$
2. **Koefisien Kesepakatan Cohen's Kappa ($\kappa$)**:
   $$\kappa = \frac{p_o - p_e}{1 - p_e}$$
3. **Latensi Komputasi (Runtime Benchmark)**:
   Mengukur waktu eksekusi inferensi (milidetik) per 50 pengulangan antara metode Mamdani dan Sugeno di perangkat seluler.
4. **System Usability Scale (SUS)**:
   Kuesioner 10 pertanyaan standar dengan skala Likert 1–5 untuk menguji tingkat penerimaan peternak terhadap kemudahan penggunaan aplikasi.

