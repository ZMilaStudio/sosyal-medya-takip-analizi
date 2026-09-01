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
Ana gerçek Meta export:
- 569 takipçi
- 1053 takip edilen
- 792 takip etmeyen
- 261 karşılıklı
- 308 yalnız takipçi
- Instagram UI takip edilen sayısı 967; export ile UI arasında 86 hesap farkı görüldü.

`gece02.19` gerçek geçmiş testi:
- İlk snapshot: 75 takipçi, 53 takip edilen, 10 takip etmeyen, 43 karşılıklı.
- İkinci snapshot: 74 takipçi, 46 takip edilen.
- `Takibi Bırakanlar (6)` + `Yeni Takipçiler (5)`; net `75 - 6 + 5 = 74`.
- İki gerçek liste fiziksel cihazda render edildi ve kullanıcı PASS verdi.
- Otomatik previous → current karşılaştırma → snapshot kaydı gerçek Meta arşivleriyle TAM PASS.

## Fiziksel / CI baseline’lar
- **v2-16 liste:** commit `90059b024cc844a101a84ac076e49a22d12b86b6`, backup `backup/device-v2-16-working-baseline`, fiziksel PASS.
- **v2-17 profil linki:** commit `ac5cce4ac53cdc05b91a2db6b34765afc40a88e4`, backup `backup/device-v2-17-links-working`, fiziksel PASS.
- **v2-21 Yok say:** commit `91bf6a03405d79c57bfe9ccb80c146bfda4ea069`, backup `backup/device-v2-21-ignored-working`, fiziksel PASS.
- **v2-22 arama/sıralama:** commit `644549a224ca72d70746ddaada7d223ca9c4d2e0`, backup `backup/device-v2-22-search-sort-working`, fiziksel PASS.
- **v2-23 5 sekme:** commit `a0c96ecfd33b9c546c2a852aac3c2b4eee40b1d0`, run `33449350608`, backup `backup/device-v2-23-five-tabs-working`, fiziksel PASS.
- **v2-26 exact launcher:** commit `aa63720d49d97fd7f23de69549c307964c684fd5`, run `33485074032`, backup `backup/device-v2-26-exact-icon-working`, fiziksel Samsung PASS. Launcher `apps/mobile/android/app/src/main/res/drawable-nodpi/takip_launcher_user.webp`, SHA-256 `7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`.
- **Manuel snapshot karşılaştırma:** commit `24d920815c9d1425b9fc933b474cc0c10b8dc55f`, run `33513457232`, CI success.
- **v2-28 X arşiv entegrasyonu:** commit `adebabb4eecca456d4af1efd289ab7324825c66b`, run `33516696991`, backup `backup/device-v2-28-x-archive-ci-working`, tam CI success.
- **v2-29 Son hesaplar + geçmiş filtreleri:** commit `5695b525a729dc7cf316e17928b5c4534383012f`, run `33527062959`, backup `backup/device-v2-29-recent-history-filters-ci-working`, tam CI success.
- **v2-30 geçmiş veri yönetimi:** commit `804fb57255231ca349d83443135d32747f74284b`, run `33527775313`, backup `backup/device-v2-30-history-data-management-ci-working`, tam CI success.
- **v2-32 rapor export:** commit `0959d2775ef8454103f1eddaccd89d4627bf6788`, run `33528930054`, backup `backup/device-v2-32-report-export-ci-working`, tam CI success. İlk run `33528694609` yalnız redundant import lint’i nedeniyle durmuş, düzeltme sonrası tamamen geçmiştir.

## X arşiv desteği — CI doğrulanmış
- `XRelationshipParser` X `window.YTD.*` JS assignment formatlarını okur.
- `accountId` stabil kullanıcı kimliği olarak kullanılır; handle yoksa sahte @handle üretilmez, ID açık gösterilir.
- ZIP importer yalnız takip ilişkisi dosyalarını kullanır; medya/post/DM geçmişini yok sayar.
- ZIP güvenlik limitleri ve unsafe path kontrolü vardır.
- Çok büyük arşiv için çıkarılmış `follower.js` + `following.js` doğrudan seçilebilir.
- X analizi ortak `FollowAnalysisEngine` kullanır; snapshot’lar aynı Drift veritabanında tutulur.
- Previous snapshot varsa Takibi Bırakanlar/Yeni Takipçiler otomatik hesaplanır.
- X profil bağlantıları harici X/Twitter uygulamasında açılır.
- Yok sayılanlar `ignored_accounts.<platform>.<owner>` ile platform/hesap bazında ayrıdır.

## Ana ekran + geçmiş UX — CI doğrulanmış
- `recentFollowAccountsProvider` platform+hesap bazında en son kayıtları çıkarır; en fazla 6 hesap gösterilir.
- Ana ekranda Son hesaplar kartından Instagram/X kullanıcı adı otomatik doldurulur.
- Geçmişte Tümü/Instagram/X filtresi ve hesap filtresi vardır.
- Aynı hesapta iki keyfi snapshot manuel karşılaştırılabilir.

## Geçmiş veri yönetimi — CI doğrulanmış
- `deleteSnapshot(snapshotId)` tek snapshot/ilişkilerini ve gerekirse orphan hesap/kullanıcıları temizler.
- `deleteAccountHistory(account)` yalnız seçilen hesabın tüm geçmişini siler.
- Geçmiş kartında `Bu analizi sil`; hesap filtresi seçiliyken `Bu hesabın geçmişini sil` bulunur.
- Her iki işlem açık onay ister.
- Veritabanı testleri başka hesabın geçmişinin korunmasını doğrular.

## Analiz raporu — CI doğrulanmış
- Analiz ekranında `Raporu kopyala` ve `TXT olarak kaydet` vardır.
- Rapor platform, hesap, tarih, takipçi/takip edilen sayıları ve 5 kategori listesini içerir.
- Yok sayılan hesaplar rapor listelerinden de çıkarılır.
- Yeni dependency eklenmedi; kaydetme mevcut `file_picker` ile yapılır.

## Aktif geliştirme paketi — `dev/product-polish-batch`
Taban: v2-32 `0959d2775ef8454103f1eddaccd89d4627bf6788`.

### Yerel Veri Yönetimi
- Yeni `Yerel Veri Yönetimi` ekranı: analiz sayısı, analiz edilmiş hesap sayısı, yok sayılan kayıt sayısı.
- `Tüm analiz geçmişini sil`, `Yok sayılanları temizle`, `Tüm yerel veriyi temizle` eylemleri.
- Riskli işlemler açık onay ister; sosyal medya hesabındaki verileri değiştirmediği ekranda açıkça yazılıdır.
- İşlem hataları kullanıcıya gösterilir; başarılı işlem sonrası istatistik/Son hesaplar yenilenir.
- Boş cihazda riskli butonların disabled olduğunu kontrol eden widget testi eklendi.

### X arşiv rehberi
- Yeni `X Arşivi Nasıl İndirilir?` ekranı.
- Güncel resmi X akışına göre Ayarlar ve gizlilik → Hesabın → veri arşivini indir/iste/doğrulama adımları.
- ZIP doğrudan import ve büyük arşiv için `follower.js + following.js` fallback anlatılır.
- Rehber widget testi eklendi ve run #34 içinde geçti.

### Ana ekran polish
- X kartına `X arşivi nasıl alınır?` bağlantısı eklendi.
- Geçmiş ve yönetim kartına `Yerel Veri Yönetimi` bağlantısı eklendi.
- Mevcut import/Son hesaplar/geçmiş/Yok say akışları korunarak platform kartları ortak widget’a refactor edildi.
- Home smoke testi ana `ListView`’ı açıkça hedefleyen yapıya geçirildi.

### Product polish CI geçmişi
- Run `33529876792` (#33) Analyze aşamasında durdu; APK/test aşamasına geçmedi.
  - Sebep: HomeScreen refactor’unda `AsyncValue` pattern ifadesinin named argument içinde yanlış kullanılması + nullable extra widget lint’i + smoke testte unused import.
  - Düzeltme: Instagram/X error stringleri build başında switch ile çözülüyor; nullable extra `SizedBox.shrink()` ile normalize edildi; unused import kaldırıldı.
- Run `33530222021` (#34): **Analyze success**, mevcut temel testler ve yeni X rehber testi geçti; Test adımı iki yeni testin viewport/scroll varsayımı yüzünden fail oldu, APK aşamasına geçmedi.
  - `local_data_management_screen_test.dart`: offscreen alt butonları build edilmeden `tester.widget` ile okumaya çalıştığı için `Bad state: No element`.
  - `app_smoke_test.dart`: birden fazla `Scrollable` arasından otomatik seçim yaptığı için `Bad state: Too many elements`.
  - Üretim kodu için Analyze temiz; hata yalnız test harness seçimindeydi.
- Test düzeltmeleri:
  - Home smoke testi `find.byType(ListView)` ile tek ana listeyi açıkça `scrollable:` olarak kullanıyor.
  - Yerel Veri testi de tek `ListView` üzerinden her butonu sırayla görünür hale getirip disabled durumunu kontrol ediyor.
  - Düzeltme commitleri `9afa3d3b16924dd7091b83218fc280cbafc5c22e` ve `fbe2b9e5f45b843d8a264f694c73e2c565180c2a`.
- Bu son test düzeltmeleri henüz Actions ile doğrulanmadı.

## Test APK imza sistemi
- paket `com.zmilastudio.takipanalizi.dev`
- sabit test sertifikası SHA-256 `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`
- versionCode = 300000 + GitHub Actions run number.
- Test sürümü mevcut v2 uygulamanın üzerine Güncelle olarak kurulabilir.

## MVP durumu
### Instagram
- [x] analiz motoru, JSON/HTML/ZIP import, gerçek Meta doğrulaması
- [x] snapshot/geçmiş, profil linki, Yok say, arama/sıralama, 5 sekme
- [x] otomatik ve manuel snapshot karşılaştırma
- [x] rapor kopyalama/TXT kaydetme — CI success

### X
- [x] JS parser, ZIP/direct JS importer, analiz, snapshot/geçmiş, ana ekran/import, profil/ID-only davranışı
- [x] entegrasyon CI success
- [x] uygulama içi X arşiv rehberi — product polish branch
- [ ] gerçek kullanıcı X arşiviyle ileride tek kritik fiziksel doğrulama
- [ ] canlı API/OAuth maliyet/politika değerlendirmesi

### UX / yönetim
- [x] ortak geçmiş, manuel karşılaştırma, Son hesaplar, platform/hesap filtreleri
- [x] tek snapshot ve hesap geçmişi silme — CI success
- [x] analiz raporu export — CI success
- [x] Yerel Veri Yönetimi merkezi — product polish branch
- [x] X arşiv rehberi — product polish branch

## Şu anki branch durumu
- `test/device-apk`: `f44afb891dc08fd645ca44e49eb2fb03e156ea9a` — #34 Analyze success / test harness failure; son tam çalışan rollback v2-32’dir.
- `dev/product-polish-batch`: test düzeltmeleri dahil; son kod commit `fbe2b9e5f45b843d8a264f694c73e2c565180c2a` (bu özet commitinden önce).
- Güvenli rollback: `backup/device-v2-32-report-export-ci-working`.

## Sıradaki iş
Bu özet commitinden sonra `dev/product-polish-batch` başını `test/device-apk` branch’ine fast-forward et ve tek yeni Actions run al. Analyze + tüm testler + signed debug APK + package/version/exact launcher tamamen geçerse yeni backup baseline oluştur. Kullanıcıdan küçük fiziksel PASS isteme; ardından release polish / kalan MVP işlerine geç.
