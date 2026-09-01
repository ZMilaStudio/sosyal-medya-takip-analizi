import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosyal_medya_takip_analizi/app/app.dart';

void main() {
  testWidgets('shows Instagram and X local import entry points', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: SosyalMedyaTakipApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Takip Analizi'), findsOneWidget);
    expect(find.text('Instagram'), findsOneWidget);
    expect(find.text('Instagram Verisini İçe Aktar'), findsOneWidget);
    expect(find.text('Instagram arşivi nasıl alınır?'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('X / Twitter'), 300);
    expect(find.text('X / Twitter'), findsOneWidget);
    expect(find.text('X Arşivini İçe Aktar'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Büyük arşiv: follower.js + following.js seç'),
      300,
    );
    expect(
      find.text('Büyük arşiv: follower.js + following.js seç'),
      findsOneWidget,
    );
    expect(find.text('X arşivi nasıl alınır?'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Yerel Veri Yönetimi'), 300);
    expect(find.text('Analiz Geçmişi'), findsOneWidget);
    expect(find.text('Yok Sayılan Hesaplar'), findsOneWidget);
    expect(find.text('Yerel Veri Yönetimi'), findsOneWidget);
  });
}
