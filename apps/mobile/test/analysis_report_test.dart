import 'package:flutter_test/flutter_test.dart';
import 'package:follow_core/follow_core.dart';
import 'package:sosyal_medya_takip_analizi/features/analysis/application/analysis_report.dart';

void main() {
  SocialUser user(String username) => SocialUser(
        platform: SocialPlatform.instagram,
        username: username,
      );

  test('builds report with visible categories and excludes ignored users', () {
    const account = SocialAccount(
      platform: SocialPlatform.instagram,
      username: 'owner',
    );
    final snapshot = FollowSnapshot(
      account: account,
      capturedAt: DateTime.utc(2026, 9, 1, 12, 30),
      followers: [user('mutual'), user('fan')],
      following: [user('mutual'), user('nonfollower'), user('ignored')],
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

    final report = buildAnalysisTextReport(
      result,
      ignoredUsernames: const {'ignored'},
    );

    expect(report, contains('Platform: Instagram'));
    expect(report, contains('Hesap: @owner'));
    expect(report, contains('Takip Etmeyenler (1)'));
    expect(report, contains('Karşılıklı (1)'));
    expect(report, contains('Seni Takip Edenler (1)'));
    expect(report, contains('Takibi Bırakanlar (0)'));
    expect(report, contains('Yeni Takipçiler (0)'));
    expect(report, contains('@nonfollower'));
    expect(report, isNot(contains('@ignored')));
    expect(report, contains('Yok sayılan hesaplar'));
  });

  test('creates a filesystem friendly report filename', () {
    const account = SocialAccount(
      platform: SocialPlatform.x,
      username: 'Example_User',
    );
    final snapshot = FollowSnapshot(
      account: account,
      capturedAt: DateTime.utc(2026, 9, 1, 12, 30),
      followers: const [],
      following: const [],
      sourceType: SnapshotSourceType.archive,
      sourceFormat: 'x-archive-js',
    );
    final analysis = const FollowAnalysisEngine().analyze(current: snapshot);
    final result = XFollowAnalysisResult(
      snapshot: snapshot,
      analysis: analysis,
      followerSourceFiles: const [],
      followingSourceFiles: const [],
    );

    final fileName = analysisReportFileName(result);

    expect(fileName, startsWith('takip-analizi_x_example_user_'));
    expect(fileName, endsWith('.txt'));
  });
}
