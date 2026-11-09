# BAB 2: TINJAUAN PUSTAKA

## 2.1 Manajemen Mikroklimat Ayam Broiler
Ayam broiler merupakan salah satu ternak dengan laju metabolisme tertinggi di dunia peternakan. Lingkungan mikroklimat kandang, khususnya temperatur dan kelembaban udara, memegang peranan krusial terhadap homeostasis tubuh ayam.

### 2.1.1 Zona Termonetral per Fase Umur
Zona termonetral (*thermoneutral zone*) adalah rentang suhu lingkungan di mana ternak tidak perlu mengeluarkan energi metabolisme tambahan untuk mempertahankan suhu tubuh normal ($40.5 - 41.5^\circ\text{C}$). Kebutuhan termal ayam broiler terbagi menjadi 3 fase utama:
1. **Fase Starter / Brooding (Umur 0–14 Hari)**:
   Pada umur $1-7$ hari, anak ayam belum mampu mengontrol suhu tubuhnya sendiri karena mekanisme termoregulasi belum matang dan lapisan bulu penutup tubuh masih berupa bulu jarum halus (*down feathers*). Suhu kandang awal wajib dijaga pada rentang $32.0 - 33.5^\circ\text{C}$. Paparan suhu dingin (*chilling*) pada fase ini menyebabkan kantung kuning telur tidak terserap optimal, gangguan omphalitis, asites, serta gangguan pertumbuhan permanen.
2. **Fase Grower (Umur 15–28 Hari)**:
   Ayam mengalami pertumbuhan otot dan rangka yang sangat pesat. Bulu primer mulai menutupi sebagian besar tubuh. Suhu lingkungan diturunkan bertahap dari $27.0^\circ\text{C}$ hingga $24.5^\circ\text{C}$ dengan kelembaban optimal $60 - 70\%$.
3. **Fase Finisher (Umur 29–42 Hari)**:
   Ayam dewasa berbobot besar ($> 1.8\text{ kg}$) dengan kepadatan biomassa tinggi di lantai kandang menghasilkan panas tubuh endogen yang luar biasa besar. Ayam tidak memiliki kelenjar keringat (*sweat glands*), sehingga pelepasan panas tubuh hanya mengandalkan radiasi, konveksi, dan penguapan laten melalui pernapasan cepat terengah-engah (*panting*). Suhu lingkungan wajib dijaga sejuk pada kisaran $20.0 - 22.5^\circ\text{C}$. Jika suhu melebihi $26^\circ\text{C}$ dengan kelembaban tinggi ($> 75\%$), ayam akan mengalami stres panas berat (*heat stress*) yang memicu serangan jantung mendadak (*heat prostration / sudden death syndrome*).

---

## 2.2 Indeks Performa (IP) Broiler
Indeks Performa (IP) atau *Performance Index* (PI) merupakan indikator standar internasional yang digunakan oleh perusahaan integrator maupun peternak mandiri untuk mengukur efisiensi produksi dan keberhasilan finansial pemeliharaan satu siklus ayam broiler.

Formula matematis perhitungan Indeks Performa (IP) adalah:
$$\text{IP} = \frac{(100 - M) \times B}{\text{FCR} \times U} \times 100$$

Di mana:
* $M$ = Tingkat mortalitas / kematian ayam ($\%$).
* $B$ = Bobot badan rata-rata ayam saat panen ($\text{kg}$).
* $\text{FCR}$ = *Feed Conversion Ratio* (Total konsumsi pakan dibagi total bobot panen).
* $U$ = Rata-rata umur panen (hari).

### Klasifikasi Standar Nilai IP di Industri:
* $\text{IP} > 400$ : Kategori **Istimewa / Sangat Memuaskan**
* $350 \le \text{IP} \le 400$ : Kategori **Baik Sekali**
* $300 \le \text{IP} < 350$ : Kategori **Cukup / Standar**
* $\text{IP} < 300$ : Kategori **Kurang / Berisiko Rugi**

---

## 2.3 Konsep Logika Fuzzy (Fuzzy Inference System)
Logika Fuzzy pertama kali diperkenalkan oleh Prof. Lotfi A. Zadeh pada tahun 1965 untuk mengatasi keterbatasan logika tegas (*Boolean/Crisp Logic*) yang hanya mengenal nilai biner 0 (salah) atau 1 (benar). Dalam logika fuzzy, derajat keanggotaan suatu elemen dalam suatu himpunan bernilai kontinu dalam interval tertutup $[0, 1]$.

### 2.3.1 Metode Penalaran Mamdani
Metode Mamdani (*Max-Min Inference*) sering disebut metode intuitif yang paling dekat dengan penalaran bahasa manusia. Tahapannya meliputi:
1. **Fuzzifikasi**: Mentransformasikan input tegas (umur, deviasi suhu, RH) ke dalam derajat keanggotaan menggunakan kurva keanggotaan (segitiga dan trapesium).
2. **Evaluasi Aturan**: Menggunakan operasi logika fuzzy konjungsi $\text{AND} = \min(\mu_A, \mu_B, \mu_C)$.
3. **Agregasi**: Menggabungkan luaran seluruh aturan yang aktif menggunakan operasi $\text{Max}$.
4. **Defuzzifikasi Centroid**: Menghitung titik pusat gravitasi (*Center of Gravity* / COG) dari area agregasi kontinu:
   $$z^* = \frac{\int z \cdot \mu_C(z) \, dz}{\int \mu_C(z) \, dz}$$

### 2.3.2 Metode Penalaran Sugeno (TSK)
Metode Sugeno (*Takagi-Sugeno-Kang*) menggunakan konsekuen berupa fungsi linier atau konstanta tegas (*singleton*). Pada Sugeno orde-nol (*zero-order*):
$$\text{IF } x_1 \text{ is } A_1 \text{ AND } x_2 \text{ is } A_2 \dots \text{ THEN } z = k$$
Defuzzifikasi dilakukan dengan rata-rata berbobot (*Weighted Average*):
$$z^* = \frac{\sum_{i=1}^{n} w_i \cdot z_i}{\sum_{i=1}^{n} w_i}$$
Keunggulan utama metode Sugeno adalah efisiensi komputasinya yang jauh lebih cepat dan ringan saat dioperasikan pada arsitektur perangkat seluler berdaya rendah (*embedded/edge devices*).

---

## 2.4 Penelitian Terdahulu dan Posisi Kebaruan (Research Gap)

| Peneliti & Tahun | Metode yang Digunakan | Variabel Input | Keterbatasan / Gap | Posisi Kebaruan Penelitian Ini |
| :--- | :--- | :--- | :--- | :--- |
| **Pratama dkk. (2021)** | Fuzzy Mamdani Web | Suhu & Kelembaban | Batas suhu statis ($24-28^\circ\text{C}$); mengabaikan umur ayam. | Menggunakan variabel **deviasi suhu adaptif terhadap kurva umur** ($T_{\text{aktual}} - T_{\text{target}}$). |
| **Suryanto & Hidayat (2022)** | Fuzzy Tsukamoto Desktop | Suhu, RH, Amonia | Sistem berjalan di PC desktop; tidak ada estimasi IP panen. | Berjalan secara **offline-first di Android**, terhubung langsung dengan prediksi Indeks Performa. |
| **Rahmawati (2023)** | Rule-Based Expert System | Gejala klinis ayam | Bersifat kuratif setelah ayam sakit, tidak memantau mikroklimat harian. | Bersifat **preventif harian** dengan sistem peringatan dini (*early warning* tren 3 hari). |
| **Kurniawan dkk. (2024)** | Fuzzy Mamdani Android | Suhu & Kelembaban | Hanya menggunakan satu algoritma; tidak membandingkan efisiensi runtime. | Melakukan **komparasi komputasi empiris Mamdani vs Sugeno** (latensi dan MAE). |
| **Penelitian Ini (2026)** | **Adaptive FIS (Mamdani & Sugeno)** | **Umur (0–42 hr), Deviasi Suhu, Kelembaban** | - | **Aplikasi Flutter offline, 27 aturan adaptif biologis, rekomendasi tindakan hierarkis, komparasi performa.** |

