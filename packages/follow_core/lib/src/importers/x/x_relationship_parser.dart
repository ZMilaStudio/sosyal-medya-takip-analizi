import 'dart:convert';

import '../../models/social_platform.dart';
import '../../models/social_user.dart';

/// Parses the JavaScript relationship files inside an official X data archive.
///
/// X archives expose relationship data as JavaScript assignments such as
/// `window.YTD.following.part0 = [...]` and `window.YTD.follower.part0 = [...]`.
/// Depending on archive generation, `userLink` may be a direct profile URL or
/// an `intent/user?user_id=...` URL that contains no handle. Stable account IDs
/// are therefore treated as the canonical identity whenever available.
class XRelationshipParser {
  const XRelationshipParser();

  List<SocialUser> parseJs(String source) {
    final jsonText = _extractJsonArray(source);
    final Object? decoded;
    try {
      decoded = jsonDecode(jsonText);
    } on FormatException {
      rethrow;
    }

    if (decoded is! List) {
      throw const FormatException('X ilişki dosyasının kökü bir liste olmalı.');
    }

    final usersByIdentity = <String, SocialUser>{};
    for (final entry in decoded) {
      final user = _parseEntry(entry);
      if (user != null) {
        usersByIdentity[user.identityKey] = user;
      }
    }

    return List.unmodifiable(usersByIdentity.values);
  }

  String _extractJsonArray(String source) {
    final text = source.replaceFirst('\uFEFF', '').trim();
    final start = text.indexOf('[');
    final end = text.lastIndexOf(']');
    if (start < 0 || end < start) {
      throw const FormatException('X ilişki dosyasında JSON listesi bulunamadı.');
    }
    return text.substring(start, end + 1);
  }

  SocialUser? _parseEntry(Object? entry) {
    if (entry is! Map) return null;

    final map = Map<String, Object?>.from(entry);
    final payload = _relationshipPayload(map);
    if (payload == null) return null;

    final accountId = _stringValue(payload['accountId']) ??
        _stringValue(payload['account_id']) ??
        _stringValue(payload['id']);
    final rawLink = _firstString([
      payload['userLink'],
      payload['user_link'],
      payload['profileLink'],
      payload['profile_link'],
    ]);

    final username = _firstUsername([
          payload['username'],
          payload['screenName'],
          payload['screen_name'],
          payload['handle'],
        ]) ??
        _usernameFromUrl(rawLink) ??
        _fallbackUsername(accountId);

    if (username == null) return null;

    return SocialUser(
      platform: SocialPlatform.x,
      username: username,
      platformUserId: accountId,
      profileUrl: _profileUrl(rawLink, username),
    );
  }

  Map<String, Object?>? _relationshipPayload(Map<String, Object?> entry) {
    for (final key in const ['following', 'follower']) {
      final value = entry[key];
      if (value is Map) return Map<String, Object?>.from(value);
    }

    if (entry.containsKey('accountId') ||
        entry.containsKey('userLink') ||
        entry.containsKey('username')) {
      return entry;
    }
    return null;
  }

  String? _firstUsername(Iterable<Object?> values) {
    for (final value in values) {
      final raw = _stringValue(value);
      if (raw == null) continue;
      final username = _normalizeHandle(raw);
      if (username != null) return username;
    }
    return null;
  }

  String? _firstString(Iterable<Object?> values) {
    for (final value in values) {
      final text = _stringValue(value);
      if (text != null) return text;
    }
    return null;
  }

  String? _normalizeHandle(String raw) {
    var value = raw.trim();
    if (value.startsWith('@')) value = value.substring(1);
    if (!_usernamePattern.hasMatch(value)) return null;
    return value;
  }

  String? _usernameFromUrl(String? raw) {
    if (raw == null) return null;
    final uri = Uri.tryParse(raw.trim());
    if (uri == null || !uri.hasScheme || uri.pathSegments.isEmpty) return null;
    if (!_isXHost(uri.host)) return null;

    // Intent links identify the account by query-string user_id, not handle.
    // Never interpret the literal `/intent/user` path as a username.
    if (uri.pathSegments.first.toLowerCase() == 'intent') return null;

    if (uri.pathSegments.length != 1) return null;
    final candidate = Uri.decodeComponent(uri.pathSegments.single);
    if (_reservedPathSegments.contains(candidate.toLowerCase())) return null;
    return _normalizeHandle(candidate);
  }

  Uri? _profileUrl(String? rawLink, String username) {
    if (rawLink != null) {
      final parsed = Uri.tryParse(rawLink.trim());
      if (parsed != null && parsed.hasScheme && _isXHost(parsed.host)) {
        return parsed;
      }
    }

    if (_isFallbackUsername(username)) return null;
    return Uri.https('x.com', '/$username');
  }

  bool _isXHost(String host) {
    final normalized = host.toLowerCase();
    return normalized == 'x.com' ||
        normalized == 'www.x.com' ||
        normalized == 'twitter.com' ||
        normalized == 'www.twitter.com' ||
        normalized == 'mobile.twitter.com';
  }

  String? _fallbackUsername(String? accountId) {
    if (accountId == null || !_accountIdPattern.hasMatch(accountId)) return null;
    return 'id_$accountId';
  }

  bool _isFallbackUsername(String username) => username.startsWith('id_');

  String? _stringValue(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static final RegExp _usernamePattern = RegExp(r'^[A-Za-z0-9_]{1,50}$');
  static final RegExp _accountIdPattern = RegExp(r'^\d+$');
  static const _reservedPathSegments = {
    'home',
    'intent',
    'search',
    'settings',
    'explore',
    'notifications',
    'messages',
    'compose',
    'i',
  };
}
