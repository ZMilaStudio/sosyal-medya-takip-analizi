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

  test('deduplicates users across follower parts', () {
    final bytes = zip({
      'followers_1.json': relationJson('Alice'),
      'followers_2.json': relationJson('alice'),
      'following.json': relationJson('alice'),
    });

    final result = importer.importBytes(bytes);
    expect(result.followers.length, 1);
  });

  test('reports missing following JSON', () {
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

  test('detects HTML-only export as unsupported for current MVP', () {
    final bytes = zip({
      'connections/followers_and_following/followers_1.html': '<html></html>',
      'connections/followers_and_following/following.html': '<html></html>',
    });

    expect(
      () => importer.importBytes(bytes),
      throwsA(
        isA<InstagramArchiveImportException>().having(
          (error) => error.code,
          'code',
          InstagramArchiveImportError.htmlExportNotSupported,
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
