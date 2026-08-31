import 'dart:convert';

import '../../models/social_platform.dart';
import '../../models/social_user.dart';

/// Parses Instagram relationship JSON files from Meta's official data export.
///
/// Export shapes have changed over time. This parser intentionally accepts
/// both top-level arrays and wrapper maps (for example relationships_following)
/// and extracts entries containing string_list_data/value records.
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

      if (stringListData is List) {
        for (final raw in stringListData) {
          if (raw is! Map) continue;
          final item = Map<String, Object?>.from(raw);
          final value = item['value']?.toString().trim();
          if (value == null || value.isEmpty) continue;

          final hrefText = item['href']?.toString().trim();
          final href = hrefText == null || hrefText.isEmpty
              ? null
              : Uri.tryParse(hrefText);

          final user = SocialUser(
            platform: SocialPlatform.instagram,
            username: value,
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
}
