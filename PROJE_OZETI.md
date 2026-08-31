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

## v2-19 — Yok sayılan hesaplar fiziksel sonucu
`v2-17` çalışan yapısı korunarak yalnız ignored entegrasyonu geri eklendi.

Fiziksel Samsung sonucu:
- üç analiz listesi çalışıyor ✅
- profil bağlantısı çalışıyor ✅
- üç nokta → Yok say çalışıyor ✅
- kategori sayısı azalıyor ✅
- `Geri al` işlevi çalışıyor ✅
- sağ üst Yok Sayılan Hesaplar ekranı çalışıyor ✅
- ilk sürümde SnackBar otomatik kapanmıyordu ❌

Teknik:
- commit `25d50a7855060577ef5cb5d3961e3d4fdba64b58`
- VersionCode `300019`
- prerelease `device-test-v2-19`

## v2-20 — SnackBar ilk düzeltme denemesi
- commit `de992b49b92ed7f2cde165d63b12f6b3f1af5781`
- Timer ile 3 saniyelik kapanış eklendi.
- Analyze ✅
- widget test ❌: dispose sırasında pending timer.
- APK üretilmedi; kullanılmayacak.

## v2-21 — Yok say özelliği tamamen fiziksel PASS
- commit `91bf6a03405d79c57bfe9ccb80c146bfda4ea069`
- VersionCode `300021`
- APK SHA-256 `fd8e1bc23884a6d04e454004f309442a19eb4bbc62ba04484f3d9cd6c7b914e5`
- prerelease `device-test-v2-21`
- backup: `backup/device-v2-21-ignored-working`

Fiziksel Samsung sonucu:
- liste ✅
- profil bağlantısı ✅
- Yok say ✅
- kategori sayısı güncelleme ✅
- Geri al ✅
- Yok Sayılan Hesaplar yönetimi ✅
- SnackBar yaklaşık 3 saniye sonra otomatik kapanıyor ✅
- **v2-21 fiziksel PASS** ✅

## v2-22 — Arama + sıralama adayı
Çalışan v2-21 yapısı korunarak yalnız arama ve sıralama geri eklendi.

Uygulama davranışı:
- Her mevcut analiz sekmesinde açıklamanın altında `Kullanıcı ara` alanı bulunur.
- Arama kullanıcı adına ve varsa displayName'e göre filtreler.
- Arama yalnız görünür listeyi filtreler; üst kategori toplamı değişmez.
- `A-Z` düğmesi varsayılan artan sıralamayı gösterir.
- Düğmeye basınca `Z-A` sırasına geçer; tekrar basınca A-Z'ye döner.
- Aramada sonuç yoksa `Aramana uygun hesap bulunamadı.` gösterilir.
- çalışan `ListView.separated`, CircleAvatar, profil `onTap`, üç nokta → Yok say, sağ üst ignored yönetimi ve SnackBar mantığı değiştirilmedi.
- son iki tarihsel sekme ve launcher bu sürüme eklenmedi.

Regresyon testleri:
- mevcut liste + sekme testi ✅
- arama `bob` → `@alice` gizlenir, `@bob` kalır ✅
- A-Z → Z-A düğmesi sonrası satır konumları tersine döner ✅
- Yok say testi ✅

CI / APK:
- kaynak commit `644549a224ca72d70746ddaada7d223ca9c4d2e0`
- workflow run `33447857481`
- run number `22`
- Analyze ✅
- Test ✅
- device compatibility wiring ✅
- deterministic signing ✅
- APK build ✅
- package/version/icon-resource/certificate doğrulama ✅
- prerelease ✅
- VersionCode `300022`
- APK SHA-256 `a1d442c81da5f2dc0dc57994eb577a944698cb315cd29b980a042c7d388f5d02`
- prerelease `device-test-v2-22`
- fiziksel Samsung doğrulaması: ⏳

Not: workflow release body metni eski render deneyi açıklamasını taşıyor; v2-22'nin gerçek kaynak durumu `644549a...` commit'i ve bu proje özetidir.

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
- [ ] **v2-22 arama/sıralamayı fiziksel cihazda doğrulama**
- [ ] Takibi Bırakanlar / Yeni Takipçiler sekmelerini geri ekleme
- [ ] koyu seçenek 4 launcher simgesini fiziksel doğrulama
- [ ] iki keyfi snapshot'ı elle karşılaştırma

### X
- [ ] resmi X arşiv fixture doğrulaması
- [ ] X importer
- [ ] X snapshot/geçmiş
- [ ] canlı API/OAuth maliyet değerlendirmesi

## Sıradaki fiziksel test
v2-22 mevcut v2-21 uygulamasının üzerine `Güncelle` olarak kurulacak. Yalnız şu maddeler doğrulanacak:
1. Üç mevcut liste hâlâ görünüyor mu?
2. Profil açma, Yok say ve sağ üst ignored yönetimi hâlâ çalışıyor mu?
3. `Kullanıcı ara` alanına yazınca liste doğru filtreleniyor mu?
4. `A-Z / Z-A` düğmesi sıralamayı gerçekten tersine çeviriyor mu?

Bu fiziksel test geçmeden son iki sekme veya launcher değişikliğine geçilmeyecek.
