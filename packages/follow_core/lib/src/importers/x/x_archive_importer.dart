import 'dart:convert';

import 'package:archive/archive.dart';

import '../../models/social_user.dart';
import 'x_relationship_parser.dart';

enum XArchiveImportError {
  archiveTooLarge,
  invalidArchive,
  tooManyEntries,
  relationshipFileTooLarge,
  followersFileMissing,
  followingFileMissing,
  unsafeRelationshipPath,
  invalidRelationshipFile,
}

class XArchiveImportException implements Exception {
  const XArchiveImportException(
    this.code, {
    this.path,
    this.message,
  });

  final XArchiveImportError code;
  final String? path;
  final String? message;

  @override
  String toString() {
    final details = [
      if (path != null) 'path=$path',
      if (message != null) message!,
    ].join(', ');
    return 'XArchiveImportException(${code.name}${details.isEmpty ? '' : ': $details'})';
  }
}

class XArchiveImportResult {
  XArchiveImportResult({
    required Iterable<SocialUser> followers,
    required Iterable<SocialUser> following,
    required Iterable<String> followerFiles,
    required Iterable<String> followingFiles,
  })  : followers = Set.unmodifiable(followers),
        following = Set.unmodifiable(following),
        followerFiles = List.unmodifiable(followerFiles),
        followingFiles = List.unmodifiable(followingFiles);

  final Set<SocialUser> followers;
  final Set<SocialUser> following;
  final List<String> followerFiles;
  final List<String> followingFiles;
}

/// Reads relationship data from X's official account archive.
///
/// Small/medium archives can be imported as a ZIP. For very large X archives,
/// callers can extract the archive and pass only `follower.js` and
/// `following.js` through [importRelationshipFiles], avoiding media-heavy ZIP
/// loading on mobile devices.
class XArchiveImporter {
  const XArchiveImporter({
    this.maxArchiveBytes = 512 * 1024 * 1024,
    this.maxEntries = 50000,
    this.maxRelationshipFileBytes = 32 * 1024 * 1024,
    this.relationshipParser = const XRelationshipParser(),
  });

  final int maxArchiveBytes;
  final int maxEntries;
  final int maxRelationshipFileBytes;
  final XRelationshipParser relationshipParser;

  XArchiveImportResult importBytes(List<int> zipBytes) {
    if (zipBytes.length > maxArchiveBytes) {
      throw const XArchiveImportException(XArchiveImportError.archiveTooLarge);
    }
    if (!_hasZipSignature(zipBytes)) {
      throw const XArchiveImportException(XArchiveImportError.invalidArchive);
    }

    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(zipBytes);
    } on ArchiveException catch (error) {
      throw XArchiveImportException(
        XArchiveImportError.invalidArchive,
        message: error.toString(),
      );
    } on FormatException catch (error) {
      throw XArchiveImportException(
        XArchiveImportError.invalidArchive,
        message: error.message,
      );
    } on RangeError catch (error) {
      throw XArchiveImportException(
        XArchiveImportError.invalidArchive,
        message: error.toString(),
      );
    }

    if (archive.length > maxEntries) {
      throw const XArchiveImportException(XArchiveImportError.tooManyEntries);
    }

    final relationshipFiles = <String, List<int>>{};
    for (final entry in archive) {
      if (!entry.isFile || _classify(entry.name) == null) continue;
      _validatePathAndSize(entry.name, entry.size);

      final bytes = entry.readBytes();
      if (bytes == null) {
        throw XArchiveImportException(
          XArchiveImportError.invalidRelationshipFile,
          path: entry.name,
          message: 'Dosya arşivden okunamadı.',
        );
      }
      relationshipFiles[entry.name] = bytes;
    }

    return importRelationshipFiles(relationshipFiles);
  }

  XArchiveImportResult importRelationshipFiles(
    Map<String, List<int>> files,
  ) {
    final followerFiles = <String, List<int>>{};
    final followingFiles = <String, List<int>>{};

    for (final entry in files.entries) {
      final kind = _classify(entry.key);
      if (kind == null) continue;
      _validatePathAndSize(entry.key, entry.value.length);

      switch (kind) {
        case _XRelationshipFileKind.followers:
          followerFiles[entry.key] = entry.value;
        case _XRelationshipFileKind.following:
          followingFiles[entry.key] = entry.value;
      }
    }

    if (followerFiles.isEmpty) {
      throw const XArchiveImportException(
        XArchiveImportError.followersFileMissing,
      );
    }
    if (followingFiles.isEmpty) {
      throw const XArchiveImportException(
        XArchiveImportError.followingFileMissing,
      );
    }

    final followerNames = followerFiles.keys.toList()..sort();
    final followingNames = followingFiles.keys.toList()..sort();
    final followers = <String, SocialUser>{};
    final following = <String, SocialUser>{};

    for (final name in followerNames) {
      for (final user in _parseBytes(name, followerFiles[name]!)) {
        followers[user.identityKey] = user;
      }
    }
    for (final name in followingNames) {
      for (final user in _parseBytes(name, followingFiles[name]!)) {
        following[user.identityKey] = user;
      }
    }

    return XArchiveImportResult(
      followers: followers.values,
      following: following.values,
      followerFiles: followerNames,
      followingFiles: followingNames,
    );
  }

  List<SocialUser> _parseBytes(String name, List<int> bytes) {
    if (bytes.length > maxRelationshipFileBytes) {
      throw XArchiveImportException(
        XArchiveImportError.relationshipFileTooLarge,
        path: name,
      );
    }

    try {
      final text = utf8.decode(bytes, allowMalformed: false);
      return relationshipParser.parseJs(text);
    } on FormatException catch (error) {
      throw XArchiveImportException(
        XArchiveImportError.invalidRelationshipFile,
        path: name,
        message: error.message,
      );
    }
  }

  void _validatePathAndSize(String path, int size) {
    if (_hasUnsafePath(path)) {
      throw XArchiveImportException(
        XArchiveImportError.unsafeRelationshipPath,
        path: path,
      );
    }
    if (size > maxRelationshipFileBytes) {
      throw XArchiveImportException(
        XArchiveImportError.relationshipFileTooLarge,
        path: path,
      );
    }
  }

  _XRelationshipFileKind? _classify(String path) {
    final normalized = path.replaceAll('\\', '/');
    final basename = normalized.split('/').last;

    if (RegExp(r'^follower(?:[_-](?:part)?\d+)?\.js$', caseSensitive: false)
        .hasMatch(basename)) {
      return _XRelationshipFileKind.followers;
    }
    if (RegExp(r'^following(?:[_-](?:part)?\d+)?\.js$', caseSensitive: false)
        .hasMatch(basename)) {
      return _XRelationshipFileKind.following;
    }
    return null;
  }

  bool _hasUnsafePath(String path) {
    final normalized = path.replaceAll('\\', '/');
    if (normalized.startsWith('/')) return true;
    return normalized.split('/').any((segment) => segment == '..');
  }

  bool _hasZipSignature(List<int> bytes) {
    if (bytes.length < 4) return false;
    if (bytes[0] != 0x50 || bytes[1] != 0x4b) return false;

    final third = bytes[2];
    final fourth = bytes[3];
    return (third == 0x03 && fourth == 0x04) ||
        (third == 0x05 && fourth == 0x06) ||
        (third == 0x07 && fourth == 0x08);
  }
}

enum _XRelationshipFileKind {
  followers,
  following,
}
