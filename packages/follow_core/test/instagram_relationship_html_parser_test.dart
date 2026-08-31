import 'package:follow_core/follow_core.dart';
import 'package:test/test.dart';

void main() {
  const parser = InstagramRelationshipHtmlParser();

  test('extracts Instagram usernames from profile anchors', () {
    const html = '''
<!doctype html>
<html>
<body>
  <div><a href="https://www.instagram.com/alice/">alice</a></div>
  <div><a href="https://instagram.com/Bob_2">Profile</a></div>
  <div><a href="https://www.instagram.com/_u/carol.3/">carol.3</a></div>
</body>
</html>
''';

    final users = parser.parseHtml(html);
    expect(
      users.map((user) => user.username).toSet(),
      {'alice', 'Bob_2', 'carol.3'},
    );
  });

  test('ignores non-profile and non-Instagram links', () {
    const html = '''
<html><body>
  <a href="https://www.instagram.com/explore/">Explore</a>
  <a href="https://www.instagram.com/p/ABC123/">Post</a>
  <a href="https://example.com/not_a_user">Other site</a>
  <a href="https://evilinstagram.com/fake_user">Fake host</a>
</body></html>
''';

    expect(parser.parseHtml(html), isEmpty);
  });

  test('deduplicates usernames case-insensitively', () {
    const html = '''
<html><body>
  <a href="https://www.instagram.com/Alice/">Alice</a>
  <a href="https://www.instagram.com/alice/">alice</a>
</body></html>
''';

    expect(parser.parseHtml(html).length, 1);
  });
}
