import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
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
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Takip Analizi',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Takip ilişkilerini güvenli biçimde, cihazında analiz et.',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.muted,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    const _SafetyMark(),
                  ],
                ),
                const SizedBox(height: 26),
                _SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const _InstagramMark(),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Instagram',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const _LocalBadge(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _usernameController,
                        enabled: !isLoading,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                          labelText: 'Instagram kullanıcı adın',
                          hintText: 'kullanici.adi',
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const _LocalInfo(),
                      if (importState case AsyncError(:final error)) ...[
                        const SizedBox(height: 14),
                        _ErrorMessage(
                          message: instagramImportErrorMessage(error),
                        ),
                      ],
                      const SizedBox(height: 18),
                      _GradientImportButton(
                        loading: isLoading,
                        onPressed: isLoading ? null : _pickInstagramArchive,
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () => context.push('/history'),
                        icon: const Icon(Icons.history_rounded),
                        label: const Text('Analiz Geçmişi'),
                      ),
                      const SizedBox(height: 4),
                      TextButton.icon(
                        onPressed: isLoading
                            ? null
                            : () => context.push('/instagram-guide'),
                        icon: const Icon(Icons.help_outline_rounded),
                        label: const Text('Nasıl yapılır?'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const _XMark(),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'X / Twitter',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const _SoonBadge(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'İlk sürümde resmi X veri arşiviyle local analiz planlanıyor. Canlı API maliyeti ayrıca değerlendirilecek.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const _SafetyFooter(),
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

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F5139A8),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _InstagramMark extends StatelessWidget {
  const _InstagramMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFA16BFF), AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x336C43F3),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(
        Icons.camera_alt_outlined,
        color: Colors.white,
      ),
    );
  }
}

class _XMark extends StatelessWidget {
  const _XMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Text(
        'X',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SafetyMark extends StatelessWidget {
  const _SafetyMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.softPurple,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: const Icon(
        Icons.shield_outlined,
        color: AppColors.primary,
      ),
    );
  }
}

class _LocalBadge extends StatelessWidget {
  const _LocalBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.softPurple,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: AppColors.primary,
          ),
          SizedBox(width: 5),
          Text(
            'Cihazda',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SoonBadge extends StatelessWidget {
  const _SoonBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EFF6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        'Yakında',
        style: TextStyle(
          color: AppColors.muted,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LocalInfo extends StatelessWidget {
  const _LocalInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFAFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.softPurple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Instagram’dan indirdiğin ZIP dosyası sunucuya gönderilmez. JSON ve HTML export desteklenir.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientImportButton extends StatelessWidget {
  const _GradientImportButton({
    required this.loading,
    required this.onPressed,
  });

  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: onPressed == null ? 0.62 : 1,
      duration: const Duration(milliseconds: 180),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7851F6), Color(0xFF5D34DF)],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(18),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (loading)
                    const SizedBox.square(
                      dimension: 19,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else
                    const Icon(
                      Icons.folder_open_outlined,
                      color: Colors.white,
                    ),
                  const SizedBox(width: 10),
                  Text(
                    loading
                        ? 'Analiz ediliyor…'
                        : 'Instagram Verisini İçe Aktar',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SafetyFooter extends StatelessWidget {
  const _SafetyFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.softPurple,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock_outline, color: AppColors.primary, size: 20),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Tüm veriler yalnızca cihazında kalır.',
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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
        borderRadius: BorderRadius.circular(14),
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
