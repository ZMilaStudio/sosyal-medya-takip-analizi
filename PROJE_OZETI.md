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
- 5 ana kategori: Takip Etmeyenler, Karşılıklı, Seni Takip Edenler, Takibi Bırakanlar, Yeni Takipçiler.
- Snapshot/geçmiş verisi cihazda tutulur.
- Aynı hesabın yeni importu önceki snapshot ile otomatik karşılaştırılır.
- Geçmişten aynı platformdaki aynı hesaba ait herhangi iki snapshot manuel seçilip karşılaştırılabilir.
- Yok sayılan hesaplar platform + hesap bazında local tutulur; ham snapshot sayıları değiştirilmez.
- Kullanıcı satırına dokununca platform profil bağlantısı harici uygulamada açılır.

## Gerçek Instagram export doğrulaması
Ana gerçek Meta export doğrulaması:
- 569 takipçi
- 1053 takip edilen
- 792 takip etmeyen
- 261 karşılıklı
- 308 yalnız takipçi
- Instagram UI takip edilen sayısı 967; export ile UI arasında 86 hesap farkı görüldü.

`gece02.19` gerçek geçmiş testi:
- İlk snapshot: 75 takipçi, 53 takip edilen, 10 takip etmeyen, 43 karşılıklı.
- İkinci snapshot: 74 takipçi, 46 takip edilen.
- Uygulama `Takibi Bırakanlar (6)` + `Yeni Takipçiler (5)` hesapladı.
- Net değişim: `75 - 6 + 5 = 74`.
- İki gerçek liste fiziksel cihazda render edildi ve kullanıcı PASS verdi.
- Otomatik previous → current karşılaştırma → current snapshot kaydı gerçek Meta arşivleriyle TAM PASS.

## Fiziksel / CI çalışan baselines
### v2-16 — liste baseline
- commit `90059b024cc844a101a84ac076e49a22d12b86b6`
- backup `backup/device-v2-16-working-baseline`
- fiziksel kullanıcı listesi + özet kartları PASS.

### v2-17 — profil bağlantısı
- commit `ac5cce4ac53cdc05b91a2db6b34765afc40a88e4`
- backup `backup/device-v2-17-links-working`
- Instagram profil bağlantısı fiziksel PASS.

### v2-21 — Yok say
- commit `91bf6a03405d79c57bfe9ccb80c146bfda4ea069`
- backup `backup/device-v2-21-ignored-working`
- Yok say / Geri al / yönetim fiziksel PASS.

### v2-22 — arama + sıralama
- commit `644549a224ca72d70746ddaada7d223ca9c4d2e0`
- APK SHA-256 `a1d442c81da5f2dc0dc57994eb577a944698cb315cd29b980a042c7d388f5d02`
- backup `backup/device-v2-22-search-sort-working`
- arama + A-Z/Z-A fiziksel PASS.

### v2-23 — 5 sekme
- final kaynak commit `a0c96ecfd33b9c546c2a852aac3c2b4eee40b1d0`
- workflow run `33449350608`
- VersionCode `300023`
- APK SHA-256 `91a7c93fa8484d92af3d50845375eab0f130f84a5a9c058c3f1185dfac39d21e`
- backup `backup/device-v2-23-five-tabs-working`
- 5 sekme + arama/sıralama/profil/Yok say fiziksel PASS.

### v2-26 — exact launcher
- kaynak commit `aa63720d49d97fd7f23de69549c307964c684fd5`
- workflow run `33485074032`
- VersionCode `300026`
- APK SHA-256 `9442a5a88c8136014ca1bc71f5565128b2d36fe47092e077aa0d9cf255f3c1f3`
- backup `backup/device-v2-26-exact-icon-working`
- kullanıcının yüklediği raster launcher fiziksel Samsung’da PASS.
- launcher asset: `apps/mobile/android/app/src/main/res/drawable-nodpi/takip_launcher_user.webp`
- asset SHA-256 `7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`

### Manuel snapshot karşılaştırma
- kaynak commit `24d920815c9d1425b9fc933b474cc0c10b8dc55f`
- workflow run `33513457232`
- CI tamamen success.
- Analiz Geçmişi ekranında aynı platform + aynı hesaba ait iki snapshot seçilip karşılaştırılabilir.

### v2-28 — X arşiv entegrasyonu
- kaynak commit `adebabb4eecca456d4af1efd289ab7324825c66b`
- workflow run `33516696991`
- Analyze + tüm testler + APK build + imza + exact launcher doğrulaması success.
- backup `backup/device-v2-28-x-archive-ci-working`

### v2-29 — Son hesaplar + geçmiş filtreleri
- kaynak commit `5695b525a729dc7cf316e17928b5c4534383012f`
- workflow run `33527062959`
- Analyze + tüm testler + APK build + imza + exact launcher doğrulaması success.
- backup `backup/device-v2-29-recent-history-filters-ci-working`
- Ana ekranda Son hesaplar hızlı seçimi ve geçmişte platform/hesap filtreleri CI doğrulandı.

### v2-30 — geçmiş veri yönetimi
- kaynak commit `804fb57255231ca349d83443135d32747f74284b`
- workflow run `33527775313`
- Analyze + tüm testler + APK build + imza + exact launcher doğrulaması success.
- backup `backup/device-v2-30-history-data-management-ci-working`
- Tek snapshot silme ve seçili hesabın tüm geçmişini silme CI doğrulandı.

### v2-32 — analiz raporu dışa aktarma
- kaynak commit `0959d2775ef8454103f1eddaccd89d4627bf6788`
- workflow run `33528930054`
- Analyze + tüm testler + APK build + imza + exact launcher doğrulaması success.
- backup `backup/device-v2-32-report-export-ci-working`
- İlk deneme run `33528694609` yalnız gereksiz `dart:typed_data` import lint’i nedeniyle Analyze’da durmuştu; import kaldırıldı ve davranış değişmeden run #32 tamamen geçti.
- Analiz ekranında rapor menüsü bulunur: `Raporu kopyala` ve `TXT olarak kaydet`.
- TXT raporu platform, hesap, analiz tarihi, takipçi/takip edilen sayıları ve 5 kategori listesini içerir.
- Yok sayılan hesaplar rapor kategori listelerinden de çıkarılır.
- Yeni dependency eklenmedi; dosya kaydetme mevcut `file_picker` üzerinden yapılır.

## X arşiv desteği — CI doğrulanmış
### Parser/importer
- `XRelationshipParser` `window.YTD.following.part0 = [...]` ve `window.YTD.follower.part0 = [...]` formatını okur.
- `accountId` stabil kullanıcı kimliğidir.
- Arşiv handle verirse tutulur.
- `userLink` yalnız `intent/user?user_id=...` içeriyorsa sahte kullanıcı adı üretilmez; UI `X hesabı • ID ...` gösterir.
- `XArchiveImporter` ZIP içindeki follower/following JS dosyalarını bulur; medya/post/DM geçmişini yok sayar.
- ZIP güvenlik limitleri ve unsafe path kontrolü vardır.
- Çok büyük arşiv için çıkarılmış `follower.js` + `following.js` doğrudan seçilebilir.

### Analiz + snapshot
- X analizi ortak `FollowAnalysisEngine` kullanır.
- ZIP ve direct JS akışları desteklenir.
- X snapshot’ları Instagram ile aynı Drift geçmiş veritabanında tutulur.
- Previous snapshot varsa Takibi Bırakanlar/Yeni Takipçiler otomatik hesaplanır.
- Ortak `FollowAnalysisResult` ile analiz ekranı Instagram/X ortak hale getirildi.

### Mobil akış
- Ana ekranda X kullanıcı adı + `X Arşivini İçe Aktar` bulunur.
- Büyük arşiv fallback: `follower.js + following.js seç`.
- Analiz başlığı platforma göre değişir.
- X profil linkleri X/Twitter’da açılır.
- Handle içermeyen arşiv satırlarında ID açık gösterilir; sahte `@id_...` etiketi yoktur.
- Analiz Geçmişi Instagram + X snapshot’larını birlikte listeler.
- Yok sayılan hesaplar `ignored_accounts.<platform>.<owner>` ile platform/hesap bazında ayrıdır.

## Ana ekran + geçmiş UX — CI doğrulanmış
- `recentFollowAccountsProvider` platform+hesap bazında en son kayıtları çıkarır; en fazla 6 hesap gösterilir.
- Ana ekranda `Son hesaplar` kartı bulunur.
- Satıra dokununca ilgili Instagram/X kullanıcı adı otomatik doldurulur.
- Yeni snapshot sonrası recent provider invalidate edilir.
- Geçmişte `Tümü / Instagram / X` platform filtresi ve hesap filtresi vardır.
- Filtre değişince görünmeyen karşılaştırma seçimleri temizlenir.

## Geçmiş veri yönetimi — CI doğrulanmış
- `FollowHistoryDatabase.deleteSnapshot(snapshotId)` tek snapshot ve ilişkilerini siler; son kayıt ise hesap satırını da temizler; orphan kullanıcıları temizler.
- `FollowHistoryDatabase.deleteAccountHistory(account)` yalnız seçilen hesabın tüm snapshot/ilişki geçmişini siler.
- Geçmiş kartında `Bu analizi sil` bulunur.
- Hesap filtresi seçiliyken `Bu hesabın geçmişini sil` bulunur.
- Her iki işlem de açık onay ister.
- Hesap geçmişini silmek Yok Sayılan Hesaplar listesini etkilemez.
- Veritabanı testleri yanlış hesabın geçmişinin silinmemesini güvence altına alır.

## Aktif geliştirme paketi — `dev/product-polish-batch`
Taban: v2-32 rapor baseline commit `0959d2775ef8454103f1eddaccd89d4627bf6788`.

### Yerel Veri Yönetimi
- Yeni `Yerel Veri Yönetimi` ekranı eklendi.
- Cihazdaki analiz sayısı, analiz edilmiş hesap sayısı ve yok sayılan kayıt sayısı gösterilir.
- `Tüm analiz geçmişini sil`: Instagram + X snapshot/geçmiş ilişkilerini temizler.
- `Yok sayılanları temizle`: tüm platform/hesap yok sayma kayıtlarını kaldırır.
- `Tüm yerel veriyi temizle`: iki veri grubunu birlikte temizler.
- Her riskli işlem açık onay ister.
- Ekran özellikle sosyal medya hesabındaki takip/içerik verilerine dokunmadığını açıkça belirtir.
- İşlem hataları kullanıcıya gösterilir; başarılı işlem sonrası istatistik ve Son hesaplar provider’ı yenilenir.
- Boş cihaz durumunda riskli butonların disabled olduğunu kontrol eden widget testi eklendi.

### X arşiv rehberi
- Yeni `X Arşivi Nasıl İndirilir?` ekranı eklendi.
- Güncel resmi X akışına göre Ayarlar ve gizlilik → Hesabın → veri arşivini indirme/istek/doğrulama adımları anlatılır.
- Arşivin hazır olmasının zaman alabileceği belirtilir.
- ZIP doğrudan import ve büyük arşiv için `follower.js + following.js` fallback anlatılır.
- X rehber widget testi eklendi.

### Ana ekran polish
- X kartına `X arşivi nasıl alınır?` bağlantısı eklendi.
- Geçmiş ve yönetim kartına `Yerel Veri Yönetimi` bağlantısı eklendi.
- Mevcut Instagram/X import, Son hesaplar, Analiz Geçmişi ve Yok Sayılan Hesaplar akışları korunarak HomeScreen ortak platform kartına refactor edildi.
- Home smoke testi sabit piksel drag yerine hedefe kadar scroll eden daha dayanıklı yapıya geçirildi.
- Son kod commit (özet commitinden önce): `b9b0d8d1f1adae8d7efd2874da9fdba0663ea39f`.
- Bu paket henüz Actions ile çalıştırılmadı.

## Test APK imza sistemi
- paket `com.zmilastudio.takipanalizi.dev`
- sabit test sertifikası SHA-256 `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`
- versionCode = 300000 + GitHub Actions run number.
- Test sürümü mevcut v2 uygulamanın üzerine `Güncelle` olarak kurulabilir.

## MVP durumu
### Instagram
- [x] analiz motoru
- [x] JSON/HTML/ZIP import
- [x] `following.json title` desteği
- [x] gerçek Meta export doğrulaması
- [x] snapshot/geçmiş veri katmanı
- [x] fiziksel kategori/listeler
- [x] profil bağlantısı
- [x] Yok say
- [x] arama/sıralama
- [x] 5 sekme
- [x] gerçek otomatik snapshot karşılaştırma
- [x] iki keyfi snapshot’ı manuel karşılaştırma
- [x] analiz raporunu kopyalama / TXT kaydetme — CI success

### X
- [x] ilişki JS parser
- [x] ZIP importer
- [x] büyük arşiv direct JS importer
- [x] analiz use case
- [x] snapshot/geçmiş entegrasyonu
- [x] ana ekran/import akışı
- [x] profil/ID-only davranışı
- [x] entegrasyon CI doğrulaması — run `33516696991`
- [x] uygulama içi X arşiv alma rehberi — dev branch
- [ ] gerçek kullanıcı X arşiviyle ileride tek kritik fiziksel doğrulama
- [ ] canlı API/OAuth maliyet/politika değerlendirmesi

### UX / yönetim
- [x] platformlar arası ortak geçmiş
- [x] manuel snapshot karşılaştırma
- [x] Son hesaplar hızlı seçim — CI success
- [x] geçmiş platform/hesap filtreleri — CI success
- [x] tek snapshot silme — CI success
- [x] hesap geçmişini toplu silme — CI success
- [x] analiz raporu export — CI success
- [x] Yerel Veri Yönetimi merkezi — dev branch
- [x] X arşiv rehberi — dev branch

## Şu anki branch durumu
- `test/device-apk`: `0959d2775ef8454103f1eddaccd89d4627bf6788` — v2-32 rapor export CI success baseline.
- `dev/product-polish-batch`: Yerel Veri Yönetimi + X rehber + ana ekran polish + yeni testler; Actions tetiklenmedi.
- Güvenli rollback: `backup/device-v2-32-report-export-ci-working`.

## Sıradaki iş
`dev/product-polish-batch` paketini tek seferde `test/device-apk` branch’ine fast-forward et. Tek Actions run ile Analyze + tüm testler + signed debug APK + package/version/exact launcher doğrulamasını al. Hata çıkarsa aynı toplu pakette düzelt; kullanıcıdan küçük fiziksel PASS isteme. CI yeşil olunca yeni backup baseline oluştur ve ardından kalan MVP/release polish işlerine geç.
