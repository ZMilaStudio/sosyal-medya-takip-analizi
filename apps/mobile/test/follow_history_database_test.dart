import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:follow_core/follow_core.dart';
import 'package:sosyal_medya_takip_analizi/data/local/follow_history_database.dart';

void main() {
  late FollowHistoryDatabase database;

  const account = SocialAccount(
    platform: SocialPlatform.instagram,
    username: 'owner',
  );

  SocialUser user(String username) => SocialUser(
        platform: SocialPlatform.instagram,
        username: username,
      );

  FollowSnapshot snapshot({
    required DateTime capturedAt,
    required List<SocialUser> followers,
    required List<SocialUser> following,
  }) =>
      FollowSnapshot(
        account: account,
        capturedAt: capturedAt,
        followers: followers,
        following: following,
        sourceType: SnapshotSourceType.archive,
        sourceFormat: 'instagram-export-json',
      );

  setUp(() {
    database = FollowHistoryDatabase(executor: NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('saves and restores a snapshot', () async {
    final original = snapshot(
      capturedAt: DateTime.utc(2026, 8, 1),
      followers: [user('A'), user('B')],
      following: [user('A'), user('C')],
    );

    await database.saveSnapshot(original);
    final restored = await database.latestSnapshot(account);

    expect(restored, isNotNull);
    expect(restored!.capturedAt, original.capturedAt);
    expect(restored.followers.map((u) => u.username).toSet(), {'A', 'B'});
    expect(restored.following.map((u) => u.username).toSet(), {'A', 'C'});
  });

  test('returns the newest snapshot for an account', () async {
    await database.saveSnapshot(
      snapshot(
        capturedAt: DateTime.utc(2026, 8, 1),
        followers: [user('A')],
        following: [user('A')],
      ),
    );
    await database.saveSnapshot(
      snapshot(
        capturedAt: DateTime.utc(2026, 8, 31),
        followers: [user('A'), user('B')],
        following: [user('A')],
      ),
    );

    final restored = await database.latestSnapshot(account);
    expect(restored!.capturedAt, DateTime.utc(2026, 8, 31));
    expect(restored.followers.map((u) => u.username).toSet(), {'A', 'B'});
  });

  test('stores each social user once across snapshots', () async {
    await database.saveSnapshot(
      snapshot(
        capturedAt: DateTime.utc(2026, 8, 1),
        followers: [user('A')],
        following: [user('A')],
      ),
    );
    await database.saveSnapshot(
      snapshot(
        capturedAt: DateTime.utc(2026, 8, 31),
        followers: [user('A'), user('B')],
        following: [user('A')],
      ),
    );

    final storedUsers = await database.select(database.storedSocialUsers).get();
    expect(storedUsers.length, 2);
  });
}
