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

Kod:
- `AnalysisScreen` ignored setini `IgnoredAccountsStore` üzerinden yükler.
- 3 mevcut kategori ignored kullanıcıları filtreler.
- ham 569/1053 özet kartları değişmez.
- sağ üst `visibility_off_outlined` → `/ignored-accounts` yönetim ekranı.
- yönetim ekranından dönünce ignored set yeniden yüklenir.
- çalışan kullanıcı satırında profil `onTap` korunur.
- satıra üç nokta menüsü eklendi; tek eylem `Yok say`.
- Yok say sonrası kullanıcı anında listeden çıkar ve kategori sayısı azalır.
- SnackBar `Geri al` ile kullanıcı geri getirilebilir.
- çalışan `ListView.separated`, CircleAvatar, 3 sekme ve özet Card yapısı korunur.
- **arama/sıralama, MonogramAvatar, son iki sekme ve launcher değişikliği eklenmedi.**

Teknik:
- kaynak commit: `25d50a7855060577ef5cb5d3961e3d4fdba64b58`
- workflow run: `33443944242`
- run number: 19
- VersionCode: `300019`
- APK SHA-256: `fae0dda99fede5c215395cf9289dee30b77783a2daf29d1b0e3e30d3c643b984`
- prerelease: `device-test-v2-19`

Fiziksel Samsung sonucu:
- üç analiz listesi çalışıyor ✅
- profil bağlantısı çalışıyor ✅
- üç nokta → Yok say çalışıyor ✅
- kategori sayısı azalıyor ✅
- `Geri al` işlevi çalışıyor ✅
- sağ üst Yok Sayılan Hesaplar ekranı çalışıyor ✅
- ilk sürümde SnackBar otomatik kapanmıyordu ❌

## v2-20 — SnackBar ilk düzeltme denemesi
- commit `de992b49b92ed7f2cde165d63b12f6b3f1af5781`
- SnackBar 3 saniye sonra zorla kapatılacak şekilde Timer eklendi.
- Analyze ✅
- widget test ❌: ekran dispose edilirken Timer açık kaldığı için test framework pending timer hatası verdi.
- APK üretilmedi; kullanılmayacak.

## v2-21 — SnackBar kapanış düzeltmesi FİZİKSEL PASS
- commit `91bf6a03405d79c57bfe9ccb80c146bfda4ea069`
- Timer state alanında tutuluyor.
- yeni Yok say işleminde önceki Timer iptal ediliyor.
- `Geri al` basılırsa Timer iptal ediliyor.
- ekran dispose olduğunda Timer iptal ediliyor.
- SnackBar en fazla 3 saniye sonra `controller.close()` ile kapatılıyor.
- mevcut listeler, profil açma, ignored filtreleme ve yönetim ekranına dokunulmadı.

CI:
- workflow run `33446688516`
- run number `21`
- Analyze ✅
- Test ✅
- device compatibility wiring ✅
- deterministic signing ✅
- APK build ✅
- package/version/icon-resource/certificate doğrulama ✅
- prerelease ✅
- VersionCode `300021`
- APK SHA-256 `fd8e1bc23884a6d04e454004f309442a19eb4bbc62ba04484f3d9cd6c7b914e5`
- prerelease `device-test-v2-21`

Fiziksel Samsung sonucu:
- Yok say çalışıyor ✅
- Geri al çalışıyor ✅
- SnackBar yaklaşık 3 saniye sonra kendiliğinden kapanıyor ✅
- **v2-21 fiziksel PASS** ✅
- Böylece Yok sayılan hesaplar özelliği tamamen fiziksel onaylıdır.

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
- [x] Yok sayılan hesaplar ana işlevleri fiziksel doğrulandı
- [x] v2-21 SnackBar otomatik kapanışı fiziksel doğrulandı
- [ ] arama/sıralamayı geri ekleme
- [ ] Takibi Bırakanlar / Yeni Takipçiler sekmelerini geri ekleme
- [ ] koyu seçenek 4 launcher simgesini fiziksel doğrulama
- [ ] iki keyfi snapshot'ı elle karşılaştırma

### X
- [ ] resmi X arşiv fixture doğrulaması
- [ ] X importer
- [ ] X snapshot/geçmiş
- [ ] canlı API/OAuth maliyet değerlendirmesi

## Sıradaki iş
Yok sayılan hesaplar artık tamamen PASS. Sonraki özellik yine tek başına geri eklenecek. Öncelik: **arama/sıralama**. Arama/sıralama fiziksel doğrulanmadan Takibi Bırakanlar / Yeni Takipçiler veya launcher değişikliğine geçilmeyecek.
