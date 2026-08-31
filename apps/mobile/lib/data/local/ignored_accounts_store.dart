import 'package:follow_core/follow_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IgnoredAccountRecord {
  const IgnoredAccountRecord({
    required this.ownerUsername,
    required this.ignoredUsername,
  });

  final String ownerUsername;
  final String ignoredUsername;
}

class IgnoredAccountsStore {
  static const _prefix = 'ignored_accounts.instagram.';

  Future<Set<String>> loadFor(SocialAccount account) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key(account.username)) ?? const <String>[])
        .map(_normalize)
        .where((value) => value.isNotEmpty)
        .toSet();
  }

  Future<void> ignore(SocialAccount account, SocialUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _key(account.username);
    final values = (prefs.getStringList(key) ?? const <String>[])
        .map(_normalize)
        .where((value) => value.isNotEmpty)
        .toSet()
      ..add(user.normalizedUsername);
    final sorted = values.toList()..sort();
    await prefs.setStringList(key, sorted);
  }

  Future<void> restore({
    required String ownerUsername,
    required String ignoredUsername,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _key(ownerUsername);
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
    final keys = prefs.getKeys().where((key) => key.startsWith(_prefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  Future<List<IgnoredAccountRecord>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final records = <IgnoredAccountRecord>[];

    for (final key in prefs.getKeys().where((key) => key.startsWith(_prefix))) {
      final owner = key.substring(_prefix.length);
      final ignored = prefs.getStringList(key) ?? const <String>[];
      for (final username in ignored) {
        final normalized = _normalize(username);
        if (normalized.isEmpty) continue;
        records.add(
          IgnoredAccountRecord(
            ownerUsername: owner,
            ignoredUsername: normalized,
          ),
        );
      }
    }

    records.sort((a, b) {
      final ownerCompare = a.ownerUsername.compareTo(b.ownerUsername);
      if (ownerCompare != 0) return ownerCompare;
      return a.ignoredUsername.compareTo(b.ignoredUsername);
    });
    return records;
  }

  String _key(String ownerUsername) => '$_prefix${_normalize(ownerUsername)}';

  String _normalize(String value) =>
      value.trim().replaceFirst(RegExp(r'^@'), '').toLowerCase();
}
