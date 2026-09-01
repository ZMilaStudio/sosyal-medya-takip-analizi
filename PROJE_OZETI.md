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
- Launcher hedefi kullanıcının onayladığı **4. seçeneğin koyu versiyonu**; v2-25 fiziksel doğrulama adayıdır.

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

## v2-23 model ve test notları
- `Takibi Bırakanlar` = `FollowAnalysis.unfollowers`
- `Yeni Takipçiler` = `FollowAnalysis.newFollowers`
- previous snapshot yoksa iki sekme `(0)` gösterir; bu normal davranıştır.
- previous snapshot varsa farklar iki snapshot üzerinden hesaplanır.
- previous yok testi ✅
- sentetik previous/current `@left` unfollower testi ✅
- sentetik previous/current `@newcomer` new follower testi ✅
- liste / arama / sıralama / Yok say regresyon testleri ✅

## Launcher simgesi teşhisi ve v2-25
Önceki fiziksel sürümlerde yanlış simgenin görünmesinin sebebi bulundu:
- v2-14 döneminde manifest yanlışlıkla `@drawable/takip_launcher` adlı sonradan oluşturulmuş kişi+büyüteç vektörüne bağlanmıştı.
- Bu dosya kullanıcının daha önce onayladığı **4. seçeneğin koyu versiyonu değildi**.
- Onaylı koyu launcher kaynakları Git geçmişindeki `863eb72e703151b71f151509aa46e12d6fb7fbf1` ve tam Android wiring'i sağlayan `6294a348448f8bfa28ac6e547c06e4383adfa2c8` commitlerinde bulundu.

v2-25 için geri getirilen doğru Android zinciri:
- Manifest `android:icon="@mipmap/ic_launcher"`
- Manifest `android:roundIcon="@mipmap/ic_launcher_round"`
- Android 26+ adaptive foreground: `@drawable/ic_launcher_foreground`
- adaptive normal + round kaynakları mevcut
- legacy normal + round fallback mevcut
- arka plan `#07152F`
- foreground ana renkleri `#35C2B1`, `#EEF4FF`, `#8A8FD1`
- v2-23 uygulama/analiz koduna dokunulmadı.

### v2-24 — yayınlanmadı
- launcher kaynak kodu ve tüm uygulama testleri geçti ✅
- APK build geçti ✅
- VersionCode 300024
- son APK doğrulama adımı yanlış negatif verdi: workflow `aapt dump badging` çıktısını `head -40` ile kesiyor, `application-icon-*` satırı 40. satırdan sonra kaldığı için grep başarısız oluyordu.
- APK prerelease yayınlanmadı; **v2-24 kullanılmayacak**.

### v2-25 — launcher fiziksel doğrulama adayı
- launcher kaynak commit zinciri: `52513e14b1805f1ad865f15bb62d72241b6b40a3`
- CI doğrulama düzeltme commit: `d3ec866bbf943d997001c021f8807ef372500ddc`
- workflow run `33479549756`
- VersionCode `300025`
- Analyze ✅
- 15 test ✅
- manifest/adaptive/round/legacy launcher wiring ✅
- APK build ✅
- APK package/version/launcher resource/signing certificate doğrulaması ✅
- prerelease publish ✅
- APK SHA-256 `0917c494733399b6e25acb2f1284fe00d01efbafeac987238ad1217531f1593b`
- prerelease `device-test-v2-25`
- fiziksel Samsung launcher doğrulaması ⏳

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
- [ ] **v2-25 koyu seçenek 4 launcher simgesini fiziksel Samsung'da doğrulama**
- [ ] gerçek geçmiş snapshot akışının son iki sekmeyi otomatik doldurduğunu fiziksel olarak doğrulama
- [ ] iki keyfi snapshot'ı elle karşılaştırma

### X
- [ ] resmi X arşiv fixture doğrulaması
- [ ] X importer
- [ ] X snapshot/geçmiş
- [ ] canlı API/OAuth maliyet değerlendirmesi

## Sıradaki iş
`device-test-v2-25` mevcut v2-23 uygulamasının üzerine `Güncelle` olarak kurulacak. Bu tur yalnız launcher simgesi fiziksel olarak kontrol edilecek; uygulama açılıp v2-23'te PASS olan listelerin hâlâ yerinde olduğu hızlıca doğrulanacak. Simge kullanıcı tarafından doğru görülmeden launcher işi tamamlanmış sayılmayacak.
