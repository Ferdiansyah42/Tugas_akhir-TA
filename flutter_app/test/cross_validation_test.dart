/// Unit Test Konsistensi Implementasi: Memverifikasi Keselarasan Mesin Fuzzy Dart
/// terhadap Baseline Teoretis dan Prototipe Python sesuai Blueprint Halaman 5.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/fuzzy/fuzzy_engine.dart';

void main() {
  group('Uji Konsistensi Mesin Fuzzy Broiler (Dart Engine)', () {
    late FuzzyBroilerEngine engine;

    setUp(() {
      engine = FuzzyBroilerEngine();
    });

    test('1. Verifikasi Suhu Target Adaptif Strain Cobb 500 / Ross 308', () {
      expect(engine.getTargetTemperature(1), equals(33.0));
      expect(engine.getTargetTemperature(5), equals(31.5));
      expect(engine.getTargetTemperature(10), equals(29.0));
      expect(engine.getTargetTemperature(21), equals(27.0));
      expect(engine.getTargetTemperature(25), equals(24.5));
      expect(engine.getTargetTemperature(32), equals(22.5));
      expect(engine.getTargetTemperature(40), equals(21.0));
    });

    test('2. Uji Kasus Ideal Fase Grower (Umur 21, Suhu 27.0°C, RH 65%)', () {
      final res = engine.evaluate(age: 21, temperature: 27.0, humidity: 65.0);
      expect(res.category, equals('Tinggi'));
      expect(res.scoreMamdani, greaterThanOrEqualTo(80.0));
      expect(res.scoreSugeno, greaterThanOrEqualTo(80.0));
      expect(res.tempDeviation, equals(0.0));
      expect(res.agePhase, equals('Ayam Remaja (Grower)'));
    });

    test('3. Uji Kasus Kritis Dingin Fase Starter (Chilling Sensitivity)', () {
      // DOC Hari ke-4 kedinginan (Suhu 25°C, RH 80%)
      final res = engine.evaluate(age: 4, temperature: 25.0, humidity: 80.0);
      expect(res.category, equals('Rendah'));
      expect(res.scoreMamdani, lessThan(40.0));
      expect(res.tempDeviation, lessThan(-2.0));
    });

    test('4. Uji Kasus Kritis Panas Fase Finisher (Heat Stress Sensitivity)', () {
      // Ayam Dewasa Hari ke-42 kepanasan fatal (Suhu 28.5°C, RH 80%)
      final res = engine.evaluate(age: 42, temperature: 28.5, humidity: 80.0);
      expect(res.category, equals('Rendah'));
      expect(res.scoreMamdani, lessThan(40.0));
      expect(res.tempDeviation, greaterThan(2.0));
    });

    test('5. Uji Deteksi Peringatan Dini (Early Warning System 3 Hari Beruntun)', () {
      final scores = [90.0, 88.0];
      final res = engine.evaluate(
        age: 21,
        temperature: 28.8,
        humidity: 68.0,
        previousScores: scores,
      );
      // Skor menurun dari 90 -> 88 -> ~70-86
      if (scores.last > res.scoreMamdani) {
        expect(res.warningFlag, isTrue);
        expect(res.warningMessage, isNotNull);
      }
    });
  });
}

