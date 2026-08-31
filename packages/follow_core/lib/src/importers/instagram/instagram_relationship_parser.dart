import 'dart:convert';

import '../../models/social_platform.dart';
import '../../models/social_user.dart';

/// Parses Instagram relationship JSON files from Meta's official data export.
///
/// Export shapes have changed over time. Followers commonly store the username
/// in `string_list_data[].value`, while newer following exports can store the
/// username in the parent relationship object's `title` field instead.
class InstagramRelationshipParser {
  const InstagramRelationshipParser();

  List<SocialUser> parseJson(String jsonText) {
    final decoded = jsonDecode(jsonText);
    final users = <String, SocialUser>{};

    void walk(Object? node) {
      if (node is List) {
        for (final item in node) {
          walk(item);
        }
        return;
      }

      if (node is! Map) return;

      final map = Map<String, Object?>.from(node);
      final stringListData = map['string_list_data'];
      final parentTitle = map['title']?.toString().trim();

      if (stringListData is List) {
        for (final raw in stringListData) {
          if (raw is! Map) continue;
          final item = Map<String, Object?>.from(raw);
          final value = item['value']?.toString().trim();
          final hrefText = item['href']?.toString().trim();

          final username = _firstNonEmpty([
            value,
            parentTitle,
            _usernameFromInstagramHref(hrefText),
          ]);
          if (username == null) continue;

          final href = hrefText == null || hrefText.isEmpty
              ? null
              : Uri.tryParse(hrefText);

          final user = SocialUser(
            platform: SocialPlatform.instagram,
            username: username,
            profileUrl: href,
          );
          users[user.identityKey] = user;
        }
      }

      for (final value in map.values) {
        if (identical(value, stringListData)) continue;
        if (value is Map || value is List) walk(value);
      }
    }

    walk(decoded);
    return List.unmodifiable(users.values);
  }

  static String? _firstNonEmpty(Iterable<String?> values) {
    for (final value in values) {
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  static String? _usernameFromInstagramHref(String? hrefText) {
    if (hrefText == null || hrefText.isEmpty) return null;

    final uri = Uri.tryParse(hrefText);
    if (uri == null) return null;

    final host = uri.host.toLowerCase();
    if (host != 'instagram.com' && host != 'www.instagram.com') return null;

    final segments = uri.pathSegments.where((segment) => segment.isNotEmpty);
    if (segments.isEmpty) return null;
    return segments.first.trim();
  }
}
