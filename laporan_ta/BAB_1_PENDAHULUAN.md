# BAB 1: PENDAHULUAN

## 1.1 Latar Belakang
Industri peternakan ayam broiler memegang peranan yang sangat strategis dalam pemenuhan kebutuhan protein hewani masyarakat Indonesia karena siklus produksinya yang singkat (30–42 hari) serta harga daging yang relatif terjangkau. Namun, sebagian besar peternak rakyat di Indonesia masih mengelola kandang dengan metode konvensional (*open house* atau semi-*closed house*) yang sangat rentan terhadap fluktuasi iklim mikro lingkungan, terutama kombinasi antara temperatur (suhu) dan kelembaban relatif (*Relative Humidity* / RH).

Kondisi mikroklimat yang tidak terkendali secara tepat berdampak langsung terhadap laju metabolisme, konsumsi pakan (*feed intake*), laju pertambahan bobot badan harian (*Average Daily Gain* / ADG), dan mortalitas ayam. Tingkat keberhasilan budidaya ayam broiler pada akhir periode panen diukur secara kuantitatif melalui parameter **Indeks Performa** (*Performance Index* / IP). Parameter IP menggabungkan persentase ayam hidup, bobot badan rata-rata, rasio konversi pakan (*Feed Conversion Ratio* / FCR), serta umur panen.

Permasalahan mendasar yang dihadapi peternak rakyat adalah **keterlambatan dalam mendeteksi penurunan potensi performa budidaya**. Sering kali peternak baru menyadari performa ayam memburuk ketika mendekati hari panen, saat angka mortalitas sudah terlanjur melonjak dan rasio konversi pakan membengkak. Hal ini dipicu oleh evaluasi kenyamanan mikroklimat kandang yang selama ini dilakukan secara statis tanpa memperhitungkan faktor umur ayam. Sebagai hewan *homeotermik*, kebutuhan suhu ayam broiler bersifat dinamis: anak ayam umur $1-7$ hari (*starter*) membutuhkan suhu lingkungan hangat sekitar $32-33^\circ\text{C}$ karena sistem termoregulasi tubuh dan bulunya belum terbentuk sempurna, sedangkan ayam dewasa umur $29-42$ hari (*finisher*) membutuhkan suhu sejuk sekitar $21-24^\circ\text{C}$ akibat tingginya produksi panas metabolik tubuh berbulu lebat. Akibatnya, suhu $30^\circ\text{C}$ yang bernilai aman dan nyaman bagi ayam *starter* justru menjadi pemicu stres panas fatal (*heat stress*) bagi ayam *finisher*.

Untuk mengatasi kelemahan tersebut, diperlukan sebuah **Sistem Pendukung Keputusan (SPK)** cerdas yang mampu mengevaluasi kondisi kandang secara harian dengan batas kenyamanan adaptif terhadap umur ayam. Logika Fuzzy (*Fuzzy Inference System* / FIS) merupakan metode *soft computing* yang sangat tepat untuk memodelkan ketidakpastian (*fuzziness*) persepsi kenyamanan termal biologis. Penelitian ini mengembangkan aplikasi berbasis mobile (Android/Flutter) yang berjalan secara **offline** di perangkat peternak, mengimplementasikan batas suhu adaptif terhadap standar strain broiler komersial, memetakan skor inferensi langsung ke potensi Indeks Performa (IP), membandingkan metode inferensi **Mamdani** dan **Sugeno**, serta menyajikan rekomendasi tindakan korektif dan peringatan dini secara preskriptif.

---

## 1.2 Rumusan Masalah
Berdasarkan latar belakang di atas, rumusan masalah dalam penelitian ini adalah:
1. Bagaimana merancang model *Fuzzy Inference System* (FIS) adaptif umur dengan 27 aturan yang mengintegrasikan parameter deviasi suhu terhadap pedoman strain, kelembaban udara, dan umur ayam broiler?
2. Bagaimana perbandingan performa komputasi dan kesesuaian hasil antara metode penalaran fuzzy **Mamdani (Centroid)** dan **Sugeno (Weighted Average)** pada perangkat mobile offline?
3. Bagaimana merancang dan membangun aplikasi *decision support system* (DSS) mobile berbasis Flutter yang menyajikan skor potensi Indeks Performa, panduan tindakan korektif hierarkis, serta sistem deteksi dini (*early warning*) penurunan kondisi kandang?

---

## 1.3 Batasan Masalah
Ruang lingkup dan batasan dalam penelitian ini meliputi:
1. Objek penelitian difokuskan pada pemeliharaan ayam pedaging (broiler) komersial tipe strain *Cobb 500* atau *Ross 308* dengan siklus pemeliharaan normal $0-42$ hari.
2. Parameter input lingkungan kandang dibatasi pada 3 variabel utama: umur ayam (hari), suhu ruangan aktual ($^\circ\text{C}$), dan kelembaban relatif udara ($RH\%$).
3. Mesin inferensi fuzzy dan basis data berjalan secara mandiri (*offline-first*) di dalam perangkat Android pengguna menggunakan basis data lokal SQLite tanpa ketergantungan koneksi internet.
4. Fitur sinkronisasi cloud/server dan integrasi sensor nirkabel otomatis berbasis *Internet of Things* (IoT) diposisikan sebagai saran pengembangan lanjutan (*future works*).

---

## 1.4 Tujuan Penelitian
Tujuan yang hendak dicapai dalam penelitian ini adalah:
1. Merumuskan fungsi keanggotaan dan matriks 27 basis aturan fuzzy adaptif umur berdasarkan standar fisiologis ayam broiler.
2. Membandingkan efisiensi waktu eksekusi (*computational latency*) dan tingkat kesesuaian keluaran skor antara algoritma Mamdani dan Sugeno.
3. Mengembangkan aplikasi Android berbasis Flutter yang mampu beroperasi secara offline untuk membantu peternak mengevaluasi potensi IP, memperoleh peringatan dini, dan menerapkan langkah tindakan korektif secara cepat.

---

## 1.5 Manfaat Penelitian
1. **Bagi Peternak Rakyat**: Memberikan alat bantu praktis di genggaman yang tidak membutuhkan kuota internet untuk mendeteksi ancaman penurunan performa kandang sedini mungkin sehingga kerugian mortalitas dan pembengkakan pakan dapat dicegah.
2. **Bagi Pengembangan Ilmu Pengetahuan**: Memberikan kontribusi akademis mengenai penerapan *soft computing* logika fuzzy adaptif umur dalam domain peternakan presisi (*precision poultry farming*).
