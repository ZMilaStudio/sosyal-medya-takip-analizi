import 'dart:async';

import 'package:flutter/material.dart';
import 'package:follow_core/follow_core.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/local/ignored_accounts_store.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({
    required this.result,
    super.key,
  });

  final FollowAnalysisResult result;

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final _ignoredStore = IgnoredAccountsStore();
  var _ignored = <String>{};
  Timer? _snackBarTimer;

  @override
  void initState() {
    super.initState();
    _loadIgnored();
  }

  @override
  void dispose() {
    _snackBarTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadIgnored() async {
    final ignored = await _ignoredStore.loadFor(widget.result.snapshot.account);
    if (!mounted) return;
    setState(() => _ignored = ignored);
  }

  Set<SocialUser> _visible(Set<SocialUser> users) => {
        for (final user in users)
          if (!_ignored.contains(user.normalizedUsername)) user,
      };

  Future<void> _ignoreUser(SocialUser user) async {
    await _ignoredStore.ignore(widget.result.snapshot.account, user);
    if (!mounted) return;

    setState(() => _ignored = {..._ignored, user.normalizedUsername});

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    _snackBarTimer?.cancel();

    final controller = messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(
          '${_userLabel(user, widget.result.snapshot.account.platform)} yok sayıldı.',
        ),
        action: SnackBarAction(
          label: 'Geri al',
          onPressed: () async {
            _snackBarTimer?.cancel();
            _snackBarTimer = null;
            await _ignoredStore.restore(
              platform: widget.result.snapshot.account.platform,
              ownerUsername: widget.result.snapshot.account.username,
              ignoredUsername: user.username,
            );
            if (!mounted) return;
            setState(() {
              _ignored = {..._ignored}..remove(user.normalizedUsername);
            });
          },
        ),
      ),
    );

    _snackBarTimer = Timer(const Duration(seconds: 3), () {
      controller.close();
      _snackBarTimer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final platform = result.snapshot.account.platform;
    final tabs = [
      _AnalysisTabData(
        title: 'Takip Etmeyenler',
        description: 'Sen takip ediyorsun, onlar seni takip etmiyor.',
        users: _visible(result.analysis.nonFollowers),
      ),
      _AnalysisTabData(
        title: 'Karşılıklı',
        description: 'İki hesap birbirini takip ediyor.',
        users: _visible(result.analysis.mutual),
      ),
      _AnalysisTabData(
        title: 'Seni Takip Edenler',
        description: 'Seni takip ediyorlar, sen onları takip etmiyorsun.',
        users: _visible(result.analysis.fans),
      ),
      _AnalysisTabData(
        title: 'Takibi Bırakanlar',
        description: 'Önceki analizde seni takip ediyordu, artık etmiyor.',
        users: _visible(result.analysis.unfollowers),
      ),
      _AnalysisTabData(
        title: 'Yeni Takipçiler',
        description: 'Önceki analizden sonra seni takip etmeye başladılar.',
        users: _visible(result.analysis.newFollowers),
      ),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            platform == SocialPlatform.x ? 'X Analizi' : 'Instagram Analizi',
          ),
          actions: [
            IconButton(
              tooltip: 'Yok sayılan hesaplar',
              onPressed: () async {
                await context.push('/ignored-accounts');
                await _loadIgnored();
              },
              icon: const Icon(Icons.visibility_off_outlined),
            ),
            const SizedBox(width: 4),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              for (final tab in tabs)
                Tab(text: '${tab.title} (${tab.users.length})'),
            ],
          ),
        ),
        body: Column(
          children: [
            _Summary(result: result),
            if (result.comparedToPrevious) _ChangeSummary(result: result),
            Expanded(
              child: TabBarView(
                children: [
                  for (final tab in tabs)
                    _UserList(
                      data: tab,
                      platform: platform,
                      onIgnore: _ignoreUser,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.result});

  final FollowAnalysisResult result;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: _CountCard(
              label: 'Takipçi',
              value: result.snapshot.followers.length,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _CountCard(
              label: 'Takip edilen',
              value: result.snapshot.following.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangeSummary extends StatelessWidget {
  const _ChangeSummary({required this.result});

  final FollowAnalysisResult result;

  @override
  Widget build(BuildContext context) {
    final gained = result.analysis.newFollowers.length;
    final lost = result.analysis.unfollowers.length;
    final net = gained - lost;
    final netLabel = net > 0 ? '+$net' : '$net';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: _ChangeMetric(
                  icon: Icons.person_add_alt_1_outlined,
                  label: 'Yeni',
                  value: '+$gained',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ChangeMetric(
                  icon: Icons.person_remove_outlined,
                  label: 'Bırakan',
                  value: '-$lost',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ChangeMetric(
                  icon: Icons.swap_vert_rounded,
                  label: 'Net',
                  value: netLabel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChangeMetric extends StatelessWidget {
  const _ChangeMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20),
        const SizedBox(height: 3),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}

class _CountCard extends StatelessWidget {
  const _CountCard({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value.toString(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 2),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _AnalysisTabData {
  const _AnalysisTabData({
    required this.title,
    required this.description,
    required this.users,
  });

  final String title;
  final String description;
  final Set<SocialUser> users;
}

class _UserList extends StatefulWidget {
  const _UserList({
    required this.data,
    required this.platform,
    required this.onIgnore,
  });

  final _AnalysisTabData data;
  final SocialPlatform platform;
  final Future<void> Function(SocialUser user) onIgnore;

  @override
  State<_UserList> createState() => _UserListState();
}

class _UserListState extends State<_UserList> {
  var _query = '';
  var _ascending = true;

  @override
  Widget build(BuildContext context) {
    if (widget.data.users.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, size: 42),
              const SizedBox(height: 12),
              Text(
                'Bu listede hesap yok.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                widget.data.description,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final users = widget.data.users.where((user) {
      if (_query.isEmpty) return true;
      final displayName = user.displayName?.toLowerCase() ?? '';
      final accountId = user.platformUserId?.toLowerCase() ?? '';
      return user.normalizedUsername.contains(_query) ||
          displayName.contains(_query) ||
          accountId.contains(_query);
    }).toList()
      ..sort((a, b) {
        final comparison =
            a.normalizedUsername.compareTo(b.normalizedUsername);
        return _ascending ? comparison : -comparison;
      });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.data.description),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 12, 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('analysis-search'),
                  textInputAction: TextInputAction.search,
                  onChanged: (value) {
                    setState(() => _query = value.trim().toLowerCase());
                  },
                  decoration: const InputDecoration(
                    hintText: 'Kullanıcı veya hesap ID ara',
                    prefixIcon: Icon(Icons.search_rounded),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                key: const ValueKey('analysis-sort-toggle'),
                tooltip: _ascending ? 'Z-A sırala' : 'A-Z sırala',
                onPressed: () => setState(() => _ascending = !_ascending),
                icon: Text(
                  _ascending ? 'A-Z' : 'Z-A',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: users.isEmpty
              ? const Center(child: Text('Aramana uygun hesap bulunamadı.'))
              : ListView.separated(
                  itemCount: users.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final label = _userLabel(user, widget.platform);
                    final firstCharacter = label.isEmpty
                        ? '?'
                        : label.characters.first.toUpperCase();
                    final idOnly = _isXIdOnlyUser(user, widget.platform);
                    return ListTile(
                      onTap: () => _openProfile(context, user),
                      leading: CircleAvatar(child: Text(firstCharacter)),
                      title: Text(label),
                      subtitle: idOnly
                          ? const Text(
                              'Arşiv kullanıcı adını vermedi • Profile dokun',
                            )
                          : user.displayName == null
                              ? null
                              : Text(user.displayName!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.open_in_new_rounded, size: 20),
                          PopupMenuButton<_UserAction>(
                            tooltip: 'Hesap işlemleri',
                            icon: const Icon(Icons.more_vert_rounded),
                            onSelected: (action) async {
                              if (action == _UserAction.ignore) {
                                await widget.onIgnore(user);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: _UserAction.ignore,
                                child: Row(
                                  children: [
                                    Icon(Icons.visibility_off_outlined),
                                    SizedBox(width: 10),
                                    Text('Yok say'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _openProfile(
    BuildContext context,
    SocialUser user,
  ) async {
    Uri? uri = user.profileUrl;
    if (uri == null) {
      if (_isXIdOnlyUser(user, widget.platform)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bu X hesabının profil bağlantısı arşivde yok.'),
          ),
        );
        return;
      }
      uri = switch (widget.platform) {
        SocialPlatform.instagram =>
          Uri.https('www.instagram.com', '/${user.username}/'),
        SocialPlatform.x => Uri.https('x.com', '/${user.username}'),
      };
    }

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      final platformName =
          widget.platform == SocialPlatform.x ? 'X' : 'Instagram';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$platformName profili açılamadı.')),
      );
    }
  }
}

bool _isXIdOnlyUser(SocialUser user, SocialPlatform platform) =>
    platform == SocialPlatform.x &&
    user.platformUserId != null &&
    user.username == 'id_${user.platformUserId}';

String _userLabel(SocialUser user, SocialPlatform platform) {
  if (_isXIdOnlyUser(user, platform)) {
    return 'X hesabı • ID ${user.platformUserId}';
  }
  return '@${user.username}';
}

enum _UserAction { ignore }
