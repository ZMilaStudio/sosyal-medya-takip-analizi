import 'package:archive/archive.dart';
import 'package:follow_core/follow_core.dart';
import 'package:test/test.dart';

void main() {
  const useCase = InstagramFollowAnalysisUseCase();
  const account = SocialAccount(
    platform: SocialPlatform.instagram,
    username: 'owner',
  );

  List<int> zip(Map<String, String> files) {
    final archive = Archive();
    for (final entry in files.entries) {
      archive.add(ArchiveFile.string(entry.key, entry.value));
    }
    return ZipEncoder().encodeBytes(archive);
  }

  String relationJson(Iterable<String> usernames) {
    final entries = usernames.map(
      (username) => '''
  {
    "string_list_data": [
      {
        "href": "https://www.instagram.com/$username/",
        "value": "$username",
        "timestamp": 1700000000
      }
    ]
  }''',
    );
    return '[${entries.join(',')}]';
  }

  SocialUser user(String username) => SocialUser(
        platform: SocialPlatform.instagram,
        username: username,
      );

  test('imports ZIP, builds snapshot and computes analysis end to end', () {
    final bytes = zip({
      'connections/followers_and_following/followers_1.json':
          relationJson(['A', 'B', 'C']),
      'connections/followers_and_following/following.json':
          relationJson(['A', 'B', 'D']),
    });

    final result = useCase.execute(
      zipBytes: bytes,
      account: account,
      capturedAt: DateTime.utc(2026, 8, 31),
    );

    expect(result.snapshot.followers.length, 3);
    expect(result.snapshot.following.length, 3);
    expect(result.snapshot.sourceType, SnapshotSourceType.archive);
    expect(result.snapshot.sourceFormat, 'instagram-export-json');
    expect(result.analysis.mutual.map((u) => u.username).toSet(), {'A', 'B'});
    expect(result.analysis.nonFollowers.map((u) => u.username).toSet(), {'D'});
    expect(result.analysis.fans.map((u) => u.username).toSet(), {'C'});
  });

  test('compares imported snapshot with previous snapshot', () {
    final previous = FollowSnapshot(
      account: account,
      capturedAt: DateTime.utc(2026, 8, 1),
      followers: [user('A'), user('B'), user('C')],
      following: [user('A'), user('B'), user('D')],
      sourceType: SnapshotSourceType.archive,
    );

    final bytes = zip({
      'followers_1.json': relationJson(['A', 'C', 'E']),
      'following.json': relationJson(['A', 'D', 'E']),
    });

    final result = useCase.execute(
      zipBytes: bytes,
      account: account,
      capturedAt: DateTime.utc(2026, 8, 31),
      previous: previous,
    );

    expect(result.analysis.unfollowers.map((u) => u.username).toSet(), {'B'});
    expect(result.analysis.newFollowers.map((u) => u.username).toSet(), {'E'});
    expect(result.analysis.newFollowing.map((u) => u.username).toSet(), {'E'});
    expect(
      result.analysis.noLongerFollowing.map((u) => u.username).toSet(),
      {'B'},
    );
  });

  test('records mixed source format', () {
    final bytes = zip({
      'followers_1.json': relationJson(['alice']),
      'following.html': '''
<html><body>
<a href="https://www.instagram.com/alice/">alice</a>
</body></html>
''',
    });

    final result = useCase.execute(
      zipBytes: bytes,
      account: account,
      capturedAt: DateTime.utc(2026, 8, 31),
    );

    expect(result.snapshot.sourceFormat, 'instagram-export-mixed');
  });

  test('rejects non-Instagram account', () {
    final bytes = zip({
      'followers_1.json': relationJson(['alice']),
      'following.json': relationJson(['alice']),
    });

    expect(
      () => useCase.execute(
        zipBytes: bytes,
        account: const SocialAccount(
          platform: SocialPlatform.x,
          username: 'owner',
        ),
        capturedAt: DateTime.utc(2026, 8, 31),
      ),
      throwsArgumentError,
    );
  });
}
