import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:follow_core/follow_core.dart';

import '../../../app/theme/app_theme.dart';
import '../../../data/local/follow_history_provider.dart';
import '../../../data/local/ignored_accounts_store.dart';

class LocalDataStats {
  const LocalDataStats({
    required this.snapshotCount,
    required this.accountCount,
    required this.ignoredCount,
  });

  final int snapshotCount;
  final int accountCount;
  final int ignoredCount;

  bool get isEmpty => snapshotCount == 0 && ignoredCount == 0;
}

final localDataStatsProvider = FutureProvider.autoDispose<LocalDataStats>((ref) async {
  final history = await ref.watch(followHistoryDatabaseProvider).listHistory();
  final ignored = await IgnoredAccountsStore().loadAll();
  final accountKeys = <String>{
    for (final item in history)
      '${item.account.platform.name}:${item.account.username.trim().toLowerCase()}',
  };
  return LocalDataStats(
    snapshotCount: history.length,
    accountCount: accountKeys.length,
    ignoredCount: ignored.length,
  );
});

class LocalDataManagementScreen extends ConsumerStatefulWidget {
  const LocalDataManagementScreen({super.key});

  @override
  ConsumerState<LocalDataManagementScreen> createState() =>
      _LocalDataManagementScreenState();
}

class _LocalDataManagementScreenState
    extends ConsumerState<LocalDataManagementScreen> {
  final _ignoredStore = IgnoredAccountsStore();
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(localDataStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Yerel Veri Yönetimi')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            const _PrivacyInfo(),
            const SizedBox(height: 14),
            stats.when(
              loading: () => const _StatsLoading(),
              error: (error, stackTrace) => _StatsError(
                onRetry: () => ref.invalidate(localDataStatsProvider),
              ),
              data: (value) => _StatsCard(stats: value),
            ),
            const SizedBox(height: 18),
            _DataActionCard(
              icon: Icons.history_rounded,
              title: 'Analiz geçmişini temizle',
              description:
                  'Instagram ve X snapshot kayıtlarını, karşılaştırma geçmişini ve bu geçmişte tutulan takip ilişkilerini cihazdan siler.',
              buttonLabel: 'Tüm analiz geçmişini sil',
              destructive: true,
              enabled: !_busy &&
                  (stats.valueOrNull?.snapshotCount ?? 0) > 0,
              onPressed: _clearHistory,
            ),
            const SizedBox(height: 12),
            _DataActionCard(
              icon: Icons.visibility_off_outlined,
              title: 'Yok sayılan hesapları temizle',
              description:
                  'Yok saydığın hesapların tamamını yeniden analiz listelerinde görünür hale getirir.',
              buttonLabel: 'Yok sayılanları temizle',
              destructive: false,
              enabled:
                  !_busy && (stats.valueOrNull?.ignoredCount ?? 0) > 0,
              onPressed: _clearIgnored,
            ),
            const SizedBox(height: 12),
            _DataActionCard(
              icon: Icons.delete_forever_outlined,
              title: 'Tüm yerel analiz verisini temizle',
              description:
                  'Analiz geçmişini ve yok sayılan hesapları birlikte temizler. Sosyal medya hesaplarındaki hiçbir veriyi değiştirmez.',
              buttonLabel: 'Tüm yerel veriyi temizle',
              destructive: true,
              emphasized: true,
              enabled: !_busy && !(stats.valueOrNull?.isEmpty ?? true),
              onPressed: _clearEverything,
            ),
            if (_busy) ...[
              const SizedBox(height: 20),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _clearHistory() async {
    final confirmed = await _confirm(
      title: 'Tüm analiz geçmişini sil?',
      message:
          'Cihazda saklanan tüm Instagram ve X snapshot kayıtları silinecek. Bu işlem geri alınamaz.',
      confirmLabel: 'Geçmişi sil',
    );
    if (!confirmed) return;

    await _runBusy(() async {
      final database = ref.read(followHistoryDatabaseProvider);
      final history = await database.listHistory();
      final accounts = <String, SocialAccount>{};
      for (final item in history) {
        final key = '${item.account.platform.name}:'
            '${item.account.username.trim().toLowerCase()}';
        accounts.putIfAbsent(key, () => item.account);
      }
      for (final account in accounts.values) {
        await database.deleteAccountHistory(account);
      }
      ref.invalidate(recentFollowAccountsProvider);
    }, successMessage: 'Analiz geçmişi temizlendi.');
  }

  Future<void> _clearIgnored() async {
    final confirmed = await _confirm(
      title: 'Yok sayılan hesapları temizle?',
      message:
          'Tüm platform ve hesaplar için yok sayılan kayıtlar kaldırılacak.',
      confirmLabel: 'Temizle',
      destructive: false,
    );
    if (!confirmed) return;

    await _runBusy(
      _ignoredStore.clearAll,
      successMessage: 'Yok sayılan hesaplar temizlendi.',
    );
  }

  Future<void> _clearEverything() async {
    final confirmed = await _confirm(
      title: 'Tüm yerel analiz verisini sil?',
      message:
          'Tüm analiz geçmişi ve yok sayılan hesap kayıtları bu cihazdan silinecek. Bu işlem geri alınamaz. Instagram veya X hesabındaki verilere dokunulmaz.',
      confirmLabel: 'Tümünü sil',
    );
    if (!confirmed) return;

    await _runBusy(() async {
      final database = ref.read(followHistoryDatabaseProvider);
      final history = await database.listHistory();
      final accounts = <String, SocialAccount>{};
      for (final item in history) {
        final key = '${item.account.platform.name}:'
            '${item.account.username.trim().toLowerCase()}';
        accounts.putIfAbsent(key, () => item.account);
      }
      for (final account in accounts.values) {
        await database.deleteAccountHistory(account);
      }
      await _ignoredStore.clearAll();
      ref.invalidate(recentFollowAccountsProvider);
    }, successMessage: 'Tüm yerel analiz verisi temizlendi.');
  }

  Future<void> _runBusy(
    Future<void> Function() action, {
    required String successMessage,
  }) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      ref.invalidate(localDataStatsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
    bool destructive = true,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Vazgeç'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: destructive
                    ? FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor:
                            Theme.of(context).colorScheme.onError,
                      )
                    : null,
                child: Text(confirmLabel),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class _PrivacyInfo extends StatelessWidget {
  const _PrivacyInfo();

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
          Icon(Icons.phonelink_lock_outlined, color: AppColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Bu ekran yalnız Takip Analizi’nin cihazda tuttuğu yerel verileri yönetir. Instagram ve X üzerindeki takip, hesap veya içerik verilerin değişmez.',
              style: TextStyle(color: AppColors.primaryDark),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsLoading extends StatelessWidget {
  const _StatsLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 110,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _StatsError extends StatelessWidget {
  const _StatsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onRetry,
      icon: const Icon(Icons.refresh_rounded),
      label: const Text('Yerel veri bilgilerini yeniden yükle'),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.stats});

  final LocalDataStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            value: stats.snapshotCount,
            label: 'Analiz',
            icon: Icons.analytics_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            value: stats.accountCount,
            label: 'Hesap',
            icon: Icons.account_circle_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            value: stats.ignoredCount,
            label: 'Yok sayılan',
            icon: Icons.visibility_off_outlined,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.icon,
  });

  final int value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 7),
          Text(
            '$value',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _DataActionCard extends StatelessWidget {
  const _DataActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.destructive,
    required this.enabled,
    required this.onPressed,
    this.emphasized = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final String buttonLabel;
  final bool destructive;
  final bool enabled;
  final VoidCallback onPressed;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: emphasized ? error.withValues(alpha: 0.45) : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: destructive ? error : AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(description, style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: enabled ? onPressed : null,
            style: destructive
                ? OutlinedButton.styleFrom(foregroundColor: error)
                : null,
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}
