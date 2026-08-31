import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follow_core/follow_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sosyal_medya_takip_analizi/features/analysis/presentation/analysis_screen.dart';

void main() {
  SocialUser user(String username) => SocialUser(
        platform: SocialPlatform.instagram,
        username: username,
      );

  const account = SocialAccount(
    platform: SocialPlatform.instagram,
    username: 'owner',
  );

  InstagramFollowAnalysisResult result() {
    final snapshot = FollowSnapshot(
      account: account,
      capturedAt: DateTime.utc(2026, 8, 31),
      followers: [user('mutual'), user('fan')],
      following: [user('mutual'), user('alice'), user('bob')],
      sourceType: SnapshotSourceType.archive,
      sourceFormat: 'instagram-export-json',
    );
    final analysis = const FollowAnalysisEngine().analyze(current: snapshot);
    return InstagramFollowAnalysisResult(
      snapshot: snapshot,
      analysis: analysis,
      followerSourceFiles: const [],
      followingSourceFiles: const [],
    );
  }

  InstagramFollowAnalysisResult resultWithHistory() {
    final previous = FollowSnapshot(
      account: account,
      capturedAt: DateTime.utc(2026, 8, 30),
      followers: [user('mutual'), user('fan'), user('left')],
      following: [user('mutual'), user('alice')],
      sourceType: SnapshotSourceType.archive,
      sourceFormat: 'instagram-export-json',
    );
    final current = FollowSnapshot(
      account: account,
      capturedAt: DateTime.utc(2026, 8, 31),
      followers: [user('mutual'), user('fan'), user('newcomer')],
      following: [user('mutual'), user('alice'), user('bob')],
      sourceType: SnapshotSourceType.archive,
      sourceFormat: 'instagram-export-json',
    );
    final analysis = const FollowAnalysisEngine().analyze(
      current: current,
      previous: previous,
    );
    return InstagramFollowAnalysisResult(
      snapshot: current,
      analysis: analysis,
      followerSourceFiles: const [],
      followingSourceFiles: const [],
    );
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('renders working MVP rows and switches tabs', (tester) async {
    await tester.pumpWidget(MaterialApp(home: AnalysisScreen(result: result())));
    await tester.pumpAndSettle();

    expect(find.text('Takip Etmeyenler (2)'), findsOneWidget);
    expect(find.text('@alice'), findsOneWidget);
    expect(find.text('@bob'), findsOneWidget);

    await tester.tap(find.text('Karşılıklı (1)'));
    await tester.pumpAndSettle();

    expect(find.text('@mutual'), findsOneWidget);
    expect(find.text('Takibi Bırakanlar (0)'), findsOneWidget);
    expect(find.text('Yeni Takipçiler (0)'), findsOneWidget);
  });

  testWidgets('renders unfollowers and new followers from previous snapshot',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: AnalysisScreen(result: resultWithHistory())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Takibi Bırakanlar (1)'), findsOneWidget);
    expect(find.text('Yeni Takipçiler (1)'), findsOneWidget);

    final controller =
        DefaultTabController.of(tester.element(find.byType(TabBar)));

    controller.animateTo(3);
    await tester.pumpAndSettle();
    expect(find.text('@left'), findsOneWidget);

    controller.animateTo(4);
    await tester.pumpAndSettle();
    expect(find.text('@newcomer'), findsOneWidget);
  });

  testWidgets('search filters visible accounts', (tester) async {
    await tester.pumpWidget(MaterialApp(home: AnalysisScreen(result: result())));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('analysis-search')),
      'bob',
    );
    await tester.pump();

    expect(find.text('@alice'), findsNothing);
    expect(find.text('@bob'), findsOneWidget);
    expect(find.text('Takip Etmeyenler (2)'), findsOneWidget);
  });

  testWidgets('sort toggles between A-Z and Z-A', (tester) async {
    await tester.pumpWidget(MaterialApp(home: AnalysisScreen(result: result())));
    await tester.pumpAndSettle();

    final aliceBefore = tester.getTopLeft(find.text('@alice')).dy;
    final bobBefore = tester.getTopLeft(find.text('@bob')).dy;
    expect(aliceBefore, lessThan(bobBefore));

    await tester.tap(find.byKey(const ValueKey('analysis-sort-toggle')));
    await tester.pump();

    final aliceAfter = tester.getTopLeft(find.text('@alice')).dy;
    final bobAfter = tester.getTopLeft(find.text('@bob')).dy;
    expect(bobAfter, lessThan(aliceAfter));
    expect(find.text('Z-A'), findsOneWidget);
  });

  testWidgets('ignores one account and updates the category count',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: AnalysisScreen(result: result())));
    await tester.pumpAndSettle();

    expect(find.text('Takip Etmeyenler (2)'), findsOneWidget);
    expect(find.text('@alice'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_vert_rounded).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yok say'));
    await tester.pumpAndSettle();

    expect(find.text('@alice'), findsNothing);
    expect(find.text('@bob'), findsOneWidget);
    expect(find.text('Takip Etmeyenler (1)'), findsOneWidget);
    expect(find.text('@alice yok sayıldı.'), findsOneWidget);
  });
}
