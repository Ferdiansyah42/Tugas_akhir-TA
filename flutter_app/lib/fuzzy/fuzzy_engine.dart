/// Mesin Fuzzy Inference System (FIS) untuk Evaluasi Potensi Indeks Performa Ayam Broiler
/// Ditulis dalam Dart Murni tanpa dependensi eksternal sesuai Blueprint TA Halaman 4.
/// Mendukung metode Mamdani (Centroid) dan Sugeno (Weighted Average).

import 'dart:math' as math;

class EvaluationResult {
  final int age;
  final double temperature;
  final double humidity;
  final double targetTemp;
  final double tempDeviation;
  final String agePhase;
  final String tempStatus;
  final String humidityStatus;
  final double scoreMamdani;
  final double scoreSugeno;
  final String category;
  final String conditionTitle;
  final String conditionSubtitle;
  final String predictionDesc;
  final String recommendationSummary;
  final String recommendationPriority;
  final List<RecommendationAction> recommendationDetails;
  final bool warningFlag;
  final String? warningMessage;
  final DateTime createdAt;

  EvaluationResult({
    required this.age,
    required this.temperature,
    required this.humidity,
    required this.targetTemp,
    required this.tempDeviation,
    required this.agePhase,
    required this.tempStatus,
    required this.humidityStatus,
    required this.scoreMamdani,
    required this.scoreSugeno,
    required this.category,
    required this.conditionTitle,
    required this.conditionSubtitle,
    required this.predictionDesc,
    required this.recommendationSummary,
    required this.recommendationPriority,
    required this.recommendationDetails,
    required this.warningFlag,
    this.warningMessage,
    required this.createdAt,
  });
}

class RecommendationAction {
  final String iconName;
  final String title;
  final String action;

  RecommendationAction({
    required this.iconName,
    required this.title,
    required this.action,
  });
}

class FuzzyBroilerEngine {
  /// Pedoman target suhu harian strain broiler komersial (Cobb 500 / Ross 308)
  double getTargetTemperature(int age) {
    if (age <= 3) return 33.0;
    if (age <= 7) return 31.5;
    if (age <= 14) return 29.0;
    if (age <= 21) return 27.0; // Target hari ke-21 sesuai mockup
    if (age <= 28) return 24.5;
    if (age <= 35) return 22.5;
    return 21.0;
  }

  String getAgePhase(int age) {
    if (age <= 14) return 'Ayam Starter (Brooding)';
    if (age <= 28) return 'Ayam Remaja (Grower)';
    return 'Ayam Dewasa (Finisher)';
  }

  // --- Fungsi Keanggotaan (Membership Functions) ---

  double _triangular(double x, double a, double b, double c) {
    if (x <= a || x >= c) return 0.0;
    if (a < x && x <= b) return b > a ? (x - a) / (b - a) : 1.0;
    return c > b ? (c - x) / (c - b) : 1.0;
  }

  double _trapezoidal(double x, double a, double b, double c, double d) {
    if (x <= a || x >= d) return 0.0;
    if (a < x && x < b) return b > a ? (x - a) / (b - a) : 1.0;
    if (b <= x && x <= c) return 1.0;
    return d > c ? (d - x) / (d - c) : 1.0;
  }

  Map<String, double> fuzzifyAge(double age) {
    return {
      'starter': _trapezoidal(age, 0, 0, 10, 15),
      'grower': _triangular(age, 12, 21, 30),
      'finisher': _trapezoidal(age, 27, 32, 42, 50),
    };
  }

  Map<String, double> fuzzifyTempDev(double dev) {
    return {
      'dingin': _trapezoidal(dev, -15.0, -15.0, -3.0, -1.0),
      'nyaman': _trapezoidal(dev, -2.5, -1.0, 1.8, 3.0),
      'panas': _trapezoidal(dev, 1.5, 3.2, 15.0, 15.0),
    };
  }

  Map<String, double> fuzzifyHumidity(double rh) {
    return {
      'rendah': _trapezoidal(rh, 0, 0, 50, 58),
      'ideal': _trapezoidal(rh, 55, 60, 70, 75),
      'tinggi': _trapezoidal(rh, 72, 78, 100, 100),
    };
  }

  // --- 27 Aturan Fuzzy Sesuai Blueprint TA Halaman 3 ---

  List<MapEntry<double, String>> evaluateRules(
    Map<String, double> ageMfs,
    Map<String, double> devMfs,
    Map<String, double> rhMfs,
  ) {
    const ruleConsequents = <String, String>{
      // Fase Starter (chilling sensitivity)
      'starter_dingin_rendah': 'Rendah',
      'starter_dingin_ideal': 'Rendah',
      'starter_dingin_tinggi': 'Rendah',
      'starter_nyaman_rendah': 'Sedang',
      'starter_nyaman_ideal': 'Tinggi',
      'starter_nyaman_tinggi': 'Sedang',
      'starter_panas_rendah': 'Sedang',
      'starter_panas_ideal': 'Sedang',
      'starter_panas_tinggi': 'Rendah',

      // Fase Grower (Blueprint Hal 3)
      'grower_dingin_rendah': 'Sedang',
      'grower_dingin_ideal': 'Sedang',
      'grower_dingin_tinggi': 'Rendah',
      'grower_nyaman_rendah': 'Sedang',
      'grower_nyaman_ideal': 'Tinggi',
      'grower_nyaman_tinggi': 'Sedang',
      'grower_panas_rendah': 'Sedang',
      'grower_panas_ideal': 'Rendah',
      'grower_panas_tinggi': 'Rendah',

      // Fase Finisher (heat stress sensitivity)
      'finisher_dingin_rendah': 'Sedang',
      'finisher_dingin_ideal': 'Sedang',
      'finisher_dingin_tinggi': 'Rendah',
      'finisher_nyaman_rendah': 'Sedang',
      'finisher_nyaman_ideal': 'Tinggi',
      'finisher_nyaman_tinggi': 'Sedang',
      'finisher_panas_rendah': 'Rendah',
      'finisher_panas_ideal': 'Rendah',
      'finisher_panas_tinggi': 'Rendah',
    };

    final firedRules = <MapEntry<double, String>>[];

    for (final entry in ruleConsequents.entries) {
      final parts = entry.key.split('_');
      final fase = parts[0];
      final devK = parts[1];
      final rhK = parts[2];

      final alpha = math.min(
        ageMfs[fase] ?? 0.0,
        math.min(devMfs[devK] ?? 0.0, rhMfs[rhK] ?? 0.0),
      );

      if (alpha > 0.0) {
        firedRules.add(MapEntry(alpha, entry.value));
      }
    }

    return firedRules;
  }

  // --- Defuzzifikasi Sugeno ---
  double defuzzifySugeno(List<MapEntry<double, String>> firedRules) {
    const singletons = {'Rendah': 30.0, 'Sedang': 65.0, 'Tinggi': 88.0};
    double totalWeight = 0.0;
    double weightedSum = 0.0;

    for (final rule in firedRules) {
      final weight = rule.key;
      final val = singletons[rule.value] ?? 50.0;
      totalWeight += weight;
      weightedSum += weight * val;
    }

    if (totalWeight == 0.0) return 50.0;
    return double.parse((weightedSum / totalWeight).toStringAsFixed(1));
  }

  // --- Defuzzifikasi Mamdani (Centroid / COG) ---
  double defuzzifyMamdani(List<MapEntry<double, String>> firedRules, {int steps = 100}) {
    if (firedRules.isEmpty) return 50.0;

    final maxAlpha = {'Rendah': 0.0, 'Sedang': 0.0, 'Tinggi': 0.0};
    for (final rule in firedRules) {
      if (rule.key > (maxAlpha[rule.value] ?? 0.0)) {
        maxAlpha[rule.value] = rule.key;
      }
    }

    double numerator = 0.0;
    double denominator = 0.0;

    for (int i = 0; i <= steps; i++) {
      final z = i * (100.0 / steps);
      final muRendah = math.min(maxAlpha['Rendah']!, _trapezoidal(z, 0, 0, 30, 50));
      final muSedang = math.min(maxAlpha['Sedang']!, _triangular(z, 40, 65, 80));
      final muTinggi = math.min(maxAlpha['Tinggi']!, _trapezoidal(z, 70, 85, 100, 100));

      final muComposite = math.max(muRendah, math.max(muSedang, muTinggi));

      numerator += z * muComposite;
      denominator += muComposite;
    }

    if (denominator == 0.0) return 50.0;
    return double.parse((numerator / denominator).toStringAsFixed(1));
  }

  EvaluationResult evaluate({
    required int age,
    required double temperature,
    required double humidity,
    List<double>? previousScores,
  }) {
    final targetTemp = getTargetTemperature(age);
    final dev = double.parse((temperature - targetTemp).toStringAsFixed(1));
    final agePhase = getAgePhase(age);

    final ageMfs = fuzzifyAge(age.toDouble());
    final devMfs = fuzzifyTempDev(dev);
    final rhMfs = fuzzifyHumidity(humidity);

    final firedRules = evaluateRules(ageMfs, devMfs, rhMfs);

    final scoreSugeno = defuzzifySugeno(firedRules);
    final scoreMamdani = defuzzifyMamdani(firedRules);

    final primaryScore = scoreMamdani;

    String category;
    String conditionTitle;
    String conditionSubtitle;
    String predictionDesc;

    if (primaryScore >= 75) {
      category = 'Tinggi';
      conditionTitle = 'KONDISI BAIK SEKALI';
      conditionSubtitle = 'Pertumbuhan ayam berjalan optimal';
      predictionDesc = 'Sangat Memuaskan';
    } else if (primaryScore >= 50) {
      category = 'Sedang';
      conditionTitle = 'KONDISI CUKUP BAIK';
      conditionSubtitle = 'Perlu sedikit penyesuaian sirkulasi';
      predictionDesc = 'Cukup Memuaskan';
    } else {
      category = 'Rendah';
      conditionTitle = 'KONDISI PERLU PERHATIAN';
      conditionSubtitle = 'Kondisi mikroklimat berisiko menurunkan performa';
      predictionDesc = 'Kurang Memuaskan';
    }

    String tempStatus;
    if (dev < -2.0) {
      tempStatus = 'Terlalu Dingin';
    } else if (dev > 2.0) {
      tempStatus = 'Terlalu Panas (Bahaya)';
    } else if (dev > 0.8) {
      tempStatus = 'Agak Hangat, Masih Aman';
    } else if (dev < -0.8) {
      tempStatus = 'Agak Sejuk, Masih Aman';
    } else {
      tempStatus = 'Pas & Nyaman (Optimal)';
    }

    String humidityStatus;
    if (humidity < 55) {
      humidityStatus = 'Kering / Kurang Lembab';
    } else if (humidity > 75) {
      humidityStatus = 'Terlalu Lembab';
    } else {
      humidityStatus = 'Pas & Nyaman untuk Ayam';
    }

    String recSummary;
    String recPriority;
    final recDetails = <RecommendationAction>[];

    if (dev > 0.8) {
      recSummary =
          'Buka tirai samping sedikit (sekitar 30%) & nyalakan Kipas Blower nomor 2 agar hawa panas keluar dan ayam tidak gerah.';
      recPriority = 'Perlu Dilakukan';
      recDetails.add(RecommendationAction(
        iconName: 'mode_fan',
        title: 'Pengaturan Kipas / Blower',
        action:
            'Nyalakan blower exhaust fan nomor 2 untuk melancarkan sirkulasi angin (wind chill) di atas ayam.',
      ));
      recDetails.add(RecommendationAction(
        iconName: 'curtains',
        title: 'Bukaan Tirai Samping',
        action:
            'Buka tirai samping sedikit (sekitar 30%) agar hawa panas tidak terperangkap di dalam kandang.',
      ));
      recDetails.add(RecommendationAction(
        iconName: 'water_drop',
        title: 'Ketersediaan Air Minum',
        action:
            'Pastikan aliran air minum lancar dan segar untuk membantu ayam mendinginkan tubuh.',
      ));
    } else if (dev < -0.8) {
      recSummary =
          'Tutup tirai samping rapat dan nyalakan pemanas tambahan untuk menjaga kehangatan ayam.';
      recPriority = 'Perlu Dilakukan Segera';
      recDetails.add(RecommendationAction(
        iconName: 'thermostat',
        title: 'Pemanas Kandang (Brooder)',
        action:
            'Nyalakan pemanas gas/kayu secara merata agar suhu stabil di zona nyaman.',
      ));
      recDetails.add(RecommendationAction(
        iconName: 'curtains',
        title: 'Tirai Kandang',
        action:
            'Tutup tirai samping rapat untuk mencegah angin dingin langsung (chilling) mengenai ayam.',
      ));
    } else {
      recSummary =
          'Kondisi kandang saat ini sangat baik dan optimal. Pertahankan timer sirkulasi ventilasi minimum.';
      recPriority = 'Kondisi Terjaga';
      recDetails.add(RecommendationAction(
        iconName: 'check_circle',
        title: 'Ventilasi Minimum',
        action:
            'Jalankan siklus ventilasi minimum secara berkala untuk menjaga kualitas udara segar.',
      ));
      recDetails.add(RecommendationAction(
        iconName: 'inventory_2',
        title: 'Pemeriksaan Sekam (Litter)',
        action:
            'Pastikan alas sekam tetap kering dan bebas dari bau amonia menyengat.',
      ));
    }

    bool warningFlag = false;
    String? warningMsg;
    if (previousScores != null && previousScores.length >= 2) {
      final s1 = previousScores[previousScores.length - 2];
      final s2 = previousScores.last;
      if (s1 > s2 && s2 > primaryScore) {
        warningFlag = true;
        warningMsg =
            'Suhu agak sedikit naik dalam 2 hari ini. Yuk cek ventilasi dan sirkulasi angin agar ayam tetap nyaman.';
      }
    }

    return EvaluationResult(
      age: age,
      temperature: temperature,
      humidity: humidity,
      targetTemp: targetTemp,
      tempDeviation: dev,
      agePhase: agePhase,
      tempStatus: tempStatus,
      humidityStatus: humidityStatus,
      scoreMamdani: scoreMamdani,
      scoreSugeno: scoreSugeno,
      category: category,
      conditionTitle: conditionTitle,
      conditionSubtitle: conditionSubtitle,
      predictionDesc: predictionDesc,
      recommendationSummary: recSummary,
      recommendationPriority: recPriority,
      recommendationDetails: recDetails,
      warningFlag: warningFlag,
      warningMessage: warningMsg,
      createdAt: DateTime.now(),
    );
  }
}

