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

## Kritik hata geçmişi

### Following parser
Gerçek `following.json` içinde kullanıcı adı `string_list_data.value` yerine `title` alanında geldiği için 569/0 sonucu oluşuyordu. `title` fallback ile düzeltildi ve regression testi eklendi.

### Fiziksel cihazda boş analiz gövdesi
Samsung fiziksel cihazda kategori sekmeleri ve sayaçlar doğru görünürken açıklama, arama, özet ve kullanıcı satırları görünmüyordu.

PR #18'de tüm gövde tek `ListView.builder` içine alındı ancak `device-test-v2-9` fiziksel cihazda yine boş kaldı.

PR #19 main'e merge edildi:
- PR: #19 `fix: fiziksel cihaz liste gövdesi ve seçilen launcher simgesi`
- merge SHA: `5391b0a7e956ddbfe8d3f4305875d5679cc4c984`
- `DefaultTabController` / `TabBar` kaldırıldı; basit yatay kategori şeridi kullanılıyor.
- özet + arama/sıralama lazy listenin dışına alındı.
- yalnız kullanıcı satırları `ListView.separated` içinde.
- görünür hesap sayacı eklendi.
- 360×800 widget testi yeni yapıyı doğrulayacak şekilde güncellendi.

Bu yapı fiziksel cihazda henüz doğrulanmadı; yeni APK üretilemediği için liste bug'ı kapatılmış sayılmaz.

### Launcher simgesi
PR #18 yanlışlıkla seçilen koyu seçenek 4 PNG yerine teal kişi+büyüteç vector bağladı.

PR #19 ile:
- adaptive icon tekrar `@mipmap/ic_launcher_foreground` PNG'ye bağlandı.
- yanlış vector override'ları silindi.
- manifestte gereksiz `roundIcon` kaldırıldı.
- PR #15'ten kalan seçilmiş koyu launcher PNG kaynakları tekrar esas alındı.

Doğru simge kodda geri yüklendi; fiziksel cihaz doğrulaması yeni APK bekliyor.

## Test APK imza ve güncelleme sistemi
Deterministic device-test v2:
- paket: `com.zmilastudio.takipanalizi.dev`
- production paketinden ayrı
- sabit test keystore
- sertifika SHA-256: `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`
- versionCode = `300000 + GITHUB_RUN_NUMBER`
- AAPT ile paket/versionCode, apksigner ile sertifika doğrulanır
- test anahtarı production için kullanılmaz

Telefondaki v2-9 temiz kurulmuş tabandır. Sonraki v2 APK aynı paket + sertifika + daha yüksek versionCode ile kaldırmadan güncellenebilmelidir; fiziksel doğrulama bekliyor.

## GitHub / CI
Repo: `ZMilaStudio/sosyal-medya-takip-analizi` — **public** (`private=false`, `visibility=public`).

Branch düzeni:
- `main`: stabil
- `feat/<konu>` / `fix/<konu>`: PR geliştirme
- `test/device-apk`: güncel main + device-test dağıtım
- `backup/device-test-v2-9`: run #9 dönemi yedeği

Normal CI:
- Core CI: `dart analyze` + `dart test`
- App CI: Flutter 3.47.2 `pub get` + `analyze` + `test`
- normal CI artifact upload yapmaz
- docs-only workflow tetiklemez

## Güncel GitHub Actions engeli — kesinleşen teşhis

### Sosyal Medya Takip Analizi repo kanıtı
PR #19 App CI run #35 (`33423035250`) iki denemede de yaklaşık 2-3 saniyede öldü:
- `runner_id=0`
- `steps=[]`
- hiçbir Flutter/analyze/test adımı başlamadı
- log blob oluşmadı

Device Test run #10 (`33423413075`) aynı şekilde runner başlamadan öldü ve APK üretmedi.

Minimal `ubuntu-slim` Runner Diagnostic run #1 (`33423749289`), job `99592185293`:
- yalnız basit `echo + uname`
- 4 saniyede failure
- `runner_id=0`
- `steps=[]`
- runner adı boş
- log blob yok

### İkinci public repo ile çapraz doğrulama
Aynı hesaptaki public `ZMilaStudio/BilgiRotasi` reposunda daha önce aynı gün 14:47–14:58 UTC aralığında Actions başarıyla çalıştı.

Ancak 18:35 UTC'deki BilgiRotasi run `33425862577` de aynı parmak iziyle düştü:
- repo public
- runner label: `ubuntu-22.04`
- job `99599133885`
- `runner_id=0`
- `steps=[]`
- 2 saniyede failure

Bu çapraz test çok önemli: sorun artık **sosyal-medya-takip-analizi repo/YAML/koduna özgü değildir**. Aynı hesaptaki başka bir public repoda da aynı anda GitHub-hosted runner tahsisi yapılamıyor.

### Sonuç
Mevcut kanıtla sorun en güçlü şekilde **hesap düzeyinde GitHub-hosted runner entitlement / billing-backend / account-side Actions provisioning kilidi** olarak sınıflandırılıyor.

Aşağıdakiler elenmiş veya çok zayıf:
- repo private / aylık private Actions dakika kotası
- Flutter/Android kod hatası
- bu repo workflow YAML'ı
- `ubuntu-latest` imajına özgü hata
- ağır workflow
- artifact upload/storage kotasının runner başlatmayı kesmesi
- tek repo ayarı

Public repolarda standard GitHub-hosted runners normalde ücretsiz ve sınırsızdır. Sorunun aynı hesaptaki ikinci public repoda da ortaya çıkması, repo bazlı açıklamaları fiilen eler.

GitHub connector/API, kullanıcı hesabının **Billing & licensing / Budgets / payment banner** ekranını göstermiyor. Bu üst seviye account entitlement mesajı API job kaydında da yer almıyor; yalnız `runner_id=0`, `steps=[]`, no-log pre-run failure görülüyor.

## Doğrulanmış son durum
- PR #14 Meta following parser ✅
- PR #15 tema + yok sayılanlar + seçilen koyu simge ✅
- PR #16 render denemesi; cihazda liste yine boş ❌
- PR #17 deterministic v2 signing ✅
- PR #18 tek ListView yaklaşımı; cihazda liste yine boş ❌
- PR #18 yanlış launcher vector regresyonu ❌
- PR #19 yeni sabit gövde + ayrı kullanıcı listesi ✅ main'e merge
- PR #19 seçilen koyu seçenek 4 launcher wiring ✅ kodda
- PR #19 sonrası fiziksel cihaz testi ⏳ yeni APK yok
- Device Test run #9 başarılı; son indirilebilir APK `device-test-v2-9`
- Device Test run #10 ❌ runner başlamadan kesildi
- minimal `ubuntu-slim` diagnostic ❌ runner başlamadan kesildi
- BilgiRotasi public cross-check run `33425862577` ❌ aynı `runner_id=0`, `steps=[]`
- mevcut APK VersionCode `300009`
- mevcut APK SHA-256 `5b1462ec41ac150f8965c3eefc6115613d25734e1d7c3b5e873f99c3c4ddd6f8`

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
- [ ] PR #19 listesini fiziksel Android cihazda doğrulama
- [ ] doğru launcher simgesini cihazda doğrulama
- [ ] yeni v2 APK'yı kaldırmadan `Güncelle` olarak kurmayı doğrulama
- [ ] iki keyfi snapshot'ı elle seçerek karşılaştırma

### X
- [ ] gerçek resmi X arşiv fixture doğrulaması
- [ ] X ZIP/JSON importer
- [ ] X snapshot/geçmiş
- [ ] canlı API maliyet modeli
- [ ] gerekirse OAuth 2.0 PKCE

## Sıradaki işler
1. GitHub hesabında `Settings -> Billing & licensing -> Budgets and alerts` / ödeme durumu / Actions hard-stop veya account warning kontrolü yapılacak. Public repo için ücret gerekmemeli; amaç yanlış entitlement kilidini tespit etmek.
2. UI'da billing/payment mesajı yoksa GitHub Support'a şu kanıtlarla account-side hosted-runner entitlement/provisioning kontrolü istenecek:
   - App CI `33423035250`
   - Device Test `33423413075`
   - Runner Diagnostic `33423749289`
   - BilgiRotasi public cross-check `33425862577`
   - ortak parmak izi: `runner_id=0`, `steps=[]`, no log blob
3. Runner geri gelir gelmez device-test build yeniden üretilecek ve prerelease yayınlanacak.
4. Yeni APK v2-9 kaldırılmadan kurulacak; `Güncelle`, liste ve koyu seçenek 4 simgesi aynı turda doğrulanacak.
5. Liste hâlâ boşsa cihaz üstünde görünür marker/logcat ile render constraint doğrudan izole edilecek.
6. Production signing ve Play Store release düzeni daha sonra kurulacak.
