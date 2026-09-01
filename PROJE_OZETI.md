# PROJE_OZETI

Son güncelleme: 1 Eylül 2026

## Çalışma protokolü
- Her yeni sohbet başlangıcında bu dosya okunarak proje devralınır.
- Bu dosya + canlı GitHub repo proje gerçeklik kaynağıdır.
- Çalışan fiziksel baseline korunur; kritik regression olursa rollback branch kullanılır.
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
- Ana yöntem resmi X veri arşivi üzerinden local analizdir.
- Küçük/orta X arşivi ZIP olarak; çok büyük arşivlerde yalnız `follower.js` + `following.js` dosyaları seçilerek analiz edilebilir.
- **1 Eylül 2026 canlı API kararı:** X API artık pay-per-use. Normal `Following/Followers: Read` fiyatı resmi dokümana göre kaynak başına `$0.010`. `$0.001` Owned Read yalnız authenticated kullanıcı aynı zamanda developer app owner olduğunda geçerli; genel son kullanıcı modeli için uygun değil. Bu yüzden canlı X API/OAuth MVP dışına ertelendi; arşiv importu ana ücretsiz/local yol olarak kalacak.

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

## Fiziksel çalışan baselines
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

## Manuel iki snapshot karşılaştırma
- kaynak commit `24d920815c9d1425b9fc933b474cc0c10b8dc55f`
- workflow run `33513457232` / run #27
- CI tamamen SUCCESS.
- Analiz Geçmişi ekranında `Karşılaştır` modu vardır.
- Aynı platform + aynı hesaptan iki kayıt seçilir; tarihe göre eski/yeni sıralanıp standart analiz motoruna verilir.
- Bu özellik için ayrı fiziksel PASS istenmedi; toplu sürüm içinde ilerleniyor.

## X arşiv entegrasyonu — CI SUCCESS
İlk toplu X geliştirmesi `dev/x-archive-import` üzerinde hazırlandı ve `test/device-apk` branch’ine tek fast-forward ile alındı.

- entegrasyon source/head: `adebabb4eecca456d4af1efd289ab7324825c66b`
- workflow run: `33516696991` / run #28
- Analyze ✅
- tüm testler ✅
- physical-device compatibility wiring ✅
- signed debug APK build ✅
- package/version/exact launcher/signing doğrulaması ✅
- prerelease publish ✅

### X parser/importer
- `XRelationshipParser` eklendi.
- `window.YTD.following.part0 = [...]` / `window.YTD.follower.part0 = [...]` JS assignment formatı okunur.
- `accountId` stabil kullanıcı kimliği olarak kullanılır.
- Arşiv doğrudan kullanıcı adını verirse handle tutulur.
- `userLink` yalnız `intent/user?user_id=...` içeriyorsa sahte kullanıcı adı UI’da gösterilmez; hesap ID’si açıkça gösterilir ve intent profil linki korunur.
- `XArchiveImporter` ZIP içinde `follower.js` / `following.js` dosyalarını bulur; medya ve tweet geçmişini yok sayar.
- ZIP güvenlik limitleri ve unsafe path kontrolü vardır.
- Büyük arşivler için çıkarılmış iki JS dosyası doğrudan okunabilir.

### X analiz + mobil
- `XFollowAnalysisUseCase` ortak `FollowAnalysisEngine` motorunu kullanır.
- X snapshot’ları aynı Drift geçmiş veritabanına kaydedilir.
- Previous snapshot varsa Takibi Bırakanlar/Yeni Takipçiler hesaplanır.
- Ortak `FollowAnalysisResult` modeliyle analiz ekranı Instagram/X ortak hale getirildi.
- Ana ekranda X kullanıcı adı + ZIP import + büyük arşiv iki-JS fallback vardır.
- X profil/ID-only davranışı desteklenir.
- Analiz Geçmişi Instagram + X snapshot’larını birlikte listeler.
- Yok sayılan hesaplar platform bazında ayrıdır; eski Instagram kayıtları geriye uyumludur.

## Product polish batch — `dev/product-polish`
Run #28 sonrası Actions harcamadan yeni geliştirmeler bu branch’te toplanıyor.

### Tamamlanan geliştirmeler
- X arşiv indirme rehberi eklendi: `/x-guide`.
- Ana X kartına `X arşivi nasıl alınır?` girişi eklendi.
- Rehber resmi X ayar akışını ve büyük arşivlerde `follower.js + following.js` yöntemini açıklar.
- Analiz Geçmişi için `Tüm platformlar / Instagram / X` filtresi eklendi.
- Filtre aktifken karşılaştırma yalnız görünür kayıtlar üzerinden çalışır.
- Tek bir geçmiş snapshot’ını üç nokta menüsünden **onayla silme** eklendi.
- `FollowHistoryDatabase.deleteSnapshot(...)` ilişkileri temizler ve artık referans edilmeyen kullanıcı kayıtlarını kaldırır.
- Karşılaştırmalı analizlerde üst bölümde `Yeni / Bırakan / Net` değişim özeti eklendi.
- `FollowAnalysisResult.comparedToPrevious` ile ilk import ile gerçekten karşılaştırılmış ama değişmemiş snapshot ayrımı yapılabilir.
- X arşiv rehberi widget testi ve snapshot silme DB testi eklendi.
- Karşılaştırma değişim özeti için widget test kapsamı güncellendi.

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
- [x] iki keyfi snapshot’ı manuel seçip karşılaştırma — kod + CI success

### X
- [x] X ilişki JS parser
- [x] X ZIP importer
- [x] büyük arşiv direct `follower.js` + `following.js` importer
- [x] X analiz use case
- [x] X snapshot/geçmiş entegrasyonu
- [x] X ana ekran/import akışı
- [x] X profil/ID-only davranışı
- [x] X toplu paket Actions entegrasyon doğrulaması — run #28 SUCCESS
- [x] canlı API/OAuth maliyet/politika değerlendirmesi — MVP dışına ertelendi
- [ ] gerçek kullanıcı X arşiviyle ileride tek kritik fiziksel doğrulama

## Sıradaki iş
`dev/product-polish` üzerindeki X rehberi + geçmiş filtre/silme + değişim özeti paketini topluca tamamla. Sonra tek fast-forward ile `test/device-apk` branch’ine alıp yalnız bir Actions run çalıştır. Küçük küçük kullanıcı PASS turuna dönme; CI sonucuna göre gerekiyorsa teknik düzeltmeyi yap ve ürün geliştirmesine devam et.
