# PROJE_OZETI

Son güncelleme: 1 Eylül 2026

## Çalışma protokolü
- Her yeni sohbet başlangıcında bu dosya okunarak proje devralınır.
- Bu dosya + canlı GitHub repo proje gerçeklik kaynağıdır.
- Çalışan fiziksel/CI baseline korunur; kritik regressions olursa backup branch kullanılır.
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

## X arşiv desteği
- X `window.YTD.*` JS formatları okunur; `accountId` stabil kimliktir.
- Handle yoksa sahte @handle üretilmez; ID açık gösterilir.
- ZIP importer medya/post/DM geçmişini yok sayar; takip dosyalarını kullanır.
- ZIP güvenlik limitleri ve unsafe path kontrolü vardır.
- X ortak `FollowAnalysisEngine` ve aynı Drift geçmiş veritabanını kullanır.
- Previous snapshot varsa Takibi Bırakanlar/Yeni Takipçiler otomatik hesaplanır.
- X profil linkleri harici uygulamada açılır.

## CI doğrulanmış UX / yönetim
- Son hesaplar hızlı seçim.
- Geçmişte platform + hesap filtreleri.
- Manuel iki snapshot karşılaştırma.
- Tek snapshot silme ve seçilen hesabın tüm geçmişini silme; açık onay ve DB güvence testleri.
- Analiz raporunda `Raporu kopyala` + `TXT olarak kaydet`; 5 kategori ve özet sayılar; yok sayılanlar rapordan çıkarılır.

## Aktif geliştirme — `dev/product-polish-batch`
Taban: v2-32 `0959d2775ef8454103f1eddaccd89d4627bf6788`.

### Yerel Veri Yönetimi
- Yeni ekran analiz sayısı, hesap sayısı, yok sayılan kayıt sayısını gösterir.
- `Tüm analiz geçmişini sil`, `Yok sayılanları temizle`, `Tüm yerel veriyi temizle` vardır.
- Riskli işlemler açık onay ister; sosyal medya platformundaki verilere dokunmadığı açıkça yazılıdır.
- Hata snackbar’ı ve başarılı işlem sonrası provider yenilemeleri vardır.
- Widget testi boş cihazda riskli eylemlerin disabled olduğunu doğrular.

### X arşiv rehberi
- `X Arşivi Nasıl İndirilir?` ekranı eklendi.
- Resmi X ayarları → Hesabın → veri arşivini iste/doğrula/indir akışı anlatılır.
- ZIP doğrudan import ve büyük arşiv `follower.js + following.js` fallback anlatılır.
- X rehber testi #34/#35/#36 test koşularında geçti.

### Ana ekran polish
- X kartında `X arşivi nasıl alınır?` bağlantısı.
- Yönetim kartında `Yerel Veri Yönetimi` bağlantısı.
- Instagram/X kartları ortak `_PlatformCard` widget’ına refactor edildi; mevcut import/Son hesaplar/geçmiş/Yok say akışları korunur.

### Product polish CI geçmişi
- #33 `33529876792`: Analyze fail — HomeScreen refactor sözdizimi/lint; düzeltildi.
- #34 `33530222021`: Analyze success; temel testler + X rehber geçti. İki yeni test viewport/scroll harness nedeniyle fail; APK skipped.
- #35 `33530671363`: Analyze success; iki test `scrollable:` parametresine ListView verilmesi nedeniyle fail; üretim testleri geçti; APK skipped.
- #36 `33530990276`: Analyze success. **Yerel Veri Yönetimi testi artık geçti.** Toplam 21 test geçti; yalnız Home smoke fail oldu. Sebep: Home ListView descendant’ında ana dikey Scrollable yanında iki TextField’ın yatay Scrollable’ı da bulunduğu için `findsOneWidget` beklentisi 3 sonuç aldı. APK skipped.
- Son düzeltme: Home smoke `Scrollable` finder’ı yalnız `widget.axisDirection == AxisDirection.down` olan dikey scrollable ile filtreliyor.
- Son test düzeltme commit: `5f8c50e45ad1c0992b9191e0b2fbe0adb63fbcd1`.
- Bu son düzeltme henüz Actions ile doğrulanmadı.

## Test APK imza sistemi
- Paket `com.zmilastudio.takipanalizi.dev`.
- Sabit test sertifikası SHA-256 `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`.
- versionCode = 300000 + Actions run number.

## MVP durumu
### Instagram
- [x] resmi export analizi, geçmiş, profil linki, Yok say, arama/sıralama, 5 sekme
- [x] otomatik + manuel snapshot karşılaştırma
- [x] rapor export — CI success

### X
- [x] JS parser, ZIP/direct JS import, analiz, snapshot/geçmiş, profil/ID-only davranışı
- [x] X entegrasyonu CI success
- [x] uygulama içi X arşiv rehberi — product polish branch
- [ ] gerçek kullanıcı X arşiviyle ileride tek kritik fiziksel doğrulama
- [ ] canlı API/OAuth maliyet/politika değerlendirmesi

### UX / yönetim
- [x] ortak geçmiş, Son hesaplar, filtreler, manuel karşılaştırma
- [x] tek snapshot / hesap geçmişi silme — CI success
- [x] rapor export — CI success
- [x] Yerel Veri Yönetimi — product polish branch
- [x] X arşiv rehberi — product polish branch

## Branch durumu
- `test/device-apk`: `c3af7f883982481a9ef57c7f2de8df63c62e4ce9` — #36 Analyze success / yalnız Home smoke test harness failure.
- `dev/product-polish-batch`: dikey Scrollable smoke düzeltmesi dahil; son kod commit `5f8c50e45ad1c0992b9191e0b2fbe0adb63fbcd1` (bu özet commitinden önce).
- Son tam çalışan rollback: `backup/device-v2-32-report-export-ci-working`.

## Sıradaki iş
Bu özet commitinden sonra dev branch başını `test/device-apk` branch’ine fast-forward et. Tek Actions run ile Analyze + tüm testler + signed debug APK + package/version/exact launcher doğrulaması tamamen geçerse yeni backup baseline oluştur. Kullanıcıdan küçük fiziksel PASS isteme; ardından release polish / kalan MVP işlerine geç.
