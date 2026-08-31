import 'package:flutter/material.dart';
import 'package:follow_core/follow_core.dart';
import 'package:url_launcher/url_launcher.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({
    required this.result,
    super.key,
  });

  final InstagramFollowAnalysisResult result;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _AnalysisTabData(
        title: 'Takip Etmeyenler',
        description: 'Sen takip ediyorsun, onlar seni takip etmiyor.',
        users: result.analysis.nonFollowers,
      ),
      _AnalysisTabData(
        title: 'Karşılıklı',
        description: 'İki hesap birbirini takip ediyor.',
        users: result.analysis.mutual,
      ),
      _AnalysisTabData(
        title: 'Seni Takip Edenler',
        description: 'Seni takip ediyorlar, sen onları takip etmiyorsun.',
        users: result.analysis.fans,
      ),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Instagram Analizi'),
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
                  for (final tab in tabs) _UserList(data: tab),
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
  const _UserList({required this.data});

  final _AnalysisTabData data;

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
                trailing: const Icon(Icons.open_in_new_rounded, size: 20),
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
