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

  InstagramFollowAnalysisResult result() {
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
    return InstagramFollowAnalysisResult(
      snapshot: snapshot,
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
