import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../instagram_import/application/instagram_import_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final importState = ref.watch(instagramImportControllerProvider);
    final isLoading = importState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
              children: [
                Text(
                  'Takip Analizi',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Takip ilişkilerini güvenli biçimde, cihazında analiz et.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 28),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.camera_alt_outlined),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Instagram',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            const _LocalBadge(),
                          ],
                        ),
                        const SizedBox(height: 18),
                        TextField(
                          controller: _usernameController,
                          enabled: !isLoading,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          decoration: const InputDecoration(
                            labelText: 'Instagram kullanıcı adın',
                            hintText: 'kullanici.adi',
                            prefixText: '@',
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Instagram’dan indirdiğin ZIP dosyası sunucuya gönderilmez. JSON ve HTML export desteklenir.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (importState case AsyncError(:final error)) ...[
                          const SizedBox(height: 14),
                          _ErrorMessage(
                            message: instagramImportErrorMessage(error),
                          ),
                        ],
                        const SizedBox(height: 18),
                        FilledButton.icon(
                          onPressed: isLoading ? null : _pickInstagramArchive,
                          icon: isLoading
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.folder_open_outlined),
                          label: Text(
                            isLoading
                                ? 'Analiz ediliyor…'
                                : 'Instagram Verisini İçe Aktar',
                          ),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: isLoading ? null : () => context.push('/history'),
                          icon: const Icon(Icons.history),
                          label: const Text('Analiz Geçmişi'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.alternate_email),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'X / Twitter',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            const Chip(label: Text('Yakında')),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'İlk sürümde resmi X veri arşiviyle local analiz planlanıyor. Canlı API maliyeti ayrıca değerlendirilecek.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickInstagramArchive() async {
    final result = await ref
        .read(instagramImportControllerProvider.notifier)
        .pickAndAnalyze(_usernameController.text);

    if (!mounted || result == null) return;
    context.push('/analysis', extra: result);
  }
}

class _LocalBadge extends StatelessWidget {
  const _LocalBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          'Cihazda',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
      ),
    );
  }
}
