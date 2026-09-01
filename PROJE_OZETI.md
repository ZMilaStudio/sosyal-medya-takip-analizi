# PROJE_OZETI

Son güncelleme: 1 Eylül 2026

## Çalışma protokolü
- Her yeni sohbet başlangıcında bu dosya okunarak proje devralınır.
- Bu dosya + canlı GitHub repo proje gerçeklik kaynağıdır.
- Çalışan fiziksel/CI baseline korunur; kritik regression olursa backup branch kullanılır.
- Kullanıcı istemedikçe görsel mockup gönderilmez; gerçek uygulama üzerinden ilerlenir.
- **1 Eylül 2026 kararı:** her küçük değişiklik için ayrı fiziksel test/PASS turu yapılmayacak. Geliştirmeler toplu ilerletilecek; yalnız kritik sürüm noktalarında tek fiziksel doğrulama yapılacak.
- GitHub Actions kotasını korumak için büyük geliştirmeler dev branch’lerinde hazırlanıp `test/device-apk` branch’ine toplu alınır.

## Proje amacı ve sabit kararlar
Android öncelikli Flutter + Dart, local-first sosyal medya takip analizi uygulaması.

### Instagram
- Yalnız resmi Meta veri dışa aktarma ZIP/JSON/HTML dosyaları cihaz üzerinde analiz edilir.
- Scraping/private API/Instagram şifresi/otomatik follow-unfollow yok.
- `following.json` üst seviye `title` varyasyonu desteklenir.

### X / Twitter
- İlk entegrasyon resmi X veri arşivi üzerinden local analizdir.
- Canlı API/OAuth daha sonra maliyet ve politika uygunluğuna göre değerlendirilecek.
- Küçük/orta X arşivi ZIP; çok büyük arşivlerde `follower.js` + `following.js` doğrudan seçilebilir.
- X şifresi uygulamaya girilmez.

### Ortak analiz
- 5 kategori: Takip Etmeyenler, Karşılıklı, Seni Takip Edenler, Takibi Bırakanlar, Yeni Takipçiler.
- Snapshot/geçmiş cihazda tutulur; yeni import önceki snapshot ile otomatik karşılaştırılır.
- Aynı platform + aynı hesaba ait iki keyfi snapshot manuel karşılaştırılabilir.
- Yok sayılan hesaplar platform + hesap bazında local tutulur; ham snapshot sayıları değişmez.
- Kullanıcı satırına dokununca platform profil bağlantısı harici uygulamada açılır.

## Gerçek Instagram doğrulaması
- Meta export: 569 takipçi, 1053 takip edilen, 792 takip etmeyen, 261 karşılıklı, 308 yalnız takipçi.
- Instagram UI takip edilen 967; export ile UI arasında 86 fark görüldü.
- `gece02.19`: ilk snapshot 75 takipçi / 53 takip edilen; ikinci 74 / 46. `Takibi Bırakanlar (6)` + `Yeni Takipçiler (5)`; net `75 - 6 + 5 = 74`.
- Gerçek listeler fiziksel cihazda render edildi ve kullanıcı PASS verdi.

## Fiziksel / CI baseline’lar
- v2-16 liste: `90059b024cc844a101a84ac076e49a22d12b86b6`, backup `backup/device-v2-16-working-baseline`, fiziksel PASS.
- v2-17 profil linki: `ac5cce4ac53cdc05b91a2db6b34765afc40a88e4`, backup `backup/device-v2-17-links-working`, fiziksel PASS.
- v2-21 Yok say: `91bf6a03405d79c57bfe9ccb80c146bfda4ea069`, backup `backup/device-v2-21-ignored-working`, fiziksel PASS.
- v2-22 arama/sıralama: `644549a224ca72d70746ddaada7d223ca9c4d2e0`, backup `backup/device-v2-22-search-sort-working`, fiziksel PASS.
- v2-23 5 sekme: `a0c96ecfd33b9c546c2a852aac3c2b4eee40b1d0`, run `33449350608`, backup `backup/device-v2-23-five-tabs-working`, fiziksel PASS.
- v2-26 exact launcher: `aa63720d49d97fd7f23de69549c307964c684fd5`, run `33485074032`, backup `backup/device-v2-26-exact-icon-working`, fiziksel Samsung PASS. Launcher `apps/mobile/android/app/src/main/res/drawable-nodpi/takip_launcher_user.webp`, SHA-256 `7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`.
- Manuel snapshot karşılaştırma: `24d920815c9d1425b9fc933b474cc0c10b8dc55f`, run `33513457232`, CI success.
- v2-28 X arşiv entegrasyonu: `adebabb4eecca456d4af1efd289ab7324825c66b`, run `33516696991`, backup `backup/device-v2-28-x-archive-ci-working`, tam CI success.
- v2-29 Son hesaplar + geçmiş filtreleri: `5695b525a729dc7cf316e17928b5c4534383012f`, run `33527062959`, backup `backup/device-v2-29-recent-history-filters-ci-working`, tam CI success.
- v2-30 geçmiş veri yönetimi: `804fb57255231ca349d83443135d32747f74284b`, run `33527775313`, backup `backup/device-v2-30-history-data-management-ci-working`, tam CI success.
- v2-32 rapor export: `0959d2775ef8454103f1eddaccd89d4627bf6788`, run `33528930054`, backup `backup/device-v2-32-report-export-ci-working`, tam CI success.
- v2-37 product polish: `71fe29c4f95e97b03a13f8f0ba5e532584dccb0a`, run `33531313731`, backup `backup/device-v2-37-product-polish-ci-working`, tam CI success.
- **v2-38 release polish:** `e79355e5b7a21e19825f55c8f5f51ac79d2d5ebe`, run `33543687577`, backup `backup/device-v2-38-release-polish-ci-working`, **TAM CI SUCCESS**. Analyze, tüm testler, physical-device wiring, test signing, signed debug APK, package/version, exact launcher, signer sertifikası ve prerelease yayını geçti.

## v2-38 release bilgisi
- Prerelease tag: `device-test-v2-38`.
- VersionCode: `300038`.
- Paket: `com.zmilastudio.takipanalizi.dev`.
- APK: `takip-analizi-device-test.apk`.
- APK SHA-256: `18161b24ba413123c8d53971d6f7dc2d9fe81c6b9b0e01b4c20b0a05db94b3f6`.
- Boyut: 180,741,350 byte.
- Exact launcher asset kilidi korunuyor; kaynak icon SHA-256 `7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`.
- Production değildir; mevcut v2 uygulamanın üzerine kaldırmadan kurulabilir.

## X arşiv desteği
- X `window.YTD.*` JS formatları okunur; `accountId` stabil kimliktir.
- Handle yoksa sahte @handle üretilmez; ID açık gösterilir.
- ZIP importer medya/post/DM geçmişini yok sayar; takip dosyalarını kullanır.
- ZIP güvenlik limitleri ve unsafe path kontrolü vardır.
- X ortak `FollowAnalysisEngine` ve aynı Drift geçmiş veritabanını kullanır.
- Previous snapshot varsa Takibi Bırakanlar/Yeni Takipçiler otomatik hesaplanır.
- X profil linkleri harici uygulamada açılır.
- Uygulama içi `X Arşivi Nasıl İndirilir?` rehberi vardır; resmi X ayarları → Hesabın → veri arşivini iste/doğrula/indir akışı ve büyük arşiv `follower.js + following.js` fallback anlatılır.

## CI doğrulanmış UX / yönetim — v2-38
- Son hesaplar hızlı seçim.
- Geçmişte platform + hesap filtreleri.
- Manuel iki snapshot karşılaştırma.
- Tek snapshot silme ve seçilen hesabın tüm geçmişini silme; açık onay ve DB güvence testleri.
- Analiz raporunda `Raporu kopyala` + `TXT olarak kaydet`; 5 kategori ve özet sayılar; yok sayılanlar rapordan çıkarılır.
- **Yerel Veri Yönetimi** ekranı: analiz sayısı, hesap sayısı, yok sayılan kayıt sayısı; tüm geçmişi sil, yok sayılanları temizle, tüm yerel veriyi temizle. Riskli işlemler onay ister ve sosyal medya platformundaki verilere dokunmaz.
- Ana ekranda Instagram/X arşiv rehberleri, Yerel Veri Yönetimi ve **Gizlilik ve Hakkında** bağlantıları vardır.
- Instagram/X ana kartları ortak `_PlatformCard` yapısında; mevcut import/Son hesaplar/geçmiş/Yok say akışları korunur.
- Gizlilik ve Hakkında ekranı local-first, şifre istememe, seçilen dosya erişimi, yerel geçmiş, dış bağlantılar ve ZMila Studio bilgisini açıklar; Yerel Veri Yönetimi’ne bağlantı verir.

## Release / Play hazırlığı — CI doğrulanmış scaffold
- `PRIVACY_POLICY.md`: Türkçe + İngilizce gizlilik politikası taslağı.
- `PLAY_STORE_DATA_SAFETY.md`: mevcut local-first mimariye göre Play Veri Güvenliği teknik taslağı.
- `RELEASE_CHECKLIST.md`: production yayın kapıları.
- `SIGNING_SETUP.md`: production upload key kurulum, fingerprint doğrulama ve recovery prosedürü.
- `.gitignore`: private `*.jks`, `*.keystore`, `*.p12`, `*.pem`, `*.key`, `key.properties`, `.env*` dosyalarını engeller.
- Gradle production release signing yalnız `PLAY_UPLOAD_*` secure environment değerleri mevcutsa `playUpload` signing config kullanır; device-test key’e fallback yoktur.
- `.github/workflows/production-rc-aab.yml`: yalnız manuel `workflow_dispatch`; versionName/versionCode input, private secret kontrolü, upload-key fingerprint doğrulaması, Analyze + test + signed AAB + signer fingerprint kontrolü, 1 gün artifact retention.
- `production-rc-aab.yml` henüz gerçek private key ile çalıştırılmadı; bu kasıtlıdır.
- Kalıcı public privacy URL + resmi destek iletişim kanalı production blocker olarak açık bırakıldı; sahte iletişim bilgisi eklenmedi.

## Test APK imza sistemi
- Paket `com.zmilastudio.takipanalizi.dev`.
- Sabit test sertifikası SHA-256 `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`.
- versionCode = 300000 + Actions run number.

## MVP durumu
### Instagram
- [x] resmi export analizi, geçmiş, profil linki, Yok say, arama/sıralama, 5 sekme
- [x] otomatik + manuel snapshot karşılaştırma
- [x] rapor export

### X
- [x] JS parser, ZIP/direct JS import, analiz, snapshot/geçmiş, profil/ID-only davranışı
- [x] X entegrasyonu CI success
- [x] uygulama içi X arşiv rehberi
- [ ] gerçek kullanıcı X arşiviyle ileride tek kritik fiziksel doğrulama
- [ ] canlı API/OAuth maliyet/politika değerlendirmesi

### UX / yönetim
- [x] ortak geçmiş, Son hesaplar, filtreler, manuel karşılaştırma
- [x] tek snapshot / hesap geçmişi silme
- [x] rapor export
- [x] Yerel Veri Yönetimi
- [x] X arşiv rehberi
- [x] Gizlilik ve Hakkında
- [x] release signing scaffold + Play hazırlık dokümanları
- [x] v2-38 release-polish tam CI doğrulaması

## Branch durumu
- `test/device-apk`: `e79355e5b7a21e19825f55c8f5f51ac79d2d5ebe` — v2-38 tam CI success.
- **Güncel güvenli rollback:** `backup/device-v2-38-release-polish-ci-working` → `e79355e5b7a21e19825f55c8f5f51ac79d2d5ebe`.
- `backup/device-v2-37-product-polish-ci-working` korunuyor.
- `dev/release-polish-v1`: v2-38 kodu + bu docs success güncellemesi.
- `dev/product-polish-batch`: önceki ürün polish hattı.

## Production’a kalan ana kapılar
1. Gerçek Play App Signing / private upload key durumunu belirle ve `PLAY_UPLOAD_*` secrets değerlerini güvenli biçimde tanımla.
2. Final production versionName/versionCode kararı.
3. Kalıcı public privacy policy URL + resmi destek URL/e-posta.
4. Play Store kısa/tam açıklama, kategori ve mağaza görselleri.
5. Play Data safety / içerik derecelendirme / hedef kitle formlarının son doldurulması.
6. Gerçek private key ile manuel production RC AAB workflow’unu çalıştırma.
7. Tek kritik production RC fiziksel PASS; X gerçek arşiv doğrulaması bu turda yapılacak.

## Sıradaki iş
- v2-38 güvenli CI baseline olarak kilitlendi; küçük fiziksel PASS istenmeyecek.
- Actions kotasını harcamadan önce Play Store listing metinleri ve privacy/support yayın planını hazırlamaya devam et.
- Production signing yalnız kullanıcı gerçek private upload key aşamasına hazır olduğunda devreye alınacak.
