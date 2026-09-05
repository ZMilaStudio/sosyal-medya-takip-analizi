# PROJE_OZETI

Son güncelleme: 5 Eylül 2026

## Çalışma protokolü
- Her yeni iş başlangıcında bu dosya + canlı GitHub repo okunur.
- Çalışan CI/fiziksel baseline korunur; gereksiz Actions çalıştırılmaz.
- Küçük değişiklikler için ayrı fiziksel PASS turu yapılmaz; production RC noktasında tek kritik cihaz doğrulaması yapılır.
- Exact launcher/logo kullanıcı onaylı rasterdır; yeniden çizilmez veya regenerate edilmez.
- CI success fiziksel PASS sayılmaz; fiziksel başarı yalnız kullanıcı cihaz doğrulamasıyla yazılır.
- Kullanıcı gereksiz Codex/Actions tüketimi istemiyor; büyük ve mantıklı paketler halinde ilerlenir.

## Ürün
Android öncelikli Flutter + Dart, local-first Instagram ve X/Twitter takip analizi.
- Instagram: resmi Meta export ZIP içindeki JSON/HTML; scraping/private API/şifre/otomatik follow-unfollow yok.
- X: resmi arşiv ZIP; büyük arşivlerde `follower.js` + `following.js`; `window.YTD.*`; ID-only hesaplar sahte handle olmadan tutulur.
- 5 kategori: Takip Etmeyenler, Karşılıklı, Seni Takip Edenler, Takibi Bırakanlar, Yeni Takipçiler.
- Snapshot/geçmiş, otomatik ve manuel karşılaştırma, arama/sıralama, profil linki, Yok say, son hesaplar, geçmiş filtreleri/silme, rapor kopyala/TXT, Yerel Veri Yönetimi, rehberler, Gizlilik ve Hakkında.

## Fiziksel baseline
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
- `google_mobile_ads: ^9.1.0` eklendi.
- `AdsCoordinator`: UMP consent akışı, Mobile Ads initialize, banner readiness, interstitial preload/frequency cap.
- `AnchoredAdaptiveAdBanner`: ekran genişliğine göre anchored adaptive banner.
- `AdScreenFrame`: uygun route’ların altında sabit banner alanı.
- `AnalysisExitAdGate`: analiz ekranından geri çıkarken uygun ise interstitial gösterir.
- Home import akışlarında dosya seçme/analiz sırasında banner suppression uygulanır.
- `Gizlilik ve Hakkında` ekranı reklam SDK veri işleme ayrımını ve UMP privacy options girişini içerir.
- `AdConfig` test/live ayrımı yapar. Test RC’de Google’ın resmi test ID’leri kullanılır; canlı ID’ler henüz bağlanmadı.
- Android manifest `com.google.android.gms.ads.APPLICATION_ID` placeholder kullanır.
- Gradle `ADMOB_APP_ID` ortam değişkeni ile canlı App ID alabilir; verilmezse test App ID fail-safe fallback’tir.
- Dart tarafında canlı banner/interstitial ID’leri `--dart-define` ile verilebilir; test RC `ADMOB_USE_TEST_IDS=true` kullanır.

### Ads RC 1.0.0 (2) — CI SUCCESS, FİZİKSEL FAIL
Sürüm: `1.0.0+2`, package `com.zmilastudio.takipanalizi`, target/compile SDK 36.

Workflow: `.github/workflows/ads-rc-apk.yml`.
İlk run `33804414674`:
- signing/source guards PASS
- analyze PASS
- tek failure: eski privacy widget testi birebir `Local-first` başlığını bekliyordu; reklam kodu hatası değildi.
- başlık canonical `Local-first` değerine döndürüldü.

İkinci run `33804644499` / job `100812076200`: **SUCCESS**.
Head SHA: `066881777128e9c855334298caaf3aaba4b1c29c`.
PASS:
- private Play upload key + fingerprint
- production package/version/API identity
- exact launcher source hash
- `flutter analyze` clean
- **23/23 test**
- signed release APK build
- signer verification
- merged release manifest
- backup=false / cleartext=false
- test AdMob App ID present
- debuggable/testOnly yok
- exact launcher Android resource table’da mevcut
- artifact upload

APK build sonucu:
- boyut `64,678,457` byte (~64.7 MB)
- SHA-256 `4dee1e0f955508ff9b12990bebf69a0803f15c6696331b78e858b007c98bce23`
- ZIP içindeki `.sha256` ile bağımsız hash eşleşmesi PASS.
- Artifact `takip-analizi-ads-rc-apk-1.0.0-2`
- Artifact ID `9912704423`
- Artifact ZIP `31,106,806` byte
- Artifact digest `sha256:b26d7bf69b06224bbfec2dfef9b8b18e65ec6e8197e0a6801bd195ea07db1b71`.

**5 Eylül 2026 fiziksel sonuç: FAIL.**
- Kullanıcı Samsung cihazda APK’yı kurdu.
- Uygulama açılışta Android tarafından kapatıldı; ekranda `Takip Analizi sürekli olarak duruyor` mesajı görüldü.
- 5 Eylül 15:36’da gönderilen ikinci ekran görüntüsü aynı `(2)` splash/startup crash davranışını tekrar doğruladı; startup-safe `(3)` bu aşamada henüz kullanıcı tarafından kurulup doğrulanmış değildi.
- Bu nedenle `1.0.0 (2)` fiziksel PASS değildir ve yayın adayı olamaz.
- Reklamsız production RC aynı cihaz ailesindeki önceki mimaride çalıştığı için regresyon reklam entegrasyonu/startup yoluna izole edildi.
- Logcat olmadan kesin stack trace iddiası yapılmıyor.
- En güçlü şüphe: Google Mobile Ads’in Flutter ilk frame’inden önce çalışan `com.google.android.gms.ads.MobileAdsInitProvider` erken startup yolu. Merged manifestte test App ID gerçekten mevcut olduğundan sorun körlemesine `App ID eksik` olarak etiketlenmedi.

### Startup-safe Ads RC 1.0.0 (3) — CI SUCCESS, FİZİKSEL PASS BEKLİYOR
Çalışma branch’i `dev/ads-startup-safe-v1` üzerinde hazırlandı, ardından `dev/ads-v1` üzerine tek fast-forward ile taşındı.
CI head: `7da23dfd61564d2bb28efa653c1489d22ff3ae50`.

Uygulanan güvenlik paketi:
- Sürüm `1.0.0+3` yapıldı; aynı production package ve aynı upload signer ile `(2)` üzerine güncellenebilir.
- Google Mobile Ads library’nin erken `MobileAdsInitProvider` provider’ı manifest merge’de `tools:node="remove"` ile kaldırıldı.
- AdMob App ID metadata korunuyor.
- `MobileAds.instance.initialize()` ve UMP işlemleri Flutter ilk frame’i çizildikten **750 ms sonra** başlatılıyor.
- `AdsCoordinator` startup/consent/MobileAds init hatalarını yakalayıp **fail-closed** davranıyor: reklam katmanı hata verirse `adsReady=false`; analiz uygulaması çalışmaya devam etmeli.
- Mobile Ads init başarısız olursa oturum reklamları devre dışı kalıyor; app startup reklam SDK’sına bağımlı değil.
- Interstitial load/show ve privacy options çağrıları da exception-safe hale getirildi.
- Exact launcher ve analiz mimarisi değiştirilmedi.
- Reklam permission seti exact whitelist olarak kontrol ediliyor; SDK sessizce yeni permission eklerse CI fail ediyor.

CI run `33962525980` / job `101296777913`: **SUCCESS**.
PASS:
- private Play upload key + certificate fingerprint
- package `com.zmilastudio.takipanalizi`
- versionName `1.0.0`, versionCode `3`
- target/compile SDK 36
- `flutter analyze` clean
- **23/23 test**
- signed release APK build
- signer verification
- `allowBackup=false`, `usesCleartextTraffic=false`
- Google test AdMob App ID merged
- debuggable/testOnly yok
- merged release manifestte **`MobileAdsInitProvider` yok**
- exact reklam permission whitelist PASS
- exact launcher resource table PASS
- artifact upload PASS

Artifact:
- ad `takip-analizi-ads-startup-safe-rc-apk-1.0.0-3`
- ID `9968483492`
- ZIP boyutu `31,114,323` byte
- ZIP digest `sha256:21e1497977974f645db73e2097b387e815693fef6290ef179987c9fe38b3e8f1`
- APK boyutu `64,743,709` byte
- APK SHA-256 `e0185d2f33f643e0c14814f8f812df00d84787a995e08f2adee0c4a8d6a723b7`
- Artifact içindeki `.sha256` ile bağımsız yerel hash eşleşmesi PASS.
- Taze kullanıcı handoff dosyası yeniden çıkarıldı: `Takip-Analizi-1.0.0-3-ads-startup-safe-test-rc.apk`.
- Backup `backup/ads-v1-startup-crash-baseline` startup-fix öncesi reklamlı dal durumunu koruyor.
- **Fiziksel PASS henüz yok.** İlk kritik doğrulama yalnız uygulamanın açılışta artık çökmemesi olacak.

### Reklamlı merged Android permission set — GERÇEK RC’DEN
Google Mobile Ads 9.1.0 ile release merge sonucu ve `(3)` exact whitelist:
- `android.permission.ACCESS_ADSERVICES_AD_ID`
- `android.permission.ACCESS_ADSERVICES_ATTRIBUTION`
- `android.permission.ACCESS_ADSERVICES_TOPICS`
- `android.permission.ACCESS_NETWORK_STATE`
- `android.permission.FOREGROUND_SERVICE`
- `android.permission.INTERNET`
- `android.permission.WAKE_LOCK`
- `com.google.android.gms.permission.AD_ID`
- `com.zmilastudio.takipanalizi.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`

Notlar:
- Bunlar SDK/library merge izinleridir; sosyal medya arşivlerini okumak için geniş dosya/medya/contact/location/camera/mic/SMS/call-log izni eklenmedi.
- `MANAGE_EXTERNAL_STORAGE`, `READ/WRITE_EXTERNAL_STORAGE`, contacts, camera, mic, location, SMS, call log izinleri yok.
- Final production workflow’da bu permission seti exact whitelist olarak korunacak; SDK gelecekte yeni izin eklerse build duracak.

## Production privacy/security — REKLAMLI MODEL
- Analiz verisi local-first kalır.
- `android:allowBackup=false` korunur.
- `backup_rules.xml` ve `data_extraction_rules.xml` yerel app-managed veriyi backup/transfer kapsamı dışında tutar.
- `android:usesCleartextTraffic=false` korunur.
- AdMob nedeniyle production merged manifest artık INTERNET/network ve reklam SDK izinleri içerir; eski “production INTERNET yok” sözleşmesi reklamlı final için geçerli değildir.
- Kullanıcının sosyal medya şifresi istenmez.
- Dosya erişimi sistem file picker ile kullanıcı seçimine bağlı kalır.
- Reklam SDK veri işlemesi Privacy/Data Safety’de ayrıca beyan edilir.

## Privacy / Play belgeleri — REKLAM MODELİNE GÜNCELLENDİ
`dev/ads-v1` üzerinde:
- `PRIVACY_POLICY.md` reklamlı modele göre TR+EN güncellendi.
- `PLAY_STORE_DATA_SAFETY.md` reklam SDK veri işlemesiyle güncellendi.
- `PLAY_CONSOLE_FORM_ANSWERS.md`: Ads → **Yes**; Data Safety artık reklamsızdaki “No” cevabı değildir. Google Mobile Ads’in işlediği veri türleri final Play formunda SDK dokümanına göre beyan edilecek.
- Uygulama içi `Gizlilik ve Hakkında` ekranı aynı modele güncellendi.
- Public `main` privacy metni final canlı reklam build kilitlenince aynı içeriğe taşınacak.

Google Mobile Ads için değerlendirmeye alınan reklam veri sınıfları:
- IP address / approximate location türetimi
- app interactions
- diagnostics
- device/advertising identifiers
- advertising / analytics / fraud prevention amaçları
Kesin Play Data Safety işaretleri final SDK davranışı ve Google’ın güncel disclosure dokümanıyla tekrar eşleştirilecek.

## Production signing — HAZIR
- Private Play upload key: JKS, alias `takip-upload`, RSA 3072, SHA256withRSA.
- Upload certificate SHA-256 `def6c59b9a84f51af6ea5c768f21927ecbadb868ec5dbcd17dc031876b5cca65`.
- Keystore ↔ PEM fingerprint PASS; private-key signing self-test PASS.
- Keystore SHA-256 `4ff8c92eb4ca8074d75791d3a753c1290232bb13b79aa121c26fe059f788a192`.
- Private keystore/parolalar repoya commit edilmedi.
- GitHub Repository Secrets 5/5 TAMAM: `PLAY_UPLOAD_KEYSTORE_B64`, `PLAY_UPLOAD_STORE_PASSWORD`, `PLAY_UPLOAD_KEY_ALIAS`, `PLAY_UPLOAD_KEY_PASSWORD`, `PLAY_UPLOAD_CERT_SHA256`.

## Eski reklamsız Production AAB/APK — ARŞİV BASELINE, FINAL DEĞİL
Reklam kararı öncesi production RC teknik olarak başarılıydı fakat artık final yayın adayı değildir.
- AAB success run `33627604993`; artifact `takip-analizi-production-rc-1.0.0-1`.
- Reklamsız production APK success run `33658171635`.
- Reklamsız APK SHA-256 `355a9687b72fc080b1b3d23d5e06fab2149c185d6142f31c02a5532fad765aca`.
- Bunlar rollback/reference baseline olarak korunur.

## Play Console / Play App Signing — BEKLEMEDE
- Reklamlı final build fiziksel PASS almadan Play Console’a final yükleme yapılmayacak.
- Doğrulanacak upload certificate SHA-256 `def6c59b9a84f51af6ea5c768f21927ecbadb868ec5dbcd17dc031876b5cca65`.
- Canlı AdMob App ID + banner unit ID + interstitial unit ID henüz oluşturulup projeye bağlanmadı.
- Play Console Ads beyanı: **Yes** olacak.
- Data Safety reklam SDK’sı nedeniyle yeniden doldurulacak.

## Store görselleri
- Exact 512×512 icon SHA-256 `c838ffe6ef39bab9cab0176951334f8dc79e0158fc02755cb27ca28c856ae717`.
- TR feature graphic 1024×500 SHA-256 `73d4e9eec5564945813f2d6fc9aa9206693979a7c68c126dcf5cce63a4afc838`.
- EN feature graphic 1024×500 SHA-256 `e6b2da9520d4a95a2762337f0e09d558e5aeacb91cb3902e371a8453a12f0bf1`.
- 8 gerçek-app screenshot hedefi: 1080×1920, 9:16, sentetik demo verisi, production RC üzerinden.

## Branch durumu
- `test/device-apk` → v2-39 fiziksel tested baseline.
- `backup/device-v2-39-release-hardening-ci-working` korunuyor.
- `backup/pre-production-rc-aapt-fix` korunuyor.
- `backup/pre-ads-v1` → reklam entegrasyonu öncesi güvenli production hazırlığı.
- `backup/ads-v1-startup-crash-baseline` → reklamlı `(2)` startup crash döneminin güvenli referansı.
- `dev/release-polish-v1` → reklamsız production/store baseline.
- `dev/ads-v1` → startup-safe `1.0.0 (3)` Ads RC CI SUCCESS; fiziksel PASS bekliyor.
- `dev/ads-startup-safe-v1` → provider-free, delayed/fail-closed reklam startup düzeltmesinin hazırlık branch’i.
- `test/production-rc-apk-1.0.0-1` → eski reklamsız production RC APK.
- `main` → public privacy/support + production workflow; reklamlı final privacy henüz main’e taşınmadı.

## Sıradaki iş — KİLİTLİ SIRA
1. Kullanıcı Samsung cihazda `1.0.0 (3)` startup-safe Google test reklamlı APK’yı `(2)` üzerine kuracak.
2. İlk kritik fiziksel doğrulama: uygulama normal açılıyor mu, `sürekli olarak duruyor` hatası ortadan kalktı mı?
3. Açılış PASS olursa aynı tek fiziksel turda banner, Instagram gerçek analiz, 5 liste, interstitial, persistence ve X smoke tamamlanacak.
4. Fiziksel PASS sonrası AdMob Console’da gerçek Android uygulaması `com.zmilastudio.takipanalizi` oluşturulacak/bağlanacak.
5. Canlı `App ID`, adaptive banner ad unit ve interstitial ad unit oluşturulacak.
6. Canlı ID’ler repoya sabitlenmeden secure CI inputs/secrets üzerinden final AAB build’e verilecek.
7. Reklamlı final signed AAB hazırlanacak; public privacy `main` güncellenecek.
8. Play App Signing fingerprint doğrulaması + Internal testing.
9. Play Console Ads / Data Safety / IARC / 18+ / app access tamamlanacak.
10. Feature graphic final onayı + 8 store screenshot.