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
    expect(find.text('Veri arşivini iste'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('ZIP dosyasını indir'),
      300,
    );
    expect(find.text('ZIP dosyasını indir'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Arşiv çok büyükse iki dosyayı seç'),
      300,
    );
    expect(find.text('Arşiv çok büyükse iki dosyayı seç'), findsOneWidget);
  });
}
