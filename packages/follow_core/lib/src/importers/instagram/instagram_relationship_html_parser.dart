import 'package:html/parser.dart' as html_parser;

import '../../models/social_platform.dart';
import '../../models/social_user.dart';

/// Parses follower/following HTML files from Meta's official Instagram export.
///
/// Meta's markup and CSS class names may change, so this parser deliberately
/// does not depend on presentation classes. It extracts profile links and
/// validates Instagram-compatible usernames from their URL paths.
class InstagramRelationshipHtmlParser {
  const InstagramRelationshipHtmlParser();

  static final RegExp _usernamePattern = RegExp(r'^[A-Za-z0-9._]{1,30}$');

  static const Set<String> _reservedPaths = {
    'accounts',
    'about',
    'direct',
    'emails',
    'explore',
    'legal',
    'p',
    'reel',
    'reels',
    'stories',
  };

  List<SocialUser> parseHtml(String htmlText) {
    final document = html_parser.parse(htmlText);
    final users = <String, SocialUser>{};

    for (final anchor in document.querySelectorAll('a[href]')) {
      final href = anchor.attributes['href']?.trim();
      if (href == null || href.isEmpty) continue;

      final uri = Uri.tryParse(href);
      if (uri == null) continue;

      final username = _usernameFromUri(uri);
      if (username == null) continue;

      final profileUri = uri.hasScheme
          ? uri
          : Uri.parse('https://www.instagram.com/$username/');
      final user = SocialUser(
        platform: SocialPlatform.instagram,
        username: username,
        profileUrl: profileUri,
      );
      users[user.identityKey] = user;
    }

    return List.unmodifiable(users.values);
  }

  String? _usernameFromUri(Uri uri) {
    final host = uri.host.toLowerCase();
    if (host.isNotEmpty &&
        host != 'instagram.com' &&
        !host.endsWith('.instagram.com')) {
      return null;
    }

    final segments = uri.pathSegments
        .where((segment) => segment.trim().isNotEmpty)
        .toList(growable: false);
    if (segments.isEmpty) return null;

    var candidate = segments.first;
    if (candidate == '_u') {
      if (segments.length < 2) return null;
      candidate = segments[1];
    }

    try {
      candidate = Uri.decodeComponent(candidate).trim();
    } on FormatException {
      return null;
    }

    if (!_usernamePattern.hasMatch(candidate)) return null;
    if (_reservedPaths.contains(candidate.toLowerCase())) return null;
    return candidate;
  }
}
