import 'package:follow_core/follow_core.dart';
import 'package:test/test.dart';

void main() {
  const parser = InstagramRelationshipParser();

  test('parses followers top-level list format', () {
    const json = '''
[
  {
    "string_list_data": [
      {
        "href": "https://www.instagram.com/alice/",
        "value": "alice",
        "timestamp": 1700000000
      }
    ]
  },
  {
    "string_list_data": [
      {
        "href": "https://www.instagram.com/bob/",
        "value": "bob",
        "timestamp": 1700000001
      }
    ]
  }
]
''';

    final users = parser.parseJson(json);
    expect(users.map((e) => e.username).toSet(), {'alice', 'bob'});
  });

  test('parses following wrapper format with value', () {
    const json = '''
{
  "relationships_following": [
    {
      "title": "",
      "string_list_data": [
        {
          "href": "https://www.instagram.com/carol/",
          "value": "carol",
          "timestamp": 1700000002
        }
      ]
    }
  ]
}
''';

    final users = parser.parseJson(json);
    expect(users.single.username, 'carol');
  });

  test('parses current following format when username is stored in title', () {
    const json = '''
{
  "relationships_following": [
    {
      "title": "current.user",
      "string_list_data": [
        {
          "href": "https://www.instagram.com/current.user/",
          "timestamp": 1788174000
        }
      ]
    }
  ]
}
''';

    final users = parser.parseJson(json);
    expect(users.single.username, 'current.user');
    expect(
      users.single.profileUrl,
      Uri.parse('https://www.instagram.com/current.user/'),
    );
  });

  test('falls back to Instagram profile URL when value and title are empty', () {
    const json = '''
{
  "relationships_following": [
    {
      "title": "",
      "string_list_data": [
        {
          "href": "https://www.instagram.com/url.fallback/",
          "timestamp": 1788174001
        }
      ]
    }
  ]
}
''';

    final users = parser.parseJson(json);
    expect(users.single.username, 'url.fallback');
  });

  test('does not derive usernames from non-Instagram URLs', () {
    const json = '''
[
  {
    "title": "",
    "string_list_data": [
      {"href": "https://example.com/not-an-instagram-user"}
    ]
  }
]
''';

    final users = parser.parseJson(json);
    expect(users, isEmpty);
  });

  test('deduplicates usernames case-insensitively', () {
    const json = '''
[
  {"string_list_data": [{"value": "Alice"}]},
  {"string_list_data": [{"value": "alice"}]}
]
''';

    final users = parser.parseJson(json);
    expect(users.length, 1);
  });
}
