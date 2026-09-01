# Google Play — Veri Güvenliği Taslağı

Son güncelleme: 1 Eylül 2026

Bu dosya Play Console **Veri güvenliği** formunu doldururken kullanılacak teknik taslaktır. Nihai beyan, production AAB ve mağaza yayını öncesi yeniden doğrulanmalıdır.

## Mevcut mimari için teknik gerçekler

- Uygulama local-first çalışır.
- Production `main` manifestinde `android.permission.INTERNET` yoktur.
- Flutter debug/profile geliştirme build’leri hot reload/debugger için kendi manifestlerinden `INTERNET` izni ekler; bu development davranışıdır.
- Production RC workflow’u gerçek merged release manifestte `INTERNET` görülürse build’i fail edecek şekilde hazırlanmıştır.
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

### Profil bağlantısı açma “sharing” midir?

Kullanıcı bir hesap satırına dokunarak harici Instagram/X profilini açmayı kendisi başlatır. URL Android üzerinden ilgili sosyal uygulamaya veya tarayıcıya devredilir.

Google Play Data Safety tanımında kullanıcı tarafından açıkça başlatılan ve kullanıcının paylaşım/aktarım beklediği third-party transferler “sharing” beyanı istisnası kapsamında olabilir. Mevcut profil-açma akışı bu user-initiated action istisnasına göre değerlendirilmiştir.

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

## Permission / network notları

### Debug / profile

Flutter geliştirme manifestleri:

`apps/mobile/android/app/src/debug/AndroidManifest.xml`
`apps/mobile/android/app/src/profile/AndroidManifest.xml`

hot reload ve debugging için `android.permission.INTERNET` ekler.

v2-38 debug APK badging bu yüzden `INTERNET` iznini göstermiştir.

### Production release

`apps/mobile/android/app/src/main/AndroidManifest.xml` bu izni içermez.

Production RC workflow’u AAB build’inden sonra merged release manifesti bulur ve `android.permission.INTERNET` görülürse işlemi başarısız sayar. Böylece privacy/Data Safety beyanı gerçek release manifest üzerinden doğrulanmadan production adayı kabul edilmez.

## Target API

v2-38 CI debug APK doğrulaması:

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
- production release’e `INTERNET` veya başka veri erişim izni eklenmesi.

## Public privacy / support

Privacy policy:
https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md

Support:
https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md

Privacy / support email:
`zmilastudio@gmail.com`

## Yayın kapısı

Play Store’a production gönderimi yapılmadan önce:

1. Production AAB’nin merged release manifest izinleri otomatik kontrolden geçmeli.
2. Bağımlılık ağacı reklam/analytics SDK’sı açısından yeniden kontrol edilmeli.
3. Public privacy/support URL’leri erişilebilir olmalı.
4. Play Console Veri Güvenliği formu `PLAY_CONSOLE_FORM_ANSWERS.md` ile karşılaştırılarak doldurulmalı.
5. Production mimarisi bu dosyadan sapıyorsa önce bu belge ve privacy policy güncellenmeli.

## Resmi Google Play referansları

- https://support.google.com/googleplay/android-developer/answer/10787469
- https://support.google.com/googleplay/android-developer/answer/10144311
- https://support.google.com/googleplay/android-developer/answer/11926878
