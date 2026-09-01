# Takip Analizi — Privacy & Support Yayın Durumu

Son güncelleme: 1 Eylül 2026

Amaç: Google Play production yayını için kalıcı, herkese açık gizlilik politikası ve destek kanallarını doğrulanabilir biçimde tutmak.

## Durum: TAMAMLANDI

Play Store iletişim/gizlilik alanları için kullanılacak gerçek bilgiler:

- Gizlilik politikası: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md`
- Destek sayfası: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md`
- Destek / gizlilik e-postası: `zmilastudio@gmail.com`

Privacy ve support sayfaları public GitHub reposunun `main` branch’inde yayınlanmıştır. Uygulama hesabı veya özel erişim gerektirmez.

## 1. Gizlilik politikası

`PRIVACY_POLICY.md` Türkçe ve İngilizce olarak şunları açıklar:

- uygulama: Takip Analizi,
- geliştirici: ZMila Studio,
- resmi destek/gizlilik iletişimi,
- cihaz üzerinde işlenen takip verileri,
- sosyal medya şifrelerinin alınmadığı,
- analiz verilerinin mevcut mimaride geliştirici sunucusuna gönderilmediği,
- Android sistem file picker üzerinden kullanıcı-seçimli dosya erişimi,
- yerel snapshot ve Yok say verisinin saklanması,
- uygulama içi yerel veri silme mekanizması,
- kullanıcı tarafından başlatılan harici Instagram/X profil bağlantıları,
- debug/profile ile production ağ izni ayrımı,
- veri işleme davranışı değişirse politikanın güncelleneceği.

Public policy PDF değildir ve normal HTTPS web sayfası olarak açılır.

## 2. Destek e-postası

Resmi adres:

`zmilastudio@gmail.com`

Destek yaklaşımı:

- kullanıcıdan sosyal medya şifresi istenmez,
- kişisel Instagram/X arşivinin e-postayla gönderilmesi istenmez,
- hata bildirimi için yalnız gerekli teknik bilgiler talep edilir,
- uygulanabilirliği doğrulanmamış bir yanıt süresi/SLA vaat edilmez.

## 3. Destek web sayfası

Public sayfa:

`https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md`

Sayfa:

- ZMila Studio ve Takip Analizi kimliğini,
- destek e-postasını,
- arşiv/şifre göndermeme uyarısını,
- gizlilik politikası bağlantısını,
- Yerel Veri Yönetimi ile silme bilgisini

içerir.

Özel bir ZMila Studio domaini kesinleşmediği için domain uydurulmamıştır. İleride doğrulanmış resmi domain hazır olursa privacy/support URL’leri kontrollü biçimde taşınabilir; Play Console ve policy dosyaları birlikte güncellenmelidir.

## 4. Uygulama içi gizlilik erişimi

v2-38’de `Gizlilik ve Hakkında` ekranı local-first yaklaşımı, şifre istememe, kullanıcı-seçimli dosya erişimi, yerel geçmiş ve dış bağlantıları uygulama içinde açıklar.

Mevcut ürün kararı:

- uygulama içi privacy özeti offline kalır,
- public policy URL Play Store listing’de sunulur,
- sırf privacy sayfasını açmak için uygulamanın production analiz akışına `INTERNET` izni eklenmez.

Flutter debug/profile build’leri geliştirme araçları için kendi manifestlerinden `INTERNET` ekleyebilir. Production RC workflow’u merged release manifestte `android.permission.INTERNET` bulunursa build’i fail edecek şekilde hazırlanmıştır.

## 5. Play Console’a girilecek değerler

Store contact email:

`zmilastudio@gmail.com`

Website / support:

`https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md`

Privacy policy:

`https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md`

Bu değerler `PLAY_STORE_LISTING_TR.md`, `PLAY_STORE_LISTING_EN.md`, `PLAY_CONSOLE_FORM_ANSWERS.md` ve `RELEASE_CHECKLIST.md` ile eşleştirilmiştir.

## 6. Production öncesi son operasyon kontrolleri

Privacy/support bilgi üretimi tamamlandı. Production gönderiminden hemen önce yalnız şu operasyon kontrolleri yapılacak:

- [ ] Privacy URL’yi anonim/incognito tarayıcıdan aç.
- [ ] Support URL’yi anonim/incognito tarayıcıdan aç.
- [ ] Mobil görünümün okunabilir olduğunu kontrol et.
- [ ] `zmilastudio@gmail.com` adresine test mesajı gönderip alındığını doğrula.
- [ ] Play Console Store settings alanlarına yukarıdaki değerleri gir.
- [ ] Production AAB sonrası Data Safety ile privacy policy metnini son kez karşılaştır.

Bunlar yeni içerik üretme blocker’ı değildir; final release operasyon kontrolüdür.

## 7. Yeniden değerlendirme tetikleyicileri

Aşağıdakilerden biri eklenirse privacy/support içeriği ve Play Data Safety production yayını öncesi yeniden gözden geçirilecek:

- reklam / AdMob,
- analytics veya crash reporting,
- canlı Instagram/X API veya OAuth,
- bulut senkronizasyonu,
- kullanıcı hesabı,
- push notification,
- ödeme/abonelik,
- geliştirici sunucusuna veri aktarımı,
- production manifestine yeni ağ veya hassas veri izinleri eklenmesi.
