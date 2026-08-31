import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'follow_history_database.dart';

final followHistoryDatabaseProvider = Provider<FollowHistoryDatabase>((ref) {
  final database = FollowHistoryDatabase();
  ref.onDispose(database.close);
  return database;
});
