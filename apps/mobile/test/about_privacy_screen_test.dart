import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sosyal_medya_takip_analizi/features/about/presentation/about_privacy_screen.dart';

void main() {
  testWidgets('shows local-first privacy promises and data management entry',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AboutPrivacyScreen()),
    );

    expect(find.text('Gizlilik ve Hakkında'), findsOneWidget);
    expect(find.text('Takip Analizi'), findsOneWidget);
    expect(find.text('Local-first'), findsOneWidget);
    expect(find.text('Şifre istemiyoruz'), findsOneWidget);
    expect(find.text('Yalnız seçtiğin dosyalar'), findsOneWidget);
    expect(find.text('Yerel geçmiş'), findsOneWidget);
    expect(find.text('Dış bağlantılar'), findsOneWidget);
    expect(find.text('Yerel verilerimi yönet'), findsOneWidget);
    expect(find.text('ZMila Studio'), findsOneWidget);
  });
}
