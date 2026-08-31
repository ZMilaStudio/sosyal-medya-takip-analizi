import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follow_core/follow_core.dart';
import 'package:sosyal_medya_takip_analizi/features/analysis/presentation/analysis_screen.dart';

void main() {
  SocialUser user(String username) => SocialUser(
        platform: SocialPlatform.instagram,
        username: username,
      );

  testWidgets('renders first MVP analysis rows and switches tabs', (tester) async {
    const account = SocialAccount(
      platform: SocialPlatform.instagram,
      username: 'owner',
    );
    final snapshot = FollowSnapshot(
      account: account,
      capturedAt: DateTime.utc(2026, 8, 31),
      followers: [user('mutual'), user('fan')],
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

    await tester.pumpWidget(MaterialApp(home: AnalysisScreen(result: result)));
    await tester.pumpAndSettle();

    expect(find.text('Takip Etmeyenler (2)'), findsOneWidget);
    expect(find.text('@alice'), findsOneWidget);
    expect(find.text('@bob'), findsOneWidget);

    await tester.tap(find.text('Karşılıklı (1)'));
    await tester.pumpAndSettle();

    expect(find.text('@mutual'), findsOneWidget);
  });
}
