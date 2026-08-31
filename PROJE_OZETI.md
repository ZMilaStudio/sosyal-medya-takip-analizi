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
- Launcher hedefi kullanıcının onayladığı **4. seçeneğin koyu versiyonu**; henüz fiziksel doğrulanmadı.

## Gerçek Meta export
- 569 takipçi
- 1053 takip edilen
- 792 takip etmeyen
- 261 karşılıklı
- 308 yalnız takipçi
- Instagram UI takip edilen sayısı 967; export ile UI arasında 86 hesap farkı var.

## Fiziksel Android regresyon geçmişi
Başarısız: PR #16, PR #18, PR #19, device-test-v2-11, v2-14, v2-15.

Sorunu izole etmek için ilk MVP analiz ekranına rollback yapıldı.

### v2-16 — fiziksel çalışan liste baseline
- commit `90059b024cc844a101a84ac076e49a22d12b86b6`
- VersionCode 300016
- fiziksel Samsung: Takip Etmeyenler (792) listesi ve 569/1053 kartları görünür ✅
- backup: `backup/device-v2-16-working-baseline`

### v2-17 — fiziksel çalışan liste + profil bağlantısı
- commit `ac5cce4ac53cdc05b91a2db6b34765afc40a88e4`
- VersionCode 300017
- fiziksel Samsung: liste görünür ✅
- Instagram profil bağlantısı açılır ✅
- `Karşılıklı (261)` sekmesine geçiş ve liste görünümü doğrulandı ✅
- `Seni Takip Edenler (308)` sayısı doğru görünür ✅
- backup: `backup/device-v2-17-links-working`

## v2-21 — Yok say özelliği tamamen fiziksel PASS
- commit `91bf6a03405d79c57bfe9ccb80c146bfda4ea069`
- VersionCode `300021`
- prerelease `device-test-v2-21`
- backup: `backup/device-v2-21-ignored-working`
- liste / profil / Yok say / Geri al / ignored yönetimi / 3 sn SnackBar kapanışı fiziksel PASS ✅

## v2-22 — Arama + sıralama FİZİKSEL PASS
- kaynak commit `644549a224ca72d70746ddaada7d223ca9c4d2e0`
- VersionCode `300022`
- APK SHA-256 `a1d442c81da5f2dc0dc57994eb577a944698cb315cd29b980a042c7d388f5d02`
- prerelease `device-test-v2-22`
- backup: `backup/device-v2-22-search-sort-working`

Fiziksel Samsung sonucu:
- üç mevcut liste ✅
- profil açma ✅
- Yok say / Geri al / ignored yönetimi ✅
- kullanıcı arama ✅
- A-Z / Z-A sıralama ✅
- **v2-22 fiziksel PASS** ✅

## v2-23 — Takibi Bırakanlar + Yeni Takipçiler adayı
Çalışan v2-22 yapısına yalnız iki tarihsel sekme geri eklendi.

Model doğrulaması:
- `Takibi Bırakanlar` = `FollowAnalysis.unfollowers`
- `Yeni Takipçiler` = `FollowAnalysis.newFollowers`
- Bu iki küme yalnız önceki snapshot varsa hesaplanır.
- Önceki snapshot yoksa iki sekmenin de `(0)` göstermesi doğru davranıştır.

UI:
- mevcut 3 sekme korunur.
- 4. sekme `Takibi Bırakanlar`.
- 5. sekme `Yeni Takipçiler`.
- iki yeni sekmede mevcut çalışan CircleAvatar, profil açma, arama, A-Z/Z-A, Yok say ve SnackBar altyapısı aynen kullanılır.
- ignored filtresi tarihsel sekmelere de uygulanır.
- launcher bu sürümde değiştirilmedi.

Regresyon testi:
- önceki snapshot olmadan yeni sekmelerin `(0)` görünmesi kontrol edilir.
- sentetik previous/current snapshot ile 1 unfollower (`@left`) ve 1 new follower (`@newcomer`) üretilir.
- TabController ile 4. ve 5. sekme gövdelerinin doğru kullanıcıyı render ettiği doğrulanır.
- v2-22 arama/sıralama/Yok say testleri korunur.

Hazırlık:
- analiz commit `a02a5aa40873bd7b2cf92ddf53c8cfad819dc3d6`
- test commit `c8b69a91fdc198869487b08f128c7fdd1446d0db`
- final staging commit `5d8168d10891e2f602f8ff0999fe1404e23a2686`
- geçici branch `tmp/restore-history-tabs`
- test/device branch'e tek ref hareketi ile tek Actions build açılacak.
- fiziksel cihaz doğrulaması: ⏳

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
- [ ] **v2-23 Takibi Bırakanlar / Yeni Takipçiler sekmelerini CI + fiziksel cihazda doğrulama**
- [ ] koyu seçenek 4 launcher simgesini fiziksel doğrulama
- [ ] iki keyfi snapshot'ı elle karşılaştırma

### X
- [ ] resmi X arşiv fixture doğrulaması
- [ ] X importer
- [ ] X snapshot/geçmiş
- [ ] canlı API/OAuth maliyet değerlendirmesi

## Sıradaki iş
v2-23 test/device branch'ine tek ref hareketiyle taşınacak. CI başarılı olursa APK mevcut v2-22'nin üzerine kurulacak. Fiziksel testte 5 sekmenin görünmesi, ilk 3 sekmenin bozulmaması ve geçmiş verisi varsa son iki sekmenin doğru kullanıcıları göstermesi kontrol edilecek.
