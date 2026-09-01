import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';

class AboutPrivacyScreen extends StatelessWidget {
  const AboutPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gizlilik ve Hakkında')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          const _HeroCard(),
          const SizedBox(height: 12),
          const _InfoCard(
            icon: Icons.phone_android_rounded,
            title: 'Local-first',
            body:
                'Instagram ve X arşivleri cihazında analiz edilir. Production Android sürümü analiz verilerini geliştirici sunucusuna gönderecek INTERNET iznini istemeyecek şekilde hazırlanmıştır. Flutter debug/profile geliştirme build’leri geliştirme araçları için bu izni ekleyebilir.',
          ),
          const SizedBox(height: 10),
          const _InfoCard(
            icon: Icons.password_rounded,
            title: 'Şifre istemiyoruz',
            body:
                'Takip Analizi Instagram veya X şifreni istemez, sosyal medya hesabına otomatik giriş yapmaz ve private API kullanmaz.',
          ),
          const SizedBox(height: 10),
          const _InfoCard(
            icon: Icons.folder_open_rounded,
            title: 'Yalnız seçtiğin dosyalar',
            body:
                'Uygulama yalnız Android sistem dosya seçicisinden açıkça seçtiğin resmi arşiv veya takip dosyalarını okur. Tüm cihaz depolamasına genel erişim istemez.',
          ),
          const SizedBox(height: 10),
          const _InfoCard(
            icon: Icons.history_rounded,
            title: 'Yerel geçmiş',
            body:
                'Takip değişikliklerini karşılaştırabilmek için analiz snapshot’ları ve Yok say tercihleri cihazında tutulabilir.',
          ),
          const SizedBox(height: 10),
          const _InfoCard(
            icon: Icons.cloud_off_rounded,
            title: 'Otomatik yedekleme kapalı',
            body:
                'Production Android yapılandırması uygulama tarafından yönetilen analiz geçmişi ve tercihleri Android cloud backup kapsamı dışında bırakır; Android 12+ veri aktarım kurallarında da yerel app verileri hariç tutulur. Bazı üreticilerin sistem seviyesindeki cihaz taşıma davranışları uygulamanın tam kontrolü dışında olabilir.',
          ),
          const SizedBox(height: 10),
          const _InfoCard(
            icon: Icons.ios_share_rounded,
            title: 'Raporu sen dışa aktarırsın',
            body:
                'Raporu kopyalamayı seçersen analiz metni sistem panosuna; TXT olarak kaydetmeyi seçersen seçtiğin dosya konumuna yazılır. Bu işlemler yalnız sen başlattığında gerçekleşir ve rapor geliştirici sunucusuna gönderilmez.',
          ),
          const SizedBox(height: 10),
          const _InfoCard(
            icon: Icons.open_in_new_rounded,
            title: 'Dış bağlantılar',
            body:
                'Bir sosyal medya profilini açmayı seçersen bağlantı harici tarayıcıya veya ilgili sosyal medya uygulamasına devredilir. Bundan sonraki veri işleme ilgili hizmetin politikasına tabidir.',
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => context.push('/data-management'),
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('Yerel verilerimi yönet'),
          ),
          const SizedBox(height: 18),
          const _DeveloperCard(),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.softPurple,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBox(icon: Icons.shield_outlined),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Takip Analizi',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Instagram ve X takip ilişkilerini, hesabının şifresini paylaşmadan ve arşivlerini geliştirici sunucusuna göndermeden analiz etmek için tasarlanmıştır.',
                  style: TextStyle(color: AppColors.muted, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBox(icon: icon),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppColors.muted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeveloperCard extends StatelessWidget {
  const _DeveloperCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Geliştirici',
            style: TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'ZMila Studio',
            style: TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Gizlilik ve destek: zmilastudio@gmail.com\nTam gizlilik politikası ve destek sayfası Google Play mağaza girişinde herkese açık olarak sunulur.',
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.softPurple,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, color: AppColors.primary, size: 22),
    );
  }
}
