import 'dart:convert';

import '../../models/social_platform.dart';
import '../../models/social_user.dart';

/// Parses the JavaScript relationship files inside an official X data archive.
///
/// Current X archives expose relationship data as JavaScript assignments such
/// as `window.YTD.following.part0 = [...]` and `window.YTD.follower.part0 = [...]`.
/// The parser deliberately ignores the assignment prefix and reads only the JSON
/// array so minor namespace changes do not break imports.
class XRelationshipParser {
  const XRelationshipParser();

  List<SocialUser> parseJs(String source) {
    final jsonText = _extractJsonArray(source);
    final Object? decoded;
    try {
      decoded = jsonDecode(jsonText);
    } on JsonUnsupportedObjectError catch (error) {
      throw FormatException('X ilişki verisi çözümlenemedi: $error');
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

    final username = _firstUsername([
      payload['username'],
      payload['screenName'],
      payload['screen_name'],
      payload['handle'],
      payload['userLink'],
      payload['user_link'],
      payload['profileLink'],
      payload['profile_link'],
    ]);

    if (username == null) return null;

    return SocialUser(
      platform: SocialPlatform.x,
      username: username,
      platformUserId: accountId,
      profileUrl: Uri.https('x.com', '/$username'),
    );
  }

  Map<String, Object?>? _relationshipPayload(Map<String, Object?> entry) {
    for (final key in const ['following', 'follower']) {
      final value = entry[key];
      if (value is Map) return Map<String, Object?>.from(value);
    }

    // Some exports or transformed fixtures may expose the relationship object
    // directly instead of wrapping it in `following` / `follower`.
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

      final direct = _normalizeHandle(raw);
      if (direct != null) return direct;

      final fromUrl = _usernameFromUrl(raw);
      if (fromUrl != null) return fromUrl;
    }
    return null;
  }

  String? _normalizeHandle(String raw) {
    var value = raw.trim();
    if (value.startsWith('@')) value = value.substring(1);
    if (!_usernamePattern.hasMatch(value)) return null;
    return value;
  }

  String? _usernameFromUrl(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null || !uri.hasScheme || uri.pathSegments.isEmpty) return null;

    final host = uri.host.toLowerCase();
    if (host != 'x.com' &&
        host != 'www.x.com' &&
        host != 'twitter.com' &&
        host != 'www.twitter.com' &&
        host != 'mobile.twitter.com') {
      return null;
    }

    for (final segment in uri.pathSegments.reversed) {
      final username = _normalizeHandle(Uri.decodeComponent(segment));
      if (username != null) return username;
    }
    return null;
  }

  String? _stringValue(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static final RegExp _usernamePattern = RegExp(r'^[A-Za-z0-9_]{1,50}$');
}
