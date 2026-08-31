import 'social_platform.dart';

class SocialUser {
  const SocialUser({
    required this.platform,
    required this.username,
    this.platformUserId,
    this.displayName,
    this.profileUrl,
  });

  final SocialPlatform platform;
  final String username;
  final String? platformUserId;
  final String? displayName;
  final Uri? profileUrl;

  String get normalizedUsername => username.trim().toLowerCase();

  String get identityKey {
    final id = platformUserId?.trim();
    if (id != null && id.isNotEmpty) {
      return '${platform.name}:id:$id';
    }
    return '${platform.name}:username:$normalizedUsername';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocialUser && identityKey == other.identityKey;

  @override
  int get hashCode => identityKey.hashCode;
}
