import 'package:follow_core/follow_core.dart';

String buildAnalysisTextReport(
  FollowAnalysisResult result, {
  Set<String> ignoredUsernames = const {},
}) {
  final snapshot = result.snapshot;
  final platform = snapshot.account.platform;
  final categories = <_ReportCategory>[
    _ReportCategory(
      'Takip Etmeyenler',
      _visibleUsers(result.analysis.nonFollowers, ignoredUsernames),
    ),
    _ReportCategory(
      'Karşılıklı',
      _visibleUsers(result.analysis.mutual, ignoredUsernames),
    ),
    _ReportCategory(
      'Seni Takip Edenler',
      _visibleUsers(result.analysis.fans, ignoredUsernames),
    ),
    _ReportCategory(
      'Takibi Bırakanlar',
      _visibleUsers(result.analysis.unfollowers, ignoredUsernames),
    ),
    _ReportCategory(
      'Yeni Takipçiler',
      _visibleUsers(result.analysis.newFollowers, ignoredUsernames),
    ),
  ];

  final buffer = StringBuffer()
    ..writeln('TAKİP ANALİZİ RAPORU')
    ..writeln('===================')
    ..writeln('Platform: ${_platformLabel(platform)}')
    ..writeln('Hesap: @${snapshot.account.username}')
    ..writeln('Analiz tarihi: ${_formatDate(snapshot.capturedAt)}')
    ..writeln('Takipçi: ${snapshot.followers.length}')
    ..writeln('Takip edilen: ${snapshot.following.length}');

  if (ignoredUsernames.isNotEmpty) {
    buffer.writeln(
      'Not: Yok sayılan hesaplar aşağıdaki kategori listelerinden çıkarılmıştır.',
    );
  }

  for (final category in categories) {
    buffer
      ..writeln()
      ..writeln('${category.title} (${category.users.length})')
      ..writeln('-' * (category.title.length + 4));

    if (category.users.isEmpty) {
      buffer.writeln('Hesap yok.');
      continue;
    }

    for (final user in category.users) {
      final displayName = user.displayName?.trim();
      final suffix = displayName == null || displayName.isEmpty
          ? ''
          : ' — $displayName';
      buffer.writeln('• ${analysisReportUserLabel(user, platform)}$suffix');
    }
  }

  buffer
    ..writeln()
    ..writeln('Bu rapor Takip Analizi tarafından cihaz üzerinde oluşturuldu.');
  return buffer.toString();
}

String analysisReportFileName(FollowAnalysisResult result) {
  final snapshot = result.snapshot;
  final local = snapshot.capturedAt.toLocal();
  final platform = snapshot.account.platform == SocialPlatform.x
      ? 'x'
      : 'instagram';
  final username = snapshot.account.username
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9._-]+'), '_');
  String two(int value) => value.toString().padLeft(2, '0');
  final timestamp = '${local.year}-${two(local.month)}-${two(local.day)}_'
      '${two(local.hour)}${two(local.minute)}';
  return 'takip-analizi_${platform}_${username}_$timestamp.txt';
}

String analysisReportUserLabel(SocialUser user, SocialPlatform platform) {
  final id = user.platformUserId;
  if (platform == SocialPlatform.x &&
      id != null &&
      user.username == 'id_$id') {
    return 'X hesabı • ID $id';
  }
  return '@${user.username}';
}

List<SocialUser> _visibleUsers(
  Set<SocialUser> users,
  Set<String> ignoredUsernames,
) {
  final visible = users
      .where((user) => !ignoredUsernames.contains(user.normalizedUsername))
      .toList()
    ..sort((a, b) => a.normalizedUsername.compareTo(b.normalizedUsername));
  return List.unmodifiable(visible);
}

String _platformLabel(SocialPlatform platform) => switch (platform) {
      SocialPlatform.instagram => 'Instagram',
      SocialPlatform.x => 'X / Twitter',
    };

String _formatDate(DateTime value) {
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(local.day)}.${two(local.month)}.${local.year} '
      '${two(local.hour)}:${two(local.minute)}';
}

class _ReportCategory {
  const _ReportCategory(this.title, this.users);

  final String title;
  final List<SocialUser> users;
}
