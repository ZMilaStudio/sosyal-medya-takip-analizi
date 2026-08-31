# PROJE_OZETI

Son güncelleme: 31 Ağustos 2026

## Çalışma protokolü

- Her yeni sohbetin başlangıcında bu `PROJE_OZETI.md` okunarak proje buradan devralınır.
- Her kullanıcı mesajından sonra yeni kararlar, tamamlanan işler, açık sorunlar ve güncel durum gerekiyorsa bu dosyaya işlenir.
- Yeni karar eski kararı geçersiz kılar; güncelliğini yitiren veya çelişen bilgi temizlenir.
- Ana gerçeklik kaynağı canlı GitHub repo + bu özet dosyasıdır.

## Proje amacı

Android öncelikli Flutter + Dart, local-first sosyal medya takip analizi uygulaması. İlk çekirdek Instagram'ın resmi Meta veri dışa aktarma ZIP/JSON/HTML dosyalarını cihaz üzerinde analiz eder. Sonraki aşamada snapshot/geçmiş karşılaştırması ve X resmi veri arşivi desteği genişletilir.

Temel sonuçlar:
- Ben takip ediyorum, beni takip etmiyor.
- Karşılıklı takip.
- Beni takip ediyor, ben takip etmiyorum.
- Yeni takipçiler.
- Takibi bırakanlar.
- Önceki analizlerle karşılaştırma.

## Sabit ürün ve güvenlik kararları

1. Instagram kullanıcı adı/şifre toplama, scraping, private API, otomatik follow/unfollow veya güvenlik mekanizması aşma kullanılmaz.
2. Instagram ana veri kaynağı resmi Meta veri dışa aktarma arşividir.
3. X önce resmi veri arşivi importu ile yapılır; canlı API/OAuth maliyet ve politika uygun olursa değerlendirilir.
4. Uygulama local-first'tür; sosyal grafik verisi zorunlu olmadıkça cihazdan çıkmaz.
5. Analiz motoru platform bağımsız saf Dart çekirdeğidir.
6. Kimlik eşlemede platform kullanıcı ID'si varsa o, yoksa normalize kullanıcı adı kullanılır.
7. Instagram ZIP bellekte işlenir; yalnız hedef ilişki dosyaları okunur. JSON/HTML export, multipart follower dosyaları ve güncel `following.json` üst seviye `title` varyasyonu desteklenir.
8. Profil fotoğrafı scraping/unofficial API ile çekilmez; deterministik monogram avatar kullanılır.
9. Tema mor ağırlığı azaltılmış slate/teal açık temadır. Dark mode şimdilik kapsam dışıdır.
10. `Nasıl yapılır?` rehberi Meta akışını, `Takipçiler ve takip edilenler`, `Her zaman` ve tercihen JSON formatını anlatır.
11. `Yok sayılan hesaplar` hesap bazında cihazda saklanır; ham snapshot sayılarını değiştirmez, yalnız analiz listelerini filtreler.
12. Sağ üst `visibility_off` simgesi gizlilik/göster-gizle değildir; **Yok sayılan hesaplar** yönetim ekranını açar.
13. Kullanıcının onayladığı launcher tasarımı **simge seçenek 4'ün koyu versiyonudur**. Başka kişi+büyüteç vector tasarımı kullanılmayacaktır.

## Gerçek Meta export doğrulaması

Gerçek `Her zaman` Instagram arşivinde:
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
- Drift/SQLite yerel geçmiş
- merkezi `AppTheme`
- Instagram import
- analiz ekranı
- arama + A-Z/Z-A sıralama
- Instagram profilini dış uygulamada açma
- monogram avatarlar
- yok say / geri al / yönetim ekranı
- analiz geçmişi
- Instagram export rehberi
- X için pasif `Yakında`

`packages/follow_core`:
- `SocialPlatform`, `SocialAccount`, `SocialUser`
- `FollowSnapshot`, `FollowAnalysis`, `FollowAnalysisEngine`
- Instagram JSON/HTML parser
- güvenli ZIP importer
- import -> snapshot -> analiz use-case
- unit/regression testleri

## Yerel geçmiş

- `StoredAccounts`: sosyal hesabı saklar.
- `StoredSocialUsers`: `identityKey` ile deduplicate eder.
- `StoredSnapshots`: analiz zamanı, hesap, kaynak formatı.
- `StoredSnapshotRelations`: follower/following bitmask ilişkileri.
- Snapshot saatleri UTC normalize edilir.
- Varsayılan retention hesap başına son 30 snapshot.
- Eski snapshot açıldığında önceki snapshot bulunup değişim analizi yeniden hesaplanır.

## Kritik hata geçmişi ve güncel düzeltme

### Following parser
Gerçek `following.json` içinde kullanıcı adı `string_list_data.value` yerine `title` alanında geldiği için 569/0 sonucu oluşuyordu. `title` fallback ile düzeltildi ve regression testi eklendi.

### Fiziksel cihazda boş analiz gövdesi
Samsung fiziksel cihazda kategori sekmeleri ve sayaçlar doğru görünürken açıklama, arama, özet ve kullanıcı satırları görünmüyordu.

PR #18'de tüm gövde tek `ListView.builder` içine alınmıştı; widget testi başarılı olmasına rağmen `device-test-v2-9` fiziksel cihazda gövde yine tamamen boş kaldı.

PR #19 ile daha köklü ayrıştırma yapıldı ve main'e squash merge edildi:
- PR: #19 `fix: fiziksel cihaz liste gövdesi ve seçilen launcher simgesi`
- merge SHA: `5391b0a7e956ddbfe8d3f4305875d5679cc4c984`
- `DefaultTabController` / `TabBar` kaldırıldı; basit yatay kategori şeridi kullanılıyor.
- Özet kartları ve arama/sıralama kontrolleri lazy kullanıcı listesinin dışına alındı.
- Yalnız kullanıcı satırları `ListView.separated` içinde.
- `analysis-content`, `analysis-summary`, `analysis-controls`, `analysis-search`, `analysis-scroll` test anahtarları var.
- Görünür hesap sayacı (`792 hesap` vb.) eklendi.
- 360×800 gerçek ölçekli test, üst gövdenin lazy listenin dışında olduğunu ve ilk kullanıcı satırının görünür/hit-testable olduğunu doğrulayacak şekilde güncellendi.

Bu yapı fiziksel cihazda henüz doğrulanmadı; yeni APK üretilemediği için liste bug'ı kapatılmış sayılmaz.

### Launcher simgesi
PR #18, seçilen koyu seçenek 4 PNG yerine teal kişi + büyüteç vector bağlayarak regresyon oluşturdu.

PR #19 ile:
- `mipmap-anydpi-v26/ic_launcher.xml` tekrar `@mipmap/ic_launcher_foreground` PNG'ye bağlandı.
- yanlış `drawable/ic_launcher_foreground.xml` silindi.
- yanlış `mipmap-anydpi` vector override'ları silindi.
- manifestte gereksiz `roundIcon` kaldırıldı.
- PR #15'ten kalan seçilmiş koyu launcher PNG kaynakları tekrar esas alındı.

Doğru simge kodda geri yüklenmiş durumda; fiziksel cihaz doğrulaması yeni APK bekliyor.

## Test APK imza ve güncelleme sistemi

Deterministic device-test v2:
- paket: `com.zmilastudio.takipanalizi.dev`
- production paketinden ayrı
- sabit test keystore
- sertifika SHA-256: `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`
- versionCode = `300000 + GITHUB_RUN_NUMBER`
- AAPT ile paket/versionCode, apksigner ile sertifika doğrulanır.
- test anahtarı production için kullanılmaz.

Mevcut telefondaki v2-9 temiz kurulmuş tabandır. Sonraki v2 APK aynı paket + sertifika + daha yüksek versionCode ile kaldırmadan güncellenebilmelidir; bu davranış henüz fiziksel olarak doğrulanmadı.

## GitHub / CI

Repo: `ZMilaStudio/sosyal-medya-takip-analizi` — **public** (`private=false`, `visibility=public`).

Branch düzeni:
- `main`: stabil
- `feat/<konu>` / `fix/<konu>`: PR geliştirme
- `test/device-apk`: güncel main + device-test dağıtım dosyaları
- `backup/device-test-v2-9`: run #9 dönemindeki eski test branch yedeği

Normal CI:
- Core CI: `dart analyze` + `dart test`
- App CI: Flutter 3.47.2 `pub get` + `analyze` + `test`
- normal CI artifact upload yapmaz
- docs-only değişiklikler workflow tetiklemez

### Güncel GitHub Actions engeli
PR #19 App CI run #35 (`33423035250`) iki denemede de yaklaşık 2-3 saniyede başarısız oldu:
- runner hiç atanmadı (`runner_id=0`)
- `steps=[]`
- hiçbir Flutter/analyze/test adımı başlamadı
- log blob oluşmadı

PR #19 diff'i elle incelendi, PR mergeable durumdaydı ve #19 main'e merge edildi.

Device-test tarafında:
- eski `test/device-apk` önce `backup/device-test-v2-9` olarak yedeklendi.
- `test/device-apk` main `5391b0a7...` üzerine senkronlandı.
- deterministic keystore ve güncel `device-test-apk.yml` yeniden eklendi.
- Device Test run #10 (`33423413075`) oluştu.
- run #10 da 2-3 saniyede, `steps=[]` ve runner başlamadan başarısız oldu.
- `device-test-v2-10` prerelease/APK **üretilmedi**; 300010 yalnız beklenen versionCode idi.

Ek teşhis için `runner-diagnostic.yml` oluşturuldu ve public repo standard runner seçeneklerinden `ubuntu-slim` ile yalnız `echo + uname` yapan minimal job çalıştırılmaya çalışıldı:
- Runner Diagnostic run #1: `33423749289`
- job: `99592185293`
- sonuç: 4 saniyede failure, `steps=[]`, `runner_id=0`, runner adı boş; log blob oluşmadı.

Aynı repo Device Test run #9 aynı gün 14:51–14:57 UTC arasında başarıyla tamamlanmıştı. Aynı kullanıcı hesabındaki diğer public repo `ZMilaStudio/BilgiRotasi` da 14:47–14:58 UTC arasında standard GitHub-hosted runner ile başarılı workflow çalıştırdı. Sorun gün içinde daha sonra başlamış görünüyor.

### 31 Ağustos 2026 Actions araştırma sonucu

Resmi GitHub dokümantasyonuna göre:
- public repolarda **standard GitHub-hosted runners ücretsiz ve sınırsızdır**; private repo aylık dakika kotası bu public repo için uygulanmaz.
- artifact/storage kotası Actions dakikasından ayrı bir limit türüdür; minimal `echo` job'ın runner başlamadan ölmesini açıklamaz.
- normal Free plan standard hosted runner concurrency limiti 20'dir; concurrency dolduğunda işin beklemesi/queue davranışı beklenir, 4 saniyede `runner_id=0`, `steps=[]` ile bitmesi bu modele uymuyor.

GitHub Status 31 Ağustos'ta Actions'ı genel olarak operational gösteriyor. Ancak çok yakın geçmişte:
- 24 Ağustos'ta runner-assignment bileşeni arızası nedeniyle bazı Actions runları başlayamadı,
- 26 Ağustos'ta Actions jobları doğrudan başlayamadı,
- 26–27 Ağustos'ta Actions/PR gecikmeleri yaşandı,
- 27 Ağustos'ta ayrıca ayrı bir **GitHub Billing disruption** olayı kaydedildi.

GitHub Community'de 2026 içinde bizim parmak izimizle çok yakın raporlar var: GitHub-hosted job runner atanmadan, sıfır step ile düşüyor; bazı vakalarda UI `recent account payments have failed or your spending limit needs to be increased` mesajını gösteriyor. Bunun public repolarda da görüldüğü rapor edilmiş. Başka raporlarda billing ekranı sağlıklı görünmesine rağmen backend hosted-runner entitlement kilidi/desync ancak GitHub Support müdahalesiyle çözülebiliyor.

Bu nedenle olasılık sırası:
1. **En güçlü:** GitHub hesap tarafında hosted-runner entitlement/billing/budget kilidi veya backend senkronizasyon hatası.
2. **İkinci:** GitHub'ın yakın tarihli Actions/Billing incident'larından kalan hesap/runner-routing kaynaklı servis tarafı problem.
3. **Daha düşük:** hesap düzeyinde Actions/anti-abuse kısıtı.

Aşağıdakiler mevcut kanıtla elenmiş veya çok zayıf:
- repo private / aylık dakika kotası,
- Flutter/Android kod hatası,
- ağır workflow,
- `ubuntu-latest` imajına özgü hata,
- artifact upload/storage kotasının job başlatmayı kesmesi,
- normal concurrency limiti.

Kesin ayrım için GitHub UI'daki başarısız job banner/annotation metni görülmeli. API job kaydı bu üst seviye billing/entitlement açıklamasını vermiyor; yalnız pre-run failure parmak izini gösteriyor. Eğer UI payment/spending-limit mesajı gösteriyorsa sorun doğrudan account entitlement/billing kilididir. UI böyle bir mesaj göstermiyor ve Billing/Budgets normal ise üç run ID ile GitHub Support'a account-side hosted-runner entitlement/routing kontrolü istenmelidir.

## Doğrulanmış son durum

- Core/uygulama çekirdek geliştirmeleri önceki runlarda ✅
- PR #14 Meta following parser ✅
- PR #15 tema + yok sayılanlar + seçilen koyu simge ✅
- PR #16 render denemesi; cihazda liste yine boş ❌
- PR #17 deterministic v2 signing ✅
- PR #18 tek ListView yaklaşımı; cihazda liste yine boş ❌
- PR #18 yanlış launcher vector regresyonu ❌
- PR #19 yeni sabit gövde + ayrı kullanıcı listesi ✅ kodda main'e merge
- PR #19 seçilen koyu seçenek 4 launcher wiring geri yüklendi ✅ kodda
- PR #19 sonrası fiziksel cihaz testi ⏳ yeni APK yok
- Device Test run #9 başarılı; mevcut son indirilebilir APK `device-test-v2-9`
- Device Test run #10 ❌ runner başlamadan kesildi, APK üretmedi
- `ubuntu-slim` minimal diagnostic ❌ runner başlamadan kesildi
- mevcut APK v2-9 VersionCode `300009`
- mevcut APK SHA-256 `5b1462ec41ac150f8965c3eefc6115613d25734e1d7c3b5e873f99c3c4ddd6f8`

## MVP durumu

### Instagram MVP
- [x] Analiz modeli/motoru
- [x] JSON/HTML parser
- [x] güvenli ZIP importer
- [x] güncel `following.json title` desteği
- [x] gerçek Meta export doğrulaması
- [x] Flutter import akışı
- [x] sonuç kategorileri
- [x] arama / sıralama
- [x] Instagram profilini açma
- [x] snapshot/geçmiş
- [x] yeni takipçiler / takibi bırakanlar
- [x] yok sayılan hesaplar
- [x] veri indirme rehberi
- [x] sade tema + monogramlar
- [x] deterministic v2 test signing
- [x] PR #19 kod düzeyinde liste mimarisi revizyonu
- [x] seçilen koyu seçenek 4 simgesini kodda geri yükleme
- [ ] PR #19 listesini fiziksel Android cihazda doğrulama
- [ ] doğru launcher simgesini fiziksel cihazda doğrulama
- [ ] yeni v2 APK'yı kaldırmadan `Güncelle` olarak kurmayı doğrulama
- [ ] iki keyfi snapshot'ı elle seçerek karşılaştırma

### X
- [ ] gerçek resmi X arşiv fixture doğrulaması
- [ ] X ZIP/JSON importer
- [ ] X snapshot/geçmiş
- [ ] canlı API maliyet modeli
- [ ] gerekirse OAuth 2.0 PKCE

## Sıradaki işler / açık riskler

1. Başarısız GitHub Actions job ekranında üstteki banner/annotation metni kontrol edilecek. Özellikle payment/spending-limit/account locked mesajı aranacak.
2. GitHub `Settings -> Billing & licensing -> Budgets and alerts` ve ödeme durumunda Actions için hard stop/uyarı olup olmadığı kontrol edilecek; public repo için ücret ödemek gerekmemeli, amaç yanlış account entitlement kilidini tespit etmektir.
3. UI billing mesajı yok ve ayarlar normalse GitHub Support'a şu üç run ID ile başvurulacak: App CI `33423035250`, Device Test `33423413075`, Runner Diagnostic `33423749289`; `runner_id=0`, `steps=[]`, no log blob ve public standard runner bilgisi özellikle verilecek.
4. Runner tekrar çalışır çalışmaz device-test build yeniden üretilecek ve prerelease yayınlanacak.
5. Yeni APK telefondaki v2-9 kaldırılmadan kurulacak; `Güncelle` davranışı, liste görünürlüğü ve koyu seçenek 4 simgesi aynı turda doğrulanacak.
6. Liste hâlâ boşsa cihaz üstünde görünür marker/logcat ile render constraint'i doğrudan izole edilecek.
7. Production signing ve Play Store release düzeni daha sonra kurulacak.
8. 128 MiB bellek içi ZIP limiti bazı arşivlerde yetersiz olabilir; gerekirse streaming/target-entry yaklaşımı genişletilecek.
9. Username-only identity kullanıcı adı değişiminde yanlış `unfollow + new` sonucu üretebilir.