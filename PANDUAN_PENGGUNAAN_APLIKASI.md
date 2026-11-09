# PANDUAN PENGGUNAAN & DEMO SIDANG APLIKASI
## FuzzyBroiler IP: Decision Support System Adaptif Umur Broiler

Dokumen ini berisi petunjuk operasional lengkap aplikasi, panduan skenario demonstrasi untuk penguji saat sidang Tugas Akhir (TA), serta instruksi pembuatan file instalasi APK Android (*release build*).

---

## 1. Cara Menjalankan Aplikasi di Komputer / Laptop

### A. Menjalankan Versi Mobile Flutter (Rekomendasi Utama)
Pastikan terminal berada di dalam direktori `flutter_app`:
```powershell
cd flutter_app
flutter run -d chrome
```
*Tips Saat Aplikasi Berjalan:*
* Tekan **`r`** di terminal untuk melakukan *Hot Reload* (memperbarui perubahan kecil seketika).
* Tekan **`R`** (kapital) untuk melakukan *Hot Restart* (memuat ulang seluruh state dari awal).
* Tekan **`q`** untuk keluar dari aplikasi.

### B. Menjalankan Versi Web Python Flask (Sebagai Prototipe Pembanding)
Buka terminal baru di root folder `c:\TA-saya`:
```powershell
.venv\Scripts\python.exe app.py
```
Lalu buka browser di: `http://127.0.0.1:5000`

---

## 2. Panduan Skenario Demonstrasi untuk Sidang Tugas Akhir (TA)

Saat dosen penguji meminta Anda mendemonstrasikan sistem, ikuti 4 skenario demo berikut:

### Skenario 1: Membuktikan Batas Suhu Adaptif terhadap Umur (Nilai Kebaruan Utama)
1. Buka Tab **Input**.
2. **Uji Kasus Anak Ayam (Starter)**:
   * Geser slider Umur ke **Hari ke-5**. Perhatikan bahwa target temperatur otomatis menunjukkan **31.5°C**.
   * Geser slider Suhu ke **31.5°C**, RH **62%**.
   * Klik **"Jalankan Inferensi Fuzzy"** $\rightarrow$ Skor akan bernilai **Tinggi (88 / 100)** (*Kondisi Baik Sekali*).
3. **Uji Kasus Ayam Dewasa (Finisher) pada Suhu yang Sama (31.5°C)**:
   * Geser slider Umur ke **Hari ke-33** (Fase Finisher). Perhatikan target temperatur turun menjadi **22.5°C**.
   * Tetap pasang Suhu di **31.5°C** (Suhu yang sama persis seperti anak ayam tadi!).
   * Klik **"Jalankan Inferensi Fuzzy"** $\rightarrow$ Skor seketika anjlok ke **Rendah (< 30 / 100)** (*Kondisi Kritis / Heat Stress*).
4. **Poin Penjelasan ke Dosen**:
   > *"Bapak/Ibu Penguji, ini membuktikan kebaruan sistem kami: suhu 31.5°C adalah kondisi sangat nyaman bagi anak ayam berumur 5 hari, namun sangat mematikan bagi ayam dewasa umur 33 hari. Sistem aturan statis konvensional tidak mampu membedakan hal ini, sedangkan FIS adaptif kami mampu mendeteksinya secara tepat."*

---

### Skenario 2: Menggunakan Tombol Preset Cepat (1-Click Test)
Di bagian atas Tab **Input**, Anda dapat menekan tombol preset cepat:
* Klik **"✨ Kondisi Ideal"** $\rightarrow$ Menunjukkan kandang normal optimal (Skor 88, Kategori Tinggi).
* Klik **"🔥 Panas (+3°C)"** $\rightarrow$ Menunjukkan ayam mengalami kegerahan dan butuh blower.
* Klik **"❄️ Dingin (-4°C)"** $\rightarrow$ Menunjukkan anak ayam kedinginan dan butuh tirai rapat/pemanas.
* Klik **"🚨 Finisher Kritis"** $\rightarrow$ Menunjukkan kondisi bahaya kematian massal jelang panen.

---

### Skenario 3: Membuktikan Komparasi Mamdani vs Sugeno
1. Buka Tab **Hasil**.
2. Tunjukkan kepada penguji perbandingan dua kartu skor berdampingan:
   * Skor **Mamdani (Centroid)**: 88.0 (Skor linguistik kontinu).
   * Skor **Sugeno (Weighted Average)**: 88.0 (Skor skalar terbobot).
3. Tunjukkan kotak **Benchmark Performa Komputasi**:
   * Latensi Sugeno: **0.0054 ms** (**92.5x lebih cepat** daripada Mamdani 0.4959 ms).
   * Nilai Korelasi Pearson: **r = 0.9987** (Sangat kuat dan hampir identik).
4. Tunjukkan estimasi **Indeks Performa (IP)** panen:
   * Proyeksi nilai IP (misal: 385 - Sangat Bagus), estimasi FCR 1.48, dan mortalitas 1.8%.

---

### Skenario 4: Membuktikan Checklist Solusi & Sistem Peringatan Dini
1. Buka Tab **Solusi**:
   * Tunjukkan bahwa setiap rekomendasi (pengaturan kipas blower nomor 2, bukaan tirai 30%, air minum dingin) memiliki **kotak centang (*checkbox*) interaktif**.
   * Centang salah satu kotak $\rightarrow$ Teks otomatis tercoret dan progress bar penanganan di atas bertambah (*misal: "Progres Penerapan: 2 dari 3 Selesai (67%)"*).
2. Tunjukkan Tab **Riwayat**:
   * Perlihatkan **Grafik Tren Garis (*CustomPainter Canvas*)** yang menggambarkan histori skor kesehatan kandang dari hari ke hari dengan batas garis ambang hijau ($75+$).
   * Ketuk salah satu kartu riwayat untuk memunculkan lembar detail (*Modal BottomSheet*).

---

## 3. Cara Melakukan Build APK Android (Release)

Jika Anda ingin meng-install aplikasi ini langsung ke HP Android peternak atau membawanya ke ruang sidang:

1. Pastikan Android SDK sudah terpasang di komputer Anda.
2. Buka terminal di folder `flutter_app`:
   ```powershell
   cd flutter_app
   flutter build apk --release
   ```
3. File APK siap pakai akan terbentuk di direktori:
   `flutter_app/build/app/outputs/flutter-apk/app-release.apk`
4. Kirimkan file `.apk` tersebut ke HP Android Anda (melalui WhatsApp/kabel data), lalu instal dan jalankan secara mandiri tanpa butuh internet.

