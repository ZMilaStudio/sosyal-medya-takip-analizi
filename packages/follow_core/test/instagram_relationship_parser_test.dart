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

  test('parses following wrapper format', () {
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
