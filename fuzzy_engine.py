"""
Fuzzy Inference System (FIS) untuk Evaluasi Potensi Indeks Performa Ayam Broiler
Mendukung inferensi Mamdani (Centroid) dan Sugeno (Weighted Average).
Batas suhu adaptif terhadap umur ayam (pedoman strain Cobb 500 / Ross 308).
"""

from dataclasses import dataclass
from typing import Dict, List, Tuple, Optional


@dataclass
class EvaluationResult:
    age: int
    temperature: float
    humidity: float
    target_temp: float
    temp_deviation: float
    age_phase: str
    temp_status: str
    humidity_status: str
    score_mamdani: float
    score_sugeno: float
    category: str
    prediction_desc: str
    condition_title: str
    condition_subtitle: str
    recommendation_summary: str
    recommendation_priority: str
    recommendation_details: List[Dict[str, str]]
    warning_flag: bool
    warning_message: Optional[str] = None


class FuzzyBroilerEngine:
    def __init__(self):
        # Target suhu standar manajemen strain broiler (Cobb 500 / Ross 308)
        self.strain_temp_targets = {
            (1, 3): 33.0,
            (4, 7): 31.5,
            (8, 14): 29.0,
            (15, 21): 27.0,  # 27°C pada hari ke-21 (sesuai target di mockup)
            (22, 28): 24.5,
            (29, 35): 22.5,
            (36, 42): 21.0,
        }

    def get_target_temperature(self, age: int) -> float:
        """Menghitung suhu target optimal sesuai umur ayam broiler (hari)."""
        if age <= 0:
            return 33.0
        for (start_day, end_day), target in self.strain_temp_targets.items():
            if start_day <= age <= end_day:
                return target
        return 21.0 if age > 42 else 33.0

    def get_age_phase(self, age: int) -> str:
        """Menentukan fase pemeliharaan ayam broiler."""
        if age <= 14:
            return "Ayam Starter (Brooding)"
        elif age <= 28:
            return "Ayam Remaja (Grower)"
        else:
            return "Ayam Dewasa (Finisher)"

    # --- Fungsi Keanggotaan (Membership Functions) ---

    @staticmethod
    def _triangular(x: float, a: float, b: float, c: float) -> float:
        if x <= a or x >= c:
            return 0.0
        elif a < x <= b:
            return (x - a) / (b - a) if b > a else 1.0
        else:
            return (c - x) / (c - b) if c > b else 1.0

    @staticmethod
    def _trapezoidal(x: float, a: float, b: float, c: float, d: float) -> float:
        if x <= a or x >= d:
            return 0.0
        elif a < x < b:
            return (x - a) / (b - a) if b > a else 1.0
        elif b <= x <= c:
            return 1.0
        else:
            return (d - x) / (d - c) if d > c else 1.0

    def fuzzify_age(self, age: float) -> Dict[str, float]:
        """Derajat keanggotaan umur: Starter, Grower, Finisher."""
        return {
            "starter": self._trapezoidal(age, 0, 0, 10, 15),
            "grower": self._triangular(age, 12, 21, 30),
            "finisher": self._trapezoidal(age, 27, 32, 42, 50),
        }

    def fuzzify_temp_dev(self, dev: float) -> Dict[str, float]:
        """
        Derajat keanggotaan deviasi suhu (aktual - target):
        Dingin: dev < -1.5 (puncak di bawah -3.0)
        Nyaman: zona nyaman -2.0 s.d. +2.0 (plato di -1.0 s.d. +1.5)
        Panas: dev > +1.5 (puncak di atas +3.5)
        """
        return {
            "dingin": self._trapezoidal(dev, -15.0, -15.0, -3.0, -1.0),
            "nyaman": self._trapezoidal(dev, -2.5, -1.0, 1.8, 3.0),
            "panas": self._trapezoidal(dev, 1.5, 3.2, 15.0, 15.0),
        }

    def fuzzify_humidity(self, rh: float) -> Dict[str, float]:
        """Derajat keanggotaan kelembaban relatif (RH %): Rendah, Ideal, Tinggi."""
        return {
            "rendah": self._trapezoidal(rh, 0, 0, 50, 58),
            "ideal": self._trapezoidal(rh, 55, 60, 70, 75),
            "tinggi": self._trapezoidal(rh, 72, 78, 100, 100),
        }

    # --- 27 Aturan Fuzzy (Knowledge Base Blueprint) ---

    def evaluate_rules(
        self, age_mfs: Dict[str, float], dev_mfs: Dict[str, float], rh_mfs: Dict[str, float]
    ) -> List[Tuple[float, str]]:
        """
        Mengevaluasi 27 aturan If-Then fuzzy (3x3x3) sesuai Blueprint halaman 3.
        """
        rule_consequents = {
            # Fase Starter (sangat peka dingin/chilling)
            ("starter", "dingin", "rendah"): "Rendah",
            ("starter", "dingin", "ideal"): "Rendah",
            ("starter", "dingin", "tinggi"): "Rendah",
            ("starter", "nyaman", "rendah"): "Sedang",
            ("starter", "nyaman", "ideal"): "Tinggi",
            ("starter", "nyaman", "tinggi"): "Sedang",
            ("starter", "panas", "rendah"): "Sedang",
            ("starter", "panas", "ideal"): "Sedang",
            ("starter", "panas", "tinggi"): "Rendah",

            # Fase Grower (Blueprint Halaman 3)
            # Dingin: Sedang, Sedang, Rendah
            ("grower", "dingin", "rendah"): "Sedang",
            ("grower", "dingin", "ideal"): "Sedang",
            ("grower", "dingin", "tinggi"): "Rendah",
            # Nyaman: Sedang, Tinggi, Sedang
            ("grower", "nyaman", "rendah"): "Sedang",
            ("grower", "nyaman", "ideal"): "Tinggi",
            ("grower", "nyaman", "tinggi"): "Sedang",
            # Panas: Sedang, Rendah, Rendah
            ("grower", "panas", "rendah"): "Sedang",
            ("grower", "panas", "ideal"): "Rendah",
            ("grower", "panas", "tinggi"): "Rendah",

            # Fase Finisher (sangat peka panas/heat stress)
            ("finisher", "dingin", "rendah"): "Sedang",
            ("finisher", "dingin", "ideal"): "Sedang",
            ("finisher", "dingin", "tinggi"): "Rendah",
            ("finisher", "nyaman", "rendah"): "Sedang",
            ("finisher", "nyaman", "ideal"): "Tinggi",
            ("finisher", "nyaman", "tinggi"): "Sedang",
            ("finisher", "panas", "rendah"): "Rendah",
            ("finisher", "panas", "ideal"): "Rendah",
            ("finisher", "panas", "tinggi"): "Rendah",
        }

        fired_rules = []
        for (fase, dev_k, rh_k), consequent in rule_consequents.items():
            alpha = min(age_mfs[fase], dev_mfs[dev_k], rh_mfs[rh_k])
            if alpha > 0.0:
                fired_rules.append((alpha, consequent))

        return fired_rules

    # --- Defuzzifikasi Sugeno ---
    def defuzzify_sugeno(self, fired_rules: List[Tuple[float, str]]) -> float:
        """Sugeno Zero-Order: Defuzzifikasi Weighted Average."""
        singletons = {"Rendah": 30.0, "Sedang": 65.0, "Tinggi": 88.0}
        total_weight = sum(alpha for alpha, _ in fired_rules)
        if total_weight == 0.0:
            return 50.0
        weighted_sum = sum(alpha * singletons[consequent] for alpha, consequent in fired_rules)
        return round(weighted_sum / total_weight, 1)

    # --- Defuzzifikasi Mamdani ---
    def defuzzify_mamdani(self, fired_rules: List[Tuple[float, str]], steps: int = 100) -> float:
        """Mamdani: Agregasi Max & Defuzzifikasi Centroid (Center of Gravity)."""
        if not fired_rules:
            return 50.0

        max_alpha = {"Rendah": 0.0, "Sedang": 0.0, "Tinggi": 0.0}
        for alpha, consequent in fired_rules:
            if alpha > max_alpha[consequent]:
                max_alpha[consequent] = alpha

        z_values = [i * (100.0 / steps) for i in range(steps + 1)]
        numerator = 0.0
        denominator = 0.0

        for z in z_values:
            mu_rendah = min(max_alpha["Rendah"], self._trapezoidal(z, 0, 0, 30, 50))
            mu_sedang = min(max_alpha["Sedang"], self._triangular(z, 40, 65, 80))
            mu_tinggi = min(max_alpha["Tinggi"], self._trapezoidal(z, 70, 85, 100, 100))

            mu_composite = max(mu_rendah, mu_sedang, mu_tinggi)
            numerator += z * mu_composite
            denominator += mu_composite

        if denominator == 0.0:
            return 50.0

        return round(numerator / denominator, 1)

    def analyze_status(self, dev: float, rh: float) -> Tuple[str, str]:
        if dev < -2.0:
            temp_status = "Terlalu Dingin"
        elif dev > 2.0:
            temp_status = "Terlalu Panas (Bahaya)"
        elif dev > 0.8:
            temp_status = "Agak Hangat, Masih Aman"
        elif dev < -0.8:
            temp_status = "Agak Sejuk, Masih Aman"
        else:
            temp_status = "Pas & Nyaman (Optimal)"

        if rh < 55:
            humidity_status = "Kering / Kurang Lembab"
        elif rh > 75:
            humidity_status = "Terlalu Lembab"
        else:
            humidity_status = "Pas & Nyaman untuk Ayam"

        return temp_status, humidity_status

    def generate_recommendations(
        self, age: int, dev: float, rh: float, score: float
    ) -> Tuple[str, str, List[Dict[str, str]]]:
        details = []

        if dev > 0.8:
            # Agak hangat / panas
            summary = "Buka tirai samping sedikit (sekitar 30%) & nyalakan Kipas Blower nomor 2 agar hawa panas keluar dan ayam tidak gerah."
            priority = "Perlu Dilakukan"
            details.append({
                "icon": "mode_fan",
                "title": "Pengaturan Kipas / Blower",
                "action": "Nyalakan blower exhaust fan nomor 2 untuk melancarkan sirkulasi angin (wind chill) di atas ayam."
            })
            details.append({
                "icon": "curtains",
                "title": "Bukaan Tirai Samping",
                "action": "Buka tirai samping sedikit (sekitar 30%) agar hawa panas tidak terperangkap di dalam kandang."
            })
            details.append({
                "icon": "water_drop",
                "title": "Ketersediaan Air Minum",
                "action": "Pastikan aliran air minum lancar dan segar untuk membantu ayam mendinginkan tubuh."
            })
        elif dev < -0.8:
            summary = "Tutup tirai samping rapat dan nyalakan pemanas tambahan untuk menjaga kehangatan ayam."
            priority = "Perlu Dilakukan Segera"
            details.append({
                "icon": "thermostat",
                "title": "Pemanas Kandang (Brooder)",
                "action": "Nyalakan pemanas gas/kayu secara merata agar suhu stabil di zona nyaman."
            })
            details.append({
                "icon": "curtains",
                "title": "Tirai Kandang",
                "action": "Tutup tirai samping rapat untuk mencegah angin dingin langsung (chilling) mengenai ayam."
            })
        else:
            summary = "Kondisi kandang saat ini sangat baik dan optimal. Pertahankan timer sirkulasi ventilasi minimum."
            priority = "Kondisi Terjaga"
            details.append({
                "icon": "check_circle",
                "title": "Ventilasi Minimum",
                "action": "Jalankan siklus ventilasi minimum secara berkala untuk menjaga kualitas udara segar."
            })
            details.append({
                "icon": "inventory_2",
                "title": "Pemeriksaan Sekam (Litter)",
                "action": "Pastikan alas sekam tetap kering dan bebas dari bau amonia menyengat."
            })

        return summary, priority, details

    def evaluate(
        self, age: int, temperature: float, humidity: float, previous_scores: Optional[List[float]] = None
    ) -> EvaluationResult:
        target_temp = self.get_target_temperature(age)
        dev = round(temperature - target_temp, 1)
        age_phase = self.get_age_phase(age)

        # Fuzzifikasi
        age_mfs = self.fuzzify_age(float(age))
        dev_mfs = self.fuzzify_temp_dev(dev)
        rh_mfs = self.fuzzify_humidity(humidity)

        # Evaluasi aturan
        fired_rules = self.evaluate_rules(age_mfs, dev_mfs, rh_mfs)

        # Defuzzifikasi
        score_sugeno = self.defuzzify_sugeno(fired_rules)
        score_mamdani = self.defuzzify_mamdani(fired_rules)

        # Nilai skor utama
        primary_score = score_mamdani

        if primary_score >= 75:
            category = "Tinggi"
            condition_title = "KONDISI BAIK SEKALI"
            condition_subtitle = "Pertumbuhan ayam berjalan optimal"
            prediction_desc = "Sangat Memuaskan"
        elif primary_score >= 50:
            category = "Sedang"
            condition_title = "KONDISI CUKUP BAIK"
            condition_subtitle = "Perlu sedikit penyesuaian sirkulasi"
            prediction_desc = "Cukup Memuaskan"
        else:
            category = "Rendah"
            condition_title = "KONDISI PERLU PERHATIAN"
            condition_subtitle = "Kondisi mikroklimat berisiko menurunkan performa"
            prediction_desc = "Kurang Memuaskan"

        temp_status, humidity_status = self.analyze_status(dev, humidity)
        rec_summary, rec_priority, rec_details = self.generate_recommendations(
            age, dev, humidity, primary_score
        )

        warning_flag = False
        warning_msg = None
        if previous_scores and len(previous_scores) >= 2:
            s1 = previous_scores[-2]
            s2 = previous_scores[-1]
            if s1 > s2 > primary_score:
                warning_flag = True
                warning_msg = "Suhu agak sedikit naik dalam 2 hari ini. Yuk cek ventilasi dan sirkulasi angin agar ayam tetap nyaman."

        return EvaluationResult(
            age=age,
            temperature=temperature,
            humidity=humidity,
            target_temp=target_temp,
            temp_deviation=dev,
            age_phase=age_phase,
            temp_status=temp_status,
            humidity_status=humidity_status,
            score_mamdani=score_mamdani,
            score_sugeno=score_sugeno,
            category=category,
            prediction_desc=prediction_desc,
            condition_title=condition_title,
            condition_subtitle=condition_subtitle,
            recommendation_summary=rec_summary,
            recommendation_priority=rec_priority,
            recommendation_details=rec_details,
            warning_flag=warning_flag,
            warning_message=warning_msg,
        )
