# BAB 4: HASIL DAN PEMBAHASAN

## 4.1 Hasil Implementasi Sistem
Aplikasi Sistem Pendukung Keputusan (SPK) *FuzzyBroiler IP* berhasil diimplementasikan menggunakan framework Flutter (Dart) yang berjalan 100% offline pada sistem operasi Android. Sistem mampu membaca tiga parameter masukan (umur ayam, temperatur aktual, dan kelembaban udara), menghitung deviasi terhadap kurva target suhu strain broiler secara otomatis, mengevaluasi 27 basis aturan, serta menyajikan skor potensi performa panen.

### 4.1.1 Antarmuka Pengguna (5 Layar Utama)
1. **Layar Beranda**: Menampilkan kartu status kandang utama (*KONDISI BAIK SEKALI*, skor kesehatan 86/100 dengan progress bar hijau), 3 kartu telemetri mikroklimat, widget langkah penting hari ini, dan banner peringatan dini (*Early Warning Alert*) jika terdeteksi penurunan kondisi kandang.
2. **Layar Input Evaluasi**: Dilengkapi fitur deteksi fase pemeliharaan instan (*Starter / Grower / Finisher*) dan penampil target temperatur optimal strain acuan (Cobb 500 / Ross 308).
3. **Layar Hasil Inferensi**: Menampilkan perbandingan nilai skor Mamdani vs Sugeno berdampingan, rincian deviasi suhu, serta estimasi kategori Indeks Performa.
4. **Layar Solusi Tindakan**: Menyajikan panduan tindakan hierarkis sesuai tingkat urgensi (penanganan kipas blower, bukaan tirai, sekam, dan air minum).
5. **Layar Riwayat**: Menyimpan seluruh log evaluasi harian secara offline pada memori perangkat.

---

## 4.2 Analisis Komparasi Algoritma: Mamdani vs Sugeno
Pengujian komparasi empiris dilakukan menggunakan **50 skenario kasus uji representatif** yang mencakup seluruh kuadran kondisi: kasus ideal, kasus deviasi ekstrim kedinginan, kasus deviasi ekstrim kepanasan, dan kasus perbatasan (*boundary cases*) pada ketiga fase hidup broiler.

### Tabel Ringkasan Hasil Benchmark 50 Skenario Uji

| Parameter Evaluasi | Metode Mamdani (Centroid) | Metode Sugeno (Weighted Avg) | Keterangan / Analisis |
| :--- | :---: | :---: | :--- |
| **Rata-rata Waktu Inferensi** | **0.4959 ms** | **0.0054 ms** | **Sugeno 92.5x Lebih Cepat** |
| **Mean Absolute Error (MAE)** | \multicolumn{2}{c|}{**3.88 Poin**} | Selisih skor sangat kecil ($< 4\%$) |
| **Korelasi Pearson ($r$)** | \multicolumn{2}{c|}{**0.9987**} | Tingkat korelasi linier sangat kuat ($p < 0.001$) |
| **Kesesuaian Kategori Klasifikasi** | \multicolumn{2}{c|}{**98.0%** (49 dari 50 kasus)} | Hanya 1 kasus transisi batas yang berbeda kategori |

### Pembahasan Komparasi:
1. **Kecepatan Komputasi**: Metode Sugeno membutuhkan rata-rata waktu hanya $0.0054\text{ ms}$, atau sekitar **92.5 kali lebih cepat** dibandingkan metode Mamdani ($0.4959\text{ ms}$). Hal ini terjadi karena Sugeno menggunakan nilai skalar tegas (*singleton*) yang hanya membutuhkan operasi penjumlahan dan pembagian terbobot sederhana, sedangkan Mamdani memerlukan proses integrasi numerik diskrit pada kurva agregasi kontinu (100 *sampling steps*).
2. **Kesesuaian Hasil Skor**: Meskipun komputasinya jauh lebih sederhana, metode Sugeno menghasilkan skor yang sangat selaras dengan Mamdani, terbukti dari nilai koefisien korelasi Pearson $r = 0.9987$ dan nilai MAE hanya $3.88$ poin.
3. **Implikasi Desain**: Untuk aplikasi mobile smartphone modern, kedua algoritma berjalan di bawah $1\text{ ms}$ (jauh di bawah batas *frame budget* $16\text{ ms}$ pada layar 60 Hz). Mamdani sangat ideal digunakan sebagai penjelas logika linguistik bagi peternak, sedangkan Sugeno sangat direkomendasikan jika sistem nantinya diintegrasikan ke mikrokontroler IoT berdaya rendah (*low-power microcontrollers* seperti ESP32).

---

## 4.3 Uji Konsistensi Implementasi (Dart vs Python)
Berdasarkan pengujian unit test silang (*cross-validation test*) antara prototipe referensi Python (`fuzzy_engine.py`) dengan implementasi mesin Dart pada Flutter (`fuzzy_engine.dart`):
* Selisih nilai keluaran skor pada seluruh kasus uji identik adalah **$0.0$ (presisi identik)**.
* Kedua mesin menghasilkan klasifikasi kategori (*Rendah / Sedang / Tinggi*), fase umur, dan pembacaan deviasi temperatur yang sepenuhnya konsisten.

---

## 4.4 Pengujian Fungsionalitas Aplikasi (Black-Box Testing)

| No | Komponen yang Diuji | Skenario Uji | Hasil yang Diharapkan | Status |
| :-: | :--- | :--- | :--- | :---: |
| 1 | Input Umur Broiler | Memasukkan angka $1 - 42$ hari | Fase umur dan target suhu berubah otomatis | **Valid (Pass)** |
| 2 | Input Suhu & RH | Memasukkan nilai desimal valid | Pratinjau deviasi suhu dihitung seketika | **Valid (Pass)** |
| 3 | Eksekusi Inferensi | Klik tombol "Jalankan Inferensi" | Skor Mamdani & Sugeno tampil di Tab Hasil | **Valid (Pass)** |
| 4 | Sistem Deteksi Dini | Memasukkan tren skor turun 3 hari | Banner peringatan kuning muncul di Beranda | **Valid (Pass)** |
| 5 | Rekomendasi Tindakan | Menguji kondisi panas vs dingin | Saran tindakan kipas/pemanas berganti dinamis | **Valid (Pass)** |
| 6 | Navigasi Bottom Bar | Berpindah antar 5 tab menu | Halaman beralih mulus tanpa *freeze/lag* | **Valid (Pass)** |

---

## 4.5 Keterbatasan Penelitian
1. **Validasi Data Lapangan**: Penelitian ini menguji model berbasis 50 skenario komprehensif dan validasi pakar teoretis. Ketersediaan akses data pemeliharaan harian riil satu siklus panen penuh dari kandang komersial menjadi catatan pengembangan lanjutan.
2. **Penginputan Manual**: Nilai temperatur dan kelembaban pada versi ini masih dimasukkan secara manual oleh peternak melalui formulir, belum terhubung secara nirkabel langsung ke modul sensor IoT.

