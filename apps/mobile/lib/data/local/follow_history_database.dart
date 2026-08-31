import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:follow_core/follow_core.dart';

part 'follow_history_database.g.dart';

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

  static const _followerBit = 1;
  static const _followingBit = 2;

  @override
  int get schemaVersion => 1;

  Future<void> saveSnapshot(FollowSnapshot snapshot) async {
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
