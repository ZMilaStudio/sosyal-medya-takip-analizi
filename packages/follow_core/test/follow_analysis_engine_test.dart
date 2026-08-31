import 'package:follow_core/follow_core.dart';
import 'package:test/test.dart';

void main() {
  const engine = FollowAnalysisEngine();
  const account = SocialAccount(
    platform: SocialPlatform.instagram,
    username: 'owner',
  );

  SocialUser user(String username) => SocialUser(
        platform: SocialPlatform.instagram,
        username: username,
      );

  test('computes mutual, non-followers and fans', () {
    final snapshot = FollowSnapshot(
      account: account,
      capturedAt: DateTime.utc(2026, 8, 31),
      followers: [user('A'), user('B'), user('C')],
      following: [user('A'), user('B'), user('D')],
      sourceType: SnapshotSourceType.archive,
    );

    final result = engine.analyze(current: snapshot);

    expect(result.mutual.map((e) => e.username).toSet(), {'A', 'B'});
    expect(result.nonFollowers.map((e) => e.username).toSet(), {'D'});
    expect(result.fans.map((e) => e.username).toSet(), {'C'});
    expect(result.unfollowers, isEmpty);
    expect(result.newFollowers, isEmpty);
  });

  test('computes snapshot changes', () {
    final previous = FollowSnapshot(
      account: account,
      capturedAt: DateTime.utc(2026, 8, 1),
      followers: [user('A'), user('B'), user('C')],
      following: [user('A'), user('B'), user('D')],
      sourceType: SnapshotSourceType.archive,
    );

    final current = FollowSnapshot(
      account: account,
      capturedAt: DateTime.utc(2026, 8, 31),
      followers: [user('A'), user('C'), user('E')],
      following: [user('A'), user('D'), user('E')],
      sourceType: SnapshotSourceType.archive,
    );

    final result = engine.analyze(current: current, previous: previous);

    expect(result.unfollowers.map((e) => e.username).toSet(), {'B'});
    expect(result.newFollowers.map((e) => e.username).toSet(), {'E'});
    expect(result.newFollowing.map((e) => e.username).toSet(), {'E'});
    expect(result.noLongerFollowing.map((e) => e.username).toSet(), {'B'});
  });

  test('normalizes usernames for identity comparison', () {
    final snapshot = FollowSnapshot(
      account: account,
      capturedAt: DateTime.utc(2026, 8, 31),
      followers: [user('SomeUser')],
      following: [user('someuser')],
      sourceType: SnapshotSourceType.archive,
    );

    final result = engine.analyze(current: snapshot);
    expect(result.mutual.length, 1);
  });
}
