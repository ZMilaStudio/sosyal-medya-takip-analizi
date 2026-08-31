import 'package:flutter/material.dart';
import 'package:follow_core/follow_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/presentation/monogram_avatar.dart';

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
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.muted,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700),
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            dividerColor: AppColors.border,
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
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: _CountCard(
              label: 'Takipçi',
              value: result.snapshot.followers.length,
              icon: Icons.people_alt_outlined,
              tint: AppColors.softPurple,
              accent: AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _CountCard(
              label: 'Takip edilen',
              value: result.snapshot.following.length,
              icon: Icons.person_outline_rounded,
              tint: AppColors.softMint,
              accent: AppColors.mint,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountCard extends StatelessWidget {
  const _CountCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
    required this.accent,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color tint;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D5139A8),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: tint,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 1),
                Text(
                  label,
                  style: const TextStyle(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
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
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.data.description,
                style: const TextStyle(color: AppColors.muted),
              ),
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
                  SizedBox(
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          setState(() => _ascending = !_ascending),
                      icon: const Icon(Icons.sort_by_alpha, size: 20),
                      label: Text(_ascending ? 'A-Z' : 'Z-A'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                color: Colors.white,
                child: users.isEmpty
                    ? const Center(child: Text('Aramana uyan hesap yok.'))
                    : ListView.separated(
                        itemCount: users.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return ListTile(
                            onTap: () => _openInstagramProfile(user),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 3,
                            ),
                            leading: MonogramAvatar(
                              username: user.username,
                            ),
                            title: Text(
                              '@${user.username}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w650,
                                color: AppColors.ink,
                              ),
                            ),
                            subtitle: user.displayName == null
                                ? null
                                : Text(user.displayName!),
                            trailing: const Icon(
                              Icons.open_in_new_rounded,
                              size: 20,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      ),
              ),
            ),
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
            Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: AppColors.softPurple,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Bu listede hesap yok.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
