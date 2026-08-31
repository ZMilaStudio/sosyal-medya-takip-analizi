import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';

class InstagramExportGuideScreen extends StatelessWidget {
  const InstagramExportGuideScreen({super.key});

  static const _steps = [
    _GuideStepData(
      title: 'Instagram profilini aç',
      body:
          'Profil ekranında sağ üstteki ☰ menüsüne dokun ve Hesaplar Merkezi’ni aç. Instagram sürümüne göre önce “Ayarlar ve hareketler” ekranı görünebilir.',
      icon: Icons.menu_rounded,
    ),
    _GuideStepData(
      title: 'Bilgilerini dışa aktar',
      body:
          'Hesaplar Merkezi → Bilgilerin ve izinlerin → Bilgilerini dışa aktar → Dışa aktarım oluştur yolunu izle.',
      icon: Icons.ios_share_rounded,
    ),
    _GuideStepData(
      title: 'Instagram hesabını seç',
      body:
          'Analiz etmek istediğin Instagram profilini seç. Ardından “Cihaza aktar” seçeneğine dokun.',
      icon: Icons.account_circle_outlined,
    ),
    _GuideStepData(
      title: 'Yalnız gerekli bilgiyi seç',
      body:
          '“Bilgileri özelleştir” bölümüne gir. Diğer seçimleri temizle. “Bağlantılar” altında yalnız “Takipçiler ve takip edilenler” seçili kalsın.',
      icon: Icons.checklist_rounded,
      important: true,
    ),
    _GuideStepData(
      title: 'Tarih aralığı ve format',
      body:
          'En eksiksiz sonuç için tarih aralığını “Her zaman” yap. Format olarak “JSON” seç. HTML de desteklenir; medya kalitesi bu analiz için önemli değildir.',
      icon: Icons.tune_rounded,
      important: true,
    ),
    _GuideStepData(
      title: 'Dışa aktarımı başlat',
      body:
          '“Dışa aktarımı başlat” düğmesine dokun. Meta dosyayı hazırlayınca bildirim veya e-posta gönderir. Hazır olduğunda ZIP dosyasını indir. Meta, hazır dosyanın indirilmesi için sınırlı süre verir.',
      icon: Icons.cloud_download_outlined,
    ),
    _GuideStepData(
      title: 'ZIP dosyasını uygulamaya yükle',
      body:
          'ZIP dosyasını açmana gerek yok. Takip Analizi’ne dön → “Instagram Verisini İçe Aktar” → indirdiğin ZIP dosyasını seç. Analiz cihazında yapılır; dosya sunucuya gönderilmez.',
      icon: Icons.folder_open_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram Verisi Nasıl İndirilir?'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          const _GuideIntro(),
          const SizedBox(height: 14),
          for (var index = 0; index < _steps.length; index++) ...[
            _GuideStep(
              number: index + 1,
              data: _steps[index],
            ),
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
          colors: [Color(0xFFF2EDFF), Color(0xFFFCFBFF)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GuideIcon(
            icon: Icons.download_for_offline_outlined,
            color: AppColors.primary,
            background: AppColors.softPurple,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yaklaşık birkaç dakikalık ayar',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Instagram menü adları uygulama sürümüne göre küçük farklılıklar gösterebilir. Aşağıdaki seçimler analiz için gereken en küçük veri paketini oluşturur.',
                  style: TextStyle(
                    color: AppColors.muted,
                    height: 1.4,
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

class _GuideStep extends StatelessWidget {
  const _GuideStep({required this.number, required this.data});

  final int number;
  final _GuideStepData data;

  @override
  Widget build(BuildContext context) {
    final accent = data.important ? AppColors.primary : AppColors.ink;
    final background = data.important
        ? const Color(0xFFFBF9FF)
        : Colors.white;

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
            color: Color(0x0A5139A8),
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
                  style: TextStyle(
                    color: accent,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data.body,
                  style: const TextStyle(
                    color: AppColors.muted,
                    height: 1.42,
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
              'İpucu: Sadece “Takipçiler ve takip edilenler” verisini istemek ZIP dosyasını küçültür ve hazırlanmasını kolaylaştırır.',
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
