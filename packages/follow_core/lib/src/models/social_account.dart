import 'social_platform.dart';

class SocialAccount {
  const SocialAccount({
    required this.platform,
    required this.username,
    this.accountId,
    this.displayName,
  });

  final SocialPlatform platform;
  final String username;
  final String? accountId;
  final String? displayName;
}
