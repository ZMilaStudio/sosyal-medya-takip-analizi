import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:follow_core/follow_core.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../data/local/follow_history_database.dart';
import '../../../data/local/follow_history_provider.dart';
import '../../instagram_import/application/instagram_import_controller.dart';
import '../../x_import/application/x_import_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _instagramUsernameController = TextEditingController();
  final _xUsernameController = TextEditingController();

  @override
  void dispose() {
    _instagramUsernameController.dispose();
    _xUsernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final instagramState = ref.watch(instagramImportControllerProvider);
    final xState = ref.watch(xImportControllerProvider);
    final recentAccounts = ref.watch(recentFollowAccountsProvider);
    final isBusy = instagramState.isLoading || xState.isLoading;
    final instagramError = switch (instagramState) {
      AsyncError(:final error) => instagramImportErrorMessage(error),
      _ => null,
    };
    final xError = switch (xState) {
      AsyncError(:final error) => xImportErrorMessage(error),
      _ => null,
    };

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
                            'Instagram ve X takip ilişkilerini güvenli biçimde, cihazında analiz et.',
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
                if (recentAccounts case AsyncData(:final value)
                    when value.isNotEmpty) ...[
                  _RecentAccountsCard(
                    accounts: value,
                    onSelected: _selectRecentAccount,
                  ),
                  const SizedBox(height: 18),
                ],
                _PlatformCard(
                  mark: const _InstagramMark(),
                  title: 'Instagram',
                  controller: _instagramUsernameController,
                  enabled: !isBusy,
                  labelText: 'Instagram kullanıcı adın',
                  hintText: 'kullanici.adi',
                  info: const _InstagramLocalInfo(),
                  error: instagramError,
                  importButton: _ImportButton(
                    loading: instagramState.isLoading,
                    label: 'Instagram Verisini İçe Aktar',
                    onPressed: isBusy ? null : _pickInstagramArchive,
                  ),
                  footer: TextButton.icon(
                    onPressed: isBusy
                        ? null
                        : () => context.push('/instagram-guide'),
                    icon: const Icon(Icons.help_outline_rounded),
                    label: const Text('Instagram arşivi nasıl alınır?'),
                  ),
                ),
                const SizedBox(height: 18),
                _PlatformCard(
                  mark: const _XMark(),
                  title: 'X / Twitter',
                  controller: _xUsernameController,
                  enabled: !isBusy,
                  labelText: 'X kullanıcı adın',
                  hintText: 'kullanici_adi',
                  info: const _XLocalInfo(),
                  error: xError,
                  importButton: _ImportButton(
                    loading: xState.isLoading,
                    label: 'X Arşivini İçe Aktar',
                    onPressed: isBusy ? null : _pickXArchive,
                  ),
                  extra: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: isBusy ? null : _pickXRelationshipFiles,
                        icon: const Icon(Icons.data_object_rounded),
                        label: const Text(
                          'Büyük arşiv: follower.js + following.js seç',
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Arşiv çok büyükse ZIP’i çıkardıktan sonra data klasöründeki iki takip dosyasını birlikte seçebilirsin.',
                        style: TextStyle(color: AppColors.muted),
                      ),
                    ],
                  ),
                  footer: TextButton.icon(
                    onPressed: isBusy ? null : () => context.push('/x-guide'),
                    icon: const Icon(Icons.help_outline_rounded),
                    label: const Text('X arşivi nasıl alınır?'),
                  ),
                ),
                const SizedBox(height: 18),
                _SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Geçmiş ve yönetim',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: isBusy ? null : () => context.push('/history'),
                        icon: const Icon(Icons.history_rounded),
                        label: const Text('Analiz Geçmişi'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: isBusy
                            ? null
                            : () => context.push('/ignored-accounts'),
                        icon: const Icon(Icons.visibility_off_outlined),
                        label: const Text('Yok Sayılan Hesaplar'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: isBusy
                            ? null
                            : () => context.push('/data-management'),
                        icon: const Icon(Icons.storage_outlined),
                        label: const Text('Yerel Veri Yönetimi'),
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

  void _selectRecentAccount(FollowSnapshotHistoryItem item) {
    final controller = switch (item.account.platform) {
      SocialPlatform.instagram => _instagramUsernameController,
      SocialPlatform.x => _xUsernameController,
    };
    controller.text = item.account.username;
    controller.selection = TextSelection.collapsed(offset: controller.text.length);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _pickInstagramArchive() async {
    final result = await ref
        .read(instagramImportControllerProvider.notifier)
        .pickAndAnalyze(_instagramUsernameController.text);
    if (!mounted || result == null) return;
    context.push('/analysis', extra: result);
  }

  Future<void> _pickXArchive() async {
    final result = await ref
        .read(xImportControllerProvider.notifier)
        .pickAndAnalyze(_xUsernameController.text);
    if (!mounted || result == null) return;
    context.push('/analysis', extra: result);
  }

  Future<void> _pickXRelationshipFiles() async {
    final result = await ref
        .read(xImportControllerProvider.notifier)
        .pickRelationshipFiles(_xUsernameController.text);
    if (!mounted || result == null) return;
    context.push('/analysis', extra: result);
  }
}

class _PlatformCard extends StatelessWidget {
  const _PlatformCard({
    required this.mark,
    required this.title,
    required this.controller,
    required this.enabled,
    required this.labelText,
    required this.hintText,
    required this.info,
    required this.importButton,
    required this.footer,
    this.error,
    this.extra,
  });

  final Widget mark;
  final String title;
  final TextEditingController controller;
  final bool enabled;
  final String labelText;
  final String hintText;
  final Widget info;
  final Widget importButton;
  final Widget footer;
  final String? error;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    final extraWidget = extra ?? const SizedBox.shrink();
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              mark,
              const SizedBox(width: 14),
              Expanded(
                child: Text(title, style: Theme.of(context).textTheme.titleLarge),
              ),
              const _LocalBadge(),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            enabled: enabled,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              prefixIcon: const Icon(Icons.alternate_email),
            ),
          ),
          const SizedBox(height: 14),
          info,
          if (error != null) ...[
            const SizedBox(height: 14),
            _ErrorMessage(message: error!),
          ],
          const SizedBox(height: 18),
          importButton,
          extraWidget,
          const SizedBox(height: 4),
          footer,
        ],
      ),
    );
  }
}

class _RecentAccountsCard extends StatelessWidget {
  const _RecentAccountsCard({
    required this.accounts,
    required this.onSelected,
  });

  final List<FollowSnapshotHistoryItem> accounts;
  final ValueChanged<FollowSnapshotHistoryItem> onSelected;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Son hesaplar',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              TextButton(
                onPressed: () => context.push('/history'),
                child: const Text('Tümü'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Daha önce analiz ettiğin hesabı seç; kullanıcı adı otomatik dolsun.',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < accounts.length; index++) ...[
            _RecentAccountTile(
              item: accounts[index],
              onTap: () => onSelected(accounts[index]),
            ),
            if (index != accounts.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _RecentAccountTile extends StatelessWidget {
  const _RecentAccountTile({required this.item, required this.onTap});

  final FollowSnapshotHistoryItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final platformLabel = switch (item.account.platform) {
      SocialPlatform.instagram => 'Instagram',
      SocialPlatform.x => 'X',
    };

    return Material(
      color: const Color(0xFFFAFBFC),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              _RecentPlatformMark(platform: item.account.platform),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$platformLabel  @${item.account.username}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item.followersCount} takipçi • '
                      '${item.followingCount} takip edilen • '
                      '${_shortDate(item.capturedAt)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.north_east_rounded,
                size: 20,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentPlatformMark extends StatelessWidget {
  const _RecentPlatformMark({required this.platform});

  final SocialPlatform platform;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: platform == SocialPlatform.x ? AppColors.ink : AppColors.softPurple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: platform == SocialPlatform.x
          ? const Text(
              'X',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            )
          : const Icon(
              Icons.camera_alt_outlined,
              size: 20,
              color: AppColors.primary,
            ),
    );
  }
}

String _shortDate(DateTime value) {
  final local = value.toLocal();
  String two(int part) => part.toString().padLeft(2, '0');
  return '${two(local.day)}.${two(local.month)}.${local.year}';
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
            color: Color(0x0A1E2938),
            blurRadius: 22,
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
          colors: [Color(0xFF7B8797), AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
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
      child: const Icon(Icons.shield_outlined, color: AppColors.primary),
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

class _InstagramLocalInfo extends StatelessWidget {
  const _InstagramLocalInfo();

  @override
  Widget build(BuildContext context) {
    return const _LocalInfo(
      text:
          'Instagram’dan indirdiğin ZIP dosyası sunucuya gönderilmez. JSON ve HTML export desteklenir.',
    );
  }
}

class _XLocalInfo extends StatelessWidget {
  const _XLocalInfo();

  @override
  Widget build(BuildContext context) {
    return const _LocalInfo(
      text:
          'X’in resmi veri arşivindeki follower.js ve following.js dosyaları cihazında okunur; arşiv sunucuya gönderilmez.',
    );
  }
}

class _LocalInfo extends StatelessWidget {
  const _LocalInfo({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
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
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _ImportButton extends StatelessWidget {
  const _ImportButton({
    required this.loading,
    required this.label,
    required this.onPressed,
  });

  final bool loading;
  final String label;
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
              colors: [Color(0xFF6B7789), Color(0xFF556171)],
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
                    const Icon(Icons.folder_open_outlined, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    loading ? 'Analiz ediliyor…' : label,
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
