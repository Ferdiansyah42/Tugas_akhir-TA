import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/main.dart';

void main() {
  testWidgets('FuzzyBroilerApp smoke test', (WidgetTester tester) async {
    // Bangun aplikasi FuzzyBroiler
    await tester.pumpWidget(const FuzzyBroilerApp());
    await tester.pumpAndSettle();

    // Verifikasi bahwa teks judul dan elemen utama muncul
    expect(find.text('FuzzyBroiler IP'), findsOneWidget);
    expect(find.text('STATUS KANDANG SAAT INI'), findsOneWidget);
    expect(find.textContaining('KONDISI'), findsWidgets);

    // Verifikasi navigasi ke tab Profil & Pengaturan
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Profil & Pengaturan'), findsWidgets);
    expect(find.text('Ferdiansyah'), findsOneWidget);
  });
}
