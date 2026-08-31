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

  final InstagramFollowAnalysisResult result;

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final _ignoredStore = IgnoredAccountsStore();
  var _ignored = <String>{};

  @override
  void initState() {
    super.initState();
    _loadIgnored();
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

    final controller = messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text('@${user.username} yok sayıldı.'),
        action: SnackBarAction(
          label: 'Geri al',
          onPressed: () async {
            await _ignoredStore.restore(
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

    final timer = Timer(const Duration(seconds: 3), controller.close);
    unawaited(
      controller.closed.whenComplete(() {
        if (timer.isActive) timer.cancel();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
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
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Instagram Analizi'),
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
            Expanded(
              child: TabBarView(
                children: [
                  for (final tab in tabs)
                    _UserList(
                      data: tab,
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

  final InstagramFollowAnalysisResult result;

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

class _UserList extends StatelessWidget {
  const _UserList({
    required this.data,
    required this.onIgnore,
  });

  final _AnalysisTabData data;
  final Future<void> Function(SocialUser user) onIgnore;

  @override
  Widget build(BuildContext context) {
    final users = data.users.toList()
      ..sort(
        (a, b) => a.normalizedUsername.compareTo(b.normalizedUsername),
      );

    if (users.isEmpty) {
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
                data.description,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(data.description),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: users.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final user = users[index];
              final firstCharacter = user.username.isEmpty
                  ? '?'
                  : user.username.characters.first.toUpperCase();
              return ListTile(
                onTap: () => _openInstagramProfile(context, user),
                leading: CircleAvatar(child: Text(firstCharacter)),
                title: Text('@${user.username}'),
                subtitle: user.displayName == null
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
                          await onIgnore(user);
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

  Future<void> _openInstagramProfile(
    BuildContext context,
    SocialUser user,
  ) async {
    final uri = Uri.https('www.instagram.com', '/${user.username}/');
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Instagram profili açılamadı.')),
      );
    }
  }
}

enum _UserAction { ignore }
