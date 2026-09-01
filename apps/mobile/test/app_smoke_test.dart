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

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -700));
    await tester.pumpAndSettle();

    expect(find.text('X / Twitter'), findsOneWidget);
    expect(find.text('X Arşivini İçe Aktar'), findsOneWidget);
    expect(
      find.text('Büyük arşiv: follower.js + following.js seç'),
      findsOneWidget,
    );
    expect(find.text('Analiz Geçmişi'), findsOneWidget);
    expect(find.text('Yok Sayılan Hesaplar'), findsOneWidget);
  });
}
