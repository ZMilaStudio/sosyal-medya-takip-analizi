import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sosyal_medya_takip_analizi/features/instagram_guide/presentation/instagram_export_guide_screen.dart';

void main() {
  testWidgets('shows the essential Instagram export steps', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: InstagramExportGuideScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Instagram Verisi Nasıl İndirilir?'), findsOneWidget);
    expect(find.text('Instagram profilini aç'), findsOneWidget);
    expect(find.text('Bilgilerini dışa aktar'), findsOneWidget);
    expect(find.text('Instagram hesabını seç'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Yalnız gerekli bilgiyi seç'),
      300,
    );
    expect(find.text('Yalnız gerekli bilgiyi seç'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Tarih aralığı ve format'),
      300,
    );
    expect(find.text('Tarih aralığı ve format'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('ZIP dosyasını uygulamaya yükle'),
      300,
    );
    expect(find.text('ZIP dosyasını uygulamaya yükle'), findsOneWidget);
  });
}
