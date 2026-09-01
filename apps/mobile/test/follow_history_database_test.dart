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

  test('history summaries contain counts and newest first', () async {
    await database.saveSnapshot(
      snapshot(
        capturedAt: DateTime.utc(2026, 8, 1),
        followers: [user('A')],
        following: [user('A'), user('B')],
      ),
    );
    await database.saveSnapshot(
      snapshot(
        capturedAt: DateTime.utc(2026, 8, 31),
        followers: [user('A'), user('C')],
        following: [user('A')],
      ),
    );

    final history = await database.listHistory(
      platform: SocialPlatform.instagram,
    );

    expect(history.length, 2);
    expect(history.first.capturedAt, DateTime.utc(2026, 8, 31));
    expect(history.first.followersCount, 2);
    expect(history.first.followingCount, 1);
  });

  test('loads previous snapshot for a history item', () async {
    await database.saveSnapshot(
      snapshot(
        capturedAt: DateTime.utc(2026, 8, 1),
        followers: [user('A'), user('B')],
        following: [user('A')],
      ),
    );
    await database.saveSnapshot(
      snapshot(
        capturedAt: DateTime.utc(2026, 8, 31),
        followers: [user('A')],
        following: [user('A')],
      ),
    );

    final history = await database.listHistory();
    final current = await database.snapshotById(history.first.snapshotId);
    final previous =
        await database.previousSnapshotBefore(history.first.snapshotId);

    expect(current!.capturedAt, DateTime.utc(2026, 8, 31));
    expect(previous!.capturedAt, DateTime.utc(2026, 8, 1));

    final analysis = const FollowAnalysisEngine().analyze(
      current: current,
      previous: previous,
    );
    expect(analysis.unfollowers.map((u) => u.username).toSet(), {'B'});
  });

  test('deletes one snapshot and removes users no longer referenced', () async {
    await database.saveSnapshot(
      snapshot(
        capturedAt: DateTime.utc(2026, 8, 1),
        followers: [user('onlyOld'), user('shared')],
        following: [user('shared')],
      ),
    );
    await database.saveSnapshot(
      snapshot(
        capturedAt: DateTime.utc(2026, 8, 31),
        followers: [user('shared'), user('current')],
        following: [user('shared')],
      ),
    );

    final history = await database.listHistory();
    final oldItem = history.last;
    await database.deleteSnapshot(oldItem.snapshotId);

    final remaining = await database.listHistory();
    expect(remaining, hasLength(1));
    expect(remaining.single.capturedAt, DateTime.utc(2026, 8, 31));
    expect(await database.snapshotById(oldItem.snapshotId), isNull);

    final storedUsers = await database.select(database.storedSocialUsers).get();
    expect(storedUsers.map((row) => row.username).toSet(), {'shared', 'current'});
  });

  test('keeps only the configured number of newest snapshots', () async {
    for (var day = 1; day <= 4; day++) {
      await database.saveSnapshot(
        snapshot(
          capturedAt: DateTime.utc(2026, 8, day),
          followers: [user('user$day')],
          following: [user('user$day')],
        ),
        keepLatest: 3,
      );
    }

    final history = await database.listHistory();
    expect(history.length, 3);
    expect(history.map((item) => item.capturedAt.day).toList(), [4, 3, 2]);

    final storedUsers = await database.select(database.storedSocialUsers).get();
    expect(storedUsers.map((row) => row.username).toSet(), {
      'user2',
      'user3',
      'user4',
    });
  });
}
