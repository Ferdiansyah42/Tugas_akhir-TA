# Task List 01: Perancangan Model Fuzzy Inference System (FIS)

Dokumen ini memuat daftar tugas untuk merancang, memformulasikan, dan memverifikasi logika fuzzy adaptif umur sesuai Blueprint TA.

---

## 📋 Daftar Tugas Utama

- [ ] **Task 1.1: Ekstraksi Data Suhu Target Pedoman Manajemen Strain Broiler**
  - Mengambil referensi resmi standar manajemen strain broiler komersial (contoh: *Cobb 500 Broiler Management Guide* atau *Ross 308*).
  - Menyusun tabel target temperatur lingkungan kandang harian/mingguan:
    - Hari 1–7 (Starter): ~32–33 °C
    - Hari 8–14 (Starter): ~30–31 °C
    - Hari 15–21 (Grower): ~27–28 °C
    - Hari 22–28 (Grower): ~25–26 °C
    - Hari 29–42 (Finisher): ~21–24 °C
  - Merumuskan fungsi penentu suhu target berdasarkan input umur: $T_{target} = f(Umur)$.

- [ ] **Task 1.2: Perancangan Variabel & Fungsi Keanggotaan (Membership Function)**
  - **Variabel Input 1: Umur Ayam (0–42 Hari)**
    - Semesta pembicaraan: $[0, 42]$ hari.
    - Himpunan Fuzzy:
      - *Starter*: Trapesium / Segitiga [0, 0, 10, 14] hari.
      - *Grower*: Segitiga [12, 21, 28] hari.
      - *Finisher*: Trapesium / Segitiga [26, 35, 42, 42] hari.
  - **Variabel Input 2: Deviasi Suhu (-8 s.d. +8 °C)**
    - Rumus: $\text{Deviasi Suhu} = T_{aktual} - T_{target}$.
    - Semesta pembicaraan: $[-8, +8]$ °C.
    - Himpunan Fuzzy:
      - *Dingin*: Trapesium / Bahu Kiri $[-\infty, -8, -4, 0]$ °C.
      - *Nyaman*: Segitiga $[-2, 0, +2]$ °C.
      - *Panas*: Trapesium / Bahu Kanan $[0, +4, +8, +\infty]$ °C.
  - **Variabel Input 3: Kelembaban Relatif / RH (30–90 %)**
    - Semesta pembicaraan: $[30, 90]$ %.
    - Himpunan Fuzzy:
      - *Rendah*: Trapesium $[30, 30, 45, 55]$ %.
      - *Ideal*: Segitiga $[50, 60, 70]$ %.
      - *Tinggi*: Trapesium $[65, 75, 90, 90]$ %.
  - **Variabel Output: Skor Potensi Performa (0–100)**
    - Semesta pembicaraan: $[0, 100]$.
    - Himpunan Fuzzy (untuk Mamdani):
      - *Rendah*: $[0, 0, 40, 55]$.
      - *Sedang*: $[45, 65, 75]$.
      - *Tinggi*: $[70, 85, 100, 100]$.
    - Nilai Tegas Singleton (untuk Sugeno):
      - *Rendah*: $z_1 = 30$ (atau nilai diskrit yang disepakati pakar).
      - *Sedang*: $z_2 = 65$.
      - *Tinggi*: $z_3 = 90$.

- [ ] **Task 1.3: Formulasi 27 Aturan (Rule Base 3x3x3) & Penyesuaian Kepekaan Fase**
  - Membuat tabel matriks $3 \times 3 \times 3 = 27$ aturan lengkap:
    - `IF (Umur is ...) AND (Deviasi_Suhu is ...) AND (Kelembaban is ...) THEN (Skor is ...)`
  - **Penyesuaian Biologis (Domain Knowledge)**:
    - *Fase Starter*: Ayam muda belum memiliki termoregulasi sempurna (belum berbulu lengkap), sehingga **sangat sensitif terhadap dingin** (chilling). Deviasi dingin pada fase starter menghasilkan skor yang lebih rendah dibandingkan deviasi panas ringan.
    - *Fase Finisher*: Ayam dewasa berbobot besar dan berbulu lebat rentan terhadap *heat stress* (kematian mendadak). Deviasi panas pada fase finisher menghasilkan skor rendah/kritis.
  - Dokumentasikan seluruh 27 aturan dalam matriks formal untuk divalidasi pakar di Bab 3.

- [ ] **Task 1.4: Implementasi Matematika Inferensi Mamdani & Sugeno**
  - **Mamdani**:
    - Operasi fuzzy: Min (AND), Implikasi: Min.
    - Agregasi: Max.
    - Defuzzifikasi: *Centroid of Area* (COA) / *Center of Gravity* (COG):
      $$z^* = \frac{\int z \cdot \mu_C(z) \, dz}{\int \mu_C(z) \, dz}$$
  - **Sugeno (Zero-Order)**:
    - Operasi fuzzy: Min (AND), Konsekuen: nilai skalar konstan $k_i$.
    - Defuzzifikasi: *Weighted Average*:
      $$z^* = \frac{\sum_{i=1}^{27} w_i \cdot z_i}{\sum_{i=1}^{27} w_i}$$

- [ ] **Task 1.5: Prototipe Python (`scikit-fuzzy` & `numpy`)**
  - Membuat skrip Python modular sebagai referensi acuan (*ground truth baseline*).
  - Menguji komputasi 27 aturan pada berbagai titik uji ekstrem dan normal.
  - Mengekspor data hasil uji ke CSV/JSON untuk diverifikasi silang dengan implementasi Dart.

