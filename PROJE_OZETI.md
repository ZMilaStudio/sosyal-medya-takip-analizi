# PROJE_OZETI

Son güncelleme: 31 Ağustos 2026, 22:33 (Europe/Istanbul)

## Çalışma protokolü
- Bu dosya + canlı GitHub repo proje gerçeklik kaynağıdır.
- Yeni karar eski kararı geçersiz kılar.
- Önemli kararlar, tamamlanan işler ve açık fiziksel cihaz sorunları burada tutulur.
- Kullanıcı istemedikçe tekrar görsel mockup gönderilmez; uygulanmış APK üzerinden ilerlenir.

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
11. Sağ üst `visibility_off` düğmesi **Yok sayılan hesaplar** yönetimine gider.
12. Onaylanan launcher yönü: **koyu seçenek 4** — koyu lacivert/neredeyse siyah zemin, teal/mor kişi figürleri ve büyüteç.

## Gerçek Meta export doğrulaması
- `followers_1.json`: 569 benzersiz takipçi.
- `following.json`: 1053 benzersiz takip edilen; kullanıcı adı üst seviye `title` alanında.
- Instagram UI takip edilen sayısı 967; export ile UI arasında 86 hesap farkı bulunuyor.
- Ham arşiv değiştirilmez; gerekirse hesaplar `Yok say` ile analizden çıkarılır.
- Sonuç: 792 takip etmeyen, 261 karşılıklı, 308 yalnız takipçi.

## Mobil mimari
`apps/mobile`:
- Flutter 3.47.2
- Riverpod + go_router
- file_picker
- Drift/SQLite geçmiş
- merkezi `AppTheme`
- Instagram import
- analiz ekranı
- arama + A-Z/Z-A sıralama
- Instagram profilini dış uygulamada açma
- monogram avatarlar
- yok say / geri al / yönetim
- analiz geçmişi
- export rehberi
- X için pasif `Yakında`

`packages/follow_core`:
- `SocialPlatform`, `SocialAccount`, `SocialUser`
- `FollowSnapshot`, `FollowAnalysis`, `FollowAnalysisEngine`
- Instagram JSON/HTML parser
- güvenli ZIP importer
- import -> snapshot -> analiz use-case
- unit/regression testleri

## Yerel geçmiş
- `StoredAccounts`
- `StoredSocialUsers` (`identityKey` dedupe)
- `StoredSnapshots`
- `StoredSnapshotRelations`
- UTC normalize snapshot saatleri
- hesap başına varsayılan son 30 snapshot retention
- eski snapshot açıldığında önceki snapshot ile değişim analizi yeniden hesaplanır

## Kritik hata geçmişi

### Following parser
Gerçek `following.json` içinde kullanıcı adı `string_list_data.value` yerine `title` alanında geldiği için ilk sürümlerde 569/0 sonucu oluşuyordu. `title` fallback ile düzeltildi ve regression testi eklendi.

### Fiziksel Samsung cihazında boş analiz gövdesi
CI/widget testlerinde başarılı olmasına rağmen fiziksel Samsung/Android 16 cihazında kategori başlıkları ve sayıları görünürken analiz gövdesi boş kalmaya devam etti.

Başarısız fiziksel denemeler:
- PR #16 render düzenlemesi ❌
- PR #18 tek ListView yaklaşımı ❌
- PR #19 sabit özet + ayrı lazy liste yaklaşımı ❌
- `device-test-v2-11` ❌: gövde yine boş; ayrıca kullanıcı bu sürümde analiz ekranındaki düğmelerin de cevap vermediğini bildirdi.

`device-test-v2-14` için daha köklü fiziksel cihaz izolasyonu yapıldı:
- `AppBar.bottom` kaldırıldı.
- Dikey `ListView`, `Expanded` ve nested/lazy liste zinciri kaldırıldı.
- Body tek `SingleChildScrollView` + düz `Column` oldu.
- İlk 100 hesap doğrudan çiziliyor; `Daha fazla göster` ile 100'er hesap ekleniyor.
- Arama tüm kategori veri kümesinde çalışmaya devam ediyor.
- Kategori seçimleri gerçek `FilledButton/OutlinedButton` ile yapılıyor.
- `IgnoredAccountsStore` yüklemesi ilk frame sonrasına alındı ve hata durumunda analiz UI'sını engellememesi sağlandı.
- Samsung/Android 16 renderer farkını izole etmek için **yalnız v2-14 test APK'sında Impeller kapatıldı**.
- 360x800 testte gövde, ilk satır, arama, kategori değişimi ve sıralama etkileşimi doğrulanıyor.

Kök neden henüz kesin ilan edilmedi. v2-14 fiziksel cihazda doğrulanmadan sorun kapanmış sayılmaz.

### Launcher simgesi
Önceki CI kontrolü yalnız `ic_launcher` wiring ve dosya varlığını doğruluyordu. Fiziksel cihaz ekran görüntüsü mevcut PNG'lerin gerçekte Android robot/varsayılan simgeyi taşıdığını kanıtladı. Bu nedenle önceki “koyu seçenek 4 uygulandı” değerlendirmesi geçersizdir.

`device-test-v2-14` ile:
- manifest artık `@mipmap/ic_launcher` kullanmıyor;
- `android:icon` ve `android:roundIcon` doğrudan `@drawable/takip_launcher` kaynağına bağlı;
- `takip_launcher.xml`: koyu lacivert `#07152F`, teal `#2DD4BF`, mor `#8B5CF6/#A78BFA`, kişi + büyüteç tasarımı;
- CI APK içindeki `res/drawable/takip_launcher` kaynağını da doğruluyor.

Bu simge de fiziksel cihazda görülmeden tamamlanmış sayılmaz.

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
- `main`: fiziksel doğrulanmış/stabil kod hedefi
- `test/device-apk`: cihaz doğrulama branch'i
- `backup/device-test-v2-9`: eski test tabanı

CI:
- Core CI: Dart analyze + test
- App CI: Flutter analyze + test
- Device Test: test + fiziksel uyumluluk wiring + sabit imza + APK paket/version/icon doğrulama + prerelease
- normal CI artifact upload kullanmaz

### 31 Ağustos 2026 GitHub Actions ödeme olayı
GitHub hosted runner erişimi başarısız ödeme nedeniyle hesap seviyesinde geçici olarak kilitlenmişti. Payment History ekranında Visa ile $1 işlem `Declined`, MasterCard ile $1 işlem `Success` oldu. Başarılı tahsilattan sonra runner tahsisi yeniden açıldı ve Device Test build'leri çalışmaya başladı. Bu sorun şu an kapalıdır.

## Güncel doğrulanmış build durumu
### device-test-v2-11
- VersionCode `300011`
- CI tamamen başarılı ✅
- Fiziksel Samsung testi ❌
  - analiz gövdesi/listeler boş
  - analiz ekranındaki butonlar cevap vermiyor
  - launcher Android robot/varsayılan simge

### device-test-v2-14 — GÜNCEL ADAY
- commit: `fd5452f3e353fc04b65c15ab245011ec64d9edd6`
- workflow run: `33430526728`
- VersionCode: `300014`
- APK SHA-256: `aa343d6d75849ae73475fdfbfe8f2440ce0eadbfe8ee443a7485ff732f0ee06f`
- Analyze ✅
- widget/interaction tests ✅
- physical-device compatibility wiring ✅
- deterministic signing ✅
- APK build ✅
- APK package/version/icon-resource/certificate doğrulama ✅
- prerelease ✅
- fiziksel Samsung doğrulaması ⏳

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
- [x] yok sayılan hesaplar
- [x] veri indirme rehberi
- [x] sade tema + monogramlar
- [x] deterministic v2 signing
- [ ] v2-14 analiz gövdesini fiziksel Samsung cihazında doğrulama
- [ ] v2-14 buton etkileşimlerini fiziksel cihazda doğrulama
- [ ] v2-14 yeni launcher simgesini fiziksel cihazda doğrulama
- [ ] v2-14'ün eski v2 APK üzerine `Güncelle` olarak kurulduğunu doğrulama
- [ ] iki keyfi snapshot'ı elle seçerek karşılaştırma

### X
- [ ] gerçek resmi X arşiv fixture doğrulaması
- [ ] X ZIP/JSON importer
- [ ] X snapshot/geçmiş
- [ ] canlı API maliyet modeli
- [ ] gerekirse OAuth 2.0 PKCE

## Sıradaki iş
`device-test-v2-14` mevcut uygulama kaldırılmadan kurulacak. Fiziksel cihazda aynı turda dört şey kontrol edilecek:
1. Android `Güncelle` olarak kurdu mu?
2. Yeni koyu teal/mor kişi+büyüteç simgesi göründü mü?
3. Analiz özet/arama ve ilk 100 kullanıcı satırı göründü mü?
4. Kategori, sağ üst Yok Sayılanlar, arama/sıralama ve `Daha fazla göster` düğmeleri çalışıyor mu?

Fiziksel doğrulama başarılı olursa v2-14 değişiklikleri `main`e taşınacak. Başarısız olursa main'e merge edilmeyecek; sonraki teşhis gerçek cihaz runtime/logcat yönüne geçecek.
