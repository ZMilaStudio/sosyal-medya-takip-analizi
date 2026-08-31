import 'package:archive/archive.dart';
import 'package:follow_core/follow_core.dart';
import 'package:test/test.dart';

void main() {
  const importer = InstagramArchiveImporter();

  List<int> zip(Map<String, String> files) {
    final archive = Archive();
    for (final entry in files.entries) {
      archive.add(ArchiveFile.string(entry.key, entry.value));
    }
    return ZipEncoder().encodeBytes(archive);
  }

  String relationJson(String username) => '''
[
  {
    "string_list_data": [
      {
        "href": "https://www.instagram.com/$username/",
        "value": "$username",
        "timestamp": 1700000000
      }
    ]
  }
]
''';

  String relationHtml(String username) => '''
<!doctype html>
<html><body>
  <a target="_blank" href="https://www.instagram.com/$username/">$username</a>
</body></html>
''';

  test('discovers and merges multipart follower JSON files', () {
    final bytes = zip({
      'connections/followers_and_following/followers_1.json':
          relationJson('alice'),
      'connections/followers_and_following/followers_2.json':
          relationJson('bob'),
      'connections/followers_and_following/following.json': '''
{
  "relationships_following": [
    {
      "string_list_data": [
        {"value": "alice", "href": "https://www.instagram.com/alice/"}
      ]
    },
    {
      "string_list_data": [
        {"value": "carol", "href": "https://www.instagram.com/carol/"}
      ]
    }
  ]
}
''',
      'media/photos/photo.jpg': 'not relationship data',
    });

    final result = importer.importBytes(bytes);

    expect(result.followers.map((u) => u.username).toSet(), {'alice', 'bob'});
    expect(result.following.map((u) => u.username).toSet(), {'alice', 'carol'});
    expect(result.followerFiles.length, 2);
    expect(result.followingFiles, [
      'connections/followers_and_following/following.json',
    ]);
  });

  test('imports HTML-only relationship export', () {
    final bytes = zip({
      'connections/followers_and_following/followers_1.html':
          relationHtml('alice'),
      'connections/followers_and_following/followers_2.html':
          relationHtml('bob'),
      'connections/followers_and_following/following.html':
          relationHtml('alice'),
    });

    final result = importer.importBytes(bytes);
    expect(result.followers.map((u) => u.username).toSet(), {'alice', 'bob'});
    expect(result.following.map((u) => u.username).toSet(), {'alice'});
  });

  test('supports mixed JSON and HTML relationship files', () {
    final bytes = zip({
      'followers_1.json': relationJson('alice'),
      'followers_2.html': relationHtml('bob'),
      'following.html': relationHtml('alice'),
    });

    final result = importer.importBytes(bytes);
    expect(result.followers.map((u) => u.username).toSet(), {'alice', 'bob'});
    expect(result.following.map((u) => u.username).toSet(), {'alice'});
  });

  test('deduplicates users across follower parts', () {
    final bytes = zip({
      'followers_1.json': relationJson('Alice'),
      'followers_2.html': relationHtml('alice'),
      'following.json': relationJson('alice'),
    });

    final result = importer.importBytes(bytes);
    expect(result.followers.length, 1);
  });

  test('reports missing following relationship file', () {
    final bytes = zip({
      'followers_1.json': relationJson('alice'),
    });

    expect(
      () => importer.importBytes(bytes),
      throwsA(
        isA<InstagramArchiveImportException>().having(
          (error) => error.code,
          'code',
          InstagramArchiveImportError.followingFileMissing,
        ),
      ),
    );
  });

  test('rejects archive over configured in-memory limit', () {
    final bytes = zip({
      'followers_1.json': relationJson('alice'),
      'following.json': relationJson('alice'),
    });
    const tinyImporter = InstagramArchiveImporter(maxArchiveBytes: 1);

    expect(
      () => tinyImporter.importBytes(bytes),
      throwsA(
        isA<InstagramArchiveImportException>().having(
          (error) => error.code,
          'code',
          InstagramArchiveImportError.archiveTooLarge,
        ),
      ),
    );
  });

  test('rejects invalid ZIP bytes', () {
    expect(
      () => importer.importBytes([1, 2, 3, 4]),
      throwsA(
        isA<InstagramArchiveImportException>().having(
          (error) => error.code,
          'code',
          InstagramArchiveImportError.invalidArchive,
        ),
      ),
    );
  });

  test('rejects unsafe relationship path', () {
    final bytes = zip({
      '../followers_1.json': relationJson('alice'),
      'following.json': relationJson('alice'),
    });

    expect(
      () => importer.importBytes(bytes),
      throwsA(
        isA<InstagramArchiveImportException>().having(
          (error) => error.code,
          'code',
          InstagramArchiveImportError.unsafeRelationshipPath,
        ),
      ),
    );
  });
}
