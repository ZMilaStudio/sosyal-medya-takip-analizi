// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_history_database.dart';

// ignore_for_file: type=lint
class $StoredAccountsTable extends StoredAccounts
    with TableInfo<$StoredAccountsTable, StoredAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedUsernameMeta =
      const VerificationMeta('normalizedUsername');
  @override
  late final GeneratedColumn<String> normalizedUsername =
      GeneratedColumn<String>(
        'normalized_username',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _platformAccountIdMeta = const VerificationMeta(
    'platformAccountId',
  );
  @override
  late final GeneratedColumn<String> platformAccountId =
      GeneratedColumn<String>(
        'platform_account_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    platform,
    username,
    normalizedUsername,
    platformAccountId,
    displayName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('normalized_username')) {
      context.handle(
        _normalizedUsernameMeta,
        normalizedUsername.isAcceptableOrUnknown(
          data['normalized_username']!,
          _normalizedUsernameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedUsernameMeta);
    }
    if (data.containsKey('platform_account_id')) {
      context.handle(
        _platformAccountIdMeta,
        platformAccountId.isAcceptableOrUnknown(
          data['platform_account_id']!,
          _platformAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {platform, normalizedUsername},
  ];
  @override
  StoredAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredAccount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      normalizedUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_username'],
      )!,
      platformAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform_account_id'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
    );
  }

  @override
  $StoredAccountsTable createAlias(String alias) {
    return $StoredAccountsTable(attachedDatabase, alias);
  }
}

class StoredAccount extends DataClass implements Insertable<StoredAccount> {
  final int id;
  final String platform;
  final String username;
  final String normalizedUsername;
  final String? platformAccountId;
  final String? displayName;
  const StoredAccount({
    required this.id,
    required this.platform,
    required this.username,
    required this.normalizedUsername,
    this.platformAccountId,
    this.displayName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['platform'] = Variable<String>(platform);
    map['username'] = Variable<String>(username);
    map['normalized_username'] = Variable<String>(normalizedUsername);
    if (!nullToAbsent || platformAccountId != null) {
      map['platform_account_id'] = Variable<String>(platformAccountId);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    return map;
  }

  StoredAccountsCompanion toCompanion(bool nullToAbsent) {
    return StoredAccountsCompanion(
      id: Value(id),
      platform: Value(platform),
      username: Value(username),
      normalizedUsername: Value(normalizedUsername),
      platformAccountId: platformAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(platformAccountId),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
    );
  }

  factory StoredAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredAccount(
      id: serializer.fromJson<int>(json['id']),
      platform: serializer.fromJson<String>(json['platform']),
      username: serializer.fromJson<String>(json['username']),
      normalizedUsername: serializer.fromJson<String>(
        json['normalizedUsername'],
      ),
      platformAccountId: serializer.fromJson<String?>(
        json['platformAccountId'],
      ),
      displayName: serializer.fromJson<String?>(json['displayName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'platform': serializer.toJson<String>(platform),
      'username': serializer.toJson<String>(username),
      'normalizedUsername': serializer.toJson<String>(normalizedUsername),
      'platformAccountId': serializer.toJson<String?>(platformAccountId),
      'displayName': serializer.toJson<String?>(displayName),
    };
  }

  StoredAccount copyWith({
    int? id,
    String? platform,
    String? username,
    String? normalizedUsername,
    Value<String?> platformAccountId = const Value.absent(),
    Value<String?> displayName = const Value.absent(),
  }) => StoredAccount(
    id: id ?? this.id,
    platform: platform ?? this.platform,
    username: username ?? this.username,
    normalizedUsername: normalizedUsername ?? this.normalizedUsername,
    platformAccountId: platformAccountId.present
        ? platformAccountId.value
        : this.platformAccountId,
    displayName: displayName.present ? displayName.value : this.displayName,
  );
  StoredAccount copyWithCompanion(StoredAccountsCompanion data) {
    return StoredAccount(
      id: data.id.present ? data.id.value : this.id,
      platform: data.platform.present ? data.platform.value : this.platform,
      username: data.username.present ? data.username.value : this.username,
      normalizedUsername: data.normalizedUsername.present
          ? data.normalizedUsername.value
          : this.normalizedUsername,
      platformAccountId: data.platformAccountId.present
          ? data.platformAccountId.value
          : this.platformAccountId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredAccount(')
          ..write('id: $id, ')
          ..write('platform: $platform, ')
          ..write('username: $username, ')
          ..write('normalizedUsername: $normalizedUsername, ')
          ..write('platformAccountId: $platformAccountId, ')
          ..write('displayName: $displayName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    platform,
    username,
    normalizedUsername,
    platformAccountId,
    displayName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredAccount &&
          other.id == this.id &&
          other.platform == this.platform &&
          other.username == this.username &&
          other.normalizedUsername == this.normalizedUsername &&
          other.platformAccountId == this.platformAccountId &&
          other.displayName == this.displayName);
}

class StoredAccountsCompanion extends UpdateCompanion<StoredAccount> {
  final Value<int> id;
  final Value<String> platform;
  final Value<String> username;
  final Value<String> normalizedUsername;
  final Value<String?> platformAccountId;
  final Value<String?> displayName;
  const StoredAccountsCompanion({
    this.id = const Value.absent(),
    this.platform = const Value.absent(),
    this.username = const Value.absent(),
    this.normalizedUsername = const Value.absent(),
    this.platformAccountId = const Value.absent(),
    this.displayName = const Value.absent(),
  });
  StoredAccountsCompanion.insert({
    this.id = const Value.absent(),
    required String platform,
    required String username,
    required String normalizedUsername,
    this.platformAccountId = const Value.absent(),
    this.displayName = const Value.absent(),
  }) : platform = Value(platform),
       username = Value(username),
       normalizedUsername = Value(normalizedUsername);
  static Insertable<StoredAccount> custom({
    Expression<int>? id,
    Expression<String>? platform,
    Expression<String>? username,
    Expression<String>? normalizedUsername,
    Expression<String>? platformAccountId,
    Expression<String>? displayName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (platform != null) 'platform': platform,
      if (username != null) 'username': username,
      if (normalizedUsername != null) 'normalized_username': normalizedUsername,
      if (platformAccountId != null) 'platform_account_id': platformAccountId,
      if (displayName != null) 'display_name': displayName,
    });
  }

  StoredAccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? platform,
    Value<String>? username,
    Value<String>? normalizedUsername,
    Value<String?>? platformAccountId,
    Value<String?>? displayName,
  }) {
    return StoredAccountsCompanion(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      username: username ?? this.username,
      normalizedUsername: normalizedUsername ?? this.normalizedUsername,
      platformAccountId: platformAccountId ?? this.platformAccountId,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (normalizedUsername.present) {
      map['normalized_username'] = Variable<String>(normalizedUsername.value);
    }
    if (platformAccountId.present) {
      map['platform_account_id'] = Variable<String>(platformAccountId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredAccountsCompanion(')
          ..write('id: $id, ')
          ..write('platform: $platform, ')
          ..write('username: $username, ')
          ..write('normalizedUsername: $normalizedUsername, ')
          ..write('platformAccountId: $platformAccountId, ')
          ..write('displayName: $displayName')
          ..write(')'))
        .toString();
  }
}

class $StoredSocialUsersTable extends StoredSocialUsers
    with TableInfo<$StoredSocialUsersTable, StoredSocialUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredSocialUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _identityKeyMeta = const VerificationMeta(
    'identityKey',
  );
  @override
  late final GeneratedColumn<String> identityKey = GeneratedColumn<String>(
    'identity_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedUsernameMeta =
      const VerificationMeta('normalizedUsername');
  @override
  late final GeneratedColumn<String> normalizedUsername =
      GeneratedColumn<String>(
        'normalized_username',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _platformUserIdMeta = const VerificationMeta(
    'platformUserId',
  );
  @override
  late final GeneratedColumn<String> platformUserId = GeneratedColumn<String>(
    'platform_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profileUrlMeta = const VerificationMeta(
    'profileUrl',
  );
  @override
  late final GeneratedColumn<String> profileUrl = GeneratedColumn<String>(
    'profile_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    identityKey,
    platform,
    username,
    normalizedUsername,
    platformUserId,
    displayName,
    profileUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_social_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredSocialUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('identity_key')) {
      context.handle(
        _identityKeyMeta,
        identityKey.isAcceptableOrUnknown(
          data['identity_key']!,
          _identityKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_identityKeyMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('normalized_username')) {
      context.handle(
        _normalizedUsernameMeta,
        normalizedUsername.isAcceptableOrUnknown(
          data['normalized_username']!,
          _normalizedUsernameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedUsernameMeta);
    }
    if (data.containsKey('platform_user_id')) {
      context.handle(
        _platformUserIdMeta,
        platformUserId.isAcceptableOrUnknown(
          data['platform_user_id']!,
          _platformUserIdMeta,
        ),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('profile_url')) {
      context.handle(
        _profileUrlMeta,
        profileUrl.isAcceptableOrUnknown(data['profile_url']!, _profileUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {identityKey};
  @override
  StoredSocialUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredSocialUser(
      identityKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identity_key'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      normalizedUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_username'],
      )!,
      platformUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform_user_id'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      profileUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_url'],
      ),
    );
  }

  @override
  $StoredSocialUsersTable createAlias(String alias) {
    return $StoredSocialUsersTable(attachedDatabase, alias);
  }
}

class StoredSocialUser extends DataClass
    implements Insertable<StoredSocialUser> {
  final String identityKey;
  final String platform;
  final String username;
  final String normalizedUsername;
  final String? platformUserId;
  final String? displayName;
  final String? profileUrl;
  const StoredSocialUser({
    required this.identityKey,
    required this.platform,
    required this.username,
    required this.normalizedUsername,
    this.platformUserId,
    this.displayName,
    this.profileUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['identity_key'] = Variable<String>(identityKey);
    map['platform'] = Variable<String>(platform);
    map['username'] = Variable<String>(username);
    map['normalized_username'] = Variable<String>(normalizedUsername);
    if (!nullToAbsent || platformUserId != null) {
      map['platform_user_id'] = Variable<String>(platformUserId);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || profileUrl != null) {
      map['profile_url'] = Variable<String>(profileUrl);
    }
    return map;
  }

  StoredSocialUsersCompanion toCompanion(bool nullToAbsent) {
    return StoredSocialUsersCompanion(
      identityKey: Value(identityKey),
      platform: Value(platform),
      username: Value(username),
      normalizedUsername: Value(normalizedUsername),
      platformUserId: platformUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(platformUserId),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      profileUrl: profileUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(profileUrl),
    );
  }

  factory StoredSocialUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredSocialUser(
      identityKey: serializer.fromJson<String>(json['identityKey']),
      platform: serializer.fromJson<String>(json['platform']),
      username: serializer.fromJson<String>(json['username']),
      normalizedUsername: serializer.fromJson<String>(
        json['normalizedUsername'],
      ),
      platformUserId: serializer.fromJson<String?>(json['platformUserId']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      profileUrl: serializer.fromJson<String?>(json['profileUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'identityKey': serializer.toJson<String>(identityKey),
      'platform': serializer.toJson<String>(platform),
      'username': serializer.toJson<String>(username),
      'normalizedUsername': serializer.toJson<String>(normalizedUsername),
      'platformUserId': serializer.toJson<String?>(platformUserId),
      'displayName': serializer.toJson<String?>(displayName),
      'profileUrl': serializer.toJson<String?>(profileUrl),
    };
  }

  StoredSocialUser copyWith({
    String? identityKey,
    String? platform,
    String? username,
    String? normalizedUsername,
    Value<String?> platformUserId = const Value.absent(),
    Value<String?> displayName = const Value.absent(),
    Value<String?> profileUrl = const Value.absent(),
  }) => StoredSocialUser(
    identityKey: identityKey ?? this.identityKey,
    platform: platform ?? this.platform,
    username: username ?? this.username,
    normalizedUsername: normalizedUsername ?? this.normalizedUsername,
    platformUserId: platformUserId.present
        ? platformUserId.value
        : this.platformUserId,
    displayName: displayName.present ? displayName.value : this.displayName,
    profileUrl: profileUrl.present ? profileUrl.value : this.profileUrl,
  );
  StoredSocialUser copyWithCompanion(StoredSocialUsersCompanion data) {
    return StoredSocialUser(
      identityKey: data.identityKey.present
          ? data.identityKey.value
          : this.identityKey,
      platform: data.platform.present ? data.platform.value : this.platform,
      username: data.username.present ? data.username.value : this.username,
      normalizedUsername: data.normalizedUsername.present
          ? data.normalizedUsername.value
          : this.normalizedUsername,
      platformUserId: data.platformUserId.present
          ? data.platformUserId.value
          : this.platformUserId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      profileUrl: data.profileUrl.present
          ? data.profileUrl.value
          : this.profileUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredSocialUser(')
          ..write('identityKey: $identityKey, ')
          ..write('platform: $platform, ')
          ..write('username: $username, ')
          ..write('normalizedUsername: $normalizedUsername, ')
          ..write('platformUserId: $platformUserId, ')
          ..write('displayName: $displayName, ')
          ..write('profileUrl: $profileUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    identityKey,
    platform,
    username,
    normalizedUsername,
    platformUserId,
    displayName,
    profileUrl,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredSocialUser &&
          other.identityKey == this.identityKey &&
          other.platform == this.platform &&
          other.username == this.username &&
          other.normalizedUsername == this.normalizedUsername &&
          other.platformUserId == this.platformUserId &&
          other.displayName == this.displayName &&
          other.profileUrl == this.profileUrl);
}

class StoredSocialUsersCompanion extends UpdateCompanion<StoredSocialUser> {
  final Value<String> identityKey;
  final Value<String> platform;
  final Value<String> username;
  final Value<String> normalizedUsername;
  final Value<String?> platformUserId;
  final Value<String?> displayName;
  final Value<String?> profileUrl;
  final Value<int> rowid;
  const StoredSocialUsersCompanion({
    this.identityKey = const Value.absent(),
    this.platform = const Value.absent(),
    this.username = const Value.absent(),
    this.normalizedUsername = const Value.absent(),
    this.platformUserId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.profileUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoredSocialUsersCompanion.insert({
    required String identityKey,
    required String platform,
    required String username,
    required String normalizedUsername,
    this.platformUserId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.profileUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : identityKey = Value(identityKey),
       platform = Value(platform),
       username = Value(username),
       normalizedUsername = Value(normalizedUsername);
  static Insertable<StoredSocialUser> custom({
    Expression<String>? identityKey,
    Expression<String>? platform,
    Expression<String>? username,
    Expression<String>? normalizedUsername,
    Expression<String>? platformUserId,
    Expression<String>? displayName,
    Expression<String>? profileUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (identityKey != null) 'identity_key': identityKey,
      if (platform != null) 'platform': platform,
      if (username != null) 'username': username,
      if (normalizedUsername != null) 'normalized_username': normalizedUsername,
      if (platformUserId != null) 'platform_user_id': platformUserId,
      if (displayName != null) 'display_name': displayName,
      if (profileUrl != null) 'profile_url': profileUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoredSocialUsersCompanion copyWith({
    Value<String>? identityKey,
    Value<String>? platform,
    Value<String>? username,
    Value<String>? normalizedUsername,
    Value<String?>? platformUserId,
    Value<String?>? displayName,
    Value<String?>? profileUrl,
    Value<int>? rowid,
  }) {
    return StoredSocialUsersCompanion(
      identityKey: identityKey ?? this.identityKey,
      platform: platform ?? this.platform,
      username: username ?? this.username,
      normalizedUsername: normalizedUsername ?? this.normalizedUsername,
      platformUserId: platformUserId ?? this.platformUserId,
      displayName: displayName ?? this.displayName,
      profileUrl: profileUrl ?? this.profileUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (identityKey.present) {
      map['identity_key'] = Variable<String>(identityKey.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (normalizedUsername.present) {
      map['normalized_username'] = Variable<String>(normalizedUsername.value);
    }
    if (platformUserId.present) {
      map['platform_user_id'] = Variable<String>(platformUserId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (profileUrl.present) {
      map['profile_url'] = Variable<String>(profileUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredSocialUsersCompanion(')
          ..write('identityKey: $identityKey, ')
          ..write('platform: $platform, ')
          ..write('username: $username, ')
          ..write('normalizedUsername: $normalizedUsername, ')
          ..write('platformUserId: $platformUserId, ')
          ..write('displayName: $displayName, ')
          ..write('profileUrl: $profileUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoredSnapshotsTable extends StoredSnapshots
    with TableInfo<$StoredSnapshotsTable, StoredSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stored_accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceFormatMeta = const VerificationMeta(
    'sourceFormat',
  );
  @override
  late final GeneratedColumn<String> sourceFormat = GeneratedColumn<String>(
    'source_format',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    capturedAt,
    sourceType,
    sourceFormat,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_format')) {
      context.handle(
        _sourceFormatMeta,
        sourceFormat.isAcceptableOrUnknown(
          data['source_format']!,
          _sourceFormatMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredSnapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourceFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_format'],
      ),
    );
  }

  @override
  $StoredSnapshotsTable createAlias(String alias) {
    return $StoredSnapshotsTable(attachedDatabase, alias);
  }
}

class StoredSnapshot extends DataClass implements Insertable<StoredSnapshot> {
  final int id;
  final int accountId;
  final DateTime capturedAt;
  final String sourceType;
  final String? sourceFormat;
  const StoredSnapshot({
    required this.id,
    required this.accountId,
    required this.capturedAt,
    required this.sourceType,
    this.sourceFormat,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['captured_at'] = Variable<DateTime>(capturedAt);
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || sourceFormat != null) {
      map['source_format'] = Variable<String>(sourceFormat);
    }
    return map;
  }

  StoredSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return StoredSnapshotsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      capturedAt: Value(capturedAt),
      sourceType: Value(sourceType),
      sourceFormat: sourceFormat == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceFormat),
    );
  }

  factory StoredSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredSnapshot(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceFormat: serializer.fromJson<String?>(json['sourceFormat']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceFormat': serializer.toJson<String?>(sourceFormat),
    };
  }

  StoredSnapshot copyWith({
    int? id,
    int? accountId,
    DateTime? capturedAt,
    String? sourceType,
    Value<String?> sourceFormat = const Value.absent(),
  }) => StoredSnapshot(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    capturedAt: capturedAt ?? this.capturedAt,
    sourceType: sourceType ?? this.sourceType,
    sourceFormat: sourceFormat.present ? sourceFormat.value : this.sourceFormat,
  );
  StoredSnapshot copyWithCompanion(StoredSnapshotsCompanion data) {
    return StoredSnapshot(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceFormat: data.sourceFormat.present
          ? data.sourceFormat.value
          : this.sourceFormat,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredSnapshot(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceFormat: $sourceFormat')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, accountId, capturedAt, sourceType, sourceFormat);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredSnapshot &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.capturedAt == this.capturedAt &&
          other.sourceType == this.sourceType &&
          other.sourceFormat == this.sourceFormat);
}

class StoredSnapshotsCompanion extends UpdateCompanion<StoredSnapshot> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<DateTime> capturedAt;
  final Value<String> sourceType;
  final Value<String?> sourceFormat;
  const StoredSnapshotsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceFormat = const Value.absent(),
  });
  StoredSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required DateTime capturedAt,
    required String sourceType,
    this.sourceFormat = const Value.absent(),
  }) : accountId = Value(accountId),
       capturedAt = Value(capturedAt),
       sourceType = Value(sourceType);
  static Insertable<StoredSnapshot> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<DateTime>? capturedAt,
    Expression<String>? sourceType,
    Expression<String>? sourceFormat,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceFormat != null) 'source_format': sourceFormat,
    });
  }

  StoredSnapshotsCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<DateTime>? capturedAt,
    Value<String>? sourceType,
    Value<String?>? sourceFormat,
  }) {
    return StoredSnapshotsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      capturedAt: capturedAt ?? this.capturedAt,
      sourceType: sourceType ?? this.sourceType,
      sourceFormat: sourceFormat ?? this.sourceFormat,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceFormat.present) {
      map['source_format'] = Variable<String>(sourceFormat.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceFormat: $sourceFormat')
          ..write(')'))
        .toString();
  }
}

class $StoredSnapshotRelationsTable extends StoredSnapshotRelations
    with TableInfo<$StoredSnapshotRelationsTable, StoredSnapshotRelation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredSnapshotRelationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _snapshotIdMeta = const VerificationMeta(
    'snapshotId',
  );
  @override
  late final GeneratedColumn<int> snapshotId = GeneratedColumn<int>(
    'snapshot_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stored_snapshots (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _identityKeyMeta = const VerificationMeta(
    'identityKey',
  );
  @override
  late final GeneratedColumn<String> identityKey = GeneratedColumn<String>(
    'identity_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stored_social_users (identity_key)',
    ),
  );
  static const VerificationMeta _relationMeta = const VerificationMeta(
    'relation',
  );
  @override
  late final GeneratedColumn<int> relation = GeneratedColumn<int>(
    'relation',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [snapshotId, identityKey, relation];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_snapshot_relations';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredSnapshotRelation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('snapshot_id')) {
      context.handle(
        _snapshotIdMeta,
        snapshotId.isAcceptableOrUnknown(data['snapshot_id']!, _snapshotIdMeta),
      );
    } else if (isInserting) {
      context.missing(_snapshotIdMeta);
    }
    if (data.containsKey('identity_key')) {
      context.handle(
        _identityKeyMeta,
        identityKey.isAcceptableOrUnknown(
          data['identity_key']!,
          _identityKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_identityKeyMeta);
    }
    if (data.containsKey('relation')) {
      context.handle(
        _relationMeta,
        relation.isAcceptableOrUnknown(data['relation']!, _relationMeta),
      );
    } else if (isInserting) {
      context.missing(_relationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {snapshotId, identityKey};
  @override
  StoredSnapshotRelation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredSnapshotRelation(
      snapshotId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}snapshot_id'],
      )!,
      identityKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identity_key'],
      )!,
      relation: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}relation'],
      )!,
    );
  }

  @override
  $StoredSnapshotRelationsTable createAlias(String alias) {
    return $StoredSnapshotRelationsTable(attachedDatabase, alias);
  }
}

class StoredSnapshotRelation extends DataClass
    implements Insertable<StoredSnapshotRelation> {
  final int snapshotId;
  final String identityKey;
  final int relation;
  const StoredSnapshotRelation({
    required this.snapshotId,
    required this.identityKey,
    required this.relation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['snapshot_id'] = Variable<int>(snapshotId);
    map['identity_key'] = Variable<String>(identityKey);
    map['relation'] = Variable<int>(relation);
    return map;
  }

  StoredSnapshotRelationsCompanion toCompanion(bool nullToAbsent) {
    return StoredSnapshotRelationsCompanion(
      snapshotId: Value(snapshotId),
      identityKey: Value(identityKey),
      relation: Value(relation),
    );
  }

  factory StoredSnapshotRelation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredSnapshotRelation(
      snapshotId: serializer.fromJson<int>(json['snapshotId']),
      identityKey: serializer.fromJson<String>(json['identityKey']),
      relation: serializer.fromJson<int>(json['relation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'snapshotId': serializer.toJson<int>(snapshotId),
      'identityKey': serializer.toJson<String>(identityKey),
      'relation': serializer.toJson<int>(relation),
    };
  }

  StoredSnapshotRelation copyWith({
    int? snapshotId,
    String? identityKey,
    int? relation,
  }) => StoredSnapshotRelation(
    snapshotId: snapshotId ?? this.snapshotId,
    identityKey: identityKey ?? this.identityKey,
    relation: relation ?? this.relation,
  );
  StoredSnapshotRelation copyWithCompanion(
    StoredSnapshotRelationsCompanion data,
  ) {
    return StoredSnapshotRelation(
      snapshotId: data.snapshotId.present
          ? data.snapshotId.value
          : this.snapshotId,
      identityKey: data.identityKey.present
          ? data.identityKey.value
          : this.identityKey,
      relation: data.relation.present ? data.relation.value : this.relation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredSnapshotRelation(')
          ..write('snapshotId: $snapshotId, ')
          ..write('identityKey: $identityKey, ')
          ..write('relation: $relation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(snapshotId, identityKey, relation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredSnapshotRelation &&
          other.snapshotId == this.snapshotId &&
          other.identityKey == this.identityKey &&
          other.relation == this.relation);
}

class StoredSnapshotRelationsCompanion
    extends UpdateCompanion<StoredSnapshotRelation> {
  final Value<int> snapshotId;
  final Value<String> identityKey;
  final Value<int> relation;
  final Value<int> rowid;
  const StoredSnapshotRelationsCompanion({
    this.snapshotId = const Value.absent(),
    this.identityKey = const Value.absent(),
    this.relation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoredSnapshotRelationsCompanion.insert({
    required int snapshotId,
    required String identityKey,
    required int relation,
    this.rowid = const Value.absent(),
  }) : snapshotId = Value(snapshotId),
       identityKey = Value(identityKey),
       relation = Value(relation);
  static Insertable<StoredSnapshotRelation> custom({
    Expression<int>? snapshotId,
    Expression<String>? identityKey,
    Expression<int>? relation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (snapshotId != null) 'snapshot_id': snapshotId,
      if (identityKey != null) 'identity_key': identityKey,
      if (relation != null) 'relation': relation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoredSnapshotRelationsCompanion copyWith({
    Value<int>? snapshotId,
    Value<String>? identityKey,
    Value<int>? relation,
    Value<int>? rowid,
  }) {
    return StoredSnapshotRelationsCompanion(
      snapshotId: snapshotId ?? this.snapshotId,
      identityKey: identityKey ?? this.identityKey,
      relation: relation ?? this.relation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (snapshotId.present) {
      map['snapshot_id'] = Variable<int>(snapshotId.value);
    }
    if (identityKey.present) {
      map['identity_key'] = Variable<String>(identityKey.value);
    }
    if (relation.present) {
      map['relation'] = Variable<int>(relation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredSnapshotRelationsCompanion(')
          ..write('snapshotId: $snapshotId, ')
          ..write('identityKey: $identityKey, ')
          ..write('relation: $relation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$FollowHistoryDatabase extends GeneratedDatabase {
  _$FollowHistoryDatabase(QueryExecutor e) : super(e);
  $FollowHistoryDatabaseManager get managers =>
      $FollowHistoryDatabaseManager(this);
  late final $StoredAccountsTable storedAccounts = $StoredAccountsTable(this);
  late final $StoredSocialUsersTable storedSocialUsers =
      $StoredSocialUsersTable(this);
  late final $StoredSnapshotsTable storedSnapshots = $StoredSnapshotsTable(
    this,
  );
  late final $StoredSnapshotRelationsTable storedSnapshotRelations =
      $StoredSnapshotRelationsTable(this);
  late final Index storedSnapshotsAccountCapturedAt = Index(
    'stored_snapshots_account_captured_at',
    'CREATE INDEX stored_snapshots_account_captured_at ON stored_snapshots (account_id, captured_at)',
  );
  late final Index storedSnapshotRelationsIdentity = Index(
    'stored_snapshot_relations_identity',
    'CREATE INDEX stored_snapshot_relations_identity ON stored_snapshot_relations (identity_key)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    storedAccounts,
    storedSocialUsers,
    storedSnapshots,
    storedSnapshotRelations,
    storedSnapshotsAccountCapturedAt,
    storedSnapshotRelationsIdentity,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stored_accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stored_snapshots', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stored_snapshots',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('stored_snapshot_relations', kind: UpdateKind.delete),
      ],
    ),
  ]);
}

typedef $$StoredAccountsTableCreateCompanionBuilder =
    StoredAccountsCompanion Function({
      Value<int> id,
      required String platform,
      required String username,
      required String normalizedUsername,
      Value<String?> platformAccountId,
      Value<String?> displayName,
    });
typedef $$StoredAccountsTableUpdateCompanionBuilder =
    StoredAccountsCompanion Function({
      Value<int> id,
      Value<String> platform,
      Value<String> username,
      Value<String> normalizedUsername,
      Value<String?> platformAccountId,
      Value<String?> displayName,
    });

final class $$StoredAccountsTableReferences
    extends
        BaseReferences<
          _$FollowHistoryDatabase,
          $StoredAccountsTable,
          StoredAccount
        > {
  $$StoredAccountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$StoredSnapshotsTable, List<StoredSnapshot>>
  _storedSnapshotsRefsTable(_$FollowHistoryDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.storedSnapshots,
        aliasName: 'stored_accounts__id__stored_snapshots__account_id',
      );

  $$StoredSnapshotsTableProcessedTableManager get storedSnapshotsRefs {
    final manager = $$StoredSnapshotsTableTableManager(
      $_db,
      $_db.storedSnapshots,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storedSnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StoredAccountsTableFilterComposer
    extends Composer<_$FollowHistoryDatabase, $StoredAccountsTable> {
  $$StoredAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedUsername => $composableBuilder(
    column: $table.normalizedUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platformAccountId => $composableBuilder(
    column: $table.platformAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> storedSnapshotsRefs(
    Expression<bool> Function($$StoredSnapshotsTableFilterComposer f) f,
  ) {
    final $$StoredSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storedSnapshots,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.storedSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StoredAccountsTableOrderingComposer
    extends Composer<_$FollowHistoryDatabase, $StoredAccountsTable> {
  $$StoredAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedUsername => $composableBuilder(
    column: $table.normalizedUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platformAccountId => $composableBuilder(
    column: $table.platformAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoredAccountsTableAnnotationComposer
    extends Composer<_$FollowHistoryDatabase, $StoredAccountsTable> {
  $$StoredAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get normalizedUsername => $composableBuilder(
    column: $table.normalizedUsername,
    builder: (column) => column,
  );

  GeneratedColumn<String> get platformAccountId => $composableBuilder(
    column: $table.platformAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  Expression<T> storedSnapshotsRefs<T extends Object>(
    Expression<T> Function($$StoredSnapshotsTableAnnotationComposer a) f,
  ) {
    final $$StoredSnapshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storedSnapshots,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredSnapshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.storedSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StoredAccountsTableTableManager
    extends
        RootTableManager<
          _$FollowHistoryDatabase,
          $StoredAccountsTable,
          StoredAccount,
          $$StoredAccountsTableFilterComposer,
          $$StoredAccountsTableOrderingComposer,
          $$StoredAccountsTableAnnotationComposer,
          $$StoredAccountsTableCreateCompanionBuilder,
          $$StoredAccountsTableUpdateCompanionBuilder,
          (StoredAccount, $$StoredAccountsTableReferences),
          StoredAccount,
          PrefetchHooks Function({bool storedSnapshotsRefs})
        > {
  $$StoredAccountsTableTableManager(
    _$FollowHistoryDatabase db,
    $StoredAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> normalizedUsername = const Value.absent(),
                Value<String?> platformAccountId = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
              }) => StoredAccountsCompanion(
                id: id,
                platform: platform,
                username: username,
                normalizedUsername: normalizedUsername,
                platformAccountId: platformAccountId,
                displayName: displayName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String platform,
                required String username,
                required String normalizedUsername,
                Value<String?> platformAccountId = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
              }) => StoredAccountsCompanion.insert(
                id: id,
                platform: platform,
                username: username,
                normalizedUsername: normalizedUsername,
                platformAccountId: platformAccountId,
                displayName: displayName,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StoredAccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({storedSnapshotsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (storedSnapshotsRefs) db.storedSnapshots,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (storedSnapshotsRefs)
                    await $_getPrefetchedData<
                      StoredAccount,
                      $StoredAccountsTable,
                      StoredSnapshot
                    >(
                      currentTable: table,
                      referencedTable: $$StoredAccountsTableReferences
                          ._storedSnapshotsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$StoredAccountsTableReferences(
                            db,
                            table,
                            p0,
                          ).storedSnapshotsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.accountId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StoredAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$FollowHistoryDatabase,
      $StoredAccountsTable,
      StoredAccount,
      $$StoredAccountsTableFilterComposer,
      $$StoredAccountsTableOrderingComposer,
      $$StoredAccountsTableAnnotationComposer,
      $$StoredAccountsTableCreateCompanionBuilder,
      $$StoredAccountsTableUpdateCompanionBuilder,
      (StoredAccount, $$StoredAccountsTableReferences),
      StoredAccount,
      PrefetchHooks Function({bool storedSnapshotsRefs})
    >;
typedef $$StoredSocialUsersTableCreateCompanionBuilder =
    StoredSocialUsersCompanion Function({
      required String identityKey,
      required String platform,
      required String username,
      required String normalizedUsername,
      Value<String?> platformUserId,
      Value<String?> displayName,
      Value<String?> profileUrl,
      Value<int> rowid,
    });
typedef $$StoredSocialUsersTableUpdateCompanionBuilder =
    StoredSocialUsersCompanion Function({
      Value<String> identityKey,
      Value<String> platform,
      Value<String> username,
      Value<String> normalizedUsername,
      Value<String?> platformUserId,
      Value<String?> displayName,
      Value<String?> profileUrl,
      Value<int> rowid,
    });

final class $$StoredSocialUsersTableReferences
    extends
        BaseReferences<
          _$FollowHistoryDatabase,
          $StoredSocialUsersTable,
          StoredSocialUser
        > {
  $$StoredSocialUsersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $StoredSnapshotRelationsTable,
    List<StoredSnapshotRelation>
  >
  _storedSnapshotRelationsRefsTable(
    _$FollowHistoryDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.storedSnapshotRelations,
    aliasName:
        'stored_social_users__identity_key__stored_snapshot_relations__identity_key',
  );

  $$StoredSnapshotRelationsTableProcessedTableManager
  get storedSnapshotRelationsRefs {
    final manager =
        $$StoredSnapshotRelationsTableTableManager(
          $_db,
          $_db.storedSnapshotRelations,
        ).filter(
          (f) => f.identityKey.identityKey.sqlEquals(
            $_itemColumn<String>('identity_key')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _storedSnapshotRelationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StoredSocialUsersTableFilterComposer
    extends Composer<_$FollowHistoryDatabase, $StoredSocialUsersTable> {
  $$StoredSocialUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get identityKey => $composableBuilder(
    column: $table.identityKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedUsername => $composableBuilder(
    column: $table.normalizedUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platformUserId => $composableBuilder(
    column: $table.platformUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileUrl => $composableBuilder(
    column: $table.profileUrl,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> storedSnapshotRelationsRefs(
    Expression<bool> Function($$StoredSnapshotRelationsTableFilterComposer f) f,
  ) {
    final $$StoredSnapshotRelationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.identityKey,
          referencedTable: $db.storedSnapshotRelations,
          getReferencedColumn: (t) => t.identityKey,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredSnapshotRelationsTableFilterComposer(
                $db: $db,
                $table: $db.storedSnapshotRelations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StoredSocialUsersTableOrderingComposer
    extends Composer<_$FollowHistoryDatabase, $StoredSocialUsersTable> {
  $$StoredSocialUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get identityKey => $composableBuilder(
    column: $table.identityKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedUsername => $composableBuilder(
    column: $table.normalizedUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platformUserId => $composableBuilder(
    column: $table.platformUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileUrl => $composableBuilder(
    column: $table.profileUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoredSocialUsersTableAnnotationComposer
    extends Composer<_$FollowHistoryDatabase, $StoredSocialUsersTable> {
  $$StoredSocialUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get identityKey => $composableBuilder(
    column: $table.identityKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get normalizedUsername => $composableBuilder(
    column: $table.normalizedUsername,
    builder: (column) => column,
  );

  GeneratedColumn<String> get platformUserId => $composableBuilder(
    column: $table.platformUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profileUrl => $composableBuilder(
    column: $table.profileUrl,
    builder: (column) => column,
  );

  Expression<T> storedSnapshotRelationsRefs<T extends Object>(
    Expression<T> Function($$StoredSnapshotRelationsTableAnnotationComposer a)
    f,
  ) {
    final $$StoredSnapshotRelationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.identityKey,
          referencedTable: $db.storedSnapshotRelations,
          getReferencedColumn: (t) => t.identityKey,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredSnapshotRelationsTableAnnotationComposer(
                $db: $db,
                $table: $db.storedSnapshotRelations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StoredSocialUsersTableTableManager
    extends
        RootTableManager<
          _$FollowHistoryDatabase,
          $StoredSocialUsersTable,
          StoredSocialUser,
          $$StoredSocialUsersTableFilterComposer,
          $$StoredSocialUsersTableOrderingComposer,
          $$StoredSocialUsersTableAnnotationComposer,
          $$StoredSocialUsersTableCreateCompanionBuilder,
          $$StoredSocialUsersTableUpdateCompanionBuilder,
          (StoredSocialUser, $$StoredSocialUsersTableReferences),
          StoredSocialUser,
          PrefetchHooks Function({bool storedSnapshotRelationsRefs})
        > {
  $$StoredSocialUsersTableTableManager(
    _$FollowHistoryDatabase db,
    $StoredSocialUsersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredSocialUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredSocialUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredSocialUsersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> identityKey = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> normalizedUsername = const Value.absent(),
                Value<String?> platformUserId = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> profileUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredSocialUsersCompanion(
                identityKey: identityKey,
                platform: platform,
                username: username,
                normalizedUsername: normalizedUsername,
                platformUserId: platformUserId,
                displayName: displayName,
                profileUrl: profileUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String identityKey,
                required String platform,
                required String username,
                required String normalizedUsername,
                Value<String?> platformUserId = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> profileUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredSocialUsersCompanion.insert(
                identityKey: identityKey,
                platform: platform,
                username: username,
                normalizedUsername: normalizedUsername,
                platformUserId: platformUserId,
                displayName: displayName,
                profileUrl: profileUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StoredSocialUsersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({storedSnapshotRelationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (storedSnapshotRelationsRefs) db.storedSnapshotRelations,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (storedSnapshotRelationsRefs)
                    await $_getPrefetchedData<
                      StoredSocialUser,
                      $StoredSocialUsersTable,
                      StoredSnapshotRelation
                    >(
                      currentTable: table,
                      referencedTable: $$StoredSocialUsersTableReferences
                          ._storedSnapshotRelationsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$StoredSocialUsersTableReferences(
                            db,
                            table,
                            p0,
                          ).storedSnapshotRelationsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.identityKey == item.identityKey,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StoredSocialUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$FollowHistoryDatabase,
      $StoredSocialUsersTable,
      StoredSocialUser,
      $$StoredSocialUsersTableFilterComposer,
      $$StoredSocialUsersTableOrderingComposer,
      $$StoredSocialUsersTableAnnotationComposer,
      $$StoredSocialUsersTableCreateCompanionBuilder,
      $$StoredSocialUsersTableUpdateCompanionBuilder,
      (StoredSocialUser, $$StoredSocialUsersTableReferences),
      StoredSocialUser,
      PrefetchHooks Function({bool storedSnapshotRelationsRefs})
    >;
typedef $$StoredSnapshotsTableCreateCompanionBuilder =
    StoredSnapshotsCompanion Function({
      Value<int> id,
      required int accountId,
      required DateTime capturedAt,
      required String sourceType,
      Value<String?> sourceFormat,
    });
typedef $$StoredSnapshotsTableUpdateCompanionBuilder =
    StoredSnapshotsCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<DateTime> capturedAt,
      Value<String> sourceType,
      Value<String?> sourceFormat,
    });

final class $$StoredSnapshotsTableReferences
    extends
        BaseReferences<
          _$FollowHistoryDatabase,
          $StoredSnapshotsTable,
          StoredSnapshot
        > {
  $$StoredSnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StoredAccountsTable _accountIdTable(_$FollowHistoryDatabase db) => db
      .storedAccounts
      .createAlias('stored_snapshots__account_id__stored_accounts__id');

  $$StoredAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$StoredAccountsTableTableManager(
      $_db,
      $_db.storedAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $StoredSnapshotRelationsTable,
    List<StoredSnapshotRelation>
  >
  _storedSnapshotRelationsRefsTable(_$FollowHistoryDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.storedSnapshotRelations,
        aliasName:
            'stored_snapshots__id__stored_snapshot_relations__snapshot_id',
      );

  $$StoredSnapshotRelationsTableProcessedTableManager
  get storedSnapshotRelationsRefs {
    final manager = $$StoredSnapshotRelationsTableTableManager(
      $_db,
      $_db.storedSnapshotRelations,
    ).filter((f) => f.snapshotId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storedSnapshotRelationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StoredSnapshotsTableFilterComposer
    extends Composer<_$FollowHistoryDatabase, $StoredSnapshotsTable> {
  $$StoredSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceFormat => $composableBuilder(
    column: $table.sourceFormat,
    builder: (column) => ColumnFilters(column),
  );

  $$StoredAccountsTableFilterComposer get accountId {
    final $$StoredAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.storedAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredAccountsTableFilterComposer(
            $db: $db,
            $table: $db.storedAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> storedSnapshotRelationsRefs(
    Expression<bool> Function($$StoredSnapshotRelationsTableFilterComposer f) f,
  ) {
    final $$StoredSnapshotRelationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storedSnapshotRelations,
          getReferencedColumn: (t) => t.snapshotId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredSnapshotRelationsTableFilterComposer(
                $db: $db,
                $table: $db.storedSnapshotRelations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StoredSnapshotsTableOrderingComposer
    extends Composer<_$FollowHistoryDatabase, $StoredSnapshotsTable> {
  $$StoredSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceFormat => $composableBuilder(
    column: $table.sourceFormat,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoredAccountsTableOrderingComposer get accountId {
    final $$StoredAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.storedAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.storedAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredSnapshotsTableAnnotationComposer
    extends Composer<_$FollowHistoryDatabase, $StoredSnapshotsTable> {
  $$StoredSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceFormat => $composableBuilder(
    column: $table.sourceFormat,
    builder: (column) => column,
  );

  $$StoredAccountsTableAnnotationComposer get accountId {
    final $$StoredAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.storedAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.storedAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> storedSnapshotRelationsRefs<T extends Object>(
    Expression<T> Function($$StoredSnapshotRelationsTableAnnotationComposer a)
    f,
  ) {
    final $$StoredSnapshotRelationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storedSnapshotRelations,
          getReferencedColumn: (t) => t.snapshotId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredSnapshotRelationsTableAnnotationComposer(
                $db: $db,
                $table: $db.storedSnapshotRelations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StoredSnapshotsTableTableManager
    extends
        RootTableManager<
          _$FollowHistoryDatabase,
          $StoredSnapshotsTable,
          StoredSnapshot,
          $$StoredSnapshotsTableFilterComposer,
          $$StoredSnapshotsTableOrderingComposer,
          $$StoredSnapshotsTableAnnotationComposer,
          $$StoredSnapshotsTableCreateCompanionBuilder,
          $$StoredSnapshotsTableUpdateCompanionBuilder,
          (StoredSnapshot, $$StoredSnapshotsTableReferences),
          StoredSnapshot,
          PrefetchHooks Function({
            bool accountId,
            bool storedSnapshotRelationsRefs,
          })
        > {
  $$StoredSnapshotsTableTableManager(
    _$FollowHistoryDatabase db,
    $StoredSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> sourceFormat = const Value.absent(),
              }) => StoredSnapshotsCompanion(
                id: id,
                accountId: accountId,
                capturedAt: capturedAt,
                sourceType: sourceType,
                sourceFormat: sourceFormat,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required DateTime capturedAt,
                required String sourceType,
                Value<String?> sourceFormat = const Value.absent(),
              }) => StoredSnapshotsCompanion.insert(
                id: id,
                accountId: accountId,
                capturedAt: capturedAt,
                sourceType: sourceType,
                sourceFormat: sourceFormat,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StoredSnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({accountId = false, storedSnapshotRelationsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (storedSnapshotRelationsRefs) db.storedSnapshotRelations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accountId,
                                    referencedTable:
                                        $$StoredSnapshotsTableReferences
                                            ._accountIdTable(db),
                                    referencedColumn:
                                        $$StoredSnapshotsTableReferences
                                            ._accountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (storedSnapshotRelationsRefs)
                        await $_getPrefetchedData<
                          StoredSnapshot,
                          $StoredSnapshotsTable,
                          StoredSnapshotRelation
                        >(
                          currentTable: table,
                          referencedTable: $$StoredSnapshotsTableReferences
                              ._storedSnapshotRelationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StoredSnapshotsTableReferences(
                                db,
                                table,
                                p0,
                              ).storedSnapshotRelationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.snapshotId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StoredSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$FollowHistoryDatabase,
      $StoredSnapshotsTable,
      StoredSnapshot,
      $$StoredSnapshotsTableFilterComposer,
      $$StoredSnapshotsTableOrderingComposer,
      $$StoredSnapshotsTableAnnotationComposer,
      $$StoredSnapshotsTableCreateCompanionBuilder,
      $$StoredSnapshotsTableUpdateCompanionBuilder,
      (StoredSnapshot, $$StoredSnapshotsTableReferences),
      StoredSnapshot,
      PrefetchHooks Function({bool accountId, bool storedSnapshotRelationsRefs})
    >;
typedef $$StoredSnapshotRelationsTableCreateCompanionBuilder =
    StoredSnapshotRelationsCompanion Function({
      required int snapshotId,
      required String identityKey,
      required int relation,
      Value<int> rowid,
    });
typedef $$StoredSnapshotRelationsTableUpdateCompanionBuilder =
    StoredSnapshotRelationsCompanion Function({
      Value<int> snapshotId,
      Value<String> identityKey,
      Value<int> relation,
      Value<int> rowid,
    });

final class $$StoredSnapshotRelationsTableReferences
    extends
        BaseReferences<
          _$FollowHistoryDatabase,
          $StoredSnapshotRelationsTable,
          StoredSnapshotRelation
        > {
  $$StoredSnapshotRelationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StoredSnapshotsTable _snapshotIdTable(_$FollowHistoryDatabase db) =>
      db.storedSnapshots.createAlias(
        'stored_snapshot_relations__snapshot_id__stored_snapshots__id',
      );

  $$StoredSnapshotsTableProcessedTableManager get snapshotId {
    final $_column = $_itemColumn<int>('snapshot_id')!;

    final manager = $$StoredSnapshotsTableTableManager(
      $_db,
      $_db.storedSnapshots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_snapshotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StoredSocialUsersTable _identityKeyTable(
    _$FollowHistoryDatabase db,
  ) => db.storedSocialUsers.createAlias(
    'stored_snapshot_relations__identity_key__stored_social_users__identity_key',
  );

  $$StoredSocialUsersTableProcessedTableManager get identityKey {
    final $_column = $_itemColumn<String>('identity_key')!;

    final manager = $$StoredSocialUsersTableTableManager(
      $_db,
      $_db.storedSocialUsers,
    ).filter((f) => f.identityKey.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_identityKeyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StoredSnapshotRelationsTableFilterComposer
    extends Composer<_$FollowHistoryDatabase, $StoredSnapshotRelationsTable> {
  $$StoredSnapshotRelationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get relation => $composableBuilder(
    column: $table.relation,
    builder: (column) => ColumnFilters(column),
  );

  $$StoredSnapshotsTableFilterComposer get snapshotId {
    final $$StoredSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.snapshotId,
      referencedTable: $db.storedSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.storedSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StoredSocialUsersTableFilterComposer get identityKey {
    final $$StoredSocialUsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.identityKey,
      referencedTable: $db.storedSocialUsers,
      getReferencedColumn: (t) => t.identityKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredSocialUsersTableFilterComposer(
            $db: $db,
            $table: $db.storedSocialUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredSnapshotRelationsTableOrderingComposer
    extends Composer<_$FollowHistoryDatabase, $StoredSnapshotRelationsTable> {
  $$StoredSnapshotRelationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get relation => $composableBuilder(
    column: $table.relation,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoredSnapshotsTableOrderingComposer get snapshotId {
    final $$StoredSnapshotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.snapshotId,
      referencedTable: $db.storedSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredSnapshotsTableOrderingComposer(
            $db: $db,
            $table: $db.storedSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StoredSocialUsersTableOrderingComposer get identityKey {
    final $$StoredSocialUsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.identityKey,
      referencedTable: $db.storedSocialUsers,
      getReferencedColumn: (t) => t.identityKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredSocialUsersTableOrderingComposer(
            $db: $db,
            $table: $db.storedSocialUsers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredSnapshotRelationsTableAnnotationComposer
    extends Composer<_$FollowHistoryDatabase, $StoredSnapshotRelationsTable> {
  $$StoredSnapshotRelationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get relation =>
      $composableBuilder(column: $table.relation, builder: (column) => column);

  $$StoredSnapshotsTableAnnotationComposer get snapshotId {
    final $$StoredSnapshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.snapshotId,
      referencedTable: $db.storedSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredSnapshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.storedSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StoredSocialUsersTableAnnotationComposer get identityKey {
    final $$StoredSocialUsersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.identityKey,
          referencedTable: $db.storedSocialUsers,
          getReferencedColumn: (t) => t.identityKey,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredSocialUsersTableAnnotationComposer(
                $db: $db,
                $table: $db.storedSocialUsers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$StoredSnapshotRelationsTableTableManager
    extends
        RootTableManager<
          _$FollowHistoryDatabase,
          $StoredSnapshotRelationsTable,
          StoredSnapshotRelation,
          $$StoredSnapshotRelationsTableFilterComposer,
          $$StoredSnapshotRelationsTableOrderingComposer,
          $$StoredSnapshotRelationsTableAnnotationComposer,
          $$StoredSnapshotRelationsTableCreateCompanionBuilder,
          $$StoredSnapshotRelationsTableUpdateCompanionBuilder,
          (StoredSnapshotRelation, $$StoredSnapshotRelationsTableReferences),
          StoredSnapshotRelation,
          PrefetchHooks Function({bool snapshotId, bool identityKey})
        > {
  $$StoredSnapshotRelationsTableTableManager(
    _$FollowHistoryDatabase db,
    $StoredSnapshotRelationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredSnapshotRelationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$StoredSnapshotRelationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StoredSnapshotRelationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> snapshotId = const Value.absent(),
                Value<String> identityKey = const Value.absent(),
                Value<int> relation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredSnapshotRelationsCompanion(
                snapshotId: snapshotId,
                identityKey: identityKey,
                relation: relation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int snapshotId,
                required String identityKey,
                required int relation,
                Value<int> rowid = const Value.absent(),
              }) => StoredSnapshotRelationsCompanion.insert(
                snapshotId: snapshotId,
                identityKey: identityKey,
                relation: relation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StoredSnapshotRelationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({snapshotId = false, identityKey = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (snapshotId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.snapshotId,
                                referencedTable:
                                    $$StoredSnapshotRelationsTableReferences
                                        ._snapshotIdTable(db),
                                referencedColumn:
                                    $$StoredSnapshotRelationsTableReferences
                                        ._snapshotIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (identityKey) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.identityKey,
                                referencedTable:
                                    $$StoredSnapshotRelationsTableReferences
                                        ._identityKeyTable(db),
                                referencedColumn:
                                    $$StoredSnapshotRelationsTableReferences
                                        ._identityKeyTable(db)
                                        .identityKey,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StoredSnapshotRelationsTableProcessedTableManager =
    ProcessedTableManager<
      _$FollowHistoryDatabase,
      $StoredSnapshotRelationsTable,
      StoredSnapshotRelation,
      $$StoredSnapshotRelationsTableFilterComposer,
      $$StoredSnapshotRelationsTableOrderingComposer,
      $$StoredSnapshotRelationsTableAnnotationComposer,
      $$StoredSnapshotRelationsTableCreateCompanionBuilder,
      $$StoredSnapshotRelationsTableUpdateCompanionBuilder,
      (StoredSnapshotRelation, $$StoredSnapshotRelationsTableReferences),
      StoredSnapshotRelation,
      PrefetchHooks Function({bool snapshotId, bool identityKey})
    >;

class $FollowHistoryDatabaseManager {
  final _$FollowHistoryDatabase _db;
  $FollowHistoryDatabaseManager(this._db);
  $$StoredAccountsTableTableManager get storedAccounts =>
      $$StoredAccountsTableTableManager(_db, _db.storedAccounts);
  $$StoredSocialUsersTableTableManager get storedSocialUsers =>
      $$StoredSocialUsersTableTableManager(_db, _db.storedSocialUsers);
  $$StoredSnapshotsTableTableManager get storedSnapshots =>
      $$StoredSnapshotsTableTableManager(_db, _db.storedSnapshots);
  $$StoredSnapshotRelationsTableTableManager get storedSnapshotRelations =>
      $$StoredSnapshotRelationsTableTableManager(
        _db,
        _db.storedSnapshotRelations,
      );
}
