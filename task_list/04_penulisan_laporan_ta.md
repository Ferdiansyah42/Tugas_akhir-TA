# Task List 04: Penulisan Laporan Tugas Akhir (Bab 1 s.d. Bab 5)

Dokumen ini memuat daftar tugas penyusunan naskah laporan Tugas Akhir sesuai struktur akademik yang ditetapkan pada Halaman 6 Blueprint TA.

---

## 📚 Struktur & Rincian Pembahasan Laporan

- [ ] **Bab 1: Pendahuluan**
  - [ ] **1.1 Latar Belakang**:
    - Peran vital industri ayam broiler dalam ketahanan pangan & protein hewani.
    - Tantangan peternak rakyat: Sensitivitas tinggi terhadap suhu & kelembaban (*Temperature Humidity Index* / THI).
    - Permasalahan: Kegagalan deteksi dini penurunan potensi performa panen karena evaluasi iklim mikro tidak adaptif terhadap umur ayam.
  - [ ] **1.2 Rumusan Masalah**:
    - Bagaimana merancang model Fuzzy Inference System yang adaptif terhadap umur ayam broiler?
    - Bagaimana membandingkan kinerja dan efisiensi metode Mamdani vs Sugeno pada perangkat mobile offline?
    - Bagaimana merancang aplikasi SPK Android berbasis Flutter yang menyajikan skor potensi IP, rekomendasi tindakan, dan peringatan dini?
  - [ ] **1.3 Batasan Masalah**:
    - Ruang lingkup strain ayam broiler (misal pedoman standar Cobb 500 / Ross 308).
    - Input dibatasi pada 3 parameter utama: umur ayam (0–42 hari), suhu kandang aktual, dan kelembaban relatif (RH).
    - Aplikasi berjalan offline di perangkat Android; integrasi sensor IoT dan sinkronisasi server dijadikan saran pengembangan.
  - [ ] **1.4 Tujuan Penelitian**:
    - Membangun model FIS adaptif umur dengan 27 aturan.
    - Membandingkan akurasi dan latensi komputasi Mamdani vs Sugeno.
    - Mengembangkan aplikasi Android offline sebagai SPK peternak broiler.
  - [ ] **1.5 Manfaat Penelitian**:
    - Manfaat teoritis (penerapan soft computing pada domain peternakan presisi).
    - Manfaat praktis (membantu peternak rakyat memitigasi kegagalan panen sedini mungkin).

- [ ] **Bab 2: Tinjauan Pustaka**
  - [ ] **2.1 Manajemen Mikroklimat Ayam Broiler**:
    - Zona nyaman (*thermoneutral zone*) per fase umur (Starter, Grower, Finisher).
    - Dampak stres dingin (*chilling*) dan stres panas (*heat stress*) terhadap FCR & mortalitas.
  - [ ] **2.2 Indeks Performa (IP) Broiler**:
    - Definisi, rumus perhitungan empiris:
      $$\text{IP} = \frac{(100 - M) \times B}{\text{FCR} \times U} \times 100$$
    - Standar klasifikasi nilai IP di industri (Kurang, Cukup, Baik, Istimewa).
  - [ ] **2.3 Konsep Logika Fuzzy (Fuzzy Inference System)**:
    - Himpunan tegas (crisp) vs himpunan kabur (fuzzy).
    - Metode penalaran Mamdani (Max-Min, defuzzifikasi Centroid).
    - Metode penalaran Sugeno (konsekuen nilai skalar, defuzzifikasi Weighted Average).
  - [ ] **2.4 Penelitian Terdahulu & Research Gap**:
    - Tabel sintesis komparasi penelitian sejenis terdahulu.
    - Penjelasan posisi kebaruan (kebaruan terletak pada batas suhu adaptif berbasis fungsi target umur ayam dan keluaran skor yang dipetakan ke potensi IP).

- [ ] **Bab 3: Metodologi Penelitian**
  - [ ] **3.1 Diagram Alir Tahapan Penelitian** (Studi pustaka $\rightarrow$ perancangan model $\rightarrow$ prototipe $\rightarrow$ validasi pakar $\rightarrow$ implementasi mobile $\rightarrow$ pengujian).
  - [ ] **3.2 Perancangan Model FIS**:
    - Tabel semesta pembicaraan & formulasi kurva fungsi keanggotaan.
    - Formulasi fungsi suhu target dinamis terhadap umur: $T_{target}(umur)$.
    - Matriks lengkap 27 basis aturan (*rule base*).
    - Detail matematis defuzzifikasi Mamdani dan Sugeno.
  - [ ] **3.3 Perancangan Arsitektur Aplikasi Flutter**:
    - Pemisahan arsitektur modular (`fuzzy/`, `data/`, `service/`, `ui/`).
    - Skema tabel SQLite.
    - Flowchart sistem peringatan dini (early warning system).
  - [ ] **3.4 Metode Pengumpulan Data & Validasi**:
    - Data sekunder (Pedoman Strain Management Guide).
    - Desain skenario uji untuk validasi pakar (2–3 praktisi/ahli).
    - Rumus metrik evaluasi: Akurasi, MAE, Cohen's Kappa, dan SUS.

- [ ] **Bab 4: Hasil dan Pembahasan**
  - [ ] **4.1 Hasil Implementasi Model FIS**:
    - Hasil inferensi pada berbagai kasus skenario uji.
    - Verifikasi konsistensi implementasi Dart terhadap prototipe Python.
  - [ ] **4.2 Analisis Komparasi Mamdani vs Sugeno**:
    - Tabel perbandingan nilai output skor untuk kedua metode.
    - Analisis perbedaan waktu komputasi (benchmark latency di Android).
  - [ ] **4.3 Hasil Validasi Pakar**:
    - Tabel matriks konfusi penilaian sistem vs pakar.
    - Nilai evaluasi: Akurasi (%), MAE, dan indeks Cohen's Kappa.
  - [ ] **4.4 Hasil Implementasi & Uji Aplikasi Flutter**:
    - Tangkapan layar (*screenshot*) 5 antarmuka aplikasi.
    - Hasil uji fungsionalitas *black-box testing*.
    - Hasil skor usability kuesioner SUS.
  - [ ] **4.5 Pembahasan & Keterbatasan Penelitian**:
    - Diskusi implikasi hasil sistem bagi peternak rakyat.
    - Identifikasi keterbatasan (misal data skenario vs ketersediaan kandang mitra riil).

- [ ] **Bab 5: Penutup**
  - [ ] **5.1 Kesimpulan**: Menjawab seluruh rumusan masalah berdasarkan data eksperimen yang diperoleh.
  - [ ] **5.2 Saran Pengembangan Lanjutan**:
    - Integrasi sensor nirkabel berbasis IoT (misal ESP32 / DHT22) untuk pembacaan mikroklimat otomatis.
    - Penerapan metode adaptif lebih lanjut seperti ANFIS (*Adaptive Neuro-Fuzzy Inference System*).
    - Penambahan sinkronisasi cloud/server saat perangkat terhubung internet.

