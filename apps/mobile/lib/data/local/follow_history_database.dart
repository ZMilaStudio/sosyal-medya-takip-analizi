import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:follow_core/follow_core.dart';

part 'follow_history_database.g.dart';

class FollowSnapshotHistoryItem {
  const FollowSnapshotHistoryItem({
    required this.snapshotId,
    required this.account,
    required this.capturedAt,
    required this.followersCount,
    required this.followingCount,
    this.sourceFormat,
  });

  final int snapshotId;
  final SocialAccount account;
  final DateTime capturedAt;
  final int followersCount;
  final int followingCount;
  final String? sourceFormat;
}

class StoredAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get platform => text()();
  TextColumn get username => text()();
  TextColumn get normalizedUsername => text()();
  TextColumn get platformAccountId => text().nullable()();
  TextColumn get displayName => text().nullable()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {platform, normalizedUsername},
      ];
}

class StoredSocialUsers extends Table {
  TextColumn get identityKey => text()();
  TextColumn get platform => text()();
  TextColumn get username => text()();
  TextColumn get normalizedUsername => text()();
  TextColumn get platformUserId => text().nullable()();
  TextColumn get displayName => text().nullable()();
  TextColumn get profileUrl => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {identityKey};
}

@TableIndex(
  name: 'stored_snapshots_account_captured_at',
  columns: {#accountId, #capturedAt},
)
class StoredSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(
        StoredAccounts,
        #id,
        onDelete: KeyAction.cascade,
      )();
  DateTimeColumn get capturedAt => dateTime()();
  TextColumn get sourceType => text()();
  TextColumn get sourceFormat => text().nullable()();
}

@TableIndex(
  name: 'stored_snapshot_relations_identity',
  columns: {#identityKey},
)
class StoredSnapshotRelations extends Table {
  IntColumn get snapshotId => integer().references(
        StoredSnapshots,
        #id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get identityKey => text().references(
        StoredSocialUsers,
        #identityKey,
      )();
  IntColumn get relation => integer()();

  @override
  Set<Column<Object>> get primaryKey => {snapshotId, identityKey};
}

@DriftDatabase(
  tables: [
    StoredAccounts,
    StoredSocialUsers,
    StoredSnapshots,
    StoredSnapshotRelations,
  ],
)
class FollowHistoryDatabase extends _$FollowHistoryDatabase {
  FollowHistoryDatabase({QueryExecutor? executor})
      : super(executor ?? driftDatabase(name: 'follow_history'));

  static const int defaultSnapshotRetention = 30;
  static const _followerBit = 1;
  static const _followingBit = 2;

  @override
  int get schemaVersion => 1;

  Future<void> saveSnapshot(
    FollowSnapshot snapshot, {
    int? keepLatest = defaultSnapshotRetention,
  }) async {
    await transaction(() async {
      final accountId = await _ensureAccount(snapshot.account);
      final snapshotId = await into(storedSnapshots).insert(
        StoredSnapshotsCompanion.insert(
          accountId: accountId,
          capturedAt: snapshot.capturedAt.toUtc(),
          sourceType: snapshot.sourceType.name,
          sourceFormat: Value(snapshot.sourceFormat),
        ),
      );

      final users = <String, SocialUser>{};
      final relations = <String, int>{};

      for (final user in snapshot.followers) {
        users[user.identityKey] = user;
        relations[user.identityKey] =
            (relations[user.identityKey] ?? 0) | _followerBit;
      }
      for (final user in snapshot.following) {
        users[user.identityKey] = user;
        relations[user.identityKey] =
            (relations[user.identityKey] ?? 0) | _followingBit;
      }

      if (users.isEmpty) return;

      await batch((batch) {
        batch.insertAllOnConflictUpdate(
          storedSocialUsers,
          users.values.map(_userCompanion),
        );
        batch.insertAll(
          storedSnapshotRelations,
          relations.entries.map(
            (entry) => StoredSnapshotRelationsCompanion.insert(
              snapshotId: snapshotId,
              identityKey: entry.key,
              relation: entry.value,
            ),
          ),
        );
      });
    });

    if (keepLatest != null) {
      await pruneHistory(snapshot.account, keepLatest: keepLatest);
    }
  }

  Future<FollowSnapshot?> latestSnapshot(SocialAccount account) async {
    final accountId = await _findAccountId(account);
    if (accountId == null) return null;

    final snapshotQuery = select(storedSnapshots)
      ..where((row) => row.accountId.equals(accountId))
      ..orderBy([(row) => OrderingTerm.desc(row.capturedAt)])
      ..limit(1);
    final snapshot = await snapshotQuery.getSingleOrNull();
    if (snapshot == null) return null;

    return _restoreSnapshot(snapshot, account);
  }

  Future<FollowSnapshot?> snapshotById(int snapshotId) async {
    final snapshotQuery = select(storedSnapshots)
      ..where((row) => row.id.equals(snapshotId))
      ..limit(1);
    final snapshot = await snapshotQuery.getSingleOrNull();
    if (snapshot == null) return null;

    final accountQuery = select(storedAccounts)
      ..where((row) => row.id.equals(snapshot.accountId))
      ..limit(1);
    final accountRow = await accountQuery.getSingleOrNull();
    if (accountRow == null) return null;

    return _restoreSnapshot(snapshot, _accountFromRow(accountRow));
  }

  Future<void> deleteSnapshot(int snapshotId) async {
    await transaction(() async {
      await (delete(storedSnapshotRelations)
            ..where((row) => row.snapshotId.equals(snapshotId)))
          .go();
      await (delete(storedSnapshots)..where((row) => row.id.equals(snapshotId)))
          .go();
      await _deleteOrphanUsers();
    });
  }

  Future<FollowSnapshot?> previousSnapshotBefore(int snapshotId) async {
    final currentQuery = select(storedSnapshots)
      ..where((row) => row.id.equals(snapshotId))
      ..limit(1);
    final current = await currentQuery.getSingleOrNull();
    if (current == null) return null;

    final previousQuery = select(storedSnapshots)
      ..where(
        (row) => row.accountId.equals(current.accountId) &
            row.capturedAt.isSmallerThanValue(current.capturedAt),
      )
      ..orderBy([(row) => OrderingTerm.desc(row.capturedAt)])
      ..limit(1);
    final previous = await previousQuery.getSingleOrNull();
    if (previous == null) return null;

    final accountQuery = select(storedAccounts)
      ..where((row) => row.id.equals(current.accountId))
      ..limit(1);
    final accountRow = await accountQuery.getSingleOrNull();
    if (accountRow == null) return null;

    return _restoreSnapshot(previous, _accountFromRow(accountRow));
  }

  Future<List<FollowSnapshotHistoryItem>> listHistory({
    SocialPlatform? platform,
  }) async {
    final accountRows = await select(storedAccounts).get();
    final accountsById = {
      for (final row in accountRows) row.id: _accountFromRow(row),
    };

    final snapshotQuery = select(storedSnapshots)
      ..orderBy([(row) => OrderingTerm.desc(row.capturedAt)]);
    final snapshots = await snapshotQuery.get();
    final relations = await select(storedSnapshotRelations).get();

    final followerCounts = <int, int>{};
    final followingCounts = <int, int>{};
    for (final relation in relations) {
      if ((relation.relation & _followerBit) != 0) {
        followerCounts.update(
          relation.snapshotId,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }
      if ((relation.relation & _followingBit) != 0) {
        followingCounts.update(
          relation.snapshotId,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }
    }

    final result = <FollowSnapshotHistoryItem>[];
    for (final snapshot in snapshots) {
      final account = accountsById[snapshot.accountId];
      if (account == null) continue;
      if (platform != null && account.platform != platform) continue;

      result.add(
        FollowSnapshotHistoryItem(
          snapshotId: snapshot.id,
          account: account,
          capturedAt: snapshot.capturedAt.toUtc(),
          followersCount: followerCounts[snapshot.id] ?? 0,
          followingCount: followingCounts[snapshot.id] ?? 0,
          sourceFormat: snapshot.sourceFormat,
        ),
      );
    }
    return List.unmodifiable(result);
  }

  Future<void> pruneHistory(
    SocialAccount account, {
    required int keepLatest,
  }) async {
    if (keepLatest < 1) {
      throw ArgumentError.value(keepLatest, 'keepLatest', 'Must be at least 1.');
    }

    final accountId = await _findAccountId(account);
    if (accountId == null) return;

    final query = select(storedSnapshots)
      ..where((row) => row.accountId.equals(accountId))
      ..orderBy([(row) => OrderingTerm.desc(row.capturedAt)]);
    final snapshots = await query.get();
    if (snapshots.length <= keepLatest) return;

    final oldIds = snapshots.skip(keepLatest).map((row) => row.id).toList();
    await transaction(() async {
      await (delete(storedSnapshotRelations)
            ..where((row) => row.snapshotId.isIn(oldIds)))
          .go();
      await (delete(storedSnapshots)..where((row) => row.id.isIn(oldIds))).go();
      await _deleteOrphanUsers();
    });
  }

  Future<FollowSnapshot> _restoreSnapshot(
    StoredSnapshot snapshot,
    SocialAccount account,
  ) async {
    final relationQuery = select(storedSnapshotRelations).join([
      innerJoin(
        storedSocialUsers,
        storedSocialUsers.identityKey
            .equalsExp(storedSnapshotRelations.identityKey),
      ),
    ])
      ..where(storedSnapshotRelations.snapshotId.equals(snapshot.id));

    final followers = <SocialUser>{};
    final following = <SocialUser>{};

    for (final row in await relationQuery.get()) {
      final relation = row.readTable(storedSnapshotRelations);
      final storedUser = row.readTable(storedSocialUsers);
      final user = SocialUser(
        platform: SocialPlatform.values.byName(storedUser.platform),
        username: storedUser.username,
        platformUserId: storedUser.platformUserId,
        displayName: storedUser.displayName,
        profileUrl: storedUser.profileUrl == null
            ? null
            : Uri.tryParse(storedUser.profileUrl!),
      );

      if ((relation.relation & _followerBit) != 0) followers.add(user);
      if ((relation.relation & _followingBit) != 0) following.add(user);
    }

    return FollowSnapshot(
      account: account,
      capturedAt: snapshot.capturedAt.toUtc(),
      followers: followers,
      following: following,
      sourceType: SnapshotSourceType.values.byName(snapshot.sourceType),
      sourceFormat: snapshot.sourceFormat,
    );
  }

  Future<void> _deleteOrphanUsers() async {
    final relations = await select(storedSnapshotRelations).get();
    final referencedKeys = relations.map((row) => row.identityKey).toSet();
    final users = await select(storedSocialUsers).get();
    final orphanKeys = users
        .map((row) => row.identityKey)
        .where((key) => !referencedKeys.contains(key))
        .toList();

    if (orphanKeys.isEmpty) return;
    await (delete(storedSocialUsers)
          ..where((row) => row.identityKey.isIn(orphanKeys)))
        .go();
  }

  Future<int?> _findAccountId(SocialAccount account) async {
    final platformId = account.accountId?.trim();
    if (platformId != null && platformId.isNotEmpty) {
      final byPlatformId = select(storedAccounts)
        ..where(
          (row) => row.platform.equals(account.platform.name) &
              row.platformAccountId.equals(platformId),
        )
        ..limit(1);
      final match = await byPlatformId.getSingleOrNull();
      if (match != null) return match.id;
    }

    final normalized = _normalizeUsername(account.username);
    final byUsername = select(storedAccounts)
      ..where(
        (row) => row.platform.equals(account.platform.name) &
            row.normalizedUsername.equals(normalized),
      )
      ..limit(1);
    return (await byUsername.getSingleOrNull())?.id;
  }

  Future<int> _ensureAccount(SocialAccount account) async {
    final existingId = await _findAccountId(account);
    final normalized = _normalizeUsername(account.username);

    if (existingId != null) {
      await (update(storedAccounts)..where((row) => row.id.equals(existingId)))
          .write(
        StoredAccountsCompanion(
          username: Value(account.username),
          normalizedUsername: Value(normalized),
          platformAccountId: Value(account.accountId),
          displayName: Value(account.displayName),
        ),
      );
      return existingId;
    }

    return into(storedAccounts).insert(
      StoredAccountsCompanion.insert(
        platform: account.platform.name,
        username: account.username,
        normalizedUsername: normalized,
        platformAccountId: Value(account.accountId),
        displayName: Value(account.displayName),
      ),
    );
  }

  SocialAccount _accountFromRow(StoredAccount row) {
    return SocialAccount(
      platform: SocialPlatform.values.byName(row.platform),
      username: row.username,
      accountId: row.platformAccountId,
      displayName: row.displayName,
    );
  }

  StoredSocialUsersCompanion _userCompanion(SocialUser user) {
    return StoredSocialUsersCompanion.insert(
      identityKey: user.identityKey,
      platform: user.platform.name,
      username: user.username,
      normalizedUsername: user.normalizedUsername,
      platformUserId: Value(user.platformUserId),
      displayName: Value(user.displayName),
      profileUrl: Value(user.profileUrl?.toString()),
    );
  }

  String _normalizeUsername(String username) => username.trim().toLowerCase();
}
