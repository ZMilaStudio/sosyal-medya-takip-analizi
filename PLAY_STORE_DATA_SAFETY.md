# Google Play — Veri Güvenliği Taslağı

Son güncelleme: 1 Eylül 2026

Bu dosya Play Console **Veri güvenliği** formunu doldururken kullanılacak teknik taslaktır. Nihai beyan, production AAB ve mağaza yayını öncesi yeniden doğrulanmalıdır.

## Mevcut mimari için teknik gerçekler

- Uygulama local-first çalışır.
- Production kaynak manifestinde `android.permission.INTERNET` yoktur ve app-defined `<uses-permission>` girdisi bulunmaz.
- Flutter debug/profile geliştirme build’leri hot reload/debugger için kendi manifestlerinden `INTERNET` izni ekler; bu development davranışıdır.
- AndroidX Core merged manifestte `${applicationId}.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` adlı app-scoped signature-level internal permission ekleyebilir. Bu runtime/user-data izni değildir; eski Android sürümlerinde non-exported dynamic receiver güvenliği için kullanılır.
- Production RC workflow’u yalnız bu AndroidX internal iznine tolerans gösterir; `INTERNET` veya başka merged `uses-permission` görülürse build’i fail eder.
- Production manifestinde `android:allowBackup="false"` vardır.
- Android 11 ve altı için `res/xml/backup_rules.xml` tüm app-managed backup domainlerini hariç tutar.
- Android 12+ için `res/xml/data_extraction_rules.xml` hem `cloud-backup` hem `device-transfer` tarafında `root`, `file`, `database`, `sharedpref`, `external` domainlerini hariç tutar.
- Production RC workflow’u backup policy dosyalarını ve merged release manifestte `allowBackup=false` değerini doğrular.
- Production kaynak manifestinde `android:usesCleartextTraffic="false"` vardır.
- Kullanıcının sosyal medya şifresi uygulamaya girilmez.
- Dosyalar Android sistem dosya seçicisi üzerinden kullanıcı tarafından seçilir.
- Analiz snapshot’ları ve “Yok say” tercihleri cihaz üzerinde saklanır.
- Uygulama geliştirici sunucusuna analiz verisi yüklemez.
- Reklam SDK’sı yoktur.
- Analytics/telemetri SDK’sı yoktur.
- Bulut senkronizasyonu yoktur.

## Play Console için önerilen mevcut beyan

### Uygulama kullanıcı verisi topluyor veya paylaşıyor mu?

**Önerilen cevap: Hayır.**

Gerekçe:

- Sosyal medya arşivindeki veriler yalnız cihaz üzerinde işlenir.
- ZMila Studio sunucusuna veya üçüncü taraf sunucuya aktarılmaz.
- Google Play Data Safety kapsamındaki yalnız-cihazda erişim/işleme, veri cihaz dışına gönderilmiyorsa “collection” olarak beyan edilmek zorunda değildir.
- Production Android yapılandırması app-managed yerel veriyi Android automatic backup kapsamı dışında bırakacak şekilde sertleştirilmiştir.
- AndroidX’in internal signature receiver permission’ı kullanıcı verisi toplama/paylaşma yetkisi sağlamaz.

### Profil bağlantısı açma “sharing” midir?

Kullanıcı bir hesap satırına dokunarak harici Instagram/X profilini açmayı kendisi başlatır. URL Android üzerinden ilgili sosyal uygulamaya veya tarayıcıya devredilir.

Google Play Data Safety tanımında kullanıcı tarafından açıkça başlatılan ve kullanıcının paylaşım/aktarım beklediği third-party transferler “sharing” beyanı istisnası kapsamında olabilir. Mevcut profil-açma akışı bu user-initiated action istisnasına göre değerlendirilmiştir.

### Raporu kopyala / TXT olarak kaydet

Bu iki eylem kullanıcı tarafından açıkça başlatılır:

- `Raporu kopyala`: analiz metnini sistem panosuna yazar.
- `TXT olarak kaydet`: analiz metnini Android file picker üzerinden kullanıcının seçtiği hedefe yazar.

Rapor sosyal medya kullanıcı adlarını ve kategori sonuçlarını içerebilir. Uygulama bu raporu ZMila Studio sunucusuna göndermez. Kullanıcının seçtiği harici hedefteki TXT dosyası veya sistem panosu app-private veri alanı dışında olabilir ve uygulama içi Yerel Veri Yönetimi tarafından sonradan otomatik silinemez.

### Hesap oluşturma var mı?

**Hayır.**

Takip Analizi kendi kullanıcı hesabını oluşturmaz ve sosyal medya hesabına giriş yapmaz.

### Veri silme mekanizması

Uygulama içinde **Yerel Veri Yönetimi** ekranı vardır. Kullanıcı:

- analiz geçmişini,
- yok sayılan hesapları,
- tüm yerel uygulama verisini

silebilir.

Uygulama hesabı veya geliştirici sunucusunda kullanıcı verisi olmadığı için server-side account deletion akışı yoktur.

## İşlenen fakat cihazdan çıkmayan veri türleri

Bunlar mevcut mimaride Data Safety “collected” verisi olarak beyan edilmek zorunda değildir; yine de iç denetim için kaydedilmiştir:

- sosyal medya kullanıcı adı / hesap kimliği,
- takipçi ilişkileri,
- takip edilen ilişkileri,
- analiz sonuçları,
- analiz zamanı,
- yerel geçmiş snapshot’ları,
- yok sayılan hesap tercihleri.

## Android backup / transfer politikası

Android’de `android:allowBackup` varsayılanı `true` olduğundan production manifestte açıkça `false` olarak sabitlendi.

Ek koruma:

- Android 11 ve altı: `@xml/backup_rules`
- Android 12+: `@xml/data_extraction_rules`

Her iki kural seti app-managed local data domainlerini backup dışında bırakır. Android 12+ tarafında hem cloud backup hem device-transfer extraction için exclusion yazılmıştır.

Amaç:

- Drift snapshot veritabanını,
- SharedPreferences tabanlı Yok say tercihlerini,
- uygulamanın private files/root alanındaki yerel durumunu

Android otomatik backup kapsamında taşımamaktır.

Not: Android dokümantasyonuna göre bazı cihaz üreticilerinin doğrudan cihazdan cihaza taşıma davranışları sistem seviyesinde farklılık gösterebilir. Bu nedenle privacy policy mutlak “hiçbir koşulda cihazdan çıkamaz” iddiası kullanmaz; uygulama kontrolündeki backup mekanizmalarının kapatıldığı belirtilir.

## Permission / network notları

### Debug / profile

Flutter geliştirme manifestleri:

`apps/mobile/android/app/src/debug/AndroidManifest.xml`
`apps/mobile/android/app/src/profile/AndroidManifest.xml`

hot reload ve debugging için `android.permission.INTERNET` ekler.

v2-39 debug APK badging doğrulaması:

- `android.permission.INTERNET` — debug tooling nedeniyle,
- `com.zmilastudio.takipanalizi.dev.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` — AndroidX internal signature receiver permission.

Bu debug APK production Data Safety beyanının doğrudan manifest kaynağı değildir.

### Production release

`apps/mobile/android/app/src/main/AndroidManifest.xml` `INTERNET` veya app-defined `uses-permission` içermez.

AndroidX Core release merge sırasında şu internal signature permission’ı ekleyebilir:

`com.zmilastudio.takipanalizi.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`

Production RC workflow’u AAB build’inden sonra merged release manifesti bulur ve:

- `android.permission.INTERNET` görülürse,
- AndroidX internal receiver permission dışında başka `uses-permission` görülürse,
- `android:allowBackup="false"` kaybolursa,
- `android:usesCleartextTraffic="false"` kaybolursa,
- targetSdk 36 değilse,
- `debuggable=true` veya `testOnly=true` görülürse

build’i başarısız sayar.

Böylece privacy/Data Safety beyanı gerçek release manifest üzerinden doğrulanmadan production adayı kabul edilmez.

## Target API

v2-39 CI debug APK doğrulaması:

- compileSdkVersion: 36
- targetSdkVersion: 36
- platform build: Android 16

31 Ağustos 2026 itibarıyla yeni mobil Google Play uygulamalarında gereken API 36 hedefi karşılanmaktadır. Production AAB’de de yeniden doğrulanacaktır.

## Production öncesi tekrar kontrol edilmesi gereken değişiklikler

Aşağıdakilerden herhangi biri eklenirse Veri Güvenliği formu ve gizlilik politikası mutlaka yeniden değerlendirilmelidir:

- reklam veya AdMob,
- Firebase Analytics / Crashlytics veya başka telemetri,
- canlı Instagram/X API bağlantısı,
- OAuth,
- bulut yedekleme veya senkronizasyon,
- kullanıcı hesabı,
- push notification altyapısı,
- ücretli üyelik / ödeme,
- uzaktan hata loglama,
- production release’e `INTERNET` veya kullanıcı verisine erişen başka Android izni eklenmesi,
- `allowBackup`, `backup_rules` veya `data_extraction_rules` politikasının gevşetilmesi.

## Public privacy / support

Privacy policy:
https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md

Support:
https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md

Privacy / support email:
`zmilastudio@gmail.com`

## Yayın kapısı

Play Store’a production gönderimi yapılmadan önce:

1. Production AAB’nin merged release manifest izinleri ve backup policy’si otomatik kontrolden geçmeli.
2. Bağımlılık ağacı reklam/analytics SDK’sı açısından yeniden kontrol edilmeli.
3. Public privacy/support URL’leri erişilebilir olmalı.
4. Play Console Veri Güvenliği formu `PLAY_CONSOLE_FORM_ANSWERS.md` ile karşılaştırılarak doldurulmalı.
5. Production mimarisi bu dosyadan sapıyorsa önce bu belge ve privacy policy güncellenmeli.

## Resmi referanslar

Google Play:
- https://support.google.com/googleplay/android-developer/answer/10787469
- https://support.google.com/googleplay/android-developer/answer/10144311
- https://support.google.com/googleplay/android-developer/answer/11926878

Android / AndroidX:
- https://developer.android.com/guide/topics/manifest/application-element
- https://developer.android.com/about/versions/12/behavior-changes-12
- https://android.googlesource.com/platform/prebuilts/sdk/+/fa1474c543bdd7eaa690ba935d9ea8249fd12880/current/androidx/manifests/androidx.core_core/AndroidManifest.xml
