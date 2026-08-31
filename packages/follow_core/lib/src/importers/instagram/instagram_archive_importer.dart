import 'dart:convert';

import 'package:archive/archive.dart';

import '../../models/social_user.dart';
import 'instagram_relationship_parser.dart';

enum InstagramArchiveImportError {
  archiveTooLarge,
  invalidArchive,
  tooManyEntries,
  relationshipFileTooLarge,
  followersFileMissing,
  followingFileMissing,
  htmlExportNotSupported,
  unsafeRelationshipPath,
  invalidRelationshipFile,
}

class InstagramArchiveImportException implements Exception {
  const InstagramArchiveImportException(
    this.code, {
    this.path,
    this.message,
  });

  final InstagramArchiveImportError code;
  final String? path;
  final String? message;

  @override
  String toString() {
    final details = [
      if (path != null) 'path=$path',
      if (message != null) message!,
    ].join(', ');
    return 'InstagramArchiveImportException(${code.name}${details.isEmpty ? '' : ': $details'})';
  }
}

class InstagramArchiveImportResult {
  InstagramArchiveImportResult({
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

/// Reads Meta's official Instagram export ZIP without extracting it to disk.
///
/// For the first MVP this accepts an in-memory ZIP and deliberately limits the
/// archive size. The Flutter layer should guide users to export only
/// "Followers and following" data so the archive stays small. A streaming file
/// implementation can replace this later without changing the analysis model.
class InstagramArchiveImporter {
  const InstagramArchiveImporter({
    this.maxArchiveBytes = 128 * 1024 * 1024,
    this.maxEntries = 10000,
    this.maxRelationshipFileBytes = 32 * 1024 * 1024,
    this.relationshipParser = const InstagramRelationshipParser(),
  });

  final int maxArchiveBytes;
  final int maxEntries;
  final int maxRelationshipFileBytes;
  final InstagramRelationshipParser relationshipParser;

  InstagramArchiveImportResult importBytes(List<int> zipBytes) {
    if (zipBytes.length > maxArchiveBytes) {
      throw const InstagramArchiveImportException(
        InstagramArchiveImportError.archiveTooLarge,
      );
    }

    if (!_hasZipSignature(zipBytes)) {
      throw const InstagramArchiveImportException(
        InstagramArchiveImportError.invalidArchive,
      );
    }

    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(zipBytes);
    } on ArchiveException catch (error) {
      throw InstagramArchiveImportException(
        InstagramArchiveImportError.invalidArchive,
        message: error.toString(),
      );
    } on FormatException catch (error) {
      throw InstagramArchiveImportException(
        InstagramArchiveImportError.invalidArchive,
        message: error.message,
      );
    } on RangeError catch (error) {
      throw InstagramArchiveImportException(
        InstagramArchiveImportError.invalidArchive,
        message: error.toString(),
      );
    }

    if (archive.length > maxEntries) {
      throw const InstagramArchiveImportException(
        InstagramArchiveImportError.tooManyEntries,
      );
    }

    final followerEntries = <ArchiveFile>[];
    final followingEntries = <ArchiveFile>[];
    var hasFollowerHtml = false;
    var hasFollowingHtml = false;

    for (final entry in archive) {
      if (!entry.isFile) continue;

      switch (_classify(entry.name)) {
        case _RelationshipFileKind.followersJson:
          _validateRelationshipEntry(entry);
          followerEntries.add(entry);
        case _RelationshipFileKind.followingJson:
          _validateRelationshipEntry(entry);
          followingEntries.add(entry);
        case _RelationshipFileKind.followersHtml:
          hasFollowerHtml = true;
        case _RelationshipFileKind.followingHtml:
          hasFollowingHtml = true;
        case null:
          break;
      }
    }

    if (followerEntries.isEmpty && followingEntries.isEmpty &&
        (hasFollowerHtml || hasFollowingHtml)) {
      throw const InstagramArchiveImportException(
        InstagramArchiveImportError.htmlExportNotSupported,
      );
    }

    if (followerEntries.isEmpty) {
      throw const InstagramArchiveImportException(
        InstagramArchiveImportError.followersFileMissing,
      );
    }
    if (followingEntries.isEmpty) {
      throw const InstagramArchiveImportException(
        InstagramArchiveImportError.followingFileMissing,
      );
    }

    followerEntries.sort((a, b) => a.name.compareTo(b.name));
    followingEntries.sort((a, b) => a.name.compareTo(b.name));

    final followers = <String, SocialUser>{};
    final following = <String, SocialUser>{};

    for (final entry in followerEntries) {
      for (final user in _parseEntry(entry)) {
        followers[user.identityKey] = user;
      }
    }
    for (final entry in followingEntries) {
      for (final user in _parseEntry(entry)) {
        following[user.identityKey] = user;
      }
    }

    return InstagramArchiveImportResult(
      followers: followers.values,
      following: following.values,
      followerFiles: followerEntries.map((entry) => entry.name),
      followingFiles: followingEntries.map((entry) => entry.name),
    );
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

  List<SocialUser> _parseEntry(ArchiveFile entry) {
    final bytes = entry.readBytes();
    if (bytes == null || bytes.length > maxRelationshipFileBytes) {
      throw InstagramArchiveImportException(
        InstagramArchiveImportError.relationshipFileTooLarge,
        path: entry.name,
      );
    }

    try {
      final jsonText = utf8.decode(bytes, allowMalformed: false);
      return relationshipParser.parseJson(jsonText);
    } on FormatException catch (error) {
      throw InstagramArchiveImportException(
        InstagramArchiveImportError.invalidRelationshipFile,
        path: entry.name,
        message: error.message,
      );
    }
  }

  void _validateRelationshipEntry(ArchiveFile entry) {
    if (_hasUnsafePath(entry.name)) {
      throw InstagramArchiveImportException(
        InstagramArchiveImportError.unsafeRelationshipPath,
        path: entry.name,
      );
    }
    if (entry.size > maxRelationshipFileBytes) {
      throw InstagramArchiveImportException(
        InstagramArchiveImportError.relationshipFileTooLarge,
        path: entry.name,
      );
    }
  }

  bool _hasUnsafePath(String path) {
    final normalized = path.replaceAll('\\', '/');
    if (normalized.startsWith('/')) return true;
    return normalized.split('/').any((segment) => segment == '..');
  }

  _RelationshipFileKind? _classify(String path) {
    final normalized = path.replaceAll('\\', '/');
    final basename = normalized.split('/').last;

    if (RegExp(r'^followers(?:_\d+)?\.json$', caseSensitive: false)
        .hasMatch(basename)) {
      return _RelationshipFileKind.followersJson;
    }
    if (RegExp(r'^following(?:_\d+)?\.json$', caseSensitive: false)
        .hasMatch(basename)) {
      return _RelationshipFileKind.followingJson;
    }
    if (RegExp(r'^followers(?:_\d+)?\.html$', caseSensitive: false)
        .hasMatch(basename)) {
      return _RelationshipFileKind.followersHtml;
    }
    if (RegExp(r'^following(?:_\d+)?\.html$', caseSensitive: false)
        .hasMatch(basename)) {
      return _RelationshipFileKind.followingHtml;
    }
    return null;
  }
}

enum _RelationshipFileKind {
  followersJson,
  followingJson,
  followersHtml,
  followingHtml,
}
