# PANDUAN DAN MATERI SLIDE PRESENTASI SIDANG TUGAS AKHIR

**Judul Penelitian**: *Fuzzy Inference System Adaptif Umur untuk Evaluasi Potensi Indeks Performa Ayam Broiler*  
**Penyusun**: Ferdiansyah  
**Target Durasi Presentasi**: 15 – 20 Menit (Alokasi: 12 menit presentasi materi, 5 menit demo aplikasi, 3 menit penutup sebelum sesi tanya-jawab)

---

## 📊 DAFTAR ISI SLIDE (STRUKTUR 16 SLIDE STANDAR AKADEMIS)

| Slide | Topik / Judul Slide | Estimasi Waktu | Fokus Utama |
| :---: | :--- | :---: | :--- |
| **01** | Judul, Identitas Mahasiswa & Pembimbing | 1 Menit | Pembukaan formal, konteks penelitian agritech |
| **02** | Latar Belakang & Urgensi Masalah | 1.5 Menit | Keterlambatan evaluasi IP & kerentanan mikroklimat |
| **03** | Rumusan Masalah & Batasan Penelitian | 1 Menit | 3 pertanyaan penelitian & batasan adaptif umur |
| **04** | Tujuan & Kontribusi Penelitian | 1 Menit | Formulasi 27 aturan, komparasi algoritma, aplikasi mobile |
| **05** | Tinjauan Pustaka: Fisiologi & Mikroklimat Broiler | 1.5 Menit | Perbedaan kepekaan termal Starter vs Finisher |
| **06** | Metodologi Penelitian: Diagram Alir Riset | 1 Menit | 6 tahapan penelitian berurutan |
| **07** | Perancangan Model: Variabel Input & Fungsi Target Adaptif | 1.5 Menit | Kurva target umur Cobb 500 / Ross 308 & semesta pembicaraan |
| **08** | Matriks 27 Basis Aturan Inferensi Biologis | 1.5 Menit | Struktur penalaran $3 \times 3 \times 3$ berbobot biologi unggas |
| **09** | Komparasi Metode: Mamdani (Centroid) vs Sugeno (Orde-Nol) | 1.5 Menit | Formulasi matematika COG vs Weighted Average |
| **10** | Arsitektur Aplikasi Flutter: Offline-First & Modular | 1.5 Menit | 4 lapisan clean architecture & navigasi 4-tab ergonomis |
| **11** | Hasil & Pembahasan: Benchmark 50 Kasus Uji | 2 Menit | Sugeno 92.5x lebih cepat, MAE 3.88, korelasi $r = 0.9987$ |
| **12** | Uji Konsistensi & Validasi Fungsional (Black-Box) | 1 Menit | Presisi identik Dart vs Python ($0.0$ error) & uji 6 modul |
| **13** | **DEMO APLIKASI FLUTTER LANGSUNG** | **4 Menit** | Uji Skenario Ideal, Kritis Dingin DOC, dan Heat Stress |
| **14** | Kesimpulan Penelitian | 1 Menit | Jawaban terukur atas 3 rumusan masalah |
| **15** | Saran & Pengembangan Lanjutan | 1 Menit | Integrasi IoT nirkabel (ESP32) & ANFIS |
| **16** | Ucapan Terima Kasih & Sesi Tanya Jawab (Q&A) | - | Penutup dan transisi ke dosen penguji |

---

## 🎙️ PANDUAN NARASI LISAN (TALKING POINTS) PER SLIDE

### Slide 01: Judul dan Pembukaan
* **Narasi**: 
  > *"Selamat pagi/siang yang terhormat Bapak/Ibu Dewan Penguji dan Dosen Pembimbing. Puji syukur ke hadirat Tuhan Yang Maha Esa, perkenankan saya, Ferdiansyah, mempresentasikan hasil penelitian Tugas Akhir saya yang berjudul: **Fuzzy Inference System Adaptif Umur untuk Evaluasi Potensi Indeks Performa Ayam Broiler**."*

### Slide 02: Latar Belakang Masalah
* **Poin Kunci di Layar**:
  1. Ayam broiler merupakan komoditas strategis dengan siklus hidup sangat singkat (35–42 hari).
  2. Tolok ukur keberhasilan peternakan adalah **Indeks Performa (IP)**, namun selama ini IP **hanya dihitung setelah ayam dipanen (bersifat retrospektif)**.
  3. Fluktuasi suhu dan kelembaban harian di kandang tropis sering tidak terdeteksi sejak dini, mengakibatkan lonjakan FCR dan mortalitas.
* **Narasi**:
  > *"Bapak/Ibu penguji, masalah utama peternak rakyat saat ini adalah mereka baru mengetahui nilai Indeks Performa setelah ayam dipanen. Jika terjadi kesalahan manajemen mikroklimat pada umur 5 hari atau umur 35 hari, kerugian finansial sudah tidak bisa diperbaiki. Oleh karena itu, dibutuhkan sebuah sistem pendukung keputusan harian yang bersifat preventif dan adaptif terhadap umur ayam."*

### Slide 07: Perancangan Model FIS Adaptif Umur
* **Poin Kunci di Layar**:
  - Input 1: **Umur Ayam** ($0 - 42$ hari) $\rightarrow$ *Starter, Grower, Finisher*.
  - Input 2: **Deviasi Suhu** $\Delta T = T_{\text{aktual}} - T_{\text{target}}(\text{Umur})$ $\rightarrow$ *Dingin, Nyaman, Panas*.
  - Input 3: **Kelembaban Relatif** ($30\% - 95\%$) $\rightarrow$ *Kering, Nyaman, Lembab*.
  - Output: **Skor Potensi Performa** ($0 - 100$) $\rightarrow$ *Rendah, Sedang, Tinggi*.
* **Narasi**:
  > *"Kebaruan utama (*novelty*) dari penelitian ini terletak pada variabel **Deviasi Suhu Adaptif**. Berbeda dari penelitian sebelumnya yang mematok suhu nyaman statis 24–28°C untuk seluruh umur ayam, model ini secara dinamis menghitung selisih antara suhu aktual dengan target standar pedoman industri (Cobb 500 dan Ross 308). Sehingga suhu 28°C pada anak ayam umur 3 hari dinilai kedinginan, namun suhu 28°C pada ayam umur 38 hari dinilai kepanasan berbahaya."*

### Slide 11: Hasil Benchmark Mamdani vs Sugeno (Poin Terpenting)
* **Tabel yang Ditampilkan**:
  - Rata-rata Waktu Eksekusi: Sugeno **0.0054 ms** vs Mamdani **0.4959 ms** (**Sugeno 92.5x lebih cepat**).
  - Mean Absolute Error (MAE): **3.88 Poin** (selisih di bawah 4%).
  - Korelasi Pearson ($r$): **0.9987** (korelasi linier sangat kuat).
  - Kesesuaian Kategori: **98.0%** (49 dari 50 kasus uji identik).
* **Narasi**:
  > *"Berdasarkan pengujian empiris 50 skenario kasus uji, terbukti bahwa metode Sugeno mengeksekusi inferensi 92.5 kali lebih cepat dibanding Mamdani. Namun secara akurasi, kedua metode memiliki korelasi 0.9987 dan tingkat kesesuaian kategori 98%. Hal ini membuktikan bahwa metode Sugeno sangat unggul untuk implementasi perangkat berdaya rendah, sedangkan Mamdani unggul dalam representasi visual linguistik kurva defuzzifikasi."*

### Slide 13: Skenario Demonstrasi Aplikasi (Live Demo)
1. **Skenario 1 (Kondisi Ideal)**: Umur 21 hari, Suhu 27°C, RH 65% $\rightarrow$ Skor 86 (Kategori Tinggi, IP 385).
2. **Skenario 2 (Kasus Chilling DOC)**: Umur 4 hari, Suhu 25°C (Target 31.5°C, $\Delta T = -6.5^\circ\text{C}$) $\rightarrow$ Skor 25 (Kategori Rendah), Muncul rekomendasi menyalakan pemanas (*heater gasolec*).
3. **Skenario 3 (Kasus Heat Stress Finisher)**: Umur 38 hari, Suhu 29.5°C, RH 80% $\rightarrow$ Skor 24 (Kategori Rendah), Peringatan dini stres panas aktif, checklist blower dinyalakan maksimal.
4. **Skenario 4 (Navigasi & Visual Kurva)**: Buka dialog kurva fuzzy 4-vektor, tunjukkan posisi nilai masukan pada kurva segitiga/trapesium.

---

## 🛡️ BANK TANYA-JAWAB SIDANG (ANTICIPATED EXAMINER QUESTIONS & ANSWERS)

### Pertanyaan 1: "Mengapa Anda menggunakan Logika Fuzzy, bukan Machine Learning seperti Regresi Linier atau Neural Network?"
* **Jawaban Mahasiswa**:
  > *"Terima kasih atas pertanyaannya, Bapak/Ibu Penguji. Alasan utama memilih Logika Fuzzy adalah:*
  > 1. *Karakteristik hubungan antara mikroklimat dan kenyamanan ayam memiliki batas toleransi yang bertahap (*gradual*) dan tidak tegas (*imprecise*), yang sangat tepat dimodelkan dengan fungsi keanggotaan.*
  > 2. *Logika Fuzzy bersifat **White-Box (Transparan dan Terjelaskan)**. Peternak dan akademisi dapat menelusuri aturan logika mana yang aktif di balik suatu rekomendasi, berbeda dengan Neural Network yang bersifat *Black-Box*.*
  > 3. *Model ini tidak membutuhkan ratusan ribu data historis berlabel (*training dataset*) yang sulit didapat di peternakan rakyat, melainkan langsung menyerap kaidah pakar fisiologi unggas dan standar manajemen bibit broiler internasional."*

### Pertanyaan 2: "Mengapa metode Sugeno bisa 92.5 kali lebih cepat daripada Mamdani?"
* **Jawaban Mahasiswa**:
  > *"Pada tahap defuzzifikasi, metode Mamdani menggunakan rumus Center of Gravity (Centroid) yang menghitung luas area kontinu dari kurva agregasi gabungan. Dalam kode komputasi diskrit, sistem harus melakukan iterasi sebanyak 100 langkah integrasi numerik diskrit ($j = 0$ sampai $100$).*
  > *Sebaliknya, metode Sugeno orde-nol menggunakan nilai konstanta skalar tegas (*singleton*, yaitu 30, 65, dan 88). Tahap defuzzifikasinya hanya berupa operasi aritmatika dasar penjumlahan dan pembagian terbobot (*Weighted Average*). Tanpa adanya proses integrasi area, waktu komputasi Sugeno terpangkas drastis menjadi hanya 0.0054 milidetik."*

### Pertanyaan 3: "Mengapa aplikasi dirancang 100% Offline di smartphone, bukan Web Cloud berbasis IoT murni?"
* **Jawaban Mahasiswa**:
  > *"Berdasarkan survei lapangan, sebagian besar kandang broiler closed-house di Indonesia berlokasi di area perkebunan atau perbukitan terpencil yang sering mengalami kendala sinyal seluler (*blank spot*) dan pemadaman listrik.*
  > *Dengan pendekatan **Offline-First**, seluruh mesin inferensi Dart dan penyimpanan SQLite berjalan mandiri di memori HP peternak. Peternak tetap dapat mengambil keputusan darurat tanpa memerlukan kuota internet. Namun, aplikasi ini tetap disiapkan untuk integrasi online di masa depan (*hybrid sync*) saat koneksi internet tersedia."*

### Pertanyaan 4: "Bagaimana Anda membuktikan bahwa implementasi kode Anda di Flutter (Dart) sudah benar secara matematis?"
* **Jawaban Mahasiswa**:
  > *"Saya melakukan pengujian silang (*cross-validation*) dengan membandingkan luaran aplikasi Flutter Dart terhadap prototipe baku berbasis Python (`scikit-fuzzy`). Pada 50 skenario uji yang mencakup seluruh kuadran kondisi, selisih hasil antara Dart dan Python adalah **$0.0$ (presisi identik)**. Pengujian ini telah dibakukan dalam berkas automated unit test `cross_validation_test.dart` yang lolos 100%."*

---

## 💡 TIPS SUKSES SAAT HARI SIDANG
1. **Siapkan 2 Perangkat**: Satu laptop untuk menampilkan slide presentasi, dan satu smartphone Android (atau emulator) dengan aplikasi terinstal untuk demo langsung.
2. **Ucapkan Angka Secara Rinci**: Selalu sebutkan metrik kuantitatif (*92.5 kali lebih cepat, korelasi 0.9987, MAE 3.88 poin, 27 basis aturan*). Dosen penguji sangat menyukai data kuantitatif yang presisi.
3. **Posisikan Diri Sebagai Problem Solver**: Tunjukkan bahwa penelitian ini bukan sekadar tugas pemrograman, tetapi solusi nyata untuk menyelamatkan ribuan ayam broiler peternak dari ancaman kematian mendadak (*heat stress*).
