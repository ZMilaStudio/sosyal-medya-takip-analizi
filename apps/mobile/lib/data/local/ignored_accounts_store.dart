import 'package:follow_core/follow_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IgnoredAccountRecord {
  const IgnoredAccountRecord({
    required this.platform,
    required this.ownerUsername,
    required this.ignoredUsername,
  });

  final SocialPlatform platform;
  final String ownerUsername;
  final String ignoredUsername;
}

class IgnoredAccountsStore {
  static const _rootPrefix = 'ignored_accounts.';

  Future<Set<String>> loadFor(SocialAccount account) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key(account)) ?? const <String>[])
        .map(_normalize)
        .where((value) => value.isNotEmpty)
        .toSet();
  }

  Future<void> ignore(SocialAccount account, SocialUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _key(account);
    final values = (prefs.getStringList(key) ?? const <String>[])
        .map(_normalize)
        .where((value) => value.isNotEmpty)
        .toSet()
      ..add(user.normalizedUsername);
    final sorted = values.toList()..sort();
    await prefs.setStringList(key, sorted);
  }

  Future<void> restore({
    required SocialPlatform platform,
    required String ownerUsername,
    required String ignoredUsername,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyFromParts(platform, ownerUsername);
    final values = (prefs.getStringList(key) ?? const <String>[])
        .map(_normalize)
        .where((value) => value.isNotEmpty)
        .toSet()
      ..remove(_normalize(ignoredUsername));

    if (values.isEmpty) {
      await prefs.remove(key);
      return;
    }

    final sorted = values.toList()..sort();
    await prefs.setStringList(key, sorted);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_rootPrefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  Future<List<IgnoredAccountRecord>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final records = <IgnoredAccountRecord>[];

    for (final key in prefs.getKeys().where((key) => key.startsWith(_rootPrefix))) {
      final parsed = _parseKey(key);
      if (parsed == null) continue;
      final ignored = prefs.getStringList(key) ?? const <String>[];
      for (final username in ignored) {
        final normalized = _normalize(username);
        if (normalized.isEmpty) continue;
        records.add(
          IgnoredAccountRecord(
            platform: parsed.$1,
            ownerUsername: parsed.$2,
            ignoredUsername: normalized,
          ),
        );
      }
    }

    records.sort((a, b) {
      final platformCompare = a.platform.name.compareTo(b.platform.name);
      if (platformCompare != 0) return platformCompare;
      final ownerCompare = a.ownerUsername.compareTo(b.ownerUsername);
      if (ownerCompare != 0) return ownerCompare;
      return a.ignoredUsername.compareTo(b.ignoredUsername);
    });
    return records;
  }

  String _key(SocialAccount account) =>
      _keyFromParts(account.platform, account.username);

  String _keyFromParts(SocialPlatform platform, String ownerUsername) =>
      '$_rootPrefix${platform.name}.${_normalize(ownerUsername)}';

  (SocialPlatform, String)? _parseKey(String key) {
    final suffix = key.substring(_rootPrefix.length);
    final separator = suffix.indexOf('.');
    if (separator <= 0 || separator == suffix.length - 1) return null;

    final platformName = suffix.substring(0, separator);
    final owner = suffix.substring(separator + 1);
    SocialPlatform platform;
    try {
      platform = SocialPlatform.values.byName(platformName);
    } on ArgumentError {
      return null;
    }
    return (platform, owner);
  }

  String _normalize(String value) =>
      value.trim().replaceFirst(RegExp(r'^@'), '').toLowerCase();
}
