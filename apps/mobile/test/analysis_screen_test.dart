import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follow_core/follow_core.dart';
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

  testWidgets('filters users and toggles alphabetical sorting', (tester) async {
    final snapshot = FollowSnapshot(
      account: account,
      capturedAt: DateTime.utc(2026, 8, 31),
      followers: [user('mutual')],
      following: [user('mutual'), user('alice'), user('bob')],
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

    expect(find.text('@alice'), findsOneWidget);
    expect(find.text('@bob'), findsOneWidget);
    expect(find.text('A-Z'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'bob');
    await tester.pump();

    expect(find.text('@alice'), findsNothing);
    expect(find.text('@bob'), findsOneWidget);

    await tester.tap(find.byTooltip('Aramayı temizle'));
    await tester.pump();
    await tester.tap(find.text('A-Z'));
    await tester.pump();

    expect(find.text('Z-A'), findsOneWidget);
    expect(find.text('@alice'), findsOneWidget);
    expect(find.text('@bob'), findsOneWidget);
  });
}
