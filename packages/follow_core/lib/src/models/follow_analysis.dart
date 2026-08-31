import 'social_user.dart';

class FollowAnalysis {
  const FollowAnalysis({
    required this.mutual,
    required this.nonFollowers,
    required this.fans,
    required this.unfollowers,
    required this.newFollowers,
    required this.newFollowing,
    required this.noLongerFollowing,
  });

  final Set<SocialUser> mutual;
  final Set<SocialUser> nonFollowers;
  final Set<SocialUser> fans;
  final Set<SocialUser> unfollowers;
  final Set<SocialUser> newFollowers;
  final Set<SocialUser> newFollowing;
  final Set<SocialUser> noLongerFollowing;
}
