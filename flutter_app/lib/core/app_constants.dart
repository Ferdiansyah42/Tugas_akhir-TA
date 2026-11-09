/// Konstanta Aplikasi, Data Preset Sidang TA, dan Metadata Kandang
class AppConstants {
  static const String appName = 'FuzzyBroiler IP';
  static const String appSubtitle = 'DSS Evaluasi Mikroklimat Broiler';
  static const String defaultFlock = 'Kandang Blok A';
  static const String offlineBadge = 'Siap Pakai Tanpa Kuota';

  // Daftar Pilihan Kandang
  static const List<String> flocks = [
    'Kandang Blok A',
    'Kandang Blok B',
    'Kandang Blok C',
  ];

  // Preset Cepat Skenario Pengujian (Sangat berguna saat demonstrasi sidang TA)
  static const List<PresetScenario> presetScenarios = [
    PresetScenario(
      name: 'Kondisi Ideal',
      iconEmoji: '✨',
      age: 21,
      temperature: 27.0,
      humidity: 65.0,
      description: 'Suhu pas sesuai umur, kelembaban ideal',
    ),
    PresetScenario(
      name: 'Panas (+3°C)',
      iconEmoji: '🔥',
      age: 21,
      temperature: 30.5,
      humidity: 75.0,
      description: 'Suhu di atas target, rawan panting',
    ),
    PresetScenario(
      name: 'Dingin (-4°C)',
      iconEmoji: '❄️',
      age: 4,
      temperature: 26.0,
      humidity: 78.0,
      description: 'Fase brooding kedinginan, bahaya kerdil',
    ),
    PresetScenario(
      name: 'Starter Kering',
      iconEmoji: '💨',
      age: 7,
      temperature: 31.5,
      humidity: 45.0,
      description: 'Kelembaban terlalu rendah, debu tinggi',
    ),
    PresetScenario(
      name: 'Finisher Kritis',
      iconEmoji: '🚨',
      age: 42,
      temperature: 29.5,
      humidity: 85.0,
      description: 'Suhu & kelembaban tinggi menjelang panen',
    ),
  ];
}

class PresetScenario {
  final String name;
  final String iconEmoji;
  final double age;
  final double temperature;
  final double humidity;
  final String description;

  const PresetScenario({
    required this.name,
    required this.iconEmoji,
    required this.age,
    required this.temperature,
    required this.humidity,
    required this.description,
  });

  String get chipLabel => '$iconEmoji $name';
}

