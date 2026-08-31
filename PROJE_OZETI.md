# PROJE_OZETI

Son güncelleme: 31 Ağustos 2026

## Çalışma protokolü
- Her yeni sohbetin başında bu dosya okunarak proje devralınır.
- Her kullanıcı mesajından sonra yeni kararlar, tamamlanan işler, açık sorunlar ve güncel durum gerekiyorsa buraya işlenir.
- Yeni karar eski kararı geçersiz kılar; gereksiz/çelişen bilgi temizlenir.
- Ana gerçeklik kaynağı canlı GitHub repo + bu dosyadır.

## Proje amacı
Android öncelikli Flutter + Dart, local-first sosyal medya takip analizi uygulaması.

İlk çekirdek Instagram resmi Meta veri dışa aktarma ZIP/JSON/HTML dosyalarını cihaz üzerinde analiz eder. Sonraki aşamada snapshot/geçmiş karşılaştırması ve X resmi veri arşivi desteği genişletilir.

Temel sonuçlar:
- Ben takip ediyorum, beni takip etmiyor.
- Karşılıklı takip.
- Beni takip ediyor, ben takip etmiyorum.
- Yeni takipçiler.
- Takibi bırakanlar.
- Önceki analizlerle karşılaştırma.

## Sabit ürün ve güvenlik kararları
1. Instagram kullanıcı adı/şifre toplama, scraping, private API, otomatik follow/unfollow veya güvenlik mekanizması aşma yok.
2. Instagram ana veri kaynağı resmi Meta export arşivi.
3. X önce resmi veri arşivi importu ile yapılır; canlı API/OAuth maliyet ve politika uygunsa sonradan değerlendirilir.
4. Local-first; sosyal grafik verisi zorunlu olmadıkça cihazdan çıkmaz.
5. Analiz motoru saf Dart ve platform bağımsızdır.
6. Kimlik eşlemede platform ID varsa o, yoksa normalize kullanıcı adı kullanılır.
7. Instagram ZIP yalnız hedef ilişki dosyaları için işlenir. JSON/HTML, multipart follower ve güncel `following.json` üst seviye `title` varyasyonu desteklenir.
8. Profil fotoğrafı scraping/unofficial API ile çekilmez; deterministik monogram avatar kullanılır.
9. Tema mor ağırlığı azaltılmış slate/teal açık temadır. Dark mode şimdilik kapsam dışıdır.
10. `Nasıl yapılır?` rehberi Meta akışını, `Takipçiler ve takip edilenler`, `Her zaman` ve tercihen JSON formatını anlatır.
11. `Yok sayılan hesaplar` hesap bazında cihazda tutulur; ham snapshot sayılarını değiştirmez, yalnız analiz listelerini filtreler.
12. Sağ üst `visibility_off` simgesi gizlilik modu değildir; **Yok sayılan hesaplar** yönetimine gider.
13. Onaylanan launcher tasarımı **simge seçenek 4'ün koyu versiyonudur**. Başka kişi+büyüteç vector tasarımı kullanılmayacaktır.

## Gerçek Meta export doğrulaması
- `followers_1.json`: 569 benzersiz takipçi.
- `following.json`: 1053 benzersiz takip edilen; kullanıcı adı üst seviye `title` alanında.
- Instagram UI takip edilen sayısı 967; export ile UI arasında 86 hesap farkı var.
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

## Kritik hata geçmişi ve son düzeltmeler

### Following parser
Gerçek `following.json` içinde kullanıcı adı `string_list_data.value` yerine `title` alanında geldiği için 569/0 sonucu oluşuyordu. `title` fallback ile düzeltildi ve regression testi eklendi.

### Fiziksel cihazda boş analiz gövdesi
Samsung fiziksel cihazda kategori sayaçları görünürken açıklama, arama, özet ve kullanıcı satırları `device-test-v2-9` sürümünde boş kalıyordu.

PR #19 main'e merge edildi:
- merge SHA: `5391b0a7e956ddbfe8d3f4305875d5679cc4c984`
- `DefaultTabController` / `TabBar` kaldırıldı; basit yatay kategori şeridi kullanılıyor.
- özet + arama/sıralama lazy listenin dışına alındı.
- yalnız kullanıcı satırları `ListView.separated` içinde.
- görünür hesap sayacı eklendi.
- 360×800 gerçek ölçekli test var.

31 Ağustos gecesi CI testi, `analysis-summary` ve `analysis-controls` gibi yapısal `Column` widget'larını `hitTestable()` ile kontrol ettiği için yanlış negatif verdi. Test, bu yapısal alanların gerçek viewport koordinatlarını kontrol edecek ve etkileşimli `TextField`/kullanıcı satırlarını hit-test edecek şekilde düzeltildi.

Düzeltme main commit: `3f37927db83aa31381703dde1e0556a2058e6e6e`.

Bu yeni ekran yapısı artık CI'da başarılıdır; fiziksel Samsung cihaz doğrulaması `device-test-v2-11` ile yapılacaktır. Liste bug'ı cihazda görülmeden kapatılmış sayılmaz.

### Launcher simgesi
PR #18 yanlışlıkla seçilen koyu seçenek 4 PNG yerine teal kişi+büyüteç vector bağladı.

PR #19 ile adaptive icon tekrar seçilmiş koyu seçenek 4 PNG kaynaklarına bağlandı ve yanlış vector override'ları kaldırıldı.

Device Test #11 `Verify selected launcher source wiring` adımı başarılıdır. Doğru simgenin fiziksel cihazdaki görünümü v2-11 kurulunca doğrulanacaktır.

## Test APK imza ve güncelleme sistemi
Deterministic device-test v2:
- paket: `com.zmilastudio.takipanalizi.dev`
- sabit test keystore
- sertifika SHA-256: `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`
- versionCode = `300000 + GITHUB_RUN_NUMBER`
- AAPT paket/versionCode ve apksigner sertifika kontrolü

Telefondaki v2-9 temiz kurulmuş tabandır. v2-11 aynı paket + aynı sertifika + daha yüksek VersionCode ile üretilmiştir; **v2-9 kaldırılmadan Android'in `Güncelle` akışıyla kurulması beklenir**.

## GitHub / CI
Repo: `ZMilaStudio/sosyal-medya-takip-analizi` — public.

Branchler:
- `main`
- `test/device-apk`
- `backup/device-test-v2-9`

Normal CI artifact upload yapmaz. Device-test APK GitHub prerelease asset olarak yayınlanır.

### 31 Ağustos ödeme / Actions olayı — çözüldü
Gün içinde GitHub-hosted runnerlar hesap seviyesinde başlamayı durdurdu. Sosyal Medya Takip Analizi ve public BilgiRotasi repo joblarında ortak belirti `runner_id=0`, `steps=[]` idi.

Payment History ekranında:
- Visa sonu 5466 ile `$1.00` işlem: **Declined**
- MasterCard sonu 3349 ile `$1.00` işlem: **Success**

Başarılı tahsilattan sonra Runner Diagnostic `33423749289` yeniden çalıştırıldı ve sonraki denemede runner tahsis edildi; `Set up job`, runner allocation ve complete job başarılı oldu. Böylece hesap tarafındaki Actions restriction'ın kalktığı doğrulandı.

Device Test #10 yeniden çalıştırıldığında runner normal başladı ancak `flutter analyze`, `separatorBuilder: (_, __)` satırındaki `unnecessary_underscores` lint'inde durdu. Kaynak kod `separatorBuilder: (_, _)` olarak düzeltildi.
- test branch lint fix commit: `2afaaeb546955b3069776801f2c3d7bfbf1556fe`
- main lint fix commit: `6bff6e2da64e9f0404af19d7cf5f2438d9c1e482`

Ardından App CI gerçek viewport testindeki yanlış `Column.hitTestable()` varsayımını ortaya çıkardı; test viewport koordinatlarıyla düzeltildi.

Device-test workflow path filtresi de düzeltildi. Artık `test/device-apk` branch'inde `apps/mobile/**` veya `packages/follow_core/**` değişiklikleri yeni Device Test APK run'ını tetikler.

## Device Test v2-11 — TAM BAŞARILI
Run: `33427679646`
Run number: `11`
Branch commit: `7c00ae938a57efd7963b14a0f3e57fed0eaa6328`

Başarılı aşamalar:
- Resolve dependencies ✅
- Analyze ✅
- Test — 11 test ✅
- seçilen koyu launcher kaynak bağlantısı ✅
- deterministic test signing key ✅
- signed debug APK build ✅
- package + VersionCode + signing certificate verification ✅
- test package hazırlama ✅
- prerelease publish ✅

Yeni prerelease:
- tag: `device-test-v2-11`
- VersionCode: `300011`
- APK: `takip-analizi-device-test.apk`
- APK boyutu: `180651219` byte (~172.3 MiB)
- APK SHA-256: `abb26210bc1d19270e1c92b3533d49e38e1b0a9ea38eb4a479b555cc19bc18e8`
- signing cert SHA-256: `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`
- prerelease published: 31 Ağustos 2026 19:00:32 UTC

## Doğrulanmış son durum
- PR #14 Meta following parser ✅
- PR #15 tema + yok sayılanlar + seçilen koyu simge ✅
- PR #16 render denemesi; v2-9 cihazda liste boş ❌
- PR #17 deterministic v2 signing ✅
- PR #18 tek ListView yaklaşımı; v2-9 cihazda liste boş ❌
- PR #18 yanlış launcher vector regresyonu ❌
- PR #19 yeni sabit gövde + ayrı kullanıcı listesi ✅
- PR #19 koyu seçenek 4 launcher wiring ✅
- GitHub payment/runner restriction ✅ çözüldü
- Device Test v2-11 ✅ tam başarılı ve APK yayınlandı
- fiziksel cihaz v2-11 testi ⏳

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
- [x] PR #19 liste mimarisi revizyonu
- [x] koyu seçenek 4 simgesini kodda geri yükleme
- [x] Device Test v2-11 CI doğrulaması
- [ ] v2-11'i v2-9 üzerine kaldırmadan `Güncelle` olarak kurmayı doğrulama
- [ ] PR #19 listesini fiziksel Android cihazda doğrulama
- [ ] doğru launcher simgesini fiziksel cihazda doğrulama
- [ ] iki keyfi snapshot'ı elle seçerek karşılaştırma

### X
- [ ] gerçek resmi X arşiv fixture doğrulaması
- [ ] X ZIP/JSON importer
- [ ] X snapshot/geçmiş
- [ ] canlı API maliyet modeli
- [ ] gerekirse OAuth 2.0 PKCE

## Sıradaki iş
1. `device-test-v2-11` APK'yı indir.
2. Telefonda mevcut v2-9 uygulamasını **kaldırmadan** APK'yı aç; Android'in `Güncelle` seçeneği gelmeli.
3. Kurulumdan sonra üç şeyi doğrula:
   - analiz listeleri artık görünüyor mu,
   - onaylanan koyu seçenek 4 launcher simgesi görünüyor mu,
   - uygulama kaldırılmadan güncellendi mi.
4. Sonuca göre fiziksel cihaz bug'ını kapat veya bir sonraki teşhis build'ine geç.
