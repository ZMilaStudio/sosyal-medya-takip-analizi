import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosyal_medya_takip_analizi/app/app.dart';

void main() {
  testWidgets('shows Instagram import entry point', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: SosyalMedyaTakipApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Takip Analizi'), findsOneWidget);
    expect(find.text('Instagram'), findsOneWidget);
    expect(find.text('Instagram Verisini İçe Aktar'), findsOneWidget);
    expect(find.text('X / Twitter'), findsOneWidget);
  });
}
