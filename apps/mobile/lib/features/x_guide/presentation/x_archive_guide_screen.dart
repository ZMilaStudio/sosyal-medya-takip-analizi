import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';

class XArchiveGuideScreen extends StatelessWidget {
  const XArchiveGuideScreen({super.key});

  static const _steps = [
    _GuideStepData(
      title: 'X ayarlarını aç',
      body:
          'X uygulamasında profil simgene dokun → Ayarlar ve gizlilik → Hesabın bölümüne gir.',
      icon: Icons.settings_outlined,
    ),
    _GuideStepData(
      title: 'Arşiv indirme ekranına gir',
      body:
          '“Verilerinin bir arşivini indir” seçeneğini aç. X şifreni ve gerekirse e-posta veya telefonuna gönderilen doğrulama kodunu ister.',
      icon: Icons.archive_outlined,
      important: true,
    ),
    _GuideStepData(
      title: 'Arşivi iste',
      body:
          'Kimlik doğrulamadan sonra “Arşiv iste” seçeneğine dokun. X arşivi hemen oluşmayabilir; hazır olduğunda e-posta ve/veya uygulama bildirimi gönderilir.',
      icon: Icons.schedule_send_outlined,
    ),
    _GuideStepData(
      title: 'ZIP dosyasını indir',
      body:
          'Arşiv hazır olduğunda aynı ekrandan indir. Takip Analizi, ZIP içindeki takipçi ve takip edilen ilişki dosyalarını cihazında okur; arşiv sunucuya yüklenmez.',
      icon: Icons.download_rounded,
      important: true,
    ),
    _GuideStepData(
      title: 'Arşiv çok büyükse iki dosyayı seç',
      body:
          'X arşivleri medya nedeniyle çok büyük olabilir. ZIP’i cihazında çıkarıp data klasöründeki follower.js ve following.js dosyalarını bul. Uygulamadaki “Büyük arşiv” seçeneğiyle yalnız bu iki dosyayı seçebilirsin.',
      icon: Icons.folder_zip_outlined,
      important: true,
    ),
    _GuideStepData(
      title: 'Analizi başlat',
      body:
          'Takip Analizi ana ekranına dön, X kullanıcı adını yaz ve ZIP arşivini veya iki ilişki dosyasını seç. Sonuçlar ve sonraki arşivlerle oluşan değişimler cihaz geçmişine kaydedilir.',
      icon: Icons.analytics_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('X Arşivi Nasıl İndirilir?')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          const _GuideIntro(),
          const SizedBox(height: 14),
          for (var index = 0; index < _steps.length; index++) ...[
            _GuideStep(number: index + 1, data: _steps[index]),
            if (index != _steps.length - 1) const SizedBox(height: 10),
          ],
          const SizedBox(height: 14),
          const _GuideTip(),
        ],
      ),
    );
  }
}

class _GuideIntro extends StatelessWidget {
  const _GuideIntro();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF3F4F7), Color(0xFFFCFCFD)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GuideIcon(
            icon: Icons.download_for_offline_outlined,
            color: AppColors.ink,
            background: Color(0xFFF0F1F4),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'X’in resmi veri arşivini kullanıyoruz',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Şifre istemiyoruz, hesabına bağlanmıyoruz ve scraping yapmıyoruz. X’in sana verdiği resmi arşiv cihazında analiz edilir.',
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

class _GuideStep extends StatelessWidget {
  const _GuideStep({required this.number, required this.data});

  final int number;
  final _GuideStepData data;

  @override
  Widget build(BuildContext context) {
    final background = data.important ? const Color(0xFFFBFAFF) : Colors.white;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: data.important ? const Color(0xFFDCCFFF) : AppColors.border,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x081E2938),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _GuideIcon(
                icon: data.icon,
                color: data.important ? AppColors.primary : AppColors.muted,
                background: data.important
                    ? AppColors.softPurple
                    : const Color(0xFFF5F4F8),
              ),
              Positioned(
                left: -4,
                top: -5,
                child: Container(
                  width: 20,
                  height: 20,
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

class _GuideTip extends StatelessWidget {
  const _GuideTip();

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
          Icon(Icons.lightbulb_outline_rounded, color: AppColors.mint),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'İpucu: Arşivin yüzlerce MB veya birkaç GB ise ZIP’in tamamı yerine follower.js ve following.js dosyalarını seçmek çok daha hızlıdır.',
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

class _GuideIcon extends StatelessWidget {
  const _GuideIcon({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color, size: 23),
    );
  }
}

class _GuideStepData {
  const _GuideStepData({
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
