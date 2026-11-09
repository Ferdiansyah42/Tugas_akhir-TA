# LAMPIRAN-LAMPIRAN

---

## LAMPIRAN 1: MATRIKS LENGKAP 27 ATURAN INFERENSI FUZZY ADAPTIF UMUR

Matriks 27 aturan dirancang secara biologis dengan mempertimbangkan perbedaan kerentanan fisiologis ayam broiler pada fase Starter (sangat rentan *chilling* / dingin), Grower, dan Finisher (sangat rentan *heat stress* / kepanasan):

| No | Fase Umur | Kondisi Deviasi Suhu ($\Delta T$) | Kondisi Kelembaban (RH) | Konsekuen Linguistik | Output Sugeno ($z$) |
| :-: | :--- | :---: | :---: | :---: | :---: |
| **R01** | Starter (0–14 hr) | Dingin ($\Delta T \le -1.5^\circ\text{C}$) | Kering ($< 55\%$) | **Rendah** | 30 |
| **R02** | Starter (0–14 hr) | Dingin ($\Delta T \le -1.5^\circ\text{C}$) | Nyaman ($55–75\%$) | **Rendah** | 30 |
| **R03** | Starter (0–14 hr) | Dingin ($\Delta T \le -1.5^\circ\text{C}$) | Lembab ($> 75\%$) | **Rendah** | 30 |
| **R04** | Starter (0–14 hr) | Nyaman ($\pm 1.5^\circ\text{C}$) | Kering ($< 55\%$) | **Sedang** | 65 |
| **R05** | Starter (0–14 hr) | Nyaman ($\pm 1.5^\circ\text{C}$) | Nyaman ($55–75\%$) | **Tinggi** | 88 |
| **R06** | Starter (0–14 hr) | Nyaman ($\pm 1.5^\circ\text{C}$) | Lembab ($> 75\%$) | **Sedang** | 65 |
| **R07** | Starter (0–14 hr) | Panas ($\Delta T \ge +1.5^\circ\text{C}$) | Kering ($< 55\%$) | **Sedang** | 65 |
| **R08** | Starter (0–14 hr) | Panas ($\Delta T \ge +1.5^\circ\text{C}$) | Nyaman ($55–75\%$) | **Sedang** | 65 |
| **R09** | Starter (0–14 hr) | Panas ($\Delta T \ge +1.5^\circ\text{C}$) | Lembab ($> 75\%$) | **Rendah** | 30 |
| **R10** | Grower (15–28 hr) | Dingin ($\Delta T \le -1.5^\circ\text{C}$) | Kering ($< 55\%$) | **Rendah** | 30 |
| **R11** | Grower (15–28 hr) | Dingin ($\Delta T \le -1.5^\circ\text{C}$) | Nyaman ($55–75\%$) | **Sedang** | 65 |
| **R12** | Grower (15–28 hr) | Dingin ($\Delta T \le -1.5^\circ\text{C}$) | Lembab ($> 75\%$) | **Rendah** | 30 |
| **R13** | Grower (15–28 hr) | Nyaman ($\pm 1.5^\circ\text{C}$) | Kering ($< 55\%$) | **Sedang** | 65 |
| **R14** | Grower (15–28 hr) | Nyaman ($\pm 1.5^\circ\text{C}$) | Nyaman ($55–75\%$) | **Tinggi** | 88 |
| **R15** | Grower (15–28 hr) | Nyaman ($\pm 1.5^\circ\text{C}$) | Lembab ($> 75\%$) | **Sedang** | 65 |
| **R16** | Grower (15–28 hr) | Panas ($\Delta T \ge +1.5^\circ\text{C}$) | Kering ($< 55\%$) | **Sedang** | 65 |
| **R17** | Grower (15–28 hr) | Panas ($\Delta T \ge +1.5^\circ\text{C}$) | Nyaman ($55–75\%$) | **Sedang** | 65 |
| **R18** | Grower (15–28 hr) | Panas ($\Delta T \ge +1.5^\circ\text{C}$) | Lembab ($> 75\%$) | **Rendah** | 30 |
| **R19** | Finisher (29–42 hr) | Dingin ($\Delta T \le -1.5^\circ\text{C}$) | Kering ($< 55\%$) | **Sedang** | 65 |
| **R20** | Finisher (29–42 hr) | Dingin ($\Delta T \le -1.5^\circ\text{C}$) | Nyaman ($55–75\%$) | **Sedang** | 65 |
| **R21** | Finisher (29–42 hr) | Dingin ($\Delta T \le -1.5^\circ\text{C}$) | Lembab ($> 75\%$) | **Rendah** | 30 |
| **R22** | Finisher (29–42 hr) | Nyaman ($\pm 1.5^\circ\text{C}$) | Kering ($< 55\%$) | **Sedang** | 65 |
| **R23** | Finisher (29–42 hr) | Nyaman ($\pm 1.5^\circ\text{C}$) | Nyaman ($55–75\%$) | **Tinggi** | 88 |
| **R24** | Finisher (29–42 hr) | Nyaman ($\pm 1.5^\circ\text{C}$) | Lembab ($> 75\%$) | **Sedang** | 65 |
| **R25** | Finisher (29–42 hr) | Panas ($\Delta T \ge +1.5^\circ\text{C}$) | Kering ($< 55\%$) | **Rendah** | 30 |
| **R26** | Finisher (29–42 hr) | Panas ($\Delta T \ge +1.5^\circ\text{C}$) | Nyaman ($55–75\%$) | **Rendah** | 30 |
| **R27** | Finisher (29–42 hr) | Panas ($\Delta T \ge +1.5^\circ\text{C}$) | Lembab ($> 75\%$) | **Rendah** | 30 |

---

## LAMPIRAN 2: TABEL SAMPLE 10 DARI 50 SKENARIO UJI EMPIRIS (MAMDANI VS SUGENO)

| ID | Umur (hr) | Suhu Aktual ($^\circ\text{C}$) | Suhu Target ($^\circ\text{C}$) | $\Delta T$ ($^\circ\text{C}$) | RH ($\%$) | Skor Mamdani | Skor Sugeno | Selisih ($\|\Delta\|$) | Kategori |
| :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| **S01** | 3 | 32.5 | 32.5 | 0.00 | 65.0 | 85.50 | 88.00 | 2.50 | **Tinggi** |
| **S02** | 5 | 26.0 | 31.5 | -5.50 | 70.0 | 25.10 | 30.00 | 4.90 | **Rendah** |
| **S03** | 7 | 35.0 | 30.5 | +4.50 | 82.0 | 31.20 | 30.00 | 1.20 | **Rendah** |
| **S04** | 12 | 28.5 | 28.5 | 0.00 | 50.0 | 66.80 | 65.00 | 1.80 | **Sedang** |
| **S05** | 21 | 27.0 | 27.0 | 0.00 | 62.0 | 86.20 | 88.00 | 1.80 | **Tinggi** |
| **S06** | 25 | 21.0 | 24.5 | -3.50 | 60.0 | 62.50 | 65.00 | 2.50 | **Sedang** |
| **S07** | 28 | 31.0 | 23.5 | +7.50 | 85.0 | 28.40 | 30.00 | 1.60 | **Rendah** |
| **S08** | 35 | 22.0 | 22.0 | 0.00 | 68.0 | 85.00 | 88.00 | 3.00 | **Tinggi** |
| **S09** | 38 | 29.5 | 21.5 | +8.00 | 78.0 | 24.50 | 30.00 | 5.50 | **Rendah** |
| **S10** | 42 | 21.0 | 21.0 | 0.00 | 65.0 | 85.90 | 88.00 | 2.10 | **Tinggi** |

*(Seluruh 50 skenario lengkap tersimpan dalam berkas data `data_skenario_uji_50.json` dan `data_skenario_uji_50.csv`)*

---

## LAMPIRAN 3: INSTRUMEN VALIDASI PAKAR PETERNAKAN
* Format instrumen validasi pakar memuat 30 butir skenario acak dengan skala persetujuan kesesuaian biologis dan kolom saran pakar (Tersedia lengkap di file [`task_list/06_instrumen_kuesioner_validasi_pakar.md`](file:///c:/TA-saya/task_list/06_instrumen_kuesioner_validasi_pakar.md)).

---

## LAMPIRAN 4: INSTRUMEN SYSTEM USABILITY SCALE (SUS)
* Format kuesioner 10 butir pertanyaan terstandarisasi John Brooke (1996) untuk mengukur tingkat usabilitas aplikasi di tangan peternak rakyat (Tersedia lengkap di file [`task_list/07_instrumen_kuesioner_sus.md`](file:///c:/TA-saya/task_list/07_instrumen_kuesioner_sus.md)).

---

## LAMPIRAN 5: CUPLIKAN KODE MESIN INFERENSI FUZZY (DART)
* Berkas logika mesin murni: [`flutter_app/lib/fuzzy/fuzzy_engine.dart`](file:///c:/TA-saya/flutter_app/lib/fuzzy/fuzzy_engine.dart).
* Unit Test Cross-Validation: [`flutter_app/test/cross_validation_test.dart`](file:///c:/TA-saya/flutter_app/test/cross_validation_test.dart).

---

## LAMPIRAN 6: DOKUMENTASI ANTARMUKA PENGGUNA FLUTTER
* Galeri ilustrasi aset digital dan diagram perampingan 4-tab: [`desain_visual_dan_navigasi_4_tab.md`](file:///C:/Users/FERDI/.gemini/antigravity/brain/4eb9086b-1a57-4ede-b676-26316725e99a/desain_visual_dan_navigasi_4_tab.md).

