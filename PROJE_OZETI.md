# PROJE_OZETI

Son güncelleme: 6 Eylül 2026

## Çalışma protokolü
- Her yeni iş başlangıcında bu dosya + en yeni `SOHBET_DEVRI_*.md` + canlı GitHub repo okunur.
- Çalışan CI/fiziksel baseline korunur; gereksiz Actions çalıştırılmaz.
- Küçük değişiklikler için ayrı fiziksel PASS turu yapılmaz; production RC noktasında tek kritik cihaz doğrulaması yapılır.
- Exact launcher/logo kullanıcı onaylı rasterdır; yeniden çizilmez veya regenerate edilmez.
- CI SUCCESS fiziksel PASS sayılmaz; fiziksel başarı yalnız kullanıcı cihaz doğrulamasıyla yazılır.
- Kullanıcı gereksiz Codex/Actions tüketimi istemiyor; büyük ve mantıklı paketler halinde ilerlenir.
- Analiz ekranının fiziksel çalışan mimarisi gereksiz yere değiştirilmez: 5 tab, basit `Column + Expanded(TabBarView) + _UserList`, `ListView.separated`, `ListTile`, `CircleAvatar`.

## Ürün
Android öncelikli Flutter + Dart, local-first Instagram ve X/Twitter takip analizi.
- Instagram: resmi Meta export ZIP içindeki JSON/HTML; scraping/private API/şifre/otomatik follow-unfollow yok.
- X: resmi arşiv ZIP; büyük arşivlerde `follower.js` + `following.js`; `window.YTD.*`; ID-only hesaplar sahte handle olmadan tutulur.
- 5 kategori: Takip Etmeyenler, Karşılıklı, Seni Takip Edenler, Takibi Bırakanlar, Yeni Takipçiler.
- Snapshot/geçmiş, otomatik ve manuel karşılaştırma, arama/sıralama, profil linki, Yok say, son hesaplar, geçmiş filtreleri/silme, rapor kopyala/TXT, Yerel Veri Yönetimi, rehberler, Gizlilik ve Hakkında.

## Fiziksel çalışan baseline
- v2-39 test package `com.zmilastudio.takipanalizi.dev` Samsung fiziksel cihazda gerçek listelerle PASS.
- Tested commit `0816b8811aae6cf7aa2be67e63c524156093507b`; Actions `33551771267` SUCCESS.
- APK SHA-256 `d18151fbc8c75897abd14934cc71b9ef29911b1d035cb6c1670a176fac9dde97`.
- Test signer SHA-256 `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`.
- Gerçek Meta örneği: 569 takipçi / 1053 takip edilen / 792 takip etmeyen / 261 karşılıklı / 308 yalnız takipçi.
- `gece02.19`: 75/53 → 74/46; Takibi Bırakanlar 6 + Yeni Takipçiler 5; `75 - 6 + 5 = 74`.
- Backup `backup/device-v2-39-release-hardening-ci-working`.

## Exact launcher kilidi
- Kaynak: `apps/mobile/android/app/src/main/res/drawable-nodpi/takip_launcher_user.webp`.
- SHA-256 `7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`.
- Manifest `android:icon` + `android:roundIcon` doğrudan `@drawable/takip_launcher_user` kullanıyor.
- Eski kullanılmayan `mipmap/ic_launcher*` PNG/XML kaynakları production AAPT2 hatası sonrası kaldırıldı; exact launcher değişmedi.

## Reklam / monetizasyon — KİLİTLİ MODEL
3–4 Eylül 2026 kararları:
- Google Mobile Ads / AdMob kullanılacak.
- Model: **dengeli reklam modeli**.
- App Open reklamı yok.
- Rewarded reklam yok.
- Banner uygun olan mümkün olduğunca çok ekranda olacak.
- Takipçi listelerinde banner liste satırlarının arasına girmeyecek; ekranın altında anchored/adaptive banner olacak.
- Dosya seçme, ZIP/JS okuma ve analiz yükleme sırasında banner bastırılacak.
- İlk analiz sonucu görülmeden interstitial gösterilmeyecek.
- Interstitial yalnız analizden doğal çıkışta değerlendirilecek.
- Interstitial minimum aralık: **10 dakika**.
- Oturum başına maksimum interstitial: **2**.
- Sosyal medya arşiv içeriği, takipçi listeleri ve analiz snapshot’ları reklam amacıyla Google’a gönderilmeyecek; reklam SDK trafiği analiz verisinden ayrı tutulacak.

## AdMob entegrasyonu — AKTİF GELİŞTİRME
Ana reklam branch’i: `dev/ads-v1`.
Backup: `backup/pre-ads-v1` reklamsız önceki güvenli hali koruyor.

Kod/al altyapı:
- `google_mobile_ads: ^9.1.0`.
- `AdsCoordinator`: UMP consent, Mobile Ads initialize, banner readiness, interstitial preload/frequency cap.
- `AnchoredAdaptiveAdBanner`: ekran genişliğine göre anchored adaptive banner.
- `AdScreenFrame`: uygun route’ların altında sabit banner alanı.
- `AnalysisExitAdGate`: analiz ekranından geri çıkarken uygun ise interstitial gösterir.
- Home import akışlarında dosya seçme/analiz sırasında banner suppression.
- `Gizlilik ve Hakkında`: reklam SDK veri işleme ayrımı + UMP privacy options girişi.
- `AdConfig`: test/live ayrımı. Test RC Google resmi test ID’leri kullanır; canlı ID’ler henüz bağlanmadı.
- Android manifest `com.google.android.gms.ads.APPLICATION_ID` placeholder kullanır.
- Gradle `ADMOB_APP_ID` ortam değişkeni ile canlı App ID alabilir; verilmezse test App ID fail-safe fallback’tir.
- Dart canlı banner/interstitial ID’leri `--dart-define` ile alabilir.

## Ads RC 1.0.0 (2) — CI SUCCESS, FİZİKSEL FAIL
- Package `com.zmilastudio.takipanalizi`, target/compile SDK 36.
- Final CI run `33804644499`, job `100812076200`, head `066881777128e9c855334298caaf3aaba4b1c29c`: SUCCESS.
- Analyze clean, 23/23 test, signed release APK, signer/package/version/manifest/launcher kontrolleri PASS.
- APK `64,678,457` byte; SHA-256 `4dee1e0f955508ff9b12990bebf69a0803f15c6696331b78e858b007c98bce23`.
- Artifact `takip-analizi-ads-rc-apk-1.0.0-2`, ID `9912704423`.
- 5 Eylül 2026 fiziksel sonuç: Samsung cihazda splash/startup aşamasında `Takip Analizi sürekli olarak duruyor`; iki ayrı denemeyle **FAIL**.
- Logcat alınmadığı için kesin exception adı iddia edilmedi.

## Startup-safe Ads RC 1.0.0 (3) — CI SUCCESS, FİZİKSEL FAIL
Runtime head `7da23dfd61564d2bb28efa653c1489d22ff3ae50`.

Uygulanan startup güvenlik paketi:
- version `1.0.0+3`.
- Google Mobile Ads `MobileAdsInitProvider` merged manifestten `tools:node="remove"` ile kaldırıldı.
- AdMob App ID metadata korundu.
- `MobileAds.instance.initialize()` ve UMP Flutter ilk frame’den 750 ms sonrasına alındı.
- `AdsCoordinator` startup/consent/init hatalarında fail-closed yapıldı; reklam arızası ana analiz uygulamasını düşürmemeli.
- Interstitial load/show ve privacy options exception-safe yapıldı.
- Exact launcher ve analiz mimarisi değiştirilmedi.
- Reklam permission seti exact whitelist ile CI’da kilitlendi.

CI run `33962525980`, job `101296777913`: SUCCESS.
- package `com.zmilastudio.takipanalizi`
- versionName `1.0.0`, versionCode `3`
- target/compile SDK 36
- analyze clean
- 23/23 test
- signed release APK + signer verification
- `allowBackup=false`, `usesCleartextTraffic=false`
- Google test AdMob App ID present
- debuggable/testOnly yok
- merged manifestte `MobileAdsInitProvider` yok
- permission whitelist + exact launcher PASS

Artifact:
- `takip-analizi-ads-startup-safe-rc-apk-1.0.0-3`
- ID `9968483492`
- ZIP `31,114,323` byte; digest `sha256:21e1497977974f645db73e2097b387e815693fef6290ef179987c9fe38b3e8f1`
- APK `64,743,709` byte
- APK SHA-256 `e0185d2f33f643e0c14814f8f812df00d84787a995e08f2adee0c4a8d6a723b7`

**6 Eylül 2026 fiziksel sonuç: FAIL.**
- Kullanıcı `(3)` APK’yı Samsung cihazda çalıştırdı ve `Sürekli duruyor` bildirdi.
- Sonuç: `MobileAdsInitProvider` removal + Dart-side delayed/fail-closed initialization tek başına startup crash’i çözmedi.
- `(3)` kesin yayın adayı değildir.

## Android 16 / WorkManager teşhisi — 6 Eylül 2026
Kullanıcı cihazından gerçek Android stack trace/logcat henüz alınmadı; aşağıdaki neden **kanıta dayalı güçlü eşleşmedir**, kullanıcının kesin stack trace’i olarak yazılmamalıdır.

Upstream Google `googleads/googleads-mobile-flutter` issue #1444 bulguları:
- Android 16 + release mode + `google_mobile_ads` ile startup crash yeniden üretildi.
- Raporlanan zincir `androidx.startup.InitializationProvider` → `androidx.work.impl.WorkDatabase` oluşturma hatası.
- `google_mobile_ads` kaldırılınca crash kayboldu.
- Birden fazla kullanıcı `implementation("androidx.work:work-runtime:2.11.2")` ile crash’in düzeldiğini raporladı.

Bizim risk ortamı:
- Flutter `3.47.2`
- Gradle `9.3.1`
- compile/target SDK `36`
- `google_mobile_ads 9.1.0`

Bu nedenle RC4 WorkManager `2.11.2` pin ile hazırlandı; başka ürün/analiz değişikliği eklenmedi.

## Android 16 WorkManager-fix Ads RC 1.0.0 (4) — CI SUCCESS, FİZİKSEL STARTUP + BANNER PASS
Aktif runtime/CI head: `b58b2ceaae6e036a67eacc83ed790191928f9e3b`.
Hazırlık branch’i: `dev/ads-android16-workmanager-fix-v1`; ardından `dev/ads-v1` üzerine fast-forward edildi.

Değişiklikler:
- version `1.0.0+4`.
- `apps/mobile/android/app/build.gradle.kts`: `implementation("androidx.work:work-runtime:2.11.2")`.
- `(3)`teki `MobileAdsInitProvider` removal, 750 ms delayed initialization ve fail-closed reklam davranışı korunuyor.
- Exact launcher ve analiz mimarisi değişmedi.

İlk RC4 CI denemesi:
- run `33992886583`, job `101378139868`: FAIL.
- Tek failure yeni yazılan dependency guard’dı: repoda `android/gradlew` olmadığı için `./gradlew: No such file or directory`.
- Signing/source guards/pub get PASS; app build aşamasına geçilmedi. Bu uygulama hatası değildi.
- Guard, gerçek release build sonrasında Gradle cache’de `work-runtime-2.11.2.aar` doğrulayacak şekilde düzeltildi.

Final RC4 CI:
- run `33992965500`
- job `101378357878`
- head `b58b2ceaae6e036a67eacc83ed790191928f9e3b`
- conclusion **SUCCESS**

PASS:
- private Play upload key + certificate fingerprint
- source guards
- Flutter `3.47.2`
- `flutter analyze`: clean
- **23/23 test PASS**
- signed release APK build
- WorkManager runtime doğrulaması: `work-runtime-2.11.2.aar` gerçekten resolved
- package `com.zmilastudio.takipanalizi`
- versionName `1.0.0`, versionCode `4`
- compile/target SDK 36
- same private Play upload signer
- `allowBackup=false`, `usesCleartextTraffic=false`
- Google test AdMob App ID present
- debuggable/testOnly yok
- merged release manifestte `MobileAdsInitProvider` yok
- exact reklam permission whitelist PASS
- exact launcher resource PASS
- artifact upload PASS

RC4 Artifact:
- ad `takip-analizi-ads-android16-workmanager-fix-rc-apk-1.0.0-4`
- ID `9977278775`
- ZIP `31,196,542` byte
- ZIP digest `sha256:e7b95cb06c9138d147fce2b7c0f9509d3e2661a41a2609f0f9bfb29ddf98fd35`
- APK `64,828,956` byte
- APK SHA-256 `9dd334e69ecb8d932bd388bfc5cfeda756f274f69a175199d029ad02ddc74d99`
- Artifact içindeki `.sha256` ile bağımsız yerel hash birebir eşleşti.
- Kullanıcı handoff dosyası: `Takip-Analizi-1.0.0-4-ads-android16-workmanager-fix-test-rc.apk`.

**6 Eylül 2026 fiziksel sonuç — STARTUP PASS / TEST BANNER PASS:**
- Kullanıcı RC4’ü Samsung fiziksel cihazda açtı; ana `Takip Analizi` ekranı normal render edildi.
- Önceki `(2)` ve `(3)`te görülen `sürekli olarak duruyor` startup crash’i RC4’te oluşmadı.
- Kullanıcının ekran görüntüsünde alt bölümde Google test **AdMob Adaptive Banner** açıkça görünür durumda; `Test Reklamı` etiketi de görünüyor.
- Böylece iki kritik fiziksel kapı aynı anda PASS: uygulama startup + reklam SDK/banner yükleme.
- Bu sonuç, WorkManager `2.11.2` pininin hedeflenen Android 16/Google Mobile Ads uyumsuzluğunu çözmüş olduğuna dair çok güçlü kanıttır; kullanıcı logcat’i olmadığı için geçmiş crash’in kesin stack trace’i yine iddia edilmez.
- Tam fiziksel ürün PASS henüz tamamlanmadı; gerçek Instagram analiz/listeler, interstitial, persistence ve X smoke aynı RC4 üzerinde sıradadır.

## Reklamlı merged Android permission whitelist
RC3/RC4 exact set:
- `android.permission.ACCESS_ADSERVICES_AD_ID`
- `android.permission.ACCESS_ADSERVICES_ATTRIBUTION`
- `android.permission.ACCESS_ADSERVICES_TOPICS`
- `android.permission.ACCESS_NETWORK_STATE`
- `android.permission.FOREGROUND_SERVICE`
- `android.permission.INTERNET`
- `android.permission.WAKE_LOCK`
- `com.google.android.gms.permission.AD_ID`
- `com.zmilastudio.takipanalizi.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`

Yok:
- `MANAGE_EXTERNAL_STORAGE`
- `READ/WRITE_EXTERNAL_STORAGE`
- contacts
- camera
- microphone
- location
- SMS
- call log

## Production privacy/security — REKLAMLI MODEL
- Analiz verisi local-first kalır.
- `android:allowBackup=false`.
- `backup_rules.xml` ve `data_extraction_rules.xml` yerel app-managed veriyi backup/transfer kapsamı dışında tutar.
- `android:usesCleartextTraffic=false`.
- AdMob nedeniyle INTERNET/network ve reklam SDK izinleri vardır; eski “production INTERNET yok” sözleşmesi reklamlı final için geçerli değildir.
- Kullanıcının sosyal medya şifresi istenmez.
- Dosya erişimi sistem file picker ile kullanıcı seçimine bağlıdır.
- Reklam SDK veri işlemesi Privacy/Data Safety’de ayrı beyan edilir.

## Privacy / Play belgeleri — REKLAM MODELİNE GÜNCELLENDİ
`dev/ads-v1` üzerinde:
- `PRIVACY_POLICY.md` TR+EN reklamlı modele göre güncel.
- `PLAY_STORE_DATA_SAFETY.md` reklam SDK veri işlemesiyle güncel.
- `PLAY_CONSOLE_FORM_ANSWERS.md`: Ads → **Yes**; Data Safety reklamsızdaki “No” değildir.
- Uygulama içi `Gizlilik ve Hakkında` aynı modele güncel.
- Public `main` privacy final canlı reklam build kilitlenince taşınacak.

Google Mobile Ads için final Play Data Safety eşlemesinde değerlendirilecek sınıflar:
- IP address / approximate location türetimi
- app interactions
- diagnostics
- device/advertising identifiers
- advertising / analytics / fraud prevention amaçları

## Production signing — HAZIR
- Private Play upload key: JKS, alias `takip-upload`, RSA 3072, SHA256withRSA.
- Upload certificate SHA-256 `def6c59b9a84f51af6ea5c768f21927ecbadb868ec5dbcd17dc031876b5cca65`.
- Keystore ↔ PEM fingerprint PASS; private-key signing self-test PASS.
- Keystore SHA-256 `4ff8c92eb4ca8074d75791d3a753c1290232bb13b79aa121c26fe059f788a192`.
- Private keystore/parolalar repoya commit edilmedi.
- GitHub Repository Secrets 5/5 TAMAM: `PLAY_UPLOAD_KEYSTORE_B64`, `PLAY_UPLOAD_STORE_PASSWORD`, `PLAY_UPLOAD_KEY_ALIAS`, `PLAY_UPLOAD_KEY_PASSWORD`, `PLAY_UPLOAD_CERT_SHA256`.

## Eski reklamsız Production AAB/APK — ARŞİV BASELINE, FINAL DEĞİL
- AAB success run `33627604993`; artifact `takip-analizi-production-rc-1.0.0-1`.
- Reklamsız production APK success run `33658171635`.
- Reklamsız APK SHA-256 `355a9687b72fc080b1b3d23d5e06fab2149c185d6142f31c02a5532fad765aca`.
- Bunlar rollback/reference baseline olarak korunur.

## Play Console / Play App Signing — BEKLEMEDE
- Reklamlı final build tam fiziksel PASS almadan Play Console final yüklemesine geçilmeyecek.
- Doğrulanacak upload certificate SHA-256 `def6c59b9a84f51af6ea5c768f21927ecbadb868ec5dbcd17dc031876b5cca65`.
- Canlı AdMob App ID + banner unit ID + interstitial unit ID henüz oluşturulup projeye bağlanmadı.
- Play Console Ads beyanı **Yes** olacak.
- Data Safety reklam SDK’sı nedeniyle yeniden doldurulacak.

## Store görselleri
- Exact 512×512 icon SHA-256 `c838ffe6ef39bab9cab0176951334f8dc79e0158fc02755cb27ca28c856ae717`.
- TR feature graphic 1024×500 SHA-256 `73d4e9eec5564945813f2d6fc9aa9206693979a7c68c126dcf5cce63a4afc838`.
- EN feature graphic 1024×500 SHA-256 `e6b2da9520d4a95a2762337f0e09d558e5aeacb91cb3902e371a8453a12f0bf1`.
- 8 gerçek-app screenshot hedefi: 1080×1920, 9:16, sentetik demo verisi, production RC üzerinden.

## Branch durumu
- `test/device-apk` → v2-39 fiziksel tested baseline.
- `backup/device-v2-39-release-hardening-ci-working` → fiziksel baseline backup.
- `backup/pre-production-rc-aapt-fix` korunuyor.
- `backup/pre-ads-v1` → reklam entegrasyonu öncesi güvenli production hazırlığı.
- `backup/ads-v1-startup-crash-baseline` → `(2)` startup crash dönemi referansı.
- `dev/release-polish-v1` → reklamsız production/store baseline.
- `dev/ads-startup-safe-v1` → RC3 provider-free/delayed/fail-closed hazırlık branch’i.
- `dev/ads-android16-workmanager-fix-v1` → RC4 WorkManager fix hazırlık branch’i.
- `dev/ads-v1` → **aktif: 1.0.0 (4) Android 16 WorkManager-fix CI SUCCESS; Samsung fiziksel startup + test adaptive banner PASS; tam ürün fiziksel turu devam ediyor.**
- `test/production-rc-apk-1.0.0-1` → eski reklamsız production RC APK.
- `main` → public privacy/support + eski production workflow; reklamlı final privacy henüz taşınmadı.

## Sıradaki iş — KİLİTLİ SIRA
1. RC4 startup **PASS** ve anchored/adaptive test banner **PASS** tamamlandı; tekrar edilmeyecek.
2. Aynı RC4 üzerinde gerçek Instagram export ZIP ile analiz yapılacak; 5 kategori/listenin doğru açıldığı fiziksel olarak doğrulanacak.
3. Analiz ekranında profil açma/Yok say ve temel liste etkileşimleri smoke kontrol edilecek.
4. İlk analiz sonucu görüldükten sonra analiz ekranından doğal geri çıkışta test interstitial davranışı doğrulanacak; ilk sonuç öncesinde interstitial çıkmamalı.
5. Uygulama kapanıp yeniden açılarak snapshot/persistence korunumu kontrol edilecek.
6. X resmi arşiv import smoke yapılacak.
7. Tam fiziksel PASS sonrası AdMob Console’da gerçek Android app `com.zmilastudio.takipanalizi` + canlı App ID + adaptive banner + interstitial unit oluşturulacak.
8. Canlı ID’ler repoya sabitlenmeden secure CI inputs/secrets üzerinden final signed AAB build’e verilecek.
9. Public privacy `main` güncellenecek.
10. Play App Signing fingerprint doğrulaması + Internal testing.
11. Play Console Ads / Data Safety / IARC / 18+ / app access tamamlanacak.
12. Feature graphic final onayı + 8 store screenshot.

## Sohbet devri
- Eski devir: `SOHBET_DEVRI_2026-09-05.md` — RC2 FAIL / RC3 candidate dönemini korur.
- Güncel devir: `SOHBET_DEVRI_2026-09-06.md` — RC3 fiziksel FAIL + Android 16 WorkManager teşhisi + RC4 CI SUCCESS durumunu içerir; PROJE_OZETI RC4 fiziksel startup/banner PASS ile daha günceldir.
- Yeni sohbet başlangıcında `PROJE_OZETI.md` en güncel fiziksel durum olarak esas alınmalıdır.