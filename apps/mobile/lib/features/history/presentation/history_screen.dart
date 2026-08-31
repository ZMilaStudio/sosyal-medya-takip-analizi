import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:follow_core/follow_core.dart';
import 'package:go_router/go_router.dart';

import '../../../data/local/follow_history_database.dart';
import '../../../data/local/follow_history_provider.dart';

final snapshotHistoryProvider = FutureProvider.autoDispose((ref) async {
  final database = ref.watch(followHistoryDatabaseProvider);
  return database.listHistory(platform: SocialPlatform.instagram);
});

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(snapshotHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Analiz Geçmişi')),
      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _HistoryError(
          onRetry: () => ref.invalidate(snapshotHistoryProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const _EmptyHistory();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(snapshotHistoryProvider);
              await ref.read(snapshotHistoryProvider.future);
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              itemCount: items.length + 1,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const _RetentionInfo();
                }
                final item = items[index - 1];
                return _HistoryCard(
                  item: item,
                  onTap: () => _openSnapshot(context, ref, item),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _openSnapshot(
    BuildContext context,
    WidgetRef ref,
    FollowSnapshotHistoryItem item,
  ) async {
    final database = ref.read(followHistoryDatabaseProvider);
    final current = await database.snapshotById(item.snapshotId);
    if (current == null || !context.mounted) return;

    final previous = await database.previousSnapshotBefore(item.snapshotId);
    final analysis = const FollowAnalysisEngine().analyze(
      current: current,
      previous: previous,
    );
    final result = InstagramFollowAnalysisResult(
      snapshot: current,
      analysis: analysis,
      followerSourceFiles: const [],
      followingSourceFiles: const [],
    );

    if (context.mounted) {
      context.push('/analysis', extra: result);
    }
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.item,
    required this.onTap,
  });

  final FollowSnapshotHistoryItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(
          child: Icon(Icons.camera_alt_outlined),
        ),
        title: Text('@${item.account.username}'),
        subtitle: Text(
          '${_formatDate(item.capturedAt)}\n'
          '${item.followersCount} takipçi • ${item.followingCount} takip edilen',
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _RetentionInfo extends StatelessWidget {
  const _RetentionInfo();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.storage_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Cihazda her hesap için son '
                '${FollowHistoryDatabase.defaultSnapshotRetention} analiz saklanır. '
                'En eski kayıtlar otomatik temizlenir.',
              ),
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
            const Icon(Icons.history, size: 46),
            const SizedBox(height: 12),
            Text(
              'Henüz kayıtlı analiz yok.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            const Text(
              'İlk Instagram ZIP analizinden sonra geçmiş burada görünür.',
              textAlign: TextAlign.center,
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

String _formatDate(DateTime value) {
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(local.day)}.${two(local.month)}.${local.year} '
      '${two(local.hour)}:${two(local.minute)}';
}
