# PROJE_OZETI

Son güncelleme: 31 Ağustos 2026, 23:08 (Europe/Istanbul)

## Çalışma protokolü
- Her yeni sohbet başlangıcında bu `PROJE_OZETI.md` okunarak proje devralınır.
- Bu proje sohbetinde her kullanıcı mesajından sonra önemli yeni kararlar, tamamlanan işler, açık sorunlar ve güncel durum bu dosyaya işlenir.
- Bu dosya + canlı GitHub repo proje gerçeklik kaynağıdır.
- Yeni karar eski kararı geçersiz kılar.
- Kullanıcı istemedikçe görsel mockup gönderilmez; uygulanmış APK üzerinden ilerlenir.

## Proje amacı
Android öncelikli Flutter + Dart, local-first sosyal medya takip analizi uygulaması.

İlk çekirdek Instagram resmi Meta veri dışa aktarma ZIP/JSON/HTML dosyalarını cihaz üzerinde analiz eder. Daha sonra snapshot/geçmiş karşılaştırması ve X resmi veri arşivi desteği genişletilir.

Temel sonuçlar:
- Ben takip ediyorum, beni takip etmiyor.
- Karşılıklı takip.
- Beni takip ediyor, ben takip etmiyorum.
- Yeni takipçiler.
- Takibi bırakanlar.
- Önceki analizlerle karşılaştırma.

## Sabit ürün ve güvenlik kararları
1. Instagram kullanıcı adı/şifre toplama, scraping, private API ve otomatik follow/unfollow yok.
2. Ana Instagram kaynağı resmi Meta export arşividir.
3. X önce resmi veri arşivi importu ile ele alınır; canlı API/OAuth maliyet ve politika uygunsa sonra değerlendirilir.
4. Local-first; sosyal grafik verisi zorunlu olmadıkça cihazdan çıkmaz.
5. Analiz motoru saf Dart ve platform bağımsızdır.
6. Kimlik eşlemede platform ID varsa o, yoksa normalize kullanıcı adı kullanılır.
7. JSON/HTML ve multipart follower dosyaları ile güncel `following.json` üst seviye `title` varyasyonu desteklenir.
8. Profil fotoğrafı scraping ile çekilmez; deterministik monogram avatar kullanılır.
9. Tema mor ağırlığı azaltılmış slate/teal açık temadır. Dark mode şimdilik kapsam dışıdır.
10. `Yok sayılan hesaplar` hesap bazında cihazda saklanır; ham snapshot sayılarını değiştirmez, yalnız analiz sonuçlarını filtreler.
11. Onaylanan launcher yönü: koyu seçenek 4.

## Gerçek Meta export doğrulaması
- `followers_1.json`: 569 benzersiz takipçi.
- `following.json`: 1053 benzersiz takip edilen; kullanıcı adı üst seviye `title` alanında.
- Instagram UI takip edilen sayısı 967; export ile UI arasında 86 hesap farkı var.
- Sonuç: 792 takip etmeyen, 261 karşılıklı, 308 yalnız takipçi.

## Kritik hata geçmişi

### Following parser
Gerçek `following.json` içinde kullanıcı adı `string_list_data.value` yerine `title` alanında geldiği için ilk sürümlerde 569/0 sonucu oluşuyordu. `title` fallback ile düzeltildi ve regression testi eklendi.

### Fiziksel Samsung cihazında analiz ekranı regresyonu
CI/widget testlerinde başarılı görünmesine rağmen fiziksel Samsung/Android 16 cihazında analiz ekranı adım adım bozuldu.

Başarısız fiziksel denemeler:
- PR #16 render düzenlemesi ❌
- PR #18 tek ListView yaklaşımı ❌
- PR #19 sabit özet + ayrı lazy liste yaklaşımı ❌
- `device-test-v2-11` ❌: kategori başlıkları görünürken gövde boş, bazı düğmeler cevapsız.
- `device-test-v2-14` ❌: kullanıcı doğrulamasında analiz ekranında artık AppBar dışında hiçbir içerik görünmedi. Bu sürüm önceki durumu daha da kötüleştirdi ve fiziksel cihaz düzeltmesi olarak kabul edilmedi.

Kullanıcının 31 Ağustos 2026 22:58 fiziksel ekran görüntüsü v2-14 yaklaşımının başarısız olduğunu kesinleştirdi. Bu nedenle yeni render yamaları ekleme yaklaşımı durduruldu.

### Baseline rollback kararı
Yeni karar: önce çalışan temel analiz ekranına dönülecek; ardından özellikler tek tek ve fiziksel cihazda doğrulanarak eklenecek.

Referans baseline: commit `fa9ef4a45588734227ba5404bf7b52085838328e` sonrasındaki orijinal `analysis_screen.dart`.

`test/device-apk` üzerinde commit `7fd5bf5e559cafc5811585e22fca0ed5b811f545` ile:
- `analysis_screen.dart` birebir eski Git blob'una (`89bd2167887b7eb632e76c2b3fd4083f9c76de9b`) döndürüldü.
- `analysis_screen_test.dart` aynı baseline'ın orijinal testine (`b3ed750e25884b6cb1881448fbc293539a546611`) döndürüldü.
- Sonradan eklenen pagination, özel kategori butonları ve analiz ekranı render yamaları çıkarıldı.
- Parser düzeltmesi, veri katmanı, deterministic signing, paket/version sistemi ve mevcut launcher wiring korunuyor.
- v2-14 bozuk branch durumu `backup/device-v2-14-broken` altında yedeklendi.

### device-test-v2-15 — BASELINE ROLLBACK ADAYI
- commit: `7fd5bf5e559cafc5811585e22fca0ed5b811f545`
- workflow run: `33433757649`
- VersionCode: `300015`
- APK SHA-256: `9e818d53c168bda784d05ae24a3dbb8de3f5336b00ff8e58e1e88aff5ebbb819`
- Analyze ✅
- baseline'ın orijinal widget testi ✅
- signing/wiring kontrolleri ✅
- APK build ✅
- package/version/icon-resource/certificate doğrulama ✅
- prerelease ✅
- fiziksel Samsung doğrulaması ⏳

Not: workflow release açıklaması v2-14 metninden kaldığı için release body'deki “ilk 100 hesap / düz Column” açıklaması v2-15 kodunu temsil etmiyor. Gerçek kaynak commit `7fd5bf5...`; analiz ekranı baseline'a dönmüştür.

## Launcher simgesi
Önceki fiziksel testte launcher Android robot/varsayılan simge görünmüştü. v2-14 ile manifest doğrudan `@drawable/takip_launcher` kaynağına bağlandı ve APK içindeki resource doğrulandı. Ancak seçilen koyu seçenek 4 tasarımının fiziksel cihazda doğru göründüğü henüz kesinleşmedi. Launcher işi fiziksel doğrulama olmadan tamamlanmış sayılmaz.

## Test APK imza ve güncelleme sistemi
Deterministic device-test v2:
- paket: `com.zmilastudio.takipanalizi.dev`
- sabit test keystore
- sertifika SHA-256: `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`
- versionCode = `300000 + GITHUB_RUN_NUMBER`
- AAPT paket/versionCode ve apksigner sertifika kontrolü

v2 tabanı kurulduktan sonraki APK'lar aynı paket + sertifika + daha yüksek versionCode ile kaldırmadan güncellenebilmelidir.

## GitHub / CI
Repo: `ZMilaStudio/sosyal-medya-takip-analizi` — public.

Branchler:
- `main`: stabil hedef; fiziksel doğrulanmamış yeni render denemeleri merge edilmeyecek.
- `test/device-apk`: cihaz doğrulama branch'i.
- `backup/device-test-v2-9`: eski test tabanı.
- `backup/device-v2-14-broken`: v2-14 başarısız durumunun yedeği.

CI:
- Core CI: Dart analyze + test.
- App CI: Flutter analyze + test.
- Device Test: test + sabit imza + APK paket/version/icon/certificate doğrulama + prerelease.
- normal CI artifact upload kullanmaz.

### GitHub Actions ödeme olayı
GitHub hosted runner erişimi başarısız ödeme nedeniyle geçici olarak kilitlenmişti. Payment History'de Visa $1 `Declined`, MasterCard $1 `Success` oldu. Başarılı tahsilattan sonra runner erişimi açıldı. Bu sorun kapalıdır.

## MVP durumu
### Instagram MVP
- [x] Analiz modeli/motoru
- [x] JSON/HTML parser
- [x] güvenli ZIP importer
- [x] `following.json title` desteği
- [x] gerçek Meta export doğrulaması
- [x] Flutter import
- [x] sonuç kategorileri
- [x] arama / sıralama
- [x] Instagram profilini açma
- [x] snapshot/geçmiş
- [x] yeni takipçiler / takibi bırakanlar
- [x] yok sayılan hesaplar veri katmanı
- [x] veri indirme rehberi
- [x] deterministic v2 signing
- [ ] v2-15 baseline analiz ekranını fiziksel Samsung cihazında doğrulama
- [ ] baseline sağlamlandıktan sonra `Yok sayılanlar` UI'sını tek başına geri ekleme ve fiziksel doğrulama
- [ ] seçilen koyu launcher simgesini fiziksel cihazda doğrulama
- [ ] v2 APK'nın kaldırmadan `Güncelle` olarak kurulduğunu doğrulama
- [ ] iki keyfi snapshot'ı elle seçerek karşılaştırma

### X
- [ ] gerçek resmi X arşiv fixture doğrulaması
- [ ] X ZIP/JSON importer
- [ ] X snapshot/geçmiş
- [ ] canlı API maliyet modeli
- [ ] gerekirse OAuth 2.0 PKCE

## Sıradaki iş
`device-test-v2-15` mevcut uygulama kaldırılmadan kurulacak. Bu sürümde amaç yalnız baseline'ın geri geldiğini doğrulamaktır:
1. Özet kartları görünüyor mu?
2. Sekmeler görünüyor ve değişiyor mu?
3. Açıklama + arama + A-Z düğmesi görünüyor mu?
4. Kullanıcı listesi görünüyor mu?

Baseline fiziksel cihazda sağlamlanmadan yeni analiz ekranı özelliği eklenmeyecek ve `main`e merge yapılmayacak.
