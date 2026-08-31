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

### 31 Ağustos 2026 Billing ekranı — yeni kesin kanıt
Kullanıcının GitHub `Billing & licensing -> Budgets` ekran görüntüsünde:
- Account: `ZMilaStudio`
- Product: **Actions**
- **$3.68 spent / $4.00 budget**
- kullanım göstergesi **%91**
- **Stop usage: Yes**
- Codespaces: `$1.13 / $3.00`, Stop usage Yes
- Packages kartı `%100` gösteriyor; tutar ekran görüntüsünün altında kaldığı için not edilmedi.

Bu ekran, hesapta Actions için aktif bir **hard-stop budget** olduğunu doğruluyor. GitHub dokümantasyonuna göre standard GitHub-hosted runner kullanımı public repolarda ücretsizdir; dolayısıyla public repodaki minimal job'ın runner tahsis edilmeden ölmesi normal public Actions dakika kotası değildir.

Bununla birlikte `Stop usage: Yes` açık Actions bütçesinin $4 limite çok yaklaşmış olması, GitHub'ın account-side billing/entitlement gate'inin devreye girmesi için şu an en güçlü somut tetikleyicidir. UI $3.68 gösterse de billing verisi gecikmeli/pending olabilir veya hard-stop entitlement durumu public standard runnerlara hatalı biçimde uygulanıyor olabilir.

### Şu anki teşhis
En güçlü olasılık: **Actions budget hard-stop / billing entitlement kilidi**.

Hızlı doğrulama yöntemi:
1. Actions bütçesinde `Stop usage` geçici olarak **No** yapılacak veya bütçe $4'ten örneğin **$10**'a çıkarılacak.
2. Değişikliğin yayılması için kısa süre beklenecek.
3. Minimal `Runner Diagnostic` yeniden çalıştırılacak.
4. Runner atanırsa sorun kesin olarak budget/entitlement gate kaynaklıdır.
5. Runner yine atanmazsa GitHub Support'a hesap tarafında hosted-runner entitlement sync talebi açılacak.

Not: Packages'ın %100 olması artifact/package storage açısından ayrıca incelenebilir; ancak artifact kullanmayan minimal `echo` job'ın daha runner verilmeden ölmesini tek başına açıklamaz.

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
- Actions runnerları şu an account-side hard-stop/entitlement nedeniyle başlamıyor gibi görünüyor

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
1. Actions budget hard-stop testi: `Stop usage=No` veya bütçeyi $10'a çıkar.
2. Minimal Runner Diagnostic'i yeniden çalıştır.
3. Runner açılırsa yeni device-test APK üret ve prerelease yayınla.
4. APK'yı v2-9 üzerine kaldırmadan `Güncelle`; liste + doğru simge + update davranışını birlikte doğrula.
5. Hard-stop değişikliğine rağmen runner açılmazsa GitHub Support'a dört run ID ve `runner_id=0 / steps=[]` kanıtıyla başvur.
