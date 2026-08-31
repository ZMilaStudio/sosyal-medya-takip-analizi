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
      _AnalysisTabData(
        title: 'Takibi Bırakanlar',
        description:
            'Önceki kayıtlı analizde seni takip edip artık takip etmeyenler.',
        users: result.analysis.unfollowers,
      ),
      _AnalysisTabData(
        title: 'Yeni Takipçiler',
        description:
            'Önceki kayıtlı analizden sonra seni takip etmeye başlayanlar.',
        users: result.analysis.newFollowers,
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

class _UserList extends StatefulWidget {
  const _UserList({required this.data});

  final _AnalysisTabData data;

  @override
  State<_UserList> createState() => _UserListState();
}

class _UserListState extends State<_UserList> {
  final _searchController = TextEditingController();
  var _query = '';
  var _ascending = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.users.isEmpty) {
      return _EmptyList(description: widget.data.description);
    }

    final normalizedQuery = _query.trim().toLowerCase();
    final users = widget.data.users.where((user) {
      if (normalizedQuery.isEmpty) return true;
      final displayName = user.displayName?.toLowerCase() ?? '';
      return user.normalizedUsername.contains(normalizedQuery) ||
          displayName.contains(normalizedQuery);
    }).toList()
      ..sort((a, b) {
        final result = a.normalizedUsername.compareTo(b.normalizedUsername);
        return _ascending ? result : -result;
      });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.data.description),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        hintText: 'Kullanıcı ara',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Aramayı temizle',
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _query = '');
                                },
                                icon: const Icon(Icons.clear),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _ascending = !_ascending),
                    icon: const Icon(Icons.sort_by_alpha),
                    label: Text(_ascending ? 'A-Z' : 'Z-A'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: users.isEmpty
              ? const Center(child: Text('Aramana uyan hesap yok.'))
              : ListView.separated(
                  itemCount: users.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final firstCharacter = user.username.isEmpty
                        ? '?'
                        : user.username.characters.first.toUpperCase();
                    return ListTile(
                      onTap: () => _openInstagramProfile(user),
                      leading: CircleAvatar(child: Text(firstCharacter)),
                      title: Text('@${user.username}'),
                      subtitle: user.displayName == null
                          ? null
                          : Text(user.displayName!),
                      trailing: const Icon(Icons.open_in_new, size: 20),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _openInstagramProfile(SocialUser user) async {
    final uri = Uri.https('www.instagram.com', '/${user.username}/');
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Instagram profili açılamadı.')),
      );
    }
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
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
            Text(description, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
