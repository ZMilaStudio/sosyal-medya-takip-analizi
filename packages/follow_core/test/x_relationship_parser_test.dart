import 'package:follow_core/follow_core.dart';
import 'package:test/test.dart';

void main() {
  const parser = XRelationshipParser();

  test('parses direct profile links from official assignment format', () {
    final users = parser.parseJs('''
window.YTD.following.part0 = [
  {"following":{"accountId":"101","userLink":"https://twitter.com/Alice"}},
  {"following":{"accountId":"202","userLink":"https://x.com/bob"}}
]
''');

    expect(users.map((user) => user.username).toSet(), {'Alice', 'bob'});
    expect(users.map((user) => user.platformUserId).toSet(), {'101', '202'});
    expect(users.every((user) => user.platform == SocialPlatform.x), isTrue);
  });

  test('uses stable account id when archive link has no handle', () {
    final users = parser.parseJs('''
window.YTD.follower.part0 = [
  {"follower":{"accountId":"755137239156490240","userLink":"https://twitter.com/intent/user?user_id=755137239156490240"}}
]
''');

    expect(users, hasLength(1));
    expect(users.single.username, 'id_755137239156490240');
    expect(users.single.platformUserId, '755137239156490240');
    expect(
      users.single.profileUrl.toString(),
      'https://twitter.com/intent/user?user_id=755137239156490240',
    );
  });

  test('parses follower wrapper and explicit username fallback', () {
    final users = parser.parseJs('''
window.YTD.follower.part0 = [
  {"follower":{"accountId":"303","userLink":"https://mobile.twitter.com/carol/"}},
  {"follower":{"accountId":"404","username":"dave_dev"}}
]
''');

    expect(users.map((user) => user.username).toSet(), {'carol', 'dave_dev'});
  });

  test('deduplicates records by stable X account id', () {
    final users = parser.parseJs('''
[
  {"follower":{"accountId":"303","userLink":"https://x.com/Carol"}},
  {"follower":{"accountId":"303","userLink":"https://x.com/carol"}}
]
''');

    expect(users, hasLength(1));
    expect(users.single.platformUserId, '303');
  });

  test('rejects source without JSON array', () {
    expect(
      () => parser.parseJs('window.YTD.following.part0 = null;'),
      throwsFormatException,
    );
  });
}
