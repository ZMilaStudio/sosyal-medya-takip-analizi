import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:follow_core/follow_core.dart';
import 'package:test/test.dart';

void main() {
  const useCase = XFollowAnalysisUseCase();

  List<int> zip({required String followerJs, required String followingJs}) {
    final archive = Archive()
      ..add(ArchiveFile.string('data/follower.js', followerJs))
      ..add(ArchiveFile.string('data/following.js', followingJs));
    return ZipEncoder().encodeBytes(archive);
  }

  String follower(List<(String, String)> users) => '''
window.YTD.follower.part0 = [
${users.map((user) => '  {"follower":{"accountId":"${user.$2}","userLink":"https://x.com/${user.$1}"}}').join(',\n')}
]
''';

  String following(List<(String, String)> users) => '''
window.YTD.following.part0 = [
${users.map((user) => '  {"following":{"accountId":"${user.$2}","userLink":"https://x.com/${user.$1}"}}').join(',\n')}
]
''';

  const account = SocialAccount(
    platform: SocialPlatform.x,
    username: 'owner',
  );

  test('builds X snapshot and standard follow analysis from ZIP', () {
    final result = useCase.execute(
      zipBytes: zip(
        followerJs: follower([('alice', '1'), ('bob', '2')]),
        followingJs: following([('bob', '2'), ('carol', '3')]),
      ),
      account: account,
      capturedAt: DateTime.utc(2026, 9, 1, 12),
    );

    expect(result.snapshot.followers.map((user) => user.username).toSet(), {'alice', 'bob'});
    expect(result.snapshot.following.map((user) => user.username).toSet(), {'bob', 'carol'});
    expect(result.analysis.mutual.map((user) => user.username).toSet(), {'bob'});
    expect(result.analysis.nonFollowers.map((user) => user.username).toSet(), {'carol'});
    expect(result.analysis.fans.map((user) => user.username).toSet(), {'alice'});
    expect(result.snapshot.sourceFormat, 'x-archive-js');
  });

  test('builds the same analysis from extracted relationship files', () {
    final result = useCase.executeRelationshipFiles(
      files: {
        'follower.js': utf8.encode(follower([('alice', '1'), ('bob', '2')])),
        'following.js': utf8.encode(following([('bob', '2'), ('carol', '3')])),
      },
      account: account,
      capturedAt: DateTime.utc(2026, 9, 1, 12),
    );

    expect(result.analysis.mutual.map((user) => user.username).toSet(), {'bob'});
    expect(result.analysis.nonFollowers.map((user) => user.username).toSet(), {'carol'});
    expect(result.analysis.fans.map((user) => user.username).toSet(), {'alice'});
  });

  test('compares X archive against previous snapshot', () {
    final previous = FollowSnapshot(
      account: account,
      capturedAt: DateTime.utc(2026, 8, 1),
      followers: {
        const SocialUser(platform: SocialPlatform.x, username: 'left', platformUserId: '10'),
        const SocialUser(platform: SocialPlatform.x, username: 'kept', platformUserId: '20'),
      },
      following: const {},
      sourceType: SnapshotSourceType.archive,
    );

    final result = useCase.execute(
      zipBytes: zip(
        followerJs: follower([('kept', '20'), ('newcomer', '30')]),
        followingJs: following([('kept', '20')]),
      ),
      account: account,
      capturedAt: DateTime.utc(2026, 9, 1),
      previous: previous,
    );

    expect(result.analysis.unfollowers.map((user) => user.username).toSet(), {'left'});
    expect(result.analysis.newFollowers.map((user) => user.username).toSet(), {'newcomer'});
  });

  test('rejects non-X account', () {
    expect(
      () => useCase.execute(
        zipBytes: const [],
        account: const SocialAccount(
          platform: SocialPlatform.instagram,
          username: 'owner',
        ),
        capturedAt: DateTime.utc(2026, 9, 1),
      ),
      throwsArgumentError,
    );
  });
}
