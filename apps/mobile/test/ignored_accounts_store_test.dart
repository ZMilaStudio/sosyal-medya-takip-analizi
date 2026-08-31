import 'package:flutter_test/flutter_test.dart';
import 'package:follow_core/follow_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sosyal_medya_takip_analizi/data/local/ignored_accounts_store.dart';

void main() {
  final store = IgnoredAccountsStore();
  const account = SocialAccount(
    platform: SocialPlatform.instagram,
    username: 'Owner.Account',
  );
  const user = SocialUser(
    platform: SocialPlatform.instagram,
    username: 'Ignored.User',
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('stores ignored users per Instagram owner account', () async {
    await store.ignore(account, user);

    expect(await store.loadFor(account), {'ignored.user'});
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
    expect(all.single.ownerUsername, 'owner.account');
    expect(all.single.ignoredUsername, 'ignored.user');
  });

  test('restores an ignored user without touching other accounts', () async {
    await store.ignore(account, user);
    await store.restore(
      ownerUsername: account.username,
      ignoredUsername: user.username,
    );

    expect(await store.loadFor(account), isEmpty);
  });
}
