import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:follow_core/follow_core.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/presentation/monogram_avatar.dart';
import '../../../data/local/follow_history_database.dart';
import '../../../data/local/follow_history_provider.dart';

final snapshotHistoryProvider = FutureProvider.autoDispose((ref) async {
  final database = ref.watch(followHistoryDatabaseProvider);
  return database.listHistory();
});

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final List<int> _selectedIds = [];
  bool _compareMode = false;
  _HistoryPlatformFilter _platformFilter = _HistoryPlatformFilter.all;

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(snapshotHistoryProvider);
    final visibleHistory = history.valueOrNull
            ?.where(_matchesPlatformFilter)
            .toList(growable: false) ??
        const <FollowSnapshotHistoryItem>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(_compareMode ? 'İki Analizi Seç' : 'Analiz Geçmişi'),
        actions: [
          if (!_compareMode)
            PopupMenuButton<_HistoryPlatformFilter>(
              tooltip: 'Platform filtresi',
              initialValue: _platformFilter,
              icon: Badge(
                isLabelVisible: _platformFilter != _HistoryPlatformFilter.all,
                child: const Icon(Icons.filter_list_rounded),
              ),
              onSelected: (value) {
                setState(() {
                  _platformFilter = value;
                  _selectedIds.clear();
                });
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: _HistoryPlatformFilter.all,
                  child: Text('Tüm platformlar'),
                ),
                PopupMenuItem(
                  value: _HistoryPlatformFilter.instagram,
                  child: Text('Instagram'),
                ),
                PopupMenuItem(
                  value: _HistoryPlatformFilter.x,
                  child: Text('X / Twitter'),
                ),
              ],
            ),
          if (visibleHistory.length >= 2)
            TextButton(
              onPressed: _toggleCompareMode,
              child: Text(_compareMode ? 'Vazgeç' : 'Karşılaştır'),
            ),
          const SizedBox(width: 6),
        ],
      ),
      bottomNavigationBar: _compareMode
          ? SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: FilledButton.icon(
                onPressed: _selectedIds.length == 2
                    ? () => _compareSelected(visibleHistory)
                    : null,
                icon: const Icon(Icons.compare_arrows_rounded),
                label: Text(
                  _selectedIds.length == 2
                      ? 'Seçilen Analizleri Karşılaştır'
                      : '${_selectedIds.length}/2 analiz seçildi',
                ),
              ),
            )
          : null,
      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _HistoryError(
          onRetry: () => ref.invalidate(snapshotHistoryProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const _EmptyHistory();
          }

          final visibleItems =
              items.where(_matchesPlatformFilter).toList(growable: false);
          if (visibleItems.isEmpty) {
            return _FilteredEmptyHistory(filter: _platformFilter);
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(snapshotHistoryProvider);
              await ref.read(snapshotHistoryProvider.future);
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              itemCount: visibleItems.length + 1,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _compareMode
                      ? const _CompareInfo()
                      : _RetentionInfo(filter: _platformFilter);
                }
                final item = visibleItems[index - 1];
                return _HistoryCard(
                  item: item,
                  selectionMode: _compareMode,
                  selected: _selectedIds.contains(item.snapshotId),
                  onDelete: () => _deleteSnapshot(item),
                  onTap: () => _compareMode
                      ? _toggleSnapshotSelection(visibleItems, item)
                      : _openSnapshot(item),
                );
              },
            ),
          );
        },
      ),
    );
  }

  bool _matchesPlatformFilter(FollowSnapshotHistoryItem item) {
    return switch (_platformFilter) {
      _HistoryPlatformFilter.all => true,
      _HistoryPlatformFilter.instagram =>
        item.account.platform == SocialPlatform.instagram,
      _HistoryPlatformFilter.x => item.account.platform == SocialPlatform.x,
    };
  }

  void _toggleCompareMode() {
    setState(() {
      _compareMode = !_compareMode;
      _selectedIds.clear();
    });
  }

  void _toggleSnapshotSelection(
    List<FollowSnapshotHistoryItem> items,
    FollowSnapshotHistoryItem item,
  ) {
    if (_selectedIds.contains(item.snapshotId)) {
      setState(() => _selectedIds.remove(item.snapshotId));
      return;
    }

    if (_selectedIds.length >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En fazla iki analiz seçebilirsin.')),
      );
      return;
    }

    if (_selectedIds.isNotEmpty) {
      final first = items.firstWhere(
        (candidate) => candidate.snapshotId == _selectedIds.first,
      );
      if (!_sameAccount(first.account, item.account)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Karşılaştırmak için aynı platformdaki aynı hesaba ait iki analiz seç.',
            ),
          ),
        );
        return;
      }
    }

    setState(() => _selectedIds.add(item.snapshotId));
  }

  Future<void> _openSnapshot(FollowSnapshotHistoryItem item) async {
    final database = ref.read(followHistoryDatabaseProvider);
    final current = await database.snapshotById(item.snapshotId);
    if (current == null || !mounted) return;

    final previous = await database.previousSnapshotBefore(item.snapshotId);
    await _openAnalysis(current: current, previous: previous);
  }

  Future<void> _compareSelected(List<FollowSnapshotHistoryItem> items) async {
    if (_selectedIds.length != 2) return;

    final selectedItems = items
        .where((item) => _selectedIds.contains(item.snapshotId))
        .toList();
    if (selectedItems.length != 2 ||
        !_sameAccount(selectedItems[0].account, selectedItems[1].account)) {
      return;
    }

    final database = ref.read(followHistoryDatabaseProvider);
    final first = await database.snapshotById(selectedItems[0].snapshotId);
    final second = await database.snapshotById(selectedItems[1].snapshotId);
    if (first == null || second == null || !mounted) return;

    final older = first.capturedAt.isBefore(second.capturedAt) ? first : second;
    final newer = identical(older, first) ? second : first;

    await _openAnalysis(current: newer, previous: older);
    if (!mounted) return;
    setState(() {
      _compareMode = false;
      _selectedIds.clear();
    });
  }

  Future<void> _deleteSnapshot(FollowSnapshotHistoryItem item) async {
    if (_compareMode) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bu analizi sil?'),
        content: Text(
          '${_platformLabel(item.account.platform)} • @${item.account.username}\n'
          '${_formatDate(item.capturedAt)}\n\n'
          'Bu geçmiş kaydı ve yalnız bu kayda ait ilişki verileri cihazdan silinecek.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final database = ref.read(followHistoryDatabaseProvider);
    await database.deleteSnapshot(item.snapshotId);
    if (!mounted) return;

    _selectedIds.remove(item.snapshotId);
    ref.invalidate(snapshotHistoryProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Analiz geçmişten silindi.')),
    );
  }

  Future<void> _openAnalysis({
    required FollowSnapshot current,
    required FollowSnapshot? previous,
  }) async {
    final analysis = const FollowAnalysisEngine().analyze(
      current: current,
      previous: previous,
    );
    final FollowAnalysisResult result = switch (current.account.platform) {
      SocialPlatform.instagram => InstagramFollowAnalysisResult(
          snapshot: current,
          analysis: analysis,
          comparedToPrevious: previous != null,
          followerSourceFiles: const [],
          followingSourceFiles: const [],
        ),
      SocialPlatform.x => XFollowAnalysisResult(
          snapshot: current,
          analysis: analysis,
          comparedToPrevious: previous != null,
          followerSourceFiles: const [],
          followingSourceFiles: const [],
        ),
    };

    if (mounted) {
      await context.push('/analysis', extra: result);
    }
  }

  bool _sameAccount(SocialAccount a, SocialAccount b) {
    return a.platform == b.platform &&
        a.username.trim().toLowerCase() == b.username.trim().toLowerCase();
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.item,
    required this.onTap,
    required this.onDelete,
    required this.selectionMode,
    required this.selected,
  });

  final FollowSnapshotHistoryItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool selectionMode;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.softPurple : Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              MonogramAvatar(username: item.account.username, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_platformLabel(item.account.platform)} • @${item.account.username}',
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(item.capturedAt),
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item.followersCount} takipçi • ${item.followingCount} takip edilen',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              if (selectionMode)
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected ? AppColors.primary : AppColors.muted,
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.primary,
                    ),
                    PopupMenuButton<_HistoryAction>(
                      tooltip: 'Geçmiş işlemleri',
                      icon: const Icon(Icons.more_vert_rounded),
                      onSelected: (action) {
                        if (action == _HistoryAction.delete) onDelete();
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: _HistoryAction.delete,
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline_rounded),
                              SizedBox(width: 10),
                              Text('Sil'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompareInfo extends StatelessWidget {
  const _CompareInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softPurple,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.compare_arrows_rounded, color: AppColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Aynı platformdaki aynı hesaba ait iki analiz seç. Uygulama eski ve yeni kaydı tarihe göre sıralayıp aradaki takip değişimlerini gösterecek.',
              style: TextStyle(color: AppColors.primaryDark),
            ),
          ),
        ],
      ),
    );
  }
}

class _RetentionInfo extends StatelessWidget {
  const _RetentionInfo({required this.filter});

  final _HistoryPlatformFilter filter;

  @override
  Widget build(BuildContext context) {
    final filterLabel = switch (filter) {
      _HistoryPlatformFilter.all => 'Tüm platformlar',
      _HistoryPlatformFilter.instagram => 'Instagram',
      _HistoryPlatformFilter.x => 'X / Twitter',
    };
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softPurple,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.storage_outlined, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$filterLabel gösteriliyor. Cihazda her hesap için son '
              '${FollowHistoryDatabase.defaultSnapshotRetention} analiz saklanır. '
              'En eski kayıtlar otomatik temizlenir.',
              style: const TextStyle(color: AppColors.primaryDark),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilteredEmptyHistory extends StatelessWidget {
  const _FilteredEmptyHistory({required this.filter});

  final _HistoryPlatformFilter filter;

  @override
  Widget build(BuildContext context) {
    final label = switch (filter) {
      _HistoryPlatformFilter.all => 'bu filtrede',
      _HistoryPlatformFilter.instagram => 'Instagram için',
      _HistoryPlatformFilter.x => 'X için',
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.filter_alt_off_outlined, size: 44),
            const SizedBox(height: 12),
            Text(
              '$label kayıtlı analiz yok.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sağ üstteki filtre düğmesinden başka bir platform seçebilirsin.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: const BoxDecoration(
                color: AppColors.softPurple,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_rounded,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Henüz kayıtlı analiz yok.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            const Text(
              'İlk Instagram veya X arşiv analizinden sonra geçmiş burada görünür.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryError extends StatelessWidget {
  const _HistoryError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 44),
            const SizedBox(height: 12),
            const Text('Geçmiş yüklenemedi.'),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Tekrar dene'),
            ),
          ],
        ),
      ),
    );
  }
}

enum _HistoryPlatformFilter { all, instagram, x }
enum _HistoryAction { delete }

String _platformLabel(SocialPlatform platform) => switch (platform) {
      SocialPlatform.instagram => 'Instagram',
      SocialPlatform.x => 'X',
    };

String _formatDate(DateTime value) {
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(local.day)}.${two(local.month)}.${local.year} '
      '${two(local.hour)}:${two(local.minute)}';
}
