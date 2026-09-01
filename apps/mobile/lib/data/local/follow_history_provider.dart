import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'follow_history_database.dart';

final followHistoryDatabaseProvider = Provider<FollowHistoryDatabase>((ref) {
  final database = FollowHistoryDatabase();
  ref.onDispose(database.close);
  return database;
});

final recentFollowAccountsProvider =
    FutureProvider<List<FollowSnapshotHistoryItem>>((ref) async {
  final database = ref.watch(followHistoryDatabaseProvider);
  final history = await database.listHistory();
  final seen = <String>{};
  final recent = <FollowSnapshotHistoryItem>[];

  for (final item in history) {
    final key = '${item.account.platform.name}:'
        '${item.account.username.trim().toLowerCase()}';
    if (!seen.add(key)) continue;
    recent.add(item);
    if (recent.length == 6) break;
  }

  return List.unmodifiable(recent);
});
