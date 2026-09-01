import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';

class XArchiveGuideScreen extends StatelessWidget {
  const XArchiveGuideScreen({super.key});

  static const _steps = [
    _XGuideStepData(
      title: 'X ayarlarını aç',
      body:
          'X uygulamasında profil simgene dokun → “Ayarlar ve gizlilik” → “Hesabın” yolunu izle. Menü adları sürüme göre küçük farklılık gösterebilir.',
      icon: Icons.settings_outlined,
    ),
    _XGuideStepData(
      title: 'Veri arşivini iste',
      body:
          '“Verilerinin bir arşivini indir” seçeneğini aç. X senden şifreni ve e-posta veya telefonuna gelen doğrulama kodunu isteyebilir. Kimliğini doğruladıktan sonra arşiv isteğini gönder.',
      icon: Icons.archive_outlined,
      important: true,
    ),
    _XGuideStepData(
      title: 'Arşivin hazırlanmasını bekle',
      body:
          'X arşiv hazır olduğunda e-posta veya uygulama içi bildirim gönderir. Hazırlanması hesabın büyüklüğüne göre zaman alabilir.',
      icon: Icons.schedule_rounded,
    ),
    _XGuideStepData(
      title: 'ZIP dosyasını indir',
      body:
          'Bildirim geldikten sonra X hesabında oturum açarak arşivi ZIP olarak indir. Takip Analizi; arşiv içindeki follower.js ve following.js dosyalarını kullanır.',
      icon: Icons.download_rounded,
      important: true,
    ),
    _XGuideStepData(
      title: 'Önce ZIP’i doğrudan dene',
      body:
          'Takip Analizi’ne dön ve “X Arşivini İçe Aktar” düğmesinden indirdiğin ZIP’i seç. Tweet, medya ve mesaj geçmişi analiz edilmez; yalnız takip ilişkileri okunur.',
      icon: Icons.folder_open_rounded,
    ),
    _XGuideStepData(
      title: 'Arşiv çok büyükse iki dosyayı seç',
      body:
          'ZIP cihazda işlenemeyecek kadar büyükse arşivi çıkar. Genellikle data klasöründe bulunan follower.js ve following.js dosyalarını “Büyük arşiv” düğmesinden birlikte seç.',
      icon: Icons.data_object_rounded,
      important: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('X Arşivi Nasıl İndirilir?')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          const _XGuideIntro(),
          const SizedBox(height: 14),
          for (var index = 0; index < _steps.length; index++) ...[
            _XGuideStep(number: index + 1, data: _steps[index]),
            if (index != _steps.length - 1) const SizedBox(height: 10),
          ],
          const SizedBox(height: 14),
          const _XGuidePrivacyNote(),
        ],
      ),
    );
  }
}

class _XGuideIntro extends StatelessWidget {
  const _XGuideIntro();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _XGuideIcon(icon: Icons.file_download_outlined),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resmi X veri arşivini kullan',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Takip Analizi X şifreni istemez ve hesabına giriş yapmaz. Analiz, X’in sana verdiği resmi arşiv dosyaları üzerinden cihazında yapılır.',
                  style: TextStyle(color: AppColors.muted, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _XGuideStep extends StatelessWidget {
  const _XGuideStep({required this.number, required this.data});

  final int number;
  final _XGuideStepData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: data.important ? AppColors.softPurple : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: data.important ? const Color(0xFFDCCFFF) : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _XGuideIcon(icon: data.icon),
              Positioned(
                left: -5,
                top: -5,
                child: Container(
                  width: 21,
                  height: 21,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data.body,
                  style: const TextStyle(color: AppColors.muted, height: 1.42),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _XGuidePrivacyNote extends StatelessWidget {
  const _XGuidePrivacyNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.softMint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline_rounded, color: AppColors.mint),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'ZIP veya seçtiğin JS dosyaları sunucuya yüklenmez. Takipçi ve takip edilen listeleri yalnız cihazında işlenir.',
              style: TextStyle(
                color: AppColors.ink,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _XGuideIcon extends StatelessWidget {
  const _XGuideIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.softPurple,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: AppColors.primary, size: 23),
    );
  }
}

class _XGuideStepData {
  const _XGuideStepData({
    required this.title,
    required this.body,
    required this.icon,
    this.important = false,
  });

  final String title;
  final String body;
  final IconData icon;
  final bool important;
}
