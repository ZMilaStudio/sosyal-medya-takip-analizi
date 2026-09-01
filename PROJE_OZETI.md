# PROJE_OZETI

Son güncelleme: 1 Eylül 2026

## Çalışma protokolü
- Her yeni sohbet başlangıcında bu dosya okunarak proje devralınır.
- Her kullanıcı mesajından sonra önemli kararlar, tamamlanan işler, açık sorunlar ve güncel durum buraya işlenir.
- Bu dosya + canlı GitHub repo proje gerçeklik kaynağıdır.
- Fiziksel cihazda doğrulanmayan değişiklik “çözüldü” sayılmaz.
- Çalışan fiziksel baseline korunur; özellikler tek tek geri eklenir.
- Kullanıcı istemedikçe görsel mockup gönderilmez; gerçek APK üzerinden ilerlenir.

## Proje amacı ve sabit kararlar
Android öncelikli Flutter + Dart, local-first sosyal medya takip analizi uygulaması. Instagram resmi Meta veri dışa aktarma ZIP/JSON/HTML dosyalarını cihaz üzerinde analiz eder.

- Scraping/private API/Instagram şifresi/otomatik follow-unfollow yok.
- `following.json` üst seviye `title` varyasyonu desteklenir.
- Yok sayılan hesaplar hesap bazında cihazda tutulur; ham snapshot sayılarını değiştirmez, yalnız analiz listelerini filtreler.
- Kullanıcı satırına dokununca resmi Instagram profil URL'si harici uygulamada açılır.
- Final analiz hedefi 5 sekmedir: Takip Etmeyenler, Karşılıklı, Seni Takip Edenler, Takibi Bırakanlar, Yeni Takipçiler.
- Launcher için kullanıcı 1 Eylül 2026'da exact görseli tekrar yükledi. Bundan sonra launcher görseli yeniden çizilmeyecek/üretilmeyecek; kullanıcının yüklediği raster görsel esas alınacak.

## Gerçek Meta export
- 569 takipçi
- 1053 takip edilen
- 792 takip etmeyen
- 261 karşılıklı
- 308 yalnız takipçi
- Instagram UI takip edilen sayısı 967; export ile UI arasında 86 hesap farkı var.

## Fiziksel çalışan baselines
### v2-16 — liste baseline
- commit `90059b024cc844a101a84ac076e49a22d12b86b6`
- VersionCode 300016
- fiziksel Samsung: listeler ve 569/1053 kartları görünür ✅
- backup `backup/device-v2-16-working-baseline`

### v2-17 — profil bağlantısı PASS
- commit `ac5cce4ac53cdc05b91a2db6b34765afc40a88e4`
- profil bağlantısı fiziksel PASS ✅
- backup `backup/device-v2-17-links-working`

### v2-21 — Yok say PASS
- commit `91bf6a03405d79c57bfe9ccb80c146bfda4ea069`
- VersionCode 300021
- liste / profil / Yok say / Geri al / ignored yönetimi / 3 sn SnackBar kapanışı fiziksel PASS ✅
- backup `backup/device-v2-21-ignored-working`

### v2-22 — Arama + sıralama PASS
- commit `644549a224ca72d70746ddaada7d223ca9c4d2e0`
- VersionCode 300022
- APK SHA-256 `a1d442c81da5f2dc0dc57994eb577a944698cb315cd29b980a042c7d388f5d02`
- prerelease `device-test-v2-22`
- arama / A-Z-Z-A / listeler / profil / ignored akışı fiziksel PASS ✅
- backup `backup/device-v2-22-search-sort-working`

### v2-23 — 5 sekme PASS
- final kaynak commit `a0c96ecfd33b9c546c2a852aac3c2b4eee40b1d0`
- workflow run `33449350608`
- VersionCode `300023`
- APK SHA-256 `91a7c93fa8484d92af3d50845375eab0f130f84a5a9c058c3f1185dfac39d21e`
- prerelease `device-test-v2-23`
- 5 sekmenin tamamı fiziksel Samsung'da görünür ✅
- ilk 3 sekme ve mevcut çalışan işlevler bozulmadan korunuyor ✅
- Takibi Bırakanlar + Yeni Takipçiler sekmeleri fiziksel PASS ✅
- arama / A-Z-Z-A / profil / Yok say / ignored akışı fiziksel PASS durumunu koruyor ✅
- backup `backup/device-v2-23-five-tabs-working`

### v2-26 — exact launcher PASS
- source commit `aa63720d49d97fd7f23de69549c307964c684fd5`
- workflow run `33485074032`
- VersionCode `300026`
- prerelease `device-test-v2-26`
- APK SHA-256 `9442a5a88c8136014ca1bc71f5565128b2d36fe47092e077aa0d9cf255f3c1f3`
- kullanıcının sohbete yüklediği raster görsel doğrudan launcher olarak kullanılıyor ✅
- fiziksel Samsung launcher görünümü kullanıcı tarafından PASS ✅
- v2-23'te PASS olan analiz özellikleri korunuyor ✅

## v2-23 model ve test notları
- `Takibi Bırakanlar` = `FollowAnalysis.unfollowers`
- `Yeni Takipçiler` = `FollowAnalysis.newFollowers`
- previous snapshot yoksa iki sekme `(0)` gösterir; bu normal davranıştır.
- previous snapshot varsa farklar iki snapshot üzerinden hesaplanır.
- previous yok testi ✅
- sentetik previous/current `@left` unfollower testi ✅
- sentetik previous/current `@newcomer` new follower testi ✅
- liste / arama / sıralama / Yok say regresyon testleri ✅

## Launcher simgesi — son durum
### v2-24 — yayınlanmadı
- launcher kaynak kodu ve tüm uygulama testleri geçti ✅
- APK build geçti ✅
- VersionCode 300024
- son APK doğrulama adımı yanlış negatif verdi: workflow `aapt dump badging` çıktısını `head -40` ile kesiyordu.
- prerelease yayınlanmadı; **v2-24 kullanılmayacak**.

### v2-25 — kullanıcı tarafından RED
- eski Git geçmişindeki vektör/adaptive launcher zinciri geri getirilmişti.
- teknik CI tamamen geçti ancak kullanıcı fiziksel sonucu istediği görsel olarak kabul etmedi ❌
- bu nedenle v2-25 launcher çözümü geçersizdir; doğru simge olarak kabul edilmeyecek.
- backup `backup/device-v2-25-before-exact-icon`

### v2-26 — kullanıcının yüklediği exact raster simge PASS
- kullanıcı istediği launcher görselini doğrudan sohbete yükledi.
- görsel yeniden çizilmedi, AI ile yeniden üretilmedi, renk/kompozisyon değiştirilmedi.
- Android launcher için yalnız 192×192'e LANCZOS ile küçültülüp WebP olarak paketlendi.
- repo asset: `apps/mobile/android/app/src/main/res/drawable-nodpi/takip_launcher_user.webp`
- kaynak launcher asset SHA-256: `7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`
- manifest doğrudan `android:icon="@drawable/takip_launcher_user"` ve `android:roundIcon="@drawable/takip_launcher_user"` kullanıyor.
- eski `@mipmap/ic_launcher` / vektör zinciri launcher olarak artık kullanılmıyor.
- source commit `aa63720d49d97fd7f23de69549c307964c684fd5`
- workflow run `33485074032`
- VersionCode `300026`
- Analyze ✅
- 15 test ✅
- manifest exact raster wiring ✅
- kaynak icon SHA kilidi ✅
- APK build ✅
- APK içinde `takip_launcher_user.webp` doğrulaması ✅
- paket / VersionCode / signing certificate ✅
- prerelease publish ✅
- APK SHA-256 `9442a5a88c8136014ca1bc71f5565128b2d36fe47092e077aa0d9cf255f3c1f3`
- prerelease `device-test-v2-26`
- **fiziksel launcher görünümü PASS ✅**

## Gerçek snapshot fiziksel doğrulama — gece02.19
- Test v2-26 üzerinde başlatıldı; yeni build çıkarılmadı.
- Kullanıcı `gece02.19` hesabının eski Meta arşivini aynı hesap adıyla içe aktardı.
- Eski arşiv ilk gerçek snapshot olarak cihaz veritabanına kaydedildi ✅
- Eski snapshot ekran sonucu: 75 takipçi, 53 takip edilen, 10 takip etmeyen, 43 karşılıklı.
- Kullanıcı yeni Meta arşivini talep etti; teslim bekleniyor.
- Yeni arşiv geldiğinde uygulama/veri silinmeden aynı `gece02.19` kullanıcı adıyla ikinci kez içe aktarılacak.
- Import controller doğrulandı: önce `latestSnapshot(account)` okunuyor, current analiz previous ile yapılıyor, sonra current snapshot `saveSnapshot` ile kaydediliyor.
- Hedef: ikinci gerçek snapshot sonrası `Takibi Bırakanlar` ve `Yeni Takipçiler` sekmelerinin gerçek değişikliklerle otomatik dolduğunu fiziksel olarak doğrulamak.

## Test APK imza sistemi
- paket `com.zmilastudio.takipanalizi.dev`
- sabit test sertifikası SHA-256 `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`
- versionCode = 300000 + GitHub run number
- mevcut v2 uygulamanın üzerine `Güncelle` olarak kurulmalı.

## MVP durumu
### Instagram
- [x] analiz motoru
- [x] JSON/HTML/ZIP import
- [x] `following.json title` desteği
- [x] gerçek Meta export doğrulaması
- [x] snapshot/geçmiş veri katmanı
- [x] deterministic test signing
- [x] fiziksel kullanıcı listesi
- [x] fiziksel kategori sekmesi geçişi
- [x] fiziksel Instagram profil bağlantısı
- [x] Yok sayılan hesaplar fiziksel doğrulandı
- [x] arama/sıralama fiziksel doğrulandı
- [x] 5 sekme fiziksel Samsung'da doğrulandı
- [x] kullanıcının exact launcher görseli fiziksel Samsung'da doğrulandı
- [ ] gerçek geçmiş snapshot akışının son iki sekmeyi otomatik doldurduğunu fiziksel olarak doğrulama — `gece02.19` testi devam ediyor
- [ ] iki keyfi snapshot'ı elle karşılaştırma

### X
- [ ] resmi X arşiv fixture doğrulaması
- [ ] X importer
- [ ] X snapshot/geçmiş
- [ ] canlı API/OAuth maliyet değerlendirmesi

## Sıradaki iş
`gece02.19` için yeni Meta arşivi geldiğinde uygulamayı veya verilerini silmeden, kullanıcı adını yine `gece02.19` girerek yeni ZIP içe aktarılacak. Ardından 4. ve 5. sekmelerdeki `Takibi Bırakanlar` / `Yeni Takipçiler` sayıları ve kullanıcı listeleri fiziksel olarak kontrol edilecek.
