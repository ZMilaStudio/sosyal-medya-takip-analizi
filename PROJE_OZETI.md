# PROJE_OZETI

Son güncelleme: 1 Eylül 2026

## Çalışma protokolü
- Her yeni çalışma başlangıcında bu dosya okunur; bu dosya + canlı GitHub repo gerçeklik kaynağıdır.
- Çalışan fiziksel/CI baseline korunur; riskli geliştirme öncesi backup kullanılır.
- Kullanıcı istemedikçe görsel mockup gönderilmez; gerçek uygulama üzerinden ilerlenir.
- **1 Eylül 2026 kararı:** her küçük değişiklik için ayrı fiziksel test/PASS turu yapılmayacak. Geliştirmeler toplu ilerletilecek; yalnız kritik production RC noktasında tek fiziksel doğrulama yapılacak.
- GitHub Actions kotasını korumak için dev branch’te paket hazırlanır, `test/device-apk` branch’ine toplu alınır.

## Proje amacı ve sabit kararlar
Android öncelikli Flutter + Dart, local-first sosyal medya takip analizi uygulaması.

### Instagram
- Yalnız resmi Meta veri dışa aktarma ZIP içindeki JSON/HTML takip dosyaları cihaz üzerinde analiz edilir.
- Scraping/private API/Instagram şifresi/otomatik follow-unfollow yok.
- `following.json` üst seviye `title` varyasyonu desteklenir.

### X / Twitter
- Resmi X veri arşivi üzerinden local analiz.
- Küçük/orta arşiv ZIP; çok büyük arşivde `follower.js` + `following.js` doğrudan seçilebilir.
- X şifresi uygulamaya girilmez.
- Canlı API/OAuth ancak ileride maliyet ve politika uygunluğu ayrıca değerlendirilirse eklenebilir.

### Ortak analiz
- 5 kategori: Takip Etmeyenler, Karşılıklı, Seni Takip Edenler, Takibi Bırakanlar, Yeni Takipçiler.
- Snapshot/geçmiş cihazda tutulur; yeni import önceki snapshot ile otomatik karşılaştırılır.
- Aynı platform + aynı hesaptan iki keyfi snapshot manuel karşılaştırılabilir.
- Yok sayılan hesaplar platform + hesap bazında local tutulur; ham snapshot sayıları değişmez.
- Kullanıcı satırına dokununca platform profil bağlantısı harici uygulamada açılır.
- Arama, A-Z/Z-A, rapor kopyala/TXT kaydet, Son hesaplar, geçmiş filtreleri ve Yerel Veri Yönetimi vardır.

## Gerçek Instagram fiziksel doğrulaması
- Meta export örneği: 569 takipçi, 1053 takip edilen, 792 takip etmeyen, 261 karşılıklı, 308 yalnız takipçi.
- Instagram UI takip edilen 967 iken export 1053 gösterdi; canlı UI ile export arasında 86 fark görüldü.
- `gece02.19`: ilk snapshot 75 takipçi / 53 takip edilen; ikinci 74 / 46.
- Gerçek sonuç: `Takibi Bırakanlar (6)` + `Yeni Takipçiler (5)`; `75 - 6 + 5 = 74`.
- Gerçek listeler fiziksel Samsung cihazda render edildi ve kullanıcı PASS verdi.

## Fiziksel / CI baseline’lar
- v2-16 liste: `90059b024cc844a101a84ac076e49a22d12b86b6`, backup `backup/device-v2-16-working-baseline`, fiziksel PASS.
- v2-17 profil linki: `ac5cce4ac53cdc05b91a2db6b34765afc40a88e4`, backup `backup/device-v2-17-links-working`, fiziksel PASS.
- v2-21 Yok say: `91bf6a03405d79c57bfe9ccb80c146bfda4ea069`, backup `backup/device-v2-21-ignored-working`, fiziksel PASS.
- v2-22 arama/sıralama: `644549a224ca72d70746ddaada7d223ca9c4d2e0`, backup `backup/device-v2-22-search-sort-working`, fiziksel PASS.
- v2-23 5 sekme: `a0c96ecfd33b9c546c2a852aac3c2b4eee40b1d0`, run `33449350608`, backup `backup/device-v2-23-five-tabs-working`, fiziksel PASS.
- v2-26 exact launcher: `aa63720d49d97fd7f23de69549c307964c684fd5`, run `33485074032`, backup `backup/device-v2-26-exact-icon-working`, fiziksel PASS.
- Manuel snapshot karşılaştırma: `24d920815c9d1425b9fc933b474cc0c10b8dc55f`, run `33513457232`, CI success.
- v2-28 X arşiv: `adebabb4eecca456d4af1efd289ab7324825c66b`, run `33516696991`, backup `backup/device-v2-28-x-archive-ci-working`, tam CI success.
- v2-29 Son hesaplar + geçmiş filtreleri: `5695b525a729dc7cf316e17928b5c4534383012f`, run `33527062959`, backup `backup/device-v2-29-recent-history-filters-ci-working`, tam CI success.
- v2-30 geçmiş veri yönetimi: `804fb57255231ca349d83443135d32747f74284b`, run `33527775313`, backup `backup/device-v2-30-history-data-management-ci-working`, tam CI success.
- v2-32 rapor export: `0959d2775ef8454103f1eddaccd89d4627bf6788`, run `33528930054`, backup `backup/device-v2-32-report-export-ci-working`, tam CI success.
- v2-37 product polish: `71fe29c4f95e97b03a13f8f0ba5e532584dccb0a`, run `33531313731`, backup `backup/device-v2-37-product-polish-ci-working`, tam CI success.
- **v2-38 release polish:** `e79355e5b7a21e19825f55c8f5f51ac79d2d5ebe`, run `33543687577`, backup `backup/device-v2-38-release-polish-ci-working`, **TAM CI SUCCESS**.

## v2-38 güvenli release bilgisi
- Prerelease: `device-test-v2-38`.
- Test package: `com.zmilastudio.takipanalizi.dev`.
- VersionCode: `300038`.
- APK SHA-256: `18161b24ba413123c8d53971d6f7dc2d9fe81c6b9b0e01b4c20b0a05db94b3f6`.
- Boyut: 180,741,350 byte.
- Exact launcher: `apps/mobile/android/app/src/main/res/drawable-nodpi/takip_launcher_user.webp`.
- Exact launcher source SHA-256: `7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`.
- Launcher **yeniden çizilmeyecek / image generation ile üretilmeyecek / alternatifle değiştirilmeyecek**.
- Stable test sertifikası SHA-256: `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`.

## CI doğrulanmış UX / yönetim — v2-38
- 5 sekme ve gerçek satır render.
- Profil açma.
- Yok say / geri yükle / 3 sn Snackbar geri al.
- Arama + A-Z/Z-A.
- Instagram/X ortak geçmiş, platform + hesap filtreleri.
- Otomatik ve manuel snapshot karşılaştırma.
- Tek snapshot silme ve seçili hesap geçmişini silme.
- Son hesaplar hızlı seçim.
- Analiz raporu: kopyala + TXT kaydet; yok sayılanlar rapordan çıkarılır.
- Yerel Veri Yönetimi: tüm geçmiş / yok sayılanlar / tüm local veriyi onaylı silme.
- Instagram arşiv rehberi.
- X arşiv rehberi.
- `Gizlilik ve Hakkında` ekranı.

## Production / Google Play hazırlığı

### Production kimliği ve sürüm
- Production applicationId: `com.zmilastudio.takipanalizi`.
- Device-test applicationId: `com.zmilastudio.takipanalizi.dev`.
- İlk production sürümü **`1.0.0+1`** olarak sabitlendi (`versionName 1.0.0`, `versionCode 1`).
- `apps/mobile/pubspec.yaml` dev branch’te `version: 1.0.0+1` olarak güncel.
- v2-38 CI badging: compileSdk 36 / targetSdk 36 / Android 16.
- 31 Ağustos 2026 sonrası yeni Play uygulamaları için API 36 şartı karşılanıyor; gerçek production AAB’de tekrar doğrulanacak.

### Debug / production INTERNET ayrımı
- `src/debug/AndroidManifest.xml` ve `src/profile/AndroidManifest.xml` Flutter hot reload/debugger için `android.permission.INTERNET` ekler.
- `src/main/AndroidManifest.xml` INTERNET izni içermez.
- Bu nedenle debug APK’da INTERNET görünmesi beklenen development davranışıdır; production hakkında “debug dahil her build internetsiz” denmeyecek.
- Production RC workflow’u build sonrası merged release manifestte `android.permission.INTERNET` görülürse fail edecek.
- Aynı guard merged release manifestte targetSdk 36’yı da doğrular.

### Production signing scaffold
- `.gitignore` private `*.jks`, `*.keystore`, `*.p12`, `*.pem`, `*.key`, `key.properties`, `.env*` dosyalarını engeller.
- Gradle release signing yalnız `PLAY_UPLOAD_*` secure environment değerleriyle `playUpload` config kullanır; public device-test key’e fallback yoktur.
- `SIGNING_SETUP.md` private upload key ve fingerprint recovery prosedürünü açıklar.
- `.github/workflows/production-rc-aab.yml` yalnız manuel `workflow_dispatch` çalışır.
- Varsayılan input: `1.0.0 / 1`.
- Private key secret/fingerprint doğrulaması, Analyze, test, signed AAB, exact launcher, release merged manifest INTERNET/targetSdk guard, signer fingerprint ve 1 günlük artifact retention içerir.
- Bu workflow gerçek private Play upload key olmadığı için **henüz çalıştırılmadı**; kasıtlıdır.

### Privacy / support — TAMAMLANDI
Public `main` branch’te yayınlandı:
- Privacy: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md`
- Support: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md`
- Support / privacy email: `zmilastudio@gmail.com`.
- Policy Türkçe + İngilizce; ZMila Studio/Takip Analizi kimliği, local processing, veri silme, saklama, dış bağlantılar, debug-production ağ ayrımı ve iletişimi açıklar.
- `PRIVACY_SUPPORT_PUBLISH_PLAN.md` artık blocker değil; yayın durumu TAMAMLANDI olarak güncellendi.
- Uygulama içindeki privacy özeti offline kalır; sırf privacy sayfası için production INTERNET izni eklenmez.

### Play Console cevap paketi
- `PLAY_STORE_DATA_SAFETY.md` güncel teknik taslak.
- `PLAY_CONSOLE_FORM_ANSWERS.md` hazır.
- Mevcut local-first mimariye göre önerilen Data Safety temel cevabı: geliştiriciye/üçüncü taraf sunucuya veri gönderilmediği için collection/sharing yok.
- Profil açma kullanıcı tarafından başlatılan harici transfer olarak değerlendirilir.
- Ads: Hayır.
- App access / özel login: Hayır.
- Uygulama kendi hesabını oluşturmaz; server account deletion gereksinimi yok, local silme vardır.
- Target audience önerisi: 18+.
- News / government / health / financial features: Hayır.
- IARC sonucu uydurulmayacak; Console questionnaire üzerinden alınacak.

### Play Store listing
- `PLAY_STORE_LISTING_TR.md` ve `PLAY_STORE_LISTING_EN.md` hazır.
- Ad: `Takip Analizi` — 13/30.
- TR kısa açıklama: `Instagram ve X takip ilişkilerini arşivlerinden cihazında analiz et.` — 68/80.
- EN kısa açıklama: 77/80.
- Kategori: **Araçlar / Tools**.
- Store contact alanları gerçek privacy/support URL ve e-posta ile hazır.
- Kesin Play tag adları uydurulmayacak; Console’dan en fazla 5 gerçekten ilgili tag seçilecek.

## Mağaza görsel hazırlığı
- `STORE_VISUAL_CAPTURE_PLAN.md` hazır.
- Telefon hedefi: 8 gerçek uygulama screenshot’ı, 1080×1920, 9:16, 24-bit PNG/JPEG, alfa yok.
- İlk 3 screenshot doğrudan core UI’ye öncelik verecek.
- S25 Ultra 1440×3120 ham ekran görüntüsü uzun/kısa oranı >2 olduğu için doğrudan Play’e yüklenmeyecek; 9:16 / 1080×1920 gerçek UI çıktısı hazırlanacak.
- Kişisel hesap/takipçi verisi mağaza görsellerinde kullanılmayacak.

### Sentetik store demo arşivleri
Repo yolu: `store_assets/demo_archives/`.

Instagram demo username: `demo_analiz_2026`.
- `instagram/snapshot_1.zip`: 10 takipçi / 11 takip edilen; SHA-256 `9f9938022e3a25b6463c86090439da877412ac96f9c230547368c54904c1a10d`.
- `instagram/snapshot_2.zip`: 11 / 12; **2 Takibi Bırakan + 3 Yeni Takipçi**; SHA-256 `cbc1271712f37b5e1fe02c87ef97b5f6a1bfe868dc1a525a531de901a1be44ab`.

X demo username: `demo_x_analiz_2026`.
- `x/snapshot_1.zip`: 8 takipçi / 9 takip edilen; SHA-256 `2aaa0c99237c6f1e0a685fd69181b345fd1705f6a184e5b5f60a5dc5f0c78937`.
- `x/snapshot_2.zip`: 9 / 10; **1 Takibi Bırakan + 2 Yeni Takipçi**; SHA-256 `cda0e451b5f79c6ab830b195b90fb4475627c07f6765534cb72c03c6a8d7f038`.
- Kullanıcı adları yalnız `demo_*` sentetik değerlerdir; gerçek kişi verisi yok.
- Bu ZIP’ler APK/AAB asset’i değildir; yalnız controlled store screenshot / demo akışı içindir.
- `store_assets/demo_archives/README.md` beklenen tüm sayıları ve kullanım sırasını açıklar.

### Store icon / feature graphic
- 512×512 store icon **yeni logo olarak üretilmeyecek**; exact kilitli launcher rasterından birebir türetilecek.
- Binary source otomatik çıkarma/ölçekleme hattı henüz tamamlanmadığı için 512 PNG açık iş.
- 1024×500 feature graphic açık iş; resmi Instagram/X ilişkisi ima etmeyecek ve user onayı olmadan kilitlenmeyecek.

## Branch durumu
- `test/device-apk`: `e79355e5b7a21e19825f55c8f5f51ac79d2d5ebe` — v2-38 TAM CI SUCCESS, değiştirilmedi.
- **Güncel güvenli rollback:** `backup/device-v2-38-release-polish-ci-working` → `e79355e5b7a21e19825f55c8f5f51ac79d2d5ebe`.
- `backup/device-v2-37-product-polish-ci-working` korunuyor.
- `dev/release-polish-v1`: v2-38 üstünde production hazırlığı. `pubspec.yaml` 1.0.0+1 değişikliği + production workflow guard’ları + docs/store demo assets içerir; **bu dev başı v2-38 sonrası Device Test CI ile henüz doğrulanmadı**.
- Bu dev branch `test/device-apk` üzerine taşınırsa `apps/mobile/pubspec.yaml` değişikliği nedeniyle Device Test Actions tetiklenir; yalnız yeterli kod paketi oluştuğunda tek seferde yapılacak.
- Public `main`: privacy/support sayfaları docs-only yayınlandı.

## Production’a kalan ana kapılar
1. Google Play App Signing durumunu belirle; gerçek private upload key oluştur/kullan.
2. `PLAY_UPLOAD_*` GitHub Secrets değerlerini güvenli biçimde tanımla.
3. Gerçek private key ile manuel production RC AAB `1.0.0 / 1` workflow’unu çalıştır ve AAB doğrulamalarını PASS kapat.
4. Play Console Data Safety / IARC / target audience 18+ / app access ve ilgili deklarasyonları gir.
5. 512×512 exact store icon türevi + 1024×500 feature graphic hazırla.
6. Production RC’den sentetik demo arşivleriyle 8 mağaza screenshot’ı al.
7. Tek kritik production RC fiziksel PASS yap; bu turda gerçek X arşivi doğrulamasını da tamamla.

## Sıradaki iş
- Küçük fiziksel test isteme.
- Gereksiz Actions çalıştırma.
- Actions harcamadan yapılabilecek Play docs/store hazırlığı büyük ölçüde tamamlandı.
- Sonraki gerçek teknik blocker private Play upload signing’dir; key/secrets hazır olmadan production workflow’u çalıştırma.
- Görsel üretimde exact launcher iconu regenerate etme; store icon yalnız mevcut rasterdan türetilir.
