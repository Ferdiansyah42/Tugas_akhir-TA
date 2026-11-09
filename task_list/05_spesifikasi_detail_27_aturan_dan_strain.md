# Spesifikasi Teknis: Formulasi 27 Aturan Fuzzy & Kurva Suhu Adaptif Strain

Dokumen ini merupakan landasan perancangan model matematis dan logika inferensi sebelum masuk ke tahap pemrograman. Disusun berdasarkan pedoman manajemen budidaya ayam broiler komersial (*Cobb 500 / Ross 308 Broiler Management Guide*) dan kaidah *Fuzzy Inference System* (FIS).

---

## 1. Standar Acuan Suhu Target Adaptif Umur ($T_{\text{target}}$)

Ayam broiler adalah hewan *homeotermik* yang pada fase awal kehidupannya belum memiliki sistem termoregulasi sempurna. Oleh karena itu, suhu lingkungan kandang harus diturunkan secara bertahap seiring pertambahan umur dan pertumbuhan bulu penutup tubuh.

### Tabel Standar Suhu Target Harian (Acuan: Cobb 500 & Ross 308)

| Fase Hidup | Umur (Hari) | Suhu Target Ideal ($T_{\text{target}}$) | Toleransi Nyaman | Keterangan Fisiologis |
| :--- | :---: | :---: | :---: | :--- |
| **Starter (Brooding)** | $1 - 3$ | $33.0^\circ\text{C}$ | $32.0 - 34.0^\circ\text{C}$ | DOC membutuhkan pemanas buatan (*brooder*), penyerapan kuning telur. |
| **Starter (Brooding)** | $4 - 7$ | $31.5^\circ\text{C}$ | $30.5 - 32.5^\circ\text{C}$ | Mulai adaptasi pakan dan air, bulu jarum mulai tumbuh. |
| **Starter** | $8 - 14$ | $29.0^\circ\text{C}$ | $28.0 - 30.0^\circ\text{C}$ | Masa transisi brooding akhir, pemanas mulai dikurangi bertahap. |
| **Grower** | $15 - 21$ | $26.5^\circ\text{C}$ | $25.5 - 27.5^\circ\text{C}$ | Pertumbuhan pesat kerangka & massa otot, bulu primer tumbuh. |
| **Grower** | $22 - 28$ | $24.5^\circ\text{C}$ | $23.5 - 25.5^\circ\text{C}$ | Metabolisme meningkat tajam, mulai memproduksi panas tubuh sendiri. |
| **Finisher** | $29 - 35$ | $22.5^\circ\text{C}$ | $21.5 - 23.5^\circ\text{C}$ | Bobot mencapai 1.5–2.0 kg, rawan *heat stress*. Butuh aliran udara (*wind chill*). |
| **Finisher** | $36 - 42$ | $21.0^\circ\text{C}$ | $20.0 - 22.0^\circ\text{C}$ | Menjelang panen, bobot maksimal, ruang gerak padat, metabolisme tinggi. |

### Formulasi Variabel Deviasi Suhu ($\Delta T$)

$$\Delta T = T_{\text{aktual}} - T_{\text{target}}(Umur)$$

* Jika $\Delta T < -2.0^\circ\text{C} \rightarrow$ Terkategori **Dingin** (kondisi *underheating*).
* Jika $-2.0^\circ\text{C} \le \Delta T \le +2.0^\circ\text{C} \rightarrow$ Terkategori **Nyaman** (zona *thermoneutral*).
* Jika $\Delta T > +2.0^\circ\text{C} \rightarrow$ Terkategori **Panas** (kondisi *overheating*).

---

## 2. Definisi Matematis Fungsi Keanggotaan ($\mu$)

### A. Input 1: Umur Ayam (0–42 Hari)
* **Starter** (Trapesium Kiri):
  $$\mu_{\text{Starter}}(u) = \begin{cases} 1, & 0 \le u \le 10 \\ \frac{14 - u}{14 - 10}, & 10 < u < 14 \\ 0, & u \ge 14 \end{cases}$$
* **Grower** (Segitiga):
  $$\mu_{\text{Grower}}(u) = \begin{cases} 0, & u \le 10 \text{ atau } u \ge 30 \\ \frac{u - 10}{20 - 10}, & 10 < u \le 20 \\ \frac{30 - u}{30 - 20}, & 20 < u < 30 \end{cases}$$
* **Finisher** (Trapesium Kanan):
  $$\mu_{\text{Finisher}}(u) = \begin{cases} 0, & u \le 26 \\ \frac{u - 26}{30 - 26}, & 26 < u < 30 \\ 1, & 30 \le u \le 42 \end{cases}$$

### B. Input 2: Deviasi Suhu / $\Delta T$ ($-8 \text{ s.d. } +8^\circ\text{C}$)
* **Dingin** (Trapesium Kiri):
  $$\mu_{\text{Dingin}}(\Delta T) = \begin{cases} 1, & \Delta T \le -4 \\ \frac{0 - \Delta T}{0 - (-4)}, & -4 < \Delta T < 0 \\ 0, & \Delta T \ge 0 \end{cases}$$
* **Nyaman** (Segitiga):
  $$\mu_{\text{Nyaman}}(\Delta T) = \begin{cases} 0, & \Delta T \le -2.5 \text{ atau } \Delta T \ge 2.5 \\ \frac{\Delta T - (-2.5)}{0 - (-2.5)}, & -2.5 < \Delta T \le 0 \\ \frac{2.5 - \Delta T}{2.5 - 0}, & 0 < \Delta T < 2.5 \end{cases}$$
* **Panas** (Trapesium Kanan):
  $$\mu_{\text{Panas}}(\Delta T) = \begin{cases} 0, & \Delta T \le 0 \\ \frac{\Delta T - 0}{4 - 0}, & 0 < \Delta T < 4 \\ 1, & \Delta T \ge 4 \end{cases}$$

### C. Input 3: Kelembaban Relatif / RH ($30 - 90\%$)
* **Rendah** (Trapesium Kiri):
  $$\mu_{\text{Rendah}}(h) = \begin{cases} 1, & h \le 45 \\ \frac{55 - h}{55 - 45}, & 45 < h < 55 \\ 0, & h \ge 55 \end{cases}$$
* **Ideal** (Segitiga):
  $$\mu_{\text{Ideal}}(h) = \begin{cases} 0, & h \le 50 \text{ atau } h \ge 75 \\ \frac{h - 50}{62.5 - 50}, & 50 < h \le 62.5 \\ \frac{75 - h}{75 - 62.5}, & 62.5 < h < 75 \end{cases}$$
* **Tinggi** (Trapesium Kanan):
  $$\mu_{\text{Tinggi}}(h) = \begin{cases} 0, & h \le 70 \\ \frac{h - 70}{80 - 70}, & 70 < h < 80 \\ 1, & h \ge 80 \end{cases}$$

### D. Output: Skor Potensi Performa ($0 - 100$)
* **Rendah** (Trapesium Kiri): $[0, 0, 35, 50]$
* **Sedang** (Segitiga): $[40, 65, 80]$
* **Tinggi** (Trapesium Kanan): $[75, 85, 100, 100]$
* *Untuk Sugeno (Zero-Order Singleton)*:
  * $z_{\text{Rendah}} = 30$
  * $z_{\text{Sedang}} = 65$
  * $z_{\text{Tinggi}} = 90$

---

## 3. Matriks Lengkap 27 Aturan If-Then ($3 \times 3 \times 3$)

### Kluster 1: Fase Starter (Umur $0 - 14$ Hari)
*Karakteristik Biologis*: Sangat rentan kedinginan (*chilling*). Suhu dingin menyebabkan kematian dini dan FCR rusak permanen. Panas moderat lebih ditoleransi daripada kedinginan.

| No | Aturan | Input: Deviasi Suhu | Input: Kelembaban | Output Skor | Alasan / Justifikasi Biologis |
| :-: | :--- | :---: | :---: | :---: | :--- |
| **R01** | IF Umur Starter AND Suhu Dingin AND RH Rendah | Dingin | Rendah | **Rendah** | Kedinginan + udara kering memicu dehidrasi DOC dan penurunan nafsu makan. |
| **R02** | IF Umur Starter AND Suhu Dingin AND RH Ideal | Dingin | Ideal | **Rendah** | Kedinginan pada fase brooding menghambat penyerapan kantung kuning telur. |
| **R03** | IF Umur Starter AND Suhu Dingin AND RH Tinggi | Dingin | Tinggi | **Rendah** | *Fatal*: Kombinasi dingin dan basah menyebabkan pneumonia dan mortalitas tinggi. |
| **R04** | IF Umur Starter AND Suhu Nyaman AND RH Rendah | Nyaman | Rendah | **Sedang** | Suhu pas, namun sekam kering berdebu memicu iritasi saluran pernapasan atas. |
| **R05** | IF Umur Starter AND Suhu Nyaman AND RH Ideal | Nyaman | Ideal | **Tinggi** | **Kondisi Optimal Brooding**: Pertumbuhan bobot maksimal, FCR sangat baik. |
| **R06** | IF Umur Starter AND Suhu Nyaman AND RH Tinggi | Nyaman | Tinggi | **Sedang** | Suhu baik, namun kelembaban tinggi membuat sekam mudah basah (*caked litter*). |
| **R07** | IF Umur Starter AND Suhu Panas AND RH Rendah | Panas | Rendah | **Sedang** | Anak ayam masih mampu melakukan pendinginan evaporasi melalui *panting*. |
| **R08** | IF Umur Starter AND Suhu Panas AND RH Ideal | Panas | Ideal | **Sedang** | Ayam aktif *panting*, konsumsi air minum naik, pakan sedikit berkurang. |
| **R09** | IF Umur Starter AND Suhu Panas AND RH Tinggi | Panas | Tinggi | **Rendah** | Udara pengap dan lembab menghambat pelepasan panas tubuh DOC. |

---

### Kluster 2: Fase Grower (Umur $15 - 28$ Hari)
*Karakteristik Biologis*: Masa transisi pertumbuhan pesat. Bulu primer tumbuh, metabolisme meningkat. Membutuhkan keseimbangan antara ventilasi dan suhu.

| No | Aturan | Input: Deviasi Suhu | Input: Kelembaban | Output Skor | Alasan / Justifikasi Biologis |
| :-: | :--- | :---: | :---: | :---: | :--- |
| **R10** | IF Umur Grower AND Suhu Dingin AND RH Rendah | Dingin | Rendah | **Sedang** | Energi pakan sebagian terpakai untuk menghangatkan tubuh, debu meningkat. |
| **R11** | IF Umur Grower AND Suhu Dingin AND RH Ideal | Dingin | Ideal | **Sedang** | Konsumsi pakan meningkat tetapi konversi menjadi bobot daging sedikit terganggu. |
| **R12** | IF Umur Grower AND Suhu Dingin AND RH Tinggi | Dingin | Tinggi | **Rendah** | Kelembaban tinggi + dingin memicu perkembangan koksidiosis dan bakteri amonia. |
| **R13** | IF Umur Grower AND Suhu Nyaman AND RH Rendah | Nyaman | Rendah | **Sedang** | Suhu optimal, namun butuh pelembaban udara untuk menekan debu sekam. |
| **R14** | IF Umur Grower AND Suhu Nyaman AND RH Ideal | Nyaman | Ideal | **Tinggi** | **Kondisi Optimal Grower**: Pertumbuhan otot dan pertambahan bobot harian (ADG) prima. |
| **R15** | IF Umur Grower AND Suhu Nyaman AND RH Tinggi | Nyaman | Tinggi | **Sedang** | Suhu nyaman, tetapi ventilasi perlu ditambah untuk membuang kelembaban. |
| **R16** | IF Umur Grower AND Suhu Panas AND RH Rendah | Panas | Rendah | **Sedang** | Ayam mulai terengah-engah (*panting*), pakan sedikit turun namun air minum cukup. |
| **R17** | IF Umur Grower AND Suhu Panas AND RH Ideal | Panas | Ideal | **Rendah** | Peningkatan *heat stress*, konsumsi pakan turun nyata, pertumbuhan terhambat. |
| **R18** | IF Umur Grower AND Suhu Panas AND RH Tinggi | Panas | Tinggi | **Rendah** | Stres panas akut, evaporasi terganggu karena udara jenuh uap air. |

---

### Kluster 3: Fase Finisher (Umur $29 - 42$ Hari)
*Karakteristik Biologis*: Bobot badan besar ($> 1.8 - 2.5\text{ kg}$), bulu sangat lebat, metabolisme endogen tinggi. **Sangat rentan terhadap stres panas (*heat stress*)**. Panas dan lembab tinggi dapat menimbulkan kematian mendadak (*sudden death syndrome*). Sebaliknya, ayam dewasa jauh lebih toleran terhadap suhu sejuk/dingin.

| No | Aturan | Input: Deviasi Suhu | Input: Kelembaban | Output Skor | Alasan / Justifikasi Biologis |
| :-: | :--- | :---: | :---: | :---: | :--- |
| **R19** | IF Umur Finisher AND Suhu Dingin AND RH Rendah | Dingin | Rendah | **Sedang** | Ayam dewasa tahan sejuk, namun debu tinggi dapat mengiritasi saluran nafas. |
| **R20** | IF Umur Finisher AND Suhu Dingin AND RH Ideal | Dingin | Ideal | **Sedang** | Nafsu makan tinggi, metabolisme optimal; konversi daging cukup terjaga. |
| **R21** | IF Umur Finisher AND Suhu Dingin AND RH Tinggi | Dingin | Tinggi | **Rendah** | Sekam padat lembab (*wet litter*) memicu amonia tinggi dan luka dada (*breast blister*). |
| **R22** | IF Umur Finisher AND Suhu Nyaman AND RH Rendah | Nyaman | Rendah | **Sedang** | Suhu nyaman, tetapi lingkungan kering memicu kanibalisme dan debu bulu. |
| **R23** | IF Umur Finisher AND Suhu Nyaman AND RH Ideal | Nyaman | Ideal | **Tinggi** | **Kondisi Optimal Finisher**: Puncak pertambahan bobot akhir, mortalitas minimal, IP tinggi. |
| **R24** | IF Umur Finisher AND Suhu Nyaman AND RH Tinggi | Nyaman | Tinggi | **Sedang** | Ayam dewasa mulai kesulitan membuang panas laten jika kelembaban mendekati jenuh. |
| **R25** | IF Umur Finisher AND Suhu Panas AND RH Rendah | Panas | Rendah | **Rendah** | Ayam dewasa mengalami stres panas berat, pakan drop drastis, FCR memburuk tajam. |
| **R26** | IF Umur Finisher AND Suhu Panas AND RH Ideal | Panas | Ideal | **Rendah** | Risiko kematian mendadak (*heat prostration*) sangat tinggi pada ayam besar. |
| **R27** | IF Umur Finisher AND Suhu Panas AND RH Tinggi | Panas | Tinggi | **Rendah** | **Kondisi Kritis / Bahaya Ekstrem**: Tingkat kematian massal tinggi dalam hitungan jam. |

---

## 4. Format Rancangan Data Skenario Uji (Instrumen Validasi Pakar)

Untuk keperluan pengujian Bab 4 dan validasi oleh 2–3 pakar peternakan, disiapkan dataset skenario kasus uji yang terbagi ke dalam 3 kelompok:
1. **Kasus Kondisi Ideal (Benchmark Positif)**: Berada tepat di tengah zona nyaman masing-masing umur dan RH ideal $\rightarrow$ Memastikan sistem konsisten menghasilkan skor kategori **Tinggi** ($> 80$).
2. **Kasus Deviasi Ekstrem (Benchmark Negatif)**:
   - Kasus Starter Kedinginan Ekstrem ($\Delta T = -6^\circ\text{C}, RH = 85\%$).
   - Kasus Finisher Kepanasan Ekstrem ($\Delta T = +6^\circ\text{C}, RH = 85\%$).
   - $\rightarrow$ Memastikan sistem mendeteksi kondisi kritis dan menghasilkan kategori **Rendah** ($< 40$).
3. **Kasus Ambigu / Perbatasan (Boundary Testing)**:
   - Kasus di sekitar batas transisi umur (hari ke-13 s.d. 15, hari ke-27 s.d. 29).
   - Kasus di batas deviasi suhu ($\pm 2.0^\circ\text{C}$) dan kelembaban ($55\%$ dan $75\%$).
   - $\rightarrow$ Membuktikan keunggulan logika fuzzy dalam menghasilkan transisi nilai yang kontinu (*smooth transition*), tidak kaku seperti sistem aturan tegas (*crisp if-else*).
