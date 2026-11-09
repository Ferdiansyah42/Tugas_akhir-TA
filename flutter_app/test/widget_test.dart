import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('FuzzyBroilerApp smoke test', (WidgetTester tester) async {
    // Bangun aplikasi FuzzyBroiler
    await tester.pumpWidget(const FuzzyBroilerApp());
    await tester.pumpAndSettle();

    // Verifikasi bahwa teks judul dan elemen utama muncul
    expect(find.text('Broiler App'), findsOneWidget);
    expect(find.text('STATUS KANDANG SAAT INI'), findsOneWidget);
    expect(find.textContaining('KONDISI'), findsWidgets);

    // Verifikasi navigasi 4 Tab Bersih di Bottom Bar
    expect(find.text('Beranda'), findsWidgets);
    expect(find.text('Evaluasi'), findsOneWidget);
    expect(find.text('Solusi'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);

    // Verifikasi tab Evaluasi terpadu
    await tester.tap(find.text('Evaluasi'));
    await tester.pumpAndSettle();
    expect(find.text('Form Input'), findsOneWidget);
    expect(find.text('Hasil Inferensi'), findsOneWidget);

    // Verifikasi buka Profil & Pengaturan via avatar
    await tester.tap(find.byKey(const Key('app_bar_profile_avatar')));
    await tester.pumpAndSettle();
    expect(find.text('Ferdiansyah'), findsOneWidget);
  });
}
