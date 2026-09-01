import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sosyal_medya_takip_analizi/features/about/presentation/about_privacy_screen.dart';

void main() {
  testWidgets('shows local-first privacy promises and data management entry',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AboutPrivacyScreen()),
    );

    final pageList = find.byType(ListView);
    final pageScroll = find.descendant(
      of: pageList,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
    expect(pageList, findsOneWidget);
    expect(pageScroll, findsOneWidget);

    expect(find.text('Gizlilik ve Hakkında'), findsOneWidget);
    expect(find.text('Takip Analizi'), findsOneWidget);
    expect(find.text('Local-first'), findsOneWidget);

    for (final label in [
      'Şifre istemiyoruz',
      'Yalnız seçtiğin dosyalar',
      'Yerel geçmiş',
      'Otomatik yedekleme kapalı',
      'Raporu sen dışa aktarırsın',
      'Dış bağlantılar',
      'Yerel verilerimi yönet',
      'ZMila Studio',
    ]) {
      await tester.scrollUntilVisible(
        find.text(label),
        250,
        scrollable: pageScroll,
      );
      expect(find.text(label), findsOneWidget);
    }

    await tester.scrollUntilVisible(
      find.textContaining('zmilastudio@gmail.com'),
      250,
      scrollable: pageScroll,
    );
    expect(find.textContaining('zmilastudio@gmail.com'), findsOneWidget);
  });
}
