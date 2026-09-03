# Google Play — Veri Güvenliği Taslağı

Son güncelleme: 3 Eylül 2026

Bu dosya reklamlı **Takip Analizi 1.0.0 (2)** adayı için Play Console Veri güvenliği formu çalışma taslağıdır. Nihai form, final production AAB’nin merged manifesti ve kullanılan Google Mobile Ads SDK sürümü doğrulandıktan sonra doldurulacaktır.

## Mimari ayrımı

### Sosyal medya analiz verisi

- Instagram/X arşivi yalnız cihaz üzerinde analiz edilir.
- Sosyal medya şifresi alınmaz.
- Takipçi/takip edilen listeleri, analiz sonuçları, snapshot geçmişi ve Yok say tercihleri ZMila Studio sunucusuna yüklenmez.
- Dosyalar Android sistem dosya seçicisinden kullanıcı tarafından seçilir.
- Yerel analiz verileri Android automatic backup kapsamı dışında tutulur (`allowBackup=false` + extraction rules).

Bu sosyal medya arşiv içeriği reklam SDK’sına verilmez.

### Reklam ağı verisi

Uygulama Google Mobile Ads / AdMob kullanır. Google’ın güncel Mobile Ads veri açıklamasına göre SDK aşağıdaki verileri reklam, analytics ve fraud prevention amaçlarıyla otomatik olarak **toplayabilir ve paylaşabilir**:

1. **IP adresi** — cihazın genel/yaklaşık konumunu tahmin etmek için kullanılabilir.
2. **User product interactions / uygulama etkileşimleri** — app launch, taps, ad/video interactions gibi.
3. **Diagnostic information / tanılama** — uygulama/SDK performansı, launch time, hang rate, energy usage gibi.
4. **Device and Account identifiers / cihaz veya diğer kimlikler** — Android advertising ID, App Set ID ve uygun olduğunda başka tanımlayıcılar.

Google, bu SDK verilerinin TLS ile aktarım sırasında şifrelendiğini belirtir. Android reklam kimliği kullanıcı/OS ayarları ve consent/limited-ad davranışlarına göre gönderilmeyebilir; ancak Data Safety beyanı SDK’nın mümkün olan otomatik veri işlemesini kapsayacak şekilde muhafazakâr hazırlanacaktır.

Resmi kaynak:
https://developers.google.com/admob/android/privacy/play-data-disclosure

## Play Console temel cevapları

### Does your app collect or share any of the required user data types?

**Yes / Evet.**

Sebep: Google Mobile Ads SDK cihaz dışına reklam/ölçüm verisi aktarır.

### Data encrypted in transit?

**Yes / Evet.**

Google Mobile Ads SDK bu veri aktarımında TLS kullandığını belirtir.

### Ads declaration

**Contains ads / Reklam içeriyor → Yes / Evet.**

Uygulama anchored adaptive banner ve seyrek interstitial reklam kullanır.

## Önerilen veri türü eşlemesi

Aşağıdaki eşleme Google Play’in veri kategorilerine çevrilirken kullanılacak muhafazakâr taslaktır:

| Play veri kategorisi | Kaynak | Collected | Shared | Amaç |
| --- | --- | --- | --- | --- |
| Location → Approximate location | IP address ile genel konum tahmini | Yes | Yes | Advertising/marketing, Analytics, Fraud prevention/security/compliance |
| App activity → App interactions | app launch, taps, ad/video interactions | Yes | Yes | Advertising/marketing, Analytics, Fraud prevention/security/compliance |
| App info and performance → Diagnostics | SDK/app performance diagnostics | Yes | Yes | Advertising/marketing, Analytics, Fraud prevention/security/compliance |
| Device or other IDs | Advertising ID, App Set ID, diğer uygun identifiers | Yes | Yes | Advertising/marketing, Analytics, Fraud prevention/security/compliance |

Not: Play Console’daki isimler veya amaç seçenekleri değişirse en yakın güncel seçenek kullanılacaktır. Google, geliştiricinin kendi uygulama kullanımına göre formdan nihai olarak sorumlu olduğunu belirtir.

## User choice / required-or-optional notu

- UMP SDK her açılışta güncel consent bilgisini ister.
- Gerekli olduğunda consent formu gösterilir.
- `canRequestAds()` true olmadan uygulama reklam istemez.
- Privacy options requirement varsa uygulama içinde yeniden açılabilir bir giriş noktası sunulur.
- Kullanıcı consent tercihlerine göre personalized, non-personalized veya limited ad davranışı Google tarafında değişebilir.

Bu nedenle Play formundaki “optional” sorusu final Console metnine göre dikkatle yanıtlanacaktır; SDK’nın bazı tanımlayıcıları consent/OS durumuna göre değişse de reklam özelliğinin teknik veri akışı cihaz dışına çıkar.

## Uygulama tarafından cihazda tutulan ama geliştirici sunucusuna gönderilmeyen veriler

- sosyal medya kullanıcı adı / hesap ID,
- takipçi listesi,
- takip edilen listesi,
- analiz sonuçları,
- analiz zamanı,
- snapshot geçmişi,
- Yok say tercihleri.

Bunlar uygulamanın kendi mimarisinde yalnız cihazda işlenir ve AdMob reklam isteğine eklenmez.

## User-initiated external transfers

### Profil açma

Kullanıcının bir Instagram/X profil bağlantısını harici uygulamada açması açıkça kullanıcı tarafından başlatılır. Sonraki veri işleme ilgili uygulama/hizmet politikasına tabidir.

### Rapor kopyala / TXT kaydet

Kullanıcı raporu sistem panosuna kopyalayabilir veya kendi seçtiği dosya hedefine TXT olarak kaydedebilir. Uygulama bu raporu ZMila Studio sunucusuna yüklemez. Dışa aktarılan içerik app-private alan dışında kalabilir.

## Yerel veri silme

Uygulamadaki **Yerel Veri Yönetimi** ekranı:

- analiz geçmişini,
- Yok say tercihlerini,
- app-managed tüm yerel veriyi

silebilir. Uygulamanın ZMila Studio tarafında kullanıcı hesabı veya analiz verisi sunucusu yoktur.

AdMob/Google tarafından işlenen reklam verileri Google’ın kullanıcı gizlilik, reklam kimliği ve consent kontrollerine tabidir. Uygulama gerekli olduğunda UMP privacy-options formuna erişim sunar.

## Android permission / network kontratı

Reklamlı build için eski “production INTERNET yasak” kontratı artık geçerli değildir.

Korunacak kurallar:

- source `main` manifestte sosyal medya verisine geniş erişim veren app-defined runtime izinları eklenmeyecek,
- `android:usesCleartextTraffic="false"` korunacak,
- `android:allowBackup="false"` korunacak,
- targetSdk 36 korunacak,
- `debuggable=true` / `testOnly=true` production’da reddedilecek,
- exact launcher hash korunacak,
- merged manifestteki reklam SDK izinleri CI tarafından gerçek build üzerinden çıkarılıp yalnız beklenen whitelist ile kabul edilecek.

Beklenen reklam SDK izinleri arasında `INTERNET`, `ACCESS_NETWORK_STATE`, reklam kimliği ve Android Privacy Sandbox/AdServices ile ilişkili izinler bulunabilir. Nihai whitelist ilk reklamlı RC build logundan kilitlenecektir.

## UMP / consent

Uygulama Google’ın Flutter UMP akışını izler:

1. Her app launch’ta `requestConsentInfoUpdate()`.
2. Gerekliyse `loadAndShowConsentFormIfRequired()`.
3. Ads request öncesi `canRequestAds()`.
4. `PrivacyOptionsRequirementStatus.required` ise uygulama içi görünür privacy-options entry point.

Kaynak:
https://developers.google.com/admob/flutter/privacy

## Yayın öncesi kapı

1. Test AdMob App ID ve test ad unit ID’leriyle reklamlı RC APK build edilir.
2. Merged release manifestte gerçek permission seti çıkarılır ve whitelist kilitlenir.
3. Banner + interstitial + UMP fiziksel cihazda tek kritik RC testinden geçer.
4. Canlı AdMob App ID + banner + interstitial ad unit ID’leri GitHub Secrets olarak girilir.
5. Final AAB `ADMOB_USE_TEST_IDS=false` ile build edilir ve sample/test ID içermediği otomatik doğrulanır.
6. Public `main` privacy policy reklamlı sürüme güncellenir.
7. Play Console Ads + Data Safety cevapları bu dosyayla karşılaştırılarak doldurulur.

## Resmi referanslar

- Google Mobile Ads data disclosure: https://developers.google.com/admob/android/privacy/play-data-disclosure
- Google UMP Flutter: https://developers.google.com/admob/flutter/privacy
- Google Play Data Safety: https://support.google.com/googleplay/android-developer/answer/10787469
- Google Play User Data / Privacy: https://support.google.com/googleplay/android-developer/answer/10144311
