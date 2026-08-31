import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/presentation/monogram_avatar.dart';
import '../../../data/local/ignored_accounts_store.dart';

class IgnoredAccountsScreen extends StatefulWidget {
  const IgnoredAccountsScreen({super.key});

  @override
  State<IgnoredAccountsScreen> createState() => _IgnoredAccountsScreenState();
}

class _IgnoredAccountsScreenState extends State<IgnoredAccountsScreen> {
  final _store = IgnoredAccountsStore();
  var _records = <IgnoredAccountRecord>[];
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final records = await _store.loadAll();
    if (!mounted) return;
    setState(() {
      _records = records;
      _loading = false;
    });
  }

  Future<void> _restore(IgnoredAccountRecord record) async {
    await _store.restore(
      ownerUsername: record.ownerUsername,
      ignoredUsername: record.ignoredUsername,
    );
    await _reload();
  }

  Future<void> _clearAll() async {
    if (_records.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yok sayılanları temizle?'),
        content: const Text(
          'Tüm hesaplar yeniden analiz sonuçlarında gösterilecek.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Temizle'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _store.clearAll();
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yok Sayılan Hesaplar'),
        actions: [
          if (_records.isNotEmpty)
            TextButton(
              onPressed: _clearAll,
              child: const Text('Tümünü temizle'),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? const _EmptyIgnoredState()
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
                  itemCount: _records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final record = _records[index];
                    return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        leading: MonogramAvatar(
                          username: record.ignoredUsername,
                        ),
                        title: Text(
                          '@${record.ignoredUsername}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        subtitle: Text('@${record.ownerUsername} hesabında'),
                        trailing: IconButton(
                          tooltip: 'Yok saymayı kaldır',
                          onPressed: () => _restore(record),
                          icon: const Icon(Icons.undo_rounded),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class _EmptyIgnoredState extends StatelessWidget {
  const _EmptyIgnoredState();

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
                Icons.visibility_outlined,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Henüz yok sayılan hesap yok.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Analiz listesindeki üç nokta menüsünden bir hesabı yok sayabilirsin.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
