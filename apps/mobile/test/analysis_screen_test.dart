import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follow_core/follow_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sosyal_medya_takip_analizi/features/analysis/presentation/analysis_screen.dart';

void main() {
  const account = SocialAccount(
    platform: SocialPlatform.instagram,
    username: 'owner',
  );

  SocialUser user(String username) => SocialUser(
        platform: SocialPlatform.instagram,
        username: username,
      );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('renders and interacts with flat analysis body on phone viewport',
      (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final mutual = [for (var i = 0; i < 261; i++) user('mutual$i')];
    final fans = [for (var i = 0; i < 308; i++) user('fan$i')];
    final nonFollowers = [
      for (var i = 0; i < 792; i++)
        user('nonfollower${i.toString().padLeft(3, '0')}'),
    ];

    final snapshot = FollowSnapshot(
      account: account,
      capturedAt: DateTime.utc(2026, 8, 31),
      followers: [...mutual, ...fans],
      following: [...mutual, ...nonFollowers],
      sourceType: SnapshotSourceType.archive,
      sourceFormat: 'instagram-export-json',
    );
    final analysis = const FollowAnalysisEngine().analyze(current: snapshot);
    final result = InstagramFollowAnalysisResult(
      snapshot: snapshot,
      analysis: analysis,
      followerSourceFiles: const [],
      followingSourceFiles: const [],
    );

    await tester.pumpWidget(
      MaterialApp(home: AnalysisScreen(result: result)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Takip Etmeyenler (792)'), findsOneWidget);
    expect(find.text('Karşılıklı (261)'), findsOneWidget);
    expect(find.text('Seni Takip Edenler (308)'), findsOneWidget);
    expect(find.text('569'), findsOneWidget);
    expect(find.text('1053'), findsOneWidget);

    expect(find.byKey(const Key('analysis-content')), findsOneWidget);
    expect(find.byKey(const Key('analysis-scroll')), findsOneWidget);
    expect(find.byKey(const Key('analysis-summary')), findsOneWidget);
    expect(find.byKey(const Key('analysis-controls')), findsOneWidget);
    expect(find.byKey(const Key('analysis-search')), findsOneWidget);
    expect(find.byKey(const Key('analysis-sort')), findsOneWidget);
    expect(find.text('792 hesap'), findsOneWidget);
    expect(find.text('@nonfollower000'), findsOneWidget);
    expect(find.byKey(const Key('analysis-load-more')), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('analysis-search')));
    await tester.enterText(
      find.byKey(const Key('analysis-search')),
      'nonfollower791',
    );
    await tester.pumpAndSettle();

    expect(find.text('@nonfollower791'), findsOneWidget);
    expect(find.text('@nonfollower000'), findsNothing);
    expect(find.text('1 hesap'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('analysis-search')), '');
    await tester.pumpAndSettle();

    final mutualTab = find.byKey(const Key('analysis-tab-Karşılıklı'));
    await tester.ensureVisible(mutualTab);
    await tester.tap(mutualTab);
    await tester.pumpAndSettle();

    expect(find.text('İki hesap birbirini takip ediyor.'), findsOneWidget);
    expect(find.text('261 hesap'), findsOneWidget);
    expect(find.text('@mutual0'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('analysis-sort')));
    await tester.tap(find.byKey(const Key('analysis-sort')));
    await tester.pumpAndSettle();
    expect(find.text('Z-A'), findsOneWidget);
  });
}
