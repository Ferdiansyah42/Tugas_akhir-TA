# BAB 5: KESIMPULAN DAN SARAN

## 5.1 Kesimpulan
Berdasarkan perancangan, implementasi, dan pengujian yang telah dilakukan pada sistem pendukung keputusan *Fuzzy Inference System* (FIS) adaptif umur untuk evaluasi potensi Indeks Performa ayam broiler, diperoleh kesimpulan sebagai berikut:

1. **Efektivitas Model Fuzzy Adaptif Umur**:
   Model FIS berhasil dirancang menggunakan 3 variabel masukan (umur ayam, deviasi suhu, dan kelembaban udara) dengan 27 basis aturan If-Then yang mengakomodasi karakteristik biologis ayam broiler. Penerapan variabel **deviasi suhu terhadap kurva target umur strain** ($\Delta T = T_{\text{aktual}} - T_{\text{target}}(Umur)$) terbukti mampu mengatasi bias kenyamanan termal konvensional, di mana sistem dapat membedakan kebutuhan termal secara dinamis antara fase *starter* (yang peka terhadap suhu dingin) dan fase *finisher* (yang peka terhadap stres panas).

2. **Perbandingan Kinerja Mamdani dan Sugeno**:
   * Dari segi **kecepatan komputasi**, metode **Sugeno Orde-Nol** terbukti jauh lebih efisien dengan rata-rata waktu inferensi sebesar **$0.0054\text{ ms}$**, atau sekitar **92.5 kali lebih cepat** dibandingkan metode Mamdani ($0.4959\text{ ms}$).
   * Dari segi **keselarasan luaran skor**, metode Sugeno memiliki tingkat korelasi linier yang sangat kuat terhadap Mamdani dengan koefisien korelasi Pearson **$r = 0.9987$**, nilai *Mean Absolute Error* (MAE) sebesar **$3.88\text{ poin}$**, dan tingkat kesesuaian kategori klasifikasi mencapai **$98.0\%$** (49 dari 50 skenario uji).
   * Pada platform mobile Android, kedua metode berjalan sangat cepat di bawah batas ambang respons interaktif ($< 1\text{ ms}$). Mamdani memberikan transparansi intuitif dalam penalaran linguistik, sedangkan Sugeno sangat direkomendasikan untuk implementasi masa depan pada mikrokontroler berdaya rendah.

3. **Kinerja dan Fungsionalitas Aplikasi Flutter Offline**:
   Aplikasi mobile berbasis Flutter berhasil beroperasi secara penuh **100% offline** di perangkat Android tanpa ketergantungan koneksi internet. Seluruh fungsionalitas utama—termasuk deteksi otomatis fase pemeliharaan, kalkulasi skor potensi performa (0–100), panduan langkah tindakan korektif hierarkis (kipas blower, tirai, air minum), serta sistem peringatan dini (*early warning banner*) saat skor menurun 3 hari beruntun—lulus pengujian fungsionalitas *black-box testing* dengan status valid.

---

## 5.2 Saran
Untuk pengembangan sistem lebih lanjut pada masa yang akan datang, beberapa saran yang dapat dipertimbangkan meliputi:

1. **Integrasi Sensor Nirkabel Berbasis Internet of Things (IoT)**:
   Mengintegrasikan modul sensor mikroklimat digital (seperti sensor temperatur dan kelembaban SHT31 atau DHT22) yang terhubung dengan mikrokontroler ESP32/ESP8266 secara otomatis via Bluetooth Low Energy (BLE) atau Wi-Fi lokal, sehingga peternak tidak perlu lagi menginput data suhu dan kelembaban secara manual.

2. **Penerapan Algoritma Pembelajaran Adaptif (ANFIS)**:
   Mengembangkan model penalaran fuzzy menjadi *Adaptive Neuro-Fuzzy Inference System* (ANFIS) atau mengoptimalkan fungsi keanggotaan menggunakan algoritma genetika (*Genetic Algorithm* / GA) apabila dataset riil histori panen multi-siklus dari beberapa mitra kandang telah terkumpul dalam jumlah besar.

3. **Fitur Sinkronisasi Cloud Multi-Kandang (Opsional)**:
   Menambahkan layanan sinkronisasi data cloud latar belakang (*background cloud sync*) yang otomatis mencadangkan riwayat evaluasi lokal ke server pusat ketika perangkat pengguna mendeteksi adanya jaringan internet, serta menyediakan fitur pemantauan terpusat (*web dashboard monitor*) bagi pemilik peternakan yang memiliki lebih dari satu blok kandang.

