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
- Küçük/orta X arşivi ZIP olarak; çok büyük arşivlerde yalnız `follower.js` + `following.js` dosyaları seçilerek analiz edilebilir.
- X şifresi uygulamaya girilmez.

### Ortak analiz
- 5 kategori: Takip Etmeyenler, Karşılıklı, Seni Takip Edenler, Takibi Bırakanlar, Yeni Takipçiler.
- Snapshot/geçmiş verisi cihazda tutulur.
- Aynı hesabın yeni importu önceki snapshot ile otomatik karşılaştırılır.
- Geçmişten aynı platformdaki aynı hesaba ait herhangi iki snapshot manuel seçilip karşılaştırılabilir.
- Yok sayılan hesaplar platform + hesap bazında local tutulur; ham snapshot sayıları değişmez.
- Kullanıcı satırına dokununca platform profil bağlantısı harici uygulamada açılır.

## Gerçek Instagram export doğrulaması
- Ana gerçek Meta export: 569 takipçi, 1053 takip edilen, 792 takip etmeyen, 261 karşılıklı, 308 yalnız takipçi.
- Instagram UI takip edilen sayısı 967; export ile UI arasında 86 hesap farkı görüldü.
- `gece02.19`: ilk snapshot 75/53, ikinci 74/46; `Takibi Bırakanlar (6)` + `Yeni Takipçiler (5)`; net `75 - 6 + 5 = 74`.
- Gerçek listeler fiziksel cihazda render edildi ve kullanıcı PASS verdi.
- Otomatik previous → current karşılaştırma → snapshot kaydı gerçek Meta arşivleriyle TAM PASS.

## Fiziksel / CI baseline’lar
- **v2-16 liste:** `90059b024cc844a101a84ac076e49a22d12b86b6`, backup `backup/device-v2-16-working-baseline`, fiziksel PASS.
- **v2-17 profil linki:** `ac5cce4ac53cdc05b91a2db6b34765afc40a88e4`, backup `backup/device-v2-17-links-working`, fiziksel PASS.
- **v2-21 Yok say:** `91bf6a03405d79c57bfe9ccb80c146bfda4ea069`, backup `backup/device-v2-21-ignored-working`, fiziksel PASS.
- **v2-22 arama/sıralama:** `644549a224ca72d70746ddaada7d223ca9c4d2e0`, backup `backup/device-v2-22-search-sort-working`, fiziksel PASS.
- **v2-23 5 sekme:** `a0c96ecfd33b9c546c2a852aac3c2b4eee40b1d0`, run `33449350608`, backup `backup/device-v2-23-five-tabs-working`, fiziksel PASS.
- **v2-26 exact launcher:** `aa63720d49d97fd7f23de69549c307964c684fd5`, run `33485074032`, backup `backup/device-v2-26-exact-icon-working`, fiziksel Samsung PASS. Launcher `apps/mobile/android/app/src/main/res/drawable-nodpi/takip_launcher_user.webp`, SHA-256 `7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`.
- **Manuel snapshot karşılaştırma:** `24d920815c9d1425b9fc933b474cc0c10b8dc55f`, run `33513457232`, CI success.
- **v2-28 X arşiv entegrasyonu:** `adebabb4eecca456d4af1efd289ab7324825c66b`, run `33516696991`, backup `backup/device-v2-28-x-archive-ci-working`, tam CI success.
- **v2-29 Son hesaplar + geçmiş filtreleri:** `5695b525a729dc7cf316e17928b5c4534383012f`, run `33527062959`, backup `backup/device-v2-29-recent-history-filters-ci-working`, tam CI success.
- **v2-30 geçmiş veri yönetimi:** `804fb57255231ca349d83443135d32747f74284b`, run `33527775313`, backup `backup/device-v2-30-history-data-management-ci-working`, tam CI success.
- **v2-32 rapor export:** `0959d2775ef8454103f1eddaccd89d4627bf6788`, run `33528930054`, backup `backup/device-v2-32-report-export-ci-working`, tam CI success.

## X arşiv desteği — CI doğrulanmış
- X `window.YTD.*` JS assignment formatları okunur; `accountId` stabil kimliktir.
- Handle yoksa sahte @handle üretilmez, ID açık gösterilir.
- ZIP importer yalnız takip ilişkisi dosyalarını kullanır; medya/post/DM geçmişini yok sayar.
- ZIP güvenlik limitleri ve unsafe path kontrolü vardır.
- Büyük arşiv için çıkarılmış `follower.js` + `following.js` doğrudan seçilebilir.
- X ortak `FollowAnalysisEngine` ve aynı Drift geçmiş veritabanını kullanır.
- Previous snapshot varsa Takibi Bırakanlar/Yeni Takipçiler otomatik hesaplanır.
- Profil bağlantıları harici X/Twitter uygulamasında açılır.
- Yok sayılanlar `ignored_accounts.<platform>.<owner>` ile platform/hesap bazında ayrıdır.

## Ana ekran + geçmiş UX — CI doğrulanmış
- Son hesaplar kartı platform+hesap bazında son kayıtları gösterir ve kullanıcı adını otomatik doldurur.
- Geçmişte Tümü/Instagram/X ve hesap filtresi vardır.
- Aynı hesaptaki iki keyfi snapshot manuel karşılaştırılabilir.

## Geçmiş veri yönetimi — CI doğrulanmış
- Tek snapshot silme ve seçilen hesabın tüm geçmişini silme vardır.
- Silme işlemleri açık onay ister.
- Orphan kayıtlar temizlenir; başka hesabın geçmişinin korunması testlidir.

## Analiz raporu — CI doğrulanmış
- `Raporu kopyala` ve `TXT olarak kaydet` vardır.
- Platform, hesap, tarih, takipçi/takip edilen sayıları ve 5 kategori rapora girer.
- Yok sayılan hesaplar rapor listelerinden çıkarılır.
- Yeni dependency eklenmedi; mevcut `file_picker` kullanılır.

## Aktif geliştirme paketi — `dev/product-polish-batch`
Taban: v2-32 `0959d2775ef8454103f1eddaccd89d4627bf6788`.

### Yerel Veri Yönetimi
- Yeni ekran analiz sayısı, hesap sayısı ve yok sayılan kayıt sayısını gösterir.
- `Tüm analiz geçmişini sil`, `Yok sayılanları temizle`, `Tüm yerel veriyi temizle` eylemleri vardır.
- Riskli işlemler açık onay ister; sosyal medya hesabındaki verilere dokunmadığı açıkça belirtilir.
- Hatalar kullanıcıya gösterilir; başarılı işlem sonrası istatistik ve Son hesaplar yenilenir.

### X arşiv rehberi
- `X Arşivi Nasıl İndirilir?` ekranı eklendi.
- Resmi X ayarları → Hesabın → veri arşivini iste/doğrula/indir akışı anlatılır.
- ZIP import ve büyük arşiv için `follower.js + following.js` fallback anlatılır.
- X rehber widget testi #34/#35 test koşularında geçti.

### Ana ekran polish
- X kartında `X arşivi nasıl alınır?` bağlantısı vardır.
- Yönetim kartında `Yerel Veri Yönetimi` bağlantısı vardır.
- Instagram/X platform kartları ortak widget’a refactor edildi; mevcut import/geçmiş/Yok say/Son hesaplar akışları korunur.

### Product polish CI geçmişi
- **#33 / `33529876792`:** Analyze fail; HomeScreen refactor sözdizimi/lint hataları. Üretim davranışı çalıştırılmadı. Düzeltildi.
- **#34 / `33530222021`:** Analyze success. Temel testler + X rehber testi geçti. İki yeni test viewport/scroll varsayımı yüzünden fail; APK aşaması skipped.
- **#35 / `33530671363`:** Analyze success. Yine yalnız iki test fail; sebep `scrollUntilVisible(scrollable:)` parametresine `ListView` verilmesi. Flutter Test API bu parametrede gerçek `Scrollable` widget’ı bekliyor. Temel testler, analiz, rapor, DB ve X/Instagram rehber testleri geçti; APK aşaması skipped.
- Son test düzeltmesi: her iki testte de `find.descendant(of: find.byType(ListView), matching: find.byType(Scrollable))` ile gerçek scrollable hedefleniyor.
- Test düzeltme commitleri: `e0a223d0d6a5cc2ad3f68c980917771f06af15d8`, `4d008575ce48e25349b5ac71928621e123869277`.
- Bu son düzeltme henüz Actions ile doğrulanmadı.

## Test APK imza sistemi
- paket `com.zmilastudio.takipanalizi.dev`
- sabit test sertifikası SHA-256 `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`
- versionCode = 300000 + GitHub Actions run number.
- Test sürümü mevcut v2 uygulamanın üzerine Güncelle olarak kurulabilir.

## MVP durumu
### Instagram
- [x] analiz, resmi export import, geçmiş, profil linki, Yok say, arama/sıralama, 5 sekme
- [x] otomatik ve manuel snapshot karşılaştırma
- [x] rapor export — CI success

### X
- [x] JS parser, ZIP/direct JS importer, analiz, snapshot/geçmiş, profil/ID-only davranışı
- [x] entegrasyon CI success
- [x] uygulama içi X arşiv rehberi — product polish branch
- [ ] gerçek kullanıcı X arşiviyle ileride tek kritik fiziksel doğrulama
- [ ] canlı API/OAuth maliyet/politika değerlendirmesi

### UX / yönetim
- [x] ortak geçmiş, manuel karşılaştırma, Son hesaplar, filtreler
- [x] tek snapshot ve hesap geçmişi silme — CI success
- [x] analiz raporu export — CI success
- [x] Yerel Veri Yönetimi merkezi — product polish branch
- [x] X arşiv rehberi — product polish branch

## Şu anki branch durumu
- `test/device-apk`: `297b195e1f8d90e7ee2c1ae1a5cd4cd7b7a1c16a` — #35 Analyze success / test API failure; son tam çalışan rollback v2-32’dir.
- `dev/product-polish-batch`: gerçek `Scrollable` test düzeltmeleri dahil; son kod commit `4d008575ce48e25349b5ac71928621e123869277` (bu özet commitinden önce).
- Güvenli rollback: `backup/device-v2-32-report-export-ci-working`.

## Sıradaki iş
Bu özet commitinden sonra `dev/product-polish-batch` başını `test/device-apk` branch’ine fast-forward et ve tek Actions run al. Analyze + tüm testler + signed debug APK + package/version/exact launcher tamamen geçerse yeni backup baseline oluştur. Kullanıcıdan küçük fiziksel PASS isteme; ardından release polish / kalan MVP işlerine geç.
