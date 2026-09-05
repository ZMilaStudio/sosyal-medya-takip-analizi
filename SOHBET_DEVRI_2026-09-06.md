# SOHBET DEVRİ — 6 Eylül 2026

Bu dosya `ZMilaStudio/sosyal-medya-takip-analizi` projesinin güncel devridir.

## Yeni sohbet ilk talimatı
Önce:
1. `PROJE_OZETI.md`
2. `SOHBET_DEVRI_2026-09-06.md`
3. canlı `dev/ads-v1`
okunmalı. Sonra aşağıdaki fiziksel doğrulama kapısından devam edilmelidir.

## Kritik çalışma kuralları
- Exact launcher/logo kullanıcı onaylı rasterdır; yeniden çizilmez veya regenerate edilmez.
- CI SUCCESS fiziksel PASS değildir.
- Kullanıcı gereksiz Actions/Codex tüketimi istemiyor; büyük ve mantıklı paketler halinde ilerle.
- Analiz ekranının fiziksel çalışan mimarisini bozma: 5 tab, basit `Column + Expanded(TabBarView) + _UserList`, `ListView.separated`, `ListTile`, `CircleAvatar`.
- Sosyal medya şifresi/private API/scraping/otomatik follow-unfollow yok.
- Fiziksel startup crash sürerse kanıtsız exception adı verme; mümkünse gerçek logcat edin.

## Fiziksel baseline
Reklamsız v2-39 test package `com.zmilastudio.takipanalizi.dev` Samsung fiziksel cihazda gerçek verilerle PASS.
- commit `0816b8811aae6cf7aa2be67e63c524156093507b`
- Actions `33551771267`
- APK SHA-256 `d18151fbc8c75897abd14934cc71b9ef29911b1d035cb6c1670a176fac9dde97`

## Ads RC 1.0.0 (2) — FİZİKSEL FAIL
- CI success: run `33804644499`
- Kullanıcı Samsung cihazda splash/startup aşamasında `Takip Analizi sürekli olarak duruyor` hatasını iki kez doğruladı.

## Startup-safe Ads RC 1.0.0 (3) — FİZİKSEL FAIL
- Runtime head `7da23dfd61564d2bb28efa653c1489d22ff3ae50`
- CI run `33962525980` SUCCESS.
- `MobileAdsInitProvider` merged manifestten kaldırılmıştı.
- Ads/UMP Flutter ilk frame sonrasına 750 ms geciktirilmiş ve fail-closed yapılmıştı.
- APK SHA-256 `e0185d2f33f643e0c14814f8f812df00d84787a995e08f2adee0c4a8d6a723b7`.
- 6 Eylül 2026 00:19 civarı kullanıcı `(3)` için tekrar **`Sürekli duruyor`** bildirdi.
- Sonuç: provider removal + Dart-side delayed initialization tek başına yeterli olmadı. `(3)` yayın adayı değildir.

## Android 16 / WorkManager teşhisi
Kullanıcı cihazından gerçek logcat henüz yok; aşağıdaki neden bu yüzden **kanıta dayalı güçlü eşleşme**, cihaz stack trace'i olarak sunulmamalıdır.

Google'ın `googleads/googleads-mobile-flutter` reposundaki issue #1444'te Android 16 + release mode için `google_mobile_ads` ile startup crash yeniden üretildi. Raporlanan zincir:
- `androidx.startup.InitializationProvider`
- `androidx.work.impl.WorkDatabase` oluşturma hatası
- `google_mobile_ads` kaldırılınca crash kayboluyor
- birden fazla kullanıcı `androidx.work:work-runtime:2.11.2` sabitlemesiyle crash'in düzeldiğini bildirdi.

Bizim RC ortamı aynı risk ailesine yakın:
- Flutter `3.47.2`
- Gradle `9.3.1`
- compile/target SDK `36`
- `google_mobile_ads 9.1.0`

## Android 16 WorkManager-fix Ads RC 1.0.0 (4) — CURRENT CANDIDATE
Aktif branch `dev/ads-v1`.
Runtime/CI head: `b58b2ceaae6e036a67eacc83ed790191928f9e3b`.

Değişiklik paketi kasıtlı olarak küçüktür:
- version `1.0.0+4`
- `apps/mobile/android/app/build.gradle.kts` içine `implementation("androidx.work:work-runtime:2.11.2")`
- CI, release build sonrasında Gradle cache içinde gerçek `work-runtime-2.11.2.aar` varlığını doğruluyor
- `(3)`teki `MobileAdsInitProvider` removal, 750 ms delayed init ve fail-closed AdsCoordinator korunuyor
- exact launcher ve analiz mimarisi değişmedi

İlk CI run `33992886583` yalnız yanlış dependency-insight guard'ında FAIL oldu: repoda `android/gradlew` yoktu (`./gradlew: No such file or directory`). Bu app/build hatası değildi.

Düzeltilen final RC4 CI:
- run `33992965500`
- job `101378357878`
- head `b58b2ceaae6e036a67eacc83ed790191928f9e3b`
- conclusion **SUCCESS**
- Flutter analyze clean
- **23/23 tests PASS**
- signed release APK PASS
- WorkManager doğrulaması PASS: `work-runtime-2.11.2.aar`
- package `com.zmilastudio.takipanalizi`
- versionName `1.0.0`, versionCode `4`
- compile/target SDK 36
- same private Play upload signer
- `allowBackup=false`, `usesCleartextTraffic=false`
- Google test AdMob App ID present
- debuggable/testOnly yok
- merged manifestte `MobileAdsInitProvider` yok
- exact reklam permission whitelist PASS
- exact launcher resource PASS
- artifact upload PASS

Artifact:
- `takip-analizi-ads-android16-workmanager-fix-rc-apk-1.0.0-4`
- ID `9977278775`
- ZIP size `31,196,542` byte
- ZIP digest `sha256:e7b95cb06c9138d147fce2b7c0f9509d3e2661a41a2609f0f9bfb29ddf98fd35`
- APK size `64,828,956` byte
- APK SHA-256 `9dd334e69ecb8d932bd388bfc5cfeda756f274f69a175199d029ad02ddc74d99`
- artifact içindeki `.sha256` ile bağımsız yerel SHA-256 eşleşti
- kullanıcı handoff adı: `Takip-Analizi-1.0.0-4-ads-android16-workmanager-fix-test-rc.apk`

## Sıradaki kesin iş
1. Kullanıcı Samsung cihazda **yalnız `(4)` APK'yı** kurup açılışı kontrol edecek.
2. İlk kritik soru: splash geçilip normal ana ekran geliyor mu, `sürekli olarak duruyor` hatası bitti mi?
3. Açılış FAIL ise WorkManager eşleşmesine rağmen artık yeni varsayım üretmeden gerçek Android crash log/logcat edinmek öncelik olacak.
4. Açılış PASS ise aynı tek fiziksel turda banner, Instagram gerçek analiz, 5 liste, profil/Yok say, analizden doğal çıkışta interstitial, persistence ve X smoke tamamlanacak.
5. Tam fiziksel PASS sonrasında gerçek AdMob App ID + banner/interstitial unit IDs oluşturulup secure CI inputs ile final signed AAB hazırlanacak.
6. Sonra public privacy `main`, Play App Signing/Internal testing, Ads/Data Safety/IARC/app access ve store varlıkları tamamlanacak.
