# PROJE_OZETI

Son güncelleme: 1 Eylül 2026

## Çalışma protokolü
- Her yeni sohbet başlangıcında bu dosya okunarak proje devralınır.
- Bu dosya + canlı GitHub repo proje gerçeklik kaynağıdır.
- Çalışan fiziksel baseline korunur; kritik regressions olursa rollback branch kullanılır.
- Kullanıcı istemedikçe görsel mockup gönderilmez; gerçek uygulama üzerinden ilerlenir.
- **1 Eylül 2026 kararı:** her küçük değişiklik için ayrı fiziksel test/PASS turu yapılmayacak. Geliştirmeler toplu ilerletilecek; yalnız kritik sürüm noktalarında tek fiziksel doğrulama yapılacak.
- GitHub Actions kotasını korumak için büyük geliştirmeler ayrı dev branch’lerinde hazırlanıp `test/device-apk` branch’ine tek seferde alınacak.

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

### Ortak analiz
- 5 ana kategori: Takip Etmeyenler, Karşılıklı, Seni Takip Edenler, Takibi Bırakanlar, Yeni Takipçiler.
- Snapshot/geçmiş verisi cihazda tutulur.
- Aynı hesabın yeni importu önceki snapshot ile otomatik karşılaştırılır.
- Geçmişten aynı platformdaki aynı hesaba ait herhangi iki snapshot manuel seçilip karşılaştırılabilir.
- Yok sayılan hesaplar platform + hesap bazında local tutulur; ham snapshot sayıları değiştirilmez.
- Kullanıcı satırına dokununca platformun profil bağlantısı harici uygulamada açılır.

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
- Net değişim tutarlı: `75 - 6 + 5 = 74`.
- İki gerçek liste de fiziksel cihazda render edildi ve kullanıcı PASS verdi.
- Sonuç: otomatik previous → current karşılaştırma → current snapshot kaydı akışı gerçek Meta arşivleriyle TAM PASS.

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
- source commit `aa63720d49d97fd7f23de69549c307964c684fd5`
- workflow run `33485074032`
- VersionCode `300026`
- APK SHA-256 `9442a5a88c8136014ca1bc71f5565128b2d36fe47092e077aa0d9cf255f3c1f3`
- backup `backup/device-v2-26-exact-icon-working`
- kullanıcının sohbete yüklediği raster görsel doğrudan launcher olarak kullanılıyor ve fiziksel Samsung’da PASS.
- launcher asset: `apps/mobile/android/app/src/main/res/drawable-nodpi/takip_launcher_user.webp`
- asset SHA-256 `7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`
- Manifest doğrudan `@drawable/takip_launcher_user` kullanıyor.

### v2-28 — X arşiv entegrasyon baseline
- kaynak commit `adebabb4eecca456d4af1efd289ab7324825c66b`
- workflow run `33516696991`
- Analyze + tüm testler + APK build + imza + exact launcher doğrulaması tamamen success.
- backup `backup/device-v2-28-x-archive-ci-working`
- X arşiv desteğinin toplu CI doğrulanmış geri dönüş noktasıdır.

### v2-29 — Son hesaplar + geçmiş filtreleri
- kaynak commit `5695b525a729dc7cf316e17928b5c4534383012f`
- workflow run `33527062959`
- Analyze + tüm testler + APK build + imza + exact launcher doğrulaması tamamen success.
- backup `backup/device-v2-29-recent-history-filters-ci-working`
- Ana ekranda Son hesaplar hızlı seçimi ve geçmişte platform/hesap filtreleri CI doğrulandı.

## Manuel iki snapshot karşılaştırma
- kaynak commit `24d920815c9d1425b9fc933b474cc0c10b8dc55f`
- workflow run `33513457232`
- CI tamamen success.
- Analiz Geçmişi ekranında `Karşılaştır` modu eklendi.
- Kullanıcı iki kayıt seçer; yalnız aynı platform + aynı hesap kabul edilir.
- Kayıtlar tarihe göre eski/yeni sıralanır ve standart 5 sekmeli analiz ekranında farklar gösterilir.

## X arşiv desteği — CI doğrulanmış
### X parser/importer
- `XRelationshipParser` eklendi.
- `window.YTD.following.part0 = [...]` / `window.YTD.follower.part0 = [...]` JS assignment formatı okunur.
- `accountId` stabil kullanıcı kimliği olarak kullanılır.
- Arşiv doğrudan kullanıcı adını verirse handle tutulur.
- `userLink` yalnız `intent/user?user_id=...` içeriyorsa sahte kullanıcı adı üretilmez; UI’da `X hesabı • ID ...` gösterilir ve gerçek intent profil linki korunur.
- `XArchiveImporter` ZIP içinde `follower.js` / `following.js` dosyalarını bulur; medya ve tweet geçmişini yok sayar.
- ZIP güvenlik limitleri ve unsafe path kontrolü vardır.
- Büyük arşivler için `importRelationshipFiles(...)` ile çıkarılmış iki JS dosyası doğrudan okunabilir.

### X analiz + snapshot
- `XFollowAnalysisUseCase` mevcut `FollowAnalysisEngine` motorunu kullanır.
- ZIP ve direct JS dosya akışları desteklenir.
- X snapshot’ları aynı Drift geçmiş veritabanına kaydedilir.
- Previous snapshot varsa Takibi Bırakanlar/Yeni Takipçiler otomatik hesaplanır.
- Ortak `FollowAnalysisResult` soyut modeli ile analiz ekranı Instagram/X ortak hale getirildi.

### X mobil akış
- Ana ekrandaki X `Yakında` durumu kaldırıldı.
- X kullanıcı adı + `X Arşivini İçe Aktar` butonu eklendi.
- Büyük arşiv fallback: `follower.js + following.js seç` butonu eklendi.
- Analiz ekranı platforma göre `Instagram Analizi` / `X Analizi` başlığı gösterir.
- X kullanıcı satırı profil linkini X/Twitter’da açar.
- Handle içermeyen arşiv satırlarında kullanıcıya hesap ID’si açıkça gösterilir; sahte `@id_...` etiketi gösterilmez.
- Analiz Geçmişi Instagram + X snapshot’larını birlikte listeler ve platform etiketini gösterir.
- Yok sayılan hesaplar `ignored_accounts.<platform>.<owner>` anahtarıyla platform bazında ayrıldı; mevcut Instagram anahtar biçimi geriye uyumludur.

## Ana ekran + geçmiş UX — CI doğrulanmış
- `recentFollowAccountsProvider` cihaz geçmişinden platform+hesap bazında en son kayıtları çıkarır; en fazla 6 hesap gösterilir.
- Ana ekranda `Son hesaplar` kartı bulunur.
- Satırda platform, kullanıcı adı, takipçi/takip edilen sayısı ve son analiz tarihi gösterilir.
- Satıra dokununca ilgili Instagram/X kullanıcı adı alanı otomatik doldurulur.
- Yeni Instagram/X snapshot kaydı sonrası recent provider invalidate edilir.
- Analiz Geçmişi ekranında platform filtresi (`Tümü / Instagram / X`) vardır.
- Kayıtlı hesaba göre ikinci filtre vardır.
- Filtre değiştiğinde görünmeyen manuel karşılaştırma seçimleri temizlenir.
- Filtre sonucu kayıt yoksa ayrı boş durum gösterilir.
- Bu paket workflow run `33527062959` ile tamamen success.

## Veri yönetimi geliştirme paketi — `dev/history-data-management`
- v2-29 CI baseline üzerinden açıldı; Actions tetiklemeden hazırlanıyor.
- `FollowHistoryDatabase.deleteSnapshot(snapshotId)` eklendi.
- Tek snapshot silinince ilişkiler temizlenir; hesapta başka snapshot yoksa hesap kaydı da kaldırılır; orphan sosyal kullanıcı kayıtları temizlenir.
- `FollowHistoryDatabase.deleteAccountHistory(account)` eklendi.
- Hesabın tüm snapshot/ilişki geçmişi silinir; başka hesapların geçmişi korunur.
- Geçmiş kartlarında üç nokta menüsünden `Bu analizi sil` eklendi.
- Hesap filtresi seçiliyken `Bu hesabın geçmişini sil` eylemi görünür.
- Her iki silme işlemi de onay diyaloğu ister.
- Hesap geçmişini silmek Yok Sayılan Hesaplar listesini etkilemez.
- Silme sonrası snapshot history ve Son hesaplar provider’ları invalidate edilir.
- Veritabanı testlerine tek snapshot silme ve yalnız seçili hesabın geçmişini silme senaryoları eklendi.
- Son kod commit `dcece3bcb4ef3c1875690c8f8f07f945811bdf8d` (bu özet commitinden önce).

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
- [x] iki keyfi snapshot’ı manuel seçip karşılaştırma

### X
- [x] X ilişki JS parser
- [x] X ZIP importer
- [x] büyük arşiv için direct `follower.js` + `following.js` importer
- [x] X analiz use case
- [x] X snapshot/geçmiş entegrasyonu
- [x] X ana ekran/import akışı
- [x] X profil/ID-only davranışı
- [x] X geliştirme paketinin tek Actions run ile entegrasyon doğrulaması — run `33516696991` success
- [ ] gerçek kullanıcı X arşiviyle ileride tek kritik fiziksel doğrulama
- [ ] canlı API/OAuth maliyet/politika değerlendirmesi

### UX / yönetim
- [x] platformlar arası ortak geçmiş
- [x] manuel snapshot karşılaştırma
- [x] Son hesaplar hızlı kullanıcı adı doldurma — CI success
- [x] geçmişte platform filtresi — CI success
- [x] geçmişte hesap filtresi — CI success
- [x] tek snapshot silme — dev branch
- [x] seçili hesabın tüm geçmişini silme — dev branch
- [ ] uygulama içi genel veri yönetimi / tüm yerel veriyi temizleme
- [ ] analiz sonuçlarını dışa aktarma / paylaşma

## Sıradaki iş
`dev/history-data-management` paketini `test/device-apk` branch’ine tek fast-forward ile al ve tek Actions run ile doğrula. CI geçince veri yönetimi test prerelease’e dahil edilmiş olacak. Ardından küçük fiziksel PASS döngüsüne dönmeden genel veri yönetimi / analiz sonucu dışa aktarma geliştirmesine geç.
