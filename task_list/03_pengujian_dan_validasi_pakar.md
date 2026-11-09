# Task List 03: Pengujian, Validasi Pakar, dan Evaluasi Kinerja

Dokumen ini memuat daftar tugas untuk merancang metodologi eksperimental, validasi model bersama pakar, dan pengujian teknis sistem.

---

## 🎯 Metrik Evaluasi yang Ditargetkan

Sesuai halaman 5 Blueprint TA, terdapat 7 metrik evaluasi yang wajib dicakup:

1. **Kesesuaian dengan Pakar**: Akurasi kategori, Mean Absolute Error (MAE), Cohen's Kappa ($\kappa$).
2. **Hubungan dengan IP Riil**: Korelasi Pearson/Spearman skor sistem dengan data historis panen kandang mitra (opsional jika data kandang tersedia).
3. **Mamdani vs Sugeno**: Selisih keluaran dan perbandingan latensi komputasi pada skenario identik.
4. **Konsistensi Implementasi**: Selisih hasil engine Dart terhadap referensi Python (`scikit-fuzzy`).
5. **Fungsionalitas Aplikasi**: Black-box testing pada 5 layar dan operasi basis data.
6. **Kegunaan Aplikasi**: Evaluasi kuesioner System Usability Scale (SUS) kepada responden pengguna.
7. **Kinerja Komputasi**: Waktu komputasi inferensi (milidetik) saat dieksekusi di perangkat fisik Android.

---

## 📋 Daftar Tugas Utama

- [ ] **Task 3.1: Pembuatan Dataset Skenario Uji (Kombinasi Grid)**
  - Merancang set kombinasi input $(Umur, Suhu, Kelembaban)$ yang mencakup seluruh kuadran kondisi:
    - Kondisi ideal di setiap fase (Starter, Grower, Finisher).
    - Kondisi deviasi ekstrim (misal: Starter kedinginan parah, Finisher kepanasan parah).
    - Kondisi ambigu / di batas antar-himpunan (*boundary testing*).
  - Menyiapkan minimal 30–50 butir skenario data uji untuk dinilai oleh pakar peternakan.

- [ ] **Task 3.2: Protokol Wawancara & Penilaian Pakar (Expert Judgment)**
  - Menentukan 2–3 narasumber pakar:
    - Penyuluh Dinas Peternakan / Dokter Hewan (drh.) perunggasan / Praktisi manajer kandang broiler berpengalaman.
  - Menyiapkan kuesioner validasi:
    - Pakar diminta memberikan penilaian terhadap 27 aturan fuzzy (Apakah aturan logis dan sesuai realitas biologis ayam broiler?).
    - Pakar memberikan skor estimasi (0–100) dan kategori (Rendah/Sedang/Tinggi) untuk setiap baris dalam dataset skenario.

- [ ] **Task 3.3: Komparasi Mamdani vs Sugeno**
  - Menjalankan 27 skenario pada kedua algoritma.
  - Menghitung deviasi keluaran skor:
    $$\Delta \text{Skor} = |\text{Skor}_{\text{Mamdani}} - \text{Skor}_{\text{Sugeno}}|$$
  - Mencatat *execution time* (microsecond/millisecond) untuk 1.000 iterasi inferensi di perangkat Android.
  - Menganalisis trade-off antara kehalusan interpretasi (Mamdani) vs efisiensi komputasi (Sugeno).

- [ ] **Task 3.4: Uji Konsistensi Implementasi (Dart vs Python)**
  - Menjalankan dataset skenario yang sama di skrip Python (`scikit-fuzzy`) dan unit test Dart.
  - Memverifikasi selisih skor:
    $$\text{Error} = |y_{\text{Dart}} - y_{\text{Python}}|$$
  - Memastikan selisih mendekati nol ($< 10^{-4}$ atau hanya disebabkan oleh perbedaan metode integrasi numerik diskrit centroid).

- [ ] **Task 3.5: Perhitungan Statistik Akurasi & Cohen's Kappa**
  - Menghitung **MAE (Mean Absolute Error)** antara skor fuzzy sistem dengan skor penilaian pakar:
    $$\text{MAE} = \frac{1}{N} \sum_{i=1}^{N} |y_{\text{sistem}, i} - y_{\text{pakar}, i}|$$
  - Menghitung **Akurasi Kategori**: Persentase kecocokan klasifikasi (Rendah / Sedang / Tinggi) antara sistem dan pakar.
  - Menghitung **Cohen's Kappa ($\kappa$)** untuk mengukur tingkat kesepakatan (*inter-rater agreement*) di luar faktor kebetulan (*chance agreement*):
    $$\kappa = \frac{p_o - p_e}{1 - p_e}$$

- [ ] **Task 3.6: Pengujian Black-box Testing Aplikasi**
  - Menguji setiap fitur aplikasi menggunakan skenario uji *Test Case*:
    - Validasi batas input (input umur negatif, suhu > 50 °C, kelembaban di luar batas).
    - Penyimpanan dan pemanggilan data SQLite.
    - Pemicu sistem peringatan dini (kondisi turun 3 hari).
    - Respon antarmuka pengguna pada berbagai resolusi layar.

- [ ] **Task 3.7: Uji Kegunaan Sistem (System Usability Scale - SUS)**
  - Menyusun kuesioner 10 pertanyaan standar SUS (skala Likert 1–5).
  - Melakukan uji coba langsung aplikasi kepada 5–10 responden (peternak/pengelola kandang).
  - Menghitung skor rata-rata SUS (Target nilai minimal $> 68$ / kategori *Acceptable/Good*).

