import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosyal_medya_takip_analizi/app/app.dart';

void main() {
  testWidgets('shows Instagram and X local import entry points', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: SosyalMedyaTakipApp()),
    );
    await tester.pumpAndSettle();

    final homeList = find.byType(ListView);
    final homeScroll = find.descendant(
      of: homeList,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
    expect(homeList, findsOneWidget);
    expect(homeScroll, findsOneWidget);

    expect(find.text('Takip Analizi'), findsOneWidget);
    expect(find.text('Instagram'), findsOneWidget);
    expect(find.text('Instagram Verisini İçe Aktar'), findsOneWidget);
    expect(find.text('Instagram arşivi nasıl alınır?'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('X / Twitter'),
      300,
      scrollable: homeScroll,
    );
    expect(find.text('X / Twitter'), findsOneWidget);
    expect(find.text('X Arşivini İçe Aktar'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Büyük arşiv: follower.js + following.js seç'),
      300,
      scrollable: homeScroll,
    );
    expect(
      find.text('Büyük arşiv: follower.js + following.js seç'),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(
      find.text('X arşivi nasıl alınır?'),
      300,
      scrollable: homeScroll,
    );
    expect(find.text('X arşivi nasıl alınır?'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Gizlilik ve Hakkında'),
      300,
      scrollable: homeScroll,
    );
    expect(find.text('Analiz Geçmişi'), findsOneWidget);
    expect(find.text('Yok Sayılan Hesaplar'), findsOneWidget);
    expect(find.text('Yerel Veri Yönetimi'), findsOneWidget);
    expect(find.text('Gizlilik ve Hakkında'), findsOneWidget);
  });
}
