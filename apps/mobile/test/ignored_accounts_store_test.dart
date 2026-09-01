import 'package:flutter_test/flutter_test.dart';
import 'package:follow_core/follow_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sosyal_medya_takip_analizi/data/local/ignored_accounts_store.dart';

void main() {
  final store = IgnoredAccountsStore();
  const instagramAccount = SocialAccount(
    platform: SocialPlatform.instagram,
    username: 'Owner.Account',
  );
  const instagramUser = SocialUser(
    platform: SocialPlatform.instagram,
    username: 'Ignored.User',
  );
  const xAccount = SocialAccount(
    platform: SocialPlatform.x,
    username: 'Owner_Account',
  );
  const xUser = SocialUser(
    platform: SocialPlatform.x,
    username: 'Ignored_User',
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('stores ignored users per owner and social platform', () async {
    await store.ignore(instagramAccount, instagramUser);
    await store.ignore(xAccount, xUser);

    expect(await store.loadFor(instagramAccount), {'ignored.user'});
    expect(await store.loadFor(xAccount), {'ignored_user'});
    expect(
      await store.loadFor(
        const SocialAccount(
          platform: SocialPlatform.instagram,
          username: 'another.owner',
        ),
      ),
      isEmpty,
    );

    final all = await store.loadAll();
    expect(all, hasLength(2));
    expect(
      all.any(
        (record) =>
            record.platform == SocialPlatform.instagram &&
            record.ownerUsername == 'owner.account' &&
            record.ignoredUsername == 'ignored.user',
      ),
      isTrue,
    );
    expect(
      all.any(
        (record) =>
            record.platform == SocialPlatform.x &&
            record.ownerUsername == 'owner_account' &&
            record.ignoredUsername == 'ignored_user',
      ),
      isTrue,
    );
  });

  test('restores an ignored user without touching another platform', () async {
    await store.ignore(instagramAccount, instagramUser);
    await store.ignore(xAccount, xUser);

    await store.restore(
      platform: instagramAccount.platform,
      ownerUsername: instagramAccount.username,
      ignoredUsername: instagramUser.username,
    );

    expect(await store.loadFor(instagramAccount), isEmpty);
    expect(await store.loadFor(xAccount), {'ignored_user'});
  });
}
