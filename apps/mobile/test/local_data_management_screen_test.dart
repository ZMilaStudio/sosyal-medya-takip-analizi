import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sosyal_medya_takip_analizi/data/local/follow_history_database.dart';
import 'package:sosyal_medya_takip_analizi/data/local/follow_history_provider.dart';
import 'package:sosyal_medya_takip_analizi/features/data_management/presentation/local_data_management_screen.dart';

void main() {
  testWidgets('shows local data controls and disables empty destructive actions',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final database = FollowHistoryDatabase(executor: NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          followHistoryDatabaseProvider.overrideWithValue(database),
        ],
        child: const MaterialApp(home: LocalDataManagementScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final pageList = find.byType(ListView);
    expect(pageList, findsOneWidget);

    expect(find.text('Yerel Veri Yönetimi'), findsOneWidget);
    expect(find.text('Analiz'), findsOneWidget);
    expect(find.text('Hesap'), findsOneWidget);
    expect(find.text('Yok sayılan'), findsOneWidget);

    final historyFinder =
        find.widgetWithText(OutlinedButton, 'Tüm analiz geçmişini sil');
    await tester.scrollUntilVisible(
      historyFinder,
      250,
      scrollable: pageList,
    );
    expect(tester.widget<OutlinedButton>(historyFinder).onPressed, isNull);

    final ignoredFinder =
        find.widgetWithText(OutlinedButton, 'Yok sayılanları temizle');
    await tester.scrollUntilVisible(
      ignoredFinder,
      250,
      scrollable: pageList,
    );
    expect(tester.widget<OutlinedButton>(ignoredFinder).onPressed, isNull);

    final everythingFinder =
        find.widgetWithText(OutlinedButton, 'Tüm yerel veriyi temizle');
    await tester.scrollUntilVisible(
      everythingFinder,
      250,
      scrollable: pageList,
    );
    expect(tester.widget<OutlinedButton>(everythingFinder).onPressed, isNull);
  });
}
