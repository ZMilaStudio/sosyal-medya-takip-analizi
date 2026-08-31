import 'social_account.dart';
import 'social_user.dart';

enum SnapshotSourceType { archive, api }

class FollowSnapshot {
  FollowSnapshot({
    required this.account,
    required this.capturedAt,
    required Iterable<SocialUser> followers,
    required Iterable<SocialUser> following,
    required this.sourceType,
    this.sourceFormat,
  })  : followers = Set.unmodifiable(followers),
        following = Set.unmodifiable(following);

  final SocialAccount account;
  final DateTime capturedAt;
  final Set<SocialUser> followers;
  final Set<SocialUser> following;
  final SnapshotSourceType sourceType;
  final String? sourceFormat;
}
