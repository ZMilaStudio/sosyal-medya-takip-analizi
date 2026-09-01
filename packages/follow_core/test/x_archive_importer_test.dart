import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:follow_core/follow_core.dart';
import 'package:test/test.dart';

void main() {
  const importer = XArchiveImporter();

  List<int> zip(Map<String, String> files) {
    final archive = Archive();
    for (final entry in files.entries) {
      archive.add(ArchiveFile.string(entry.key, entry.value));
    }
    return ZipEncoder().encodeBytes(archive);
  }

  String following(String username, String id) => '''
window.YTD.following.part0 = [
  {"following":{"accountId":"$id","userLink":"https://x.com/$username"}}
]
''';

  String follower(String username, String id) => '''
window.YTD.follower.part0 = [
  {"follower":{"accountId":"$id","userLink":"https://twitter.com/$username"}}
]
''';

  test('imports follower.js and following.js from nested data folder', () {
    final bytes = zip({
      'your-x-archive/data/follower.js': follower('alice', '1'),
      'your-x-archive/data/following.js': following('bob', '2'),
      'your-x-archive/data/tweets.js': 'ignored',
      'your-x-archive/assets/image.jpg': 'ignored media',
    });

    final result = importer.importBytes(bytes);

    expect(result.followers.map((user) => user.username), ['alice']);
    expect(result.following.map((user) => user.username), ['bob']);
    expect(result.followerFiles, ['your-x-archive/data/follower.js']);
    expect(result.followingFiles, ['your-x-archive/data/following.js']);
  });

  test('imports extracted follower.js and following.js without ZIP', () {
    final result = importer.importRelationshipFiles({
      'follower.js': utf8.encode(follower('alice', '1')),
      'following.js': utf8.encode(following('bob', '2')),
    });

    expect(result.followers.map((user) => user.username), ['alice']);
    expect(result.following.map((user) => user.username), ['bob']);
    expect(result.followerFiles, ['follower.js']);
    expect(result.followingFiles, ['following.js']);
  });

  test('merges supported multipart relationship filenames', () {
    final bytes = zip({
      'data/follower-part0.js': follower('alice', '1'),
      'data/follower-part1.js': follower('bob', '2'),
      'data/following.js': following('alice', '1'),
    });

    final result = importer.importBytes(bytes);
    expect(result.followers.map((user) => user.username).toSet(), {'alice', 'bob'});
    expect(result.following.map((user) => user.username).toSet(), {'alice'});
  });

  test('reports missing following relationship file', () {
    final bytes = zip({'data/follower.js': follower('alice', '1')});

    expect(
      () => importer.importBytes(bytes),
      throwsA(
        isA<XArchiveImportException>().having(
          (error) => error.code,
          'code',
          XArchiveImportError.followingFileMissing,
        ),
      ),
    );
  });

  test('direct import reports missing follower file', () {
    expect(
      () => importer.importRelationshipFiles({
        'following.js': utf8.encode(following('bob', '2')),
      }),
      throwsA(
        isA<XArchiveImportException>().having(
          (error) => error.code,
          'code',
          XArchiveImportError.followersFileMissing,
        ),
      ),
    );
  });

  test('rejects invalid ZIP bytes', () {
    expect(
      () => importer.importBytes([1, 2, 3, 4]),
      throwsA(
        isA<XArchiveImportException>().having(
          (error) => error.code,
          'code',
          XArchiveImportError.invalidArchive,
        ),
      ),
    );
  });

  test('rejects unsafe relationship path', () {
    final bytes = zip({
      '../follower.js': follower('alice', '1'),
      'following.js': following('bob', '2'),
    });

    expect(
      () => importer.importBytes(bytes),
      throwsA(
        isA<XArchiveImportException>().having(
          (error) => error.code,
          'code',
          XArchiveImportError.unsafeRelationshipPath,
        ),
      ),
    );
  });
}
