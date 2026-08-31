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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
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
                      '@${item.account.username}',
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
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RetentionInfo extends StatelessWidget {
  const _RetentionInfo();

  @override
  Widget build(BuildContext context) {
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
              'Cihazda her hesap için son '
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
              'İlk Instagram ZIP analizinden sonra geçmiş burada görünür.',
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

String _formatDate(DateTime value) {
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(local.day)}.${two(local.month)}.${local.year} '
      '${two(local.hour)}:${two(local.minute)}';
}
