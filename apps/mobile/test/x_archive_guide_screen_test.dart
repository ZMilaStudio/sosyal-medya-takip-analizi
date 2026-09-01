import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sosyal_medya_takip_analizi/features/x_guide/presentation/x_archive_guide_screen.dart';

void main() {
  testWidgets('shows the essential X archive steps', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: XArchiveGuideScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('X Arşivi Nasıl İndirilir?'), findsOneWidget);
    expect(find.text('X ayarlarını aç'), findsOneWidget);
    expect(find.text('Arşiv indirme ekranına gir'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Arşivi iste'), 300);
    expect(find.text('Arşivi iste'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Arşiv çok büyükse iki dosyayı seç'),
      300,
    );
    expect(find.text('Arşiv çok büyükse iki dosyayı seç'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Analizi başlat'), 300);
    expect(find.text('Analizi başlat'), findsOneWidget);
  });
}
