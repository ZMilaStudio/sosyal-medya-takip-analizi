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
- merge SHA: `5391b0a7e956ddbfe8d3f4305875d5679cc4c984`
- `DefaultTabController` / `TabBar` kaldırıldı; basit yatay kategori şeridi kullanılıyor.
- özet + arama/sıralama lazy listenin dışına alındı.
- yalnız kullanıcı satırları `ListView.separated` içinde.
- görünür hesap sayacı eklendi.
- 360×800 widget testi yeni yapıyı doğrulayacak şekilde güncellendi.

Bu yapı fiziksel cihazda henüz doğrulanmadı; yeni APK üretilemediği için liste bug'ı kapatılmış sayılmaz.

### Launcher simgesi
PR #18 yanlışlıkla seçilen koyu seçenek 4 PNG yerine teal kişi+büyüteç vector bağladı.

PR #19 ile adaptive icon tekrar seçilmiş koyu seçenek 4 PNG kaynaklarına bağlandı ve yanlış vector override'ları kaldırıldı. Doğru simge kodda geri yüklendi; fiziksel cihaz doğrulaması yeni APK bekliyor.

## Test APK imza ve güncelleme sistemi
Deterministic device-test v2:
- paket: `com.zmilastudio.takipanalizi.dev`
- sabit test keystore
- sertifika SHA-256: `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`
- versionCode = `300000 + GITHUB_RUN_NUMBER`
- AAPT paket/versionCode ve apksigner sertifika kontrolü

Telefondaki v2-9 temiz kurulmuş tabandır. Sonraki v2 APK aynı paket + sertifika + daha yüksek versionCode ile kaldırmadan güncellenebilmelidir; fiziksel doğrulama bekliyor.

## GitHub / CI
Repo: `ZMilaStudio/sosyal-medya-takip-analizi` — **public** (`private=false`, `visibility=public`).

Branchler:
- `main`
- `test/device-apk`
- `backup/device-test-v2-9`

### Runner engeli kanıtları
Aşağıdaki runlar runner tahsis edilmeden öldü:
- App CI `33423035250`
- Device Test `33423413075`
- Runner Diagnostic `33423749289`
- BilgiRotasi public cross-check `33425862577`

Ortak parmak izi:
- `runner_id=0`
- `steps=[]`
- runner adı boş
- log blob yok
- birkaç saniyede failure

Aynı gün daha erken `Device Test #9` ve public `BilgiRotasi` workflow'ları başarıyla çalışmıştı. Sorun gün içinde sonradan hesap seviyesinde başlamış görünüyor.

### 31 Ağustos 2026 Billing / ödeme teşhisi
Kullanıcının GitHub `Billing & licensing -> Budgets` ekranında Actions için `$3.68 spent / $4.00 budget`, `%91` ve `Stop usage: Yes` görülüyor. Ancak bu bütçe tek başına sorunun sebebi değildir.

Kullanıcı GitHub'ın **ödemeyi alamadığına dair e-posta gönderdiğini** doğruladı. Bu, runner engeli için bütçe tahmininden daha güçlü ve doğrudan kanıttır.

Güncel teşhis:
- Repo public olduğu için standard GitHub-hosted runner kullanımı normalde ücretli dakika kotasına bağlı olmamalıdır.
- Buna rağmen hesapta başarısız ödeme / ödeme problemi oluşması GitHub'ın hesap düzeyinde Actions hosted-runner erişimini/entitlement'ını geçici olarak kilitlemiş görünüyor.
- Aynı hesaptaki ikinci public repo BilgiRotasi'nın da aynı anda `runner_id=0`, `steps=[]` ile düşmesi bunu repo/YAML/kod sorunundan çıkarıp hesap seviyesine taşır.

Dolayısıyla önceki “4 dolar Actions budget hard-stop ana sebep” değerlendirmesi geçersizdir. Ana sebep olarak **başarısız GitHub ödemesi ve bunun doğurduğu account-side Actions restriction** esas alınacaktır.

### Ödeme sonrası / yeniden deneme kontrolü
Kullanıcının “Şimdi dene” talebi üzerine minimal Runner Diagnostic run `33423749289` yeniden çalıştırıldı (attempt 2).

Attempt 2 sonucu:
- yeni job: `99601335766`
- zaman: 18:42:44–18:42:47 UTC
- sonuç: `failure`
- `runner_id=0`
- `steps=[]`
- runner adı boş

Yani yeniden deneme anında GitHub Actions hosted-runner erişimi **henüz açılmamıştı**. Bu; ödeme düzeltmesi yapıldıysa entitlement değişikliğinin henüz yayılmadığını, ödeme henüz kesinleşmediyse account-side kısıtın devam ettiğini gösterir. Bu aşamada device APK build'i tekrar tetiklenmedi; gereksiz Actions denemesi yapılmadı.

### Ödenmemiş tutarı doğrulama yolu
GitHub resmi billing akışında ödeme durumunu kontrol etmek için `Settings -> Billing & Licensing -> Payment history` ekranı kullanılacak. Burada son ödeme tarihi, tutarı ve ödeme yöntemi görülür; varsa başarısız/past due işlem veya ilgili döneme ait başarılı tahsilatın bulunmaması kontrol edilir. Kart/ödeme yöntemi için `Payment information` / `Update payment method` bölümü kullanılacak. GitHub'ın resmi belgelerine göre ödeme geçmişi bu ekrandan görüntülenebilir ve reddedilen ödeme nedeniyle kilitlenen ücretli özellikler ödeme yöntemi güncellendiğinde yeniden yetkilendirme tahsilatıyla açılır.

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
- son indirilebilir APK `device-test-v2-9`, VersionCode `300009`
- Runner Diagnostic attempt 2 ❌ yine runner tahsis edilmeden düştü

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
1. `Settings -> Billing & Licensing -> Payment history` ekranında son tahsilatı kontrol et; başarısız/past due işlem veya eksik başarılı ödeme var mı bak.
2. Gerekirse `Payment information` / `Update payment method` ile ödeme yöntemini düzelt.
3. Ödeme başarılı/tamamlandıktan sonra minimal Runner Diagnostic'i tekrar çalıştır.
4. Runner açılırsa yeni device-test APK üret ve prerelease yayınla.
5. APK'yı v2-9 üzerine kaldırmadan `Güncelle`; liste + doğru simge + update davranışını birlikte doğrula.
6. Ödeme başarılı göründüğü halde runner birkaç denemede hâlâ açılmazsa GitHub Support'a dört run ID ve `runner_id=0 / steps=[]` kanıtıyla başvur.
