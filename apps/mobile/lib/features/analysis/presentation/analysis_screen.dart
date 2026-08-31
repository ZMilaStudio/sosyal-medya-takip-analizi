import 'package:flutter/material.dart';
import 'package:follow_core/follow_core.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/presentation/monogram_avatar.dart';
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
  static const _pageSize = 100;

  final _ignoredStore = IgnoredAccountsStore();
  final _searchController = TextEditingController();

  var _ignored = <String>{};
  var _activeTab = 0;
  var _query = '';
  var _ascending = true;
  var _visibleLimit = _pageSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadIgnored();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadIgnored() async {
    try {
      final ignored =
          await _ignoredStore.loadFor(widget.result.snapshot.account);
      if (!mounted) return;
      setState(() => _ignored = ignored);
    } catch (_) {
      // Ignored-account storage must never prevent the analysis UI from
      // rendering or receiving taps on a physical device.
    }
  }

  Set<SocialUser> _visible(Set<SocialUser> users) => {
        for (final user in users)
          if (!_ignored.contains(user.normalizedUsername)) user,
      };

  void _selectTab(int index) {
    if (_activeTab == index) return;
    FocusManager.instance.primaryFocus?.unfocus();
    _searchController.clear();
    setState(() {
      _activeTab = index;
      _query = '';
      _ascending = true;
      _visibleLimit = _pageSize;
    });
  }

  Future<void> _ignoreUser(SocialUser user) async {
    await _ignoredStore.ignore(widget.result.snapshot.account, user);
    if (!mounted) return;
    setState(() => _ignored = {..._ignored, user.normalizedUsername});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
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
  }

  Future<void> _openIgnoredAccounts() async {
    await context.push('/ignored-accounts');
    await _loadIgnored();
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
      _AnalysisTabData(
        title: 'Takibi Bırakanlar',
        description:
            'Önceki kayıtlı analizde seni takip edip artık takip etmeyenler.',
        users: _visible(result.analysis.unfollowers),
      ),
      _AnalysisTabData(
        title: 'Yeni Takipçiler',
        description:
            'Önceki kayıtlı analizden sonra seni takip etmeye başlayanlar.',
        users: _visible(result.analysis.newFollowers),
      ),
    ];

    final activeTab = tabs[_activeTab];
    final normalizedQuery = _query.trim().toLowerCase();
    final filteredUsers = activeTab.users.where((user) {
      if (normalizedQuery.isEmpty) return true;
      final displayName = user.displayName?.toLowerCase() ?? '';
      return user.normalizedUsername.contains(normalizedQuery) ||
          displayName.contains(normalizedQuery);
    }).toList()
      ..sort((a, b) {
        final comparison =
            a.normalizedUsername.compareTo(b.normalizedUsername);
        return _ascending ? comparison : -comparison;
      });

    final shownUsers = filteredUsers.take(_visibleLimit).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram Analizi'),
        actions: [
          IconButton(
            tooltip: 'Yok sayılan hesaplar',
            onPressed: _openIgnoredAccounts,
            icon: const Icon(Icons.visibility_off_outlined),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ColoredBox(
        key: const Key('analysis-content'),
        color: AppColors.background,
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            key: const Key('analysis-scroll'),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CategoryStrip(
                  tabs: tabs,
                  activeIndex: _activeTab,
                  onSelected: _selectTab,
                ),
                const SizedBox(height: 14),
                _Summary(
                  result: result,
                  ignoredCount: _ignored.length,
                  onManageIgnored: _openIgnoredAccounts,
                ),
                const SizedBox(height: 14),
                _ListControls(
                  data: activeTab,
                  visibleCount: filteredUsers.length,
                  searchController: _searchController,
                  query: _query,
                  ascending: _ascending,
                  onQueryChanged: (value) {
                    setState(() {
                      _query = value;
                      _visibleLimit = _pageSize;
                    });
                  },
                  onClearQuery: () {
                    _searchController.clear();
                    setState(() {
                      _query = '';
                      _visibleLimit = _pageSize;
                    });
                  },
                  onToggleSort: () {
                    setState(() {
                      _ascending = !_ascending;
                      _visibleLimit = _pageSize;
                    });
                  },
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),
                if (activeTab.users.isEmpty)
                  _EmptyList(description: activeTab.description)
                else if (filteredUsers.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 36),
                    child: Center(child: Text('Aramana uyan hesap yok.')),
                  )
                else ...[
                  for (final user in shownUsers) ...[
                    _UserRow(
                      key: Key('user-row-${user.normalizedUsername}'),
                      user: user,
                      onIgnore: _ignoreUser,
                    ),
                    const SizedBox(height: 7),
                  ],
                  if (shownUsers.length < filteredUsers.length) ...[
                    const SizedBox(height: 6),
                    OutlinedButton.icon(
                      key: const Key('analysis-load-more'),
                      onPressed: () {
                        setState(() => _visibleLimit += _pageSize);
                      },
                      icon: const Icon(Icons.expand_more_rounded),
                      label: Text(
                        'Daha fazla göster '
                        '(${filteredUsers.length - shownUsers.length} kaldı)',
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({
    required this.tabs,
    required this.activeIndex,
    required this.onSelected,
  });

  final List<_AnalysisTabData> tabs;
  final int activeIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const Key('analysis-category-strip'),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < tabs.length; index++) ...[
            _CategoryButton(
              data: tabs[index],
              selected: index == activeIndex,
              onTap: () => onSelected(index),
            ),
            if (index != tabs.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _AnalysisTabData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      '${data.title} (${data.users.length})',
      style: const TextStyle(fontWeight: FontWeight.w700),
    );
    final key = Key('analysis-tab-${data.title}');

    if (selected) {
      return FilledButton.tonal(
        key: key,
        onPressed: onTap,
        style: FilledButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          backgroundColor: AppColors.softPurple,
          minimumSize: const Size(0, 46),
          padding: const EdgeInsets.symmetric(horizontal: 14),
        ),
        child: label,
      );
    }

    return OutlinedButton(
      key: key,
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.muted,
        minimumSize: const Size(0, 46),
        padding: const EdgeInsets.symmetric(horizontal: 14),
      ),
      child: label,
    );
  }
}

class _UserRow extends StatelessWidget {
  const _UserRow({
    required this.user,
    required this.onIgnore,
    super.key,
  });

  final SocialUser user;
  final Future<void> Function(SocialUser user) onIgnore;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        onTap: () => _openInstagramProfile(context, user),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 2,
        ),
        leading: MonogramAvatar(username: user.username),
        title: Text(
          '@${user.username}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
        subtitle: user.displayName == null ? null : Text(user.displayName!),
        trailing: PopupMenuButton<_UserAction>(
          tooltip: 'Hesap işlemleri',
          onSelected: (action) async {
            if (action == _UserAction.openProfile) {
              await _openInstagramProfile(context, user);
            } else {
              await onIgnore(user);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: _UserAction.openProfile,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.open_in_new_rounded),
                title: Text('Profili aç'),
              ),
            ),
            PopupMenuItem(
              value: _UserAction.ignore,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.visibility_off_outlined,
                  color: AppColors.danger,
                ),
                title: Text(
                  'Yok say',
                  style: TextStyle(color: AppColors.danger),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListControls extends StatelessWidget {
  const _ListControls({
    required this.data,
    required this.visibleCount,
    required this.searchController,
    required this.query,
    required this.ascending,
    required this.onQueryChanged,
    required this.onClearQuery,
    required this.onToggleSort,
  });

  final _AnalysisTabData data;
  final int visibleCount;
  final TextEditingController searchController;
  final String query;
  final bool ascending;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClearQuery;
  final VoidCallback onToggleSort;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('analysis-controls'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                data.description,
                style: const TextStyle(color: AppColors.muted),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$visibleCount hesap',
              key: const Key('analysis-visible-count'),
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key('analysis-search'),
                controller: searchController,
                onChanged: onQueryChanged,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                decoration: InputDecoration(
                  hintText: 'Kullanıcı ara',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Aramayı temizle',
                          onPressed: onClearQuery,
                          icon: const Icon(Icons.clear),
                        ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 54,
              child: OutlinedButton.icon(
                key: const Key('analysis-sort'),
                onPressed: onToggleSort,
                icon: const Icon(Icons.sort_by_alpha, size: 20),
                label: Text(ascending ? 'A-Z' : 'Z-A'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.result,
    required this.ignoredCount,
    required this.onManageIgnored,
  });

  final InstagramFollowAnalysisResult result;
  final int ignoredCount;
  final VoidCallback onManageIgnored;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('analysis-summary'),
      children: [
        Row(
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
        if (ignoredCount > 0) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onManageIgnored,
              icon: const Icon(Icons.visibility_off_outlined, size: 18),
              label: Text('$ignoredCount hesap yok sayılıyor'),
            ),
          ),
        ],
      ],
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
            color: Color(0x0A1E2938),
            blurRadius: 16,
            offset: Offset(0, 5),
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

enum _UserAction { openProfile, ignore }

class _EmptyList extends StatelessWidget {
  const _EmptyList({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
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
    );
  }
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
