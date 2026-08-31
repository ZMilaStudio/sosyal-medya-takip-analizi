import '../models/follow_analysis.dart';
import '../models/follow_snapshot.dart';
import '../models/social_user.dart';

class FollowAnalysisEngine {
  const FollowAnalysisEngine();

  FollowAnalysis analyze({
    required FollowSnapshot current,
    FollowSnapshot? previous,
  }) {
    _ensureSameAccount(current, previous);

    final currentFollowers = _byKey(current.followers);
    final currentFollowing = _byKey(current.following);

    final followerKeys = currentFollowers.keys.toSet();
    final followingKeys = currentFollowing.keys.toSet();

    final mutualKeys = followerKeys.intersection(followingKeys);
    final nonFollowerKeys = followingKeys.difference(followerKeys);
    final fanKeys = followerKeys.difference(followingKeys);

    final previousFollowers = _byKey(previous?.followers ?? const <SocialUser>[]);
    final previousFollowing = _byKey(previous?.following ?? const <SocialUser>[]);

    final previousFollowerKeys = previousFollowers.keys.toSet();
    final previousFollowingKeys = previousFollowing.keys.toSet();

    final unfollowerKeys = previous == null
        ? <String>{}
        : previousFollowerKeys.difference(followerKeys);
    final newFollowerKeys = previous == null
        ? <String>{}
        : followerKeys.difference(previousFollowerKeys);
    final newFollowingKeys = previous == null
        ? <String>{}
        : followingKeys.difference(previousFollowingKeys);
    final noLongerFollowingKeys = previous == null
        ? <String>{}
        : previousFollowingKeys.difference(followingKeys);

    return FollowAnalysis(
      mutual: _users(mutualKeys, currentFollowers),
      nonFollowers: _users(nonFollowerKeys, currentFollowing),
      fans: _users(fanKeys, currentFollowers),
      unfollowers: _users(unfollowerKeys, previousFollowers),
      newFollowers: _users(newFollowerKeys, currentFollowers),
      newFollowing: _users(newFollowingKeys, currentFollowing),
      noLongerFollowing: _users(noLongerFollowingKeys, previousFollowing),
    );
  }

  Map<String, SocialUser> _byKey(Iterable<SocialUser> users) => {
        for (final user in users) user.identityKey: user,
      };

  Set<SocialUser> _users(
    Set<String> keys,
    Map<String, SocialUser> source,
  ) =>
      Set.unmodifiable(keys.map((key) => source[key]!).toSet());

  void _ensureSameAccount(FollowSnapshot current, FollowSnapshot? previous) {
    if (previous == null) return;

    final samePlatform = current.account.platform == previous.account.platform;
    final currentId = current.account.accountId?.trim();
    final previousId = previous.account.accountId?.trim();

    final sameIdentity = currentId != null &&
            currentId.isNotEmpty &&
            previousId != null &&
            previousId.isNotEmpty
        ? currentId == previousId
        : current.account.username.trim().toLowerCase() ==
            previous.account.username.trim().toLowerCase();

    if (!samePlatform || !sameIdentity) {
      throw ArgumentError('Snapshots must belong to the same social account.');
    }
  }
}
