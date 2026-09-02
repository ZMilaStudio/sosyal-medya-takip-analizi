# PROJE_OZETI

Son güncelleme: 2 Eylül 2026

## Çalışma protokolü
- Her yeni iş başlangıcında bu dosya + canlı GitHub repo okunur.
- Çalışan CI/fiziksel baseline korunur; gereksiz Actions çalıştırılmaz.
- Küçük değişiklikler için ayrı fiziksel PASS turu yapılmaz; production RC noktasında tek kritik cihaz doğrulaması yapılır.
- Exact launcher/logo kullanıcı onaylı rasterdır; yeniden çizilmez veya regenerate edilmez.
- CI success fiziksel PASS sayılmaz; fiziksel başarı yalnız kullanıcı cihaz doğrulamasıyla yazılır.

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

## Production privacy/security
- Production source manifest: app-defined permission yok, INTERNET yok, `allowBackup=false`, `usesCleartextTraffic=false`.
- Android backup/data-transfer app-managed local veri alanları exclude.
- Merged release manifest: targetSdk36, backup=false, cleartext=false, INTERNET yok, debuggable/testOnly yok.
- Yalnız `com.zmilastudio.takipanalizi.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` AndroidX internal signature izni toleranslı.
- Impeller kapalı mevcut fiziksel uyumluluk kararı korunur.

## Production kimliği
- Package `com.zmilastudio.takipanalizi`.
- İlk production `1.0.0+1`; versionName `1.0.0`; versionCode `1`; target/compile SDK 36.
- `.dev` paketinden farklıdır; ilk production fiziksel test temiz kurulumdur ve `.dev` verisini devralmaz.

## Production signing — HAZIR
- Private Play upload key: JKS, alias `takip-upload`, RSA 3072, SHA256withRSA.
- Upload certificate SHA-256 `def6c59b9a84f51af6ea5c768f21927ecbadb868ec5dbcd17dc031876b5cca65`.
- Keystore ↔ PEM fingerprint PASS; private-key signing self-test PASS.
- Keystore SHA-256 `4ff8c92eb4ca8074d75791d3a753c1290232bb13b79aa121c26fe059f788a192`.
- Private keystore/parolalar repoya commit edilmedi.
- GitHub Repository Secrets 5/5 TAMAM: `PLAY_UPLOAD_KEYSTORE_B64`, `PLAY_UPLOAD_STORE_PASSWORD`, `PLAY_UPLOAD_KEY_ALIAS`, `PLAY_UPLOAD_KEY_PASSWORD`, `PLAY_UPLOAD_CERT_SHA256`.

## Production AAB — SUCCESS
- Workflow `.github/workflows/production-rc-aab.yml`; normal durum manual-only `workflow_dispatch`.
- İlk run `33616493137` failure: signing değil; artık kullanılmayan legacy launcher kaynaklarında AAPT2 resource compile hatası. Backup `backup/pre-production-rc-aapt-fix`.
- Cleanup sonrası başarılı run `33627604993` / #30.
- AAB build snapshot head `93eec18cd6ee53ccc0eaca8fc9df20f921089bd5`.
- PASS: signing secrets/key/fingerprint, source guards, analyze, 23/23 test, signed AAB build, merged manifest, signer, exact launcher, artifact upload.
- Artifact `takip-analizi-production-rc-1.0.0-1`, ID `9845630572`, ZIP `59,884,526` byte, artifact digest `sha256:a51a24ca088af43ac6ef5b9e237e6b6ac58cef7c981f61f068c484fc5092df70`.
- Kullanıcı production AAB ZIP paketini cihazına başarıyla indirdi.

## Production kurulabilir APK — HAZIR, FİZİKSEL PASS BEKLİYOR
- Kullanıcı Play Console aşamasına geçerken production APK ile fiziksel test yapılmadığını fark etti; bu doğru kabul edildi. Play Console kapısı fiziksel test bitene kadar durduruldu.
- AAB ile aynı runtime snapshot `93eec18cd6ee53ccc0eaca8fc9df20f921089bd5` temel alınarak `test/production-rc-apk-1.0.0-1` branch oluşturuldu. Sonraki commitler yalnız APK workflow doğrulaması; uygulama runtime kodu değişmedi.
- Workflow `.github/workflows/production-rc-apk.yml` production upload key ile signed release APK üretir.
- İlk APK run `33657387386`: APK build SUCCESS; package/version/targetSdk/signer/manifest kontrolleri PASS; yalnız yanlış `unzip` launcher-path guard'ı failure oldu. APK sorunu değildi.
- Guard Android resource table üzerinden düzeltildi.
- İkinci APK run `33658171635`: **SUCCESS**.
- PASS: private upload key/fingerprint, production source identity + exact launcher source hash, signed release APK build, APK signer, package `com.zmilastudio.takipanalizi`, version `1.0.0 (1)`, targetSdk36, backup=false, cleartext=false, INTERNET yok, debuggable/testOnly yok, launcher resource table, artifact upload.
- Artifact adı `takip-analizi-production-rc-apk-1.0.0-1`; ID `9857778252`; ZIP `28,700,652` byte; artifact digest `sha256:8d56c3c9ea2648a804280a97269e8ef9b302fe44b7b42d2ed12d2fc85a64a9f9`.
- Çıkarılan doğrudan APK boyutu `61,698,385` byte.
- Production APK SHA-256 `355a9687b72fc080b1b3d23d5e06fab2149c185d6142f31c02a5532fad765aca`; workflow `.sha256` dosyasıyla bağımsız hash eşleşmesi PASS.
- Kullanıcıya verilecek dosya: `Takip-Analizi-1.0.0-production-rc.apk`.
- Bu APK upload key ile yerel fiziksel RC testine uygundur. Play App Signing etkinleşince Play üzerinden dağıtılan APK'lar Google'ın app-signing key'i ile imzalanacaktır; runtime doğrulama amacı aynıdır fakat dağıtım imzası farklı olacaktır.
- Production fiziksel PASS henüz verilmedi.

## Play Console / Play App Signing — FİZİKSEL TEST SONRASINA BEKLİYOR
- Güncel yol: uygulama → `Google Play ile korunanlar` / bazı hesaplarda `Test edin ve yayınlayın > Uygulama bütünlüğü` → Play App Signing.
- Doğrulanacak upload certificate SHA-256 `def6c59b9a84f51af6ea5c768f21927ecbadb868ec5dbcd17dc031876b5cca65`.
- AAB `1.0.0 (1)` internal testing için hazır ancak production APK fiziksel PASS verilmeden yükleme sürecine devam edilmeyecek.

## Privacy / Play hazırlığı
Hazır: `PRIVACY_POLICY.md`, `SUPPORT.md`, `PLAY_STORE_DATA_SAFETY.md`, `PLAY_CONSOLE_FORM_ANSWERS.md`, `PLAY_STORE_LISTING_TR.md`, `PLAY_STORE_LISTING_EN.md`, `PLAY_RELEASE_NOTES.md`, `PLAY_CONSOLE_LAUNCH_PACK.md`, `RELEASE_CHECKLIST.md`, `SIGNING_SETUP.md`, `STORE_VISUAL_CAPTURE_PLAN.md`, `STORE_ICON_DERIVATION.md`, `FEATURE_GRAPHIC.md`.
- Data Safety mevcut local-only mimari için collection/sharing No.
- Ads No; özel login/app access No; kendi user account'u yok; target audience 18+; Tools/Araçlar.

## Store görselleri
- Exact 512×512 icon SHA-256 `c838ffe6ef39bab9cab0176951334f8dc79e0158fc02755cb27ca28c856ae717`.
- TR feature graphic 1024×500 SHA-256 `73d4e9eec5564945813f2d6fc9aa9206693979a7c68c126dcf5cce63a4afc838`.
- EN feature graphic 1024×500 SHA-256 `e6b2da9520d4a95a2762337f0e09d558e5aeacb91cb3902e371a8453a12f0bf1`.
- 8 gerçek-app screenshot hedefi: 1080×1920, 9:16, sentetik demo verisi, production RC üzerinden.

## Branch durumu
- `test/device-apk` → v2-39 tested baseline.
- `backup/device-v2-39-release-hardening-ci-working` korunuyor.
- `backup/pre-production-rc-aapt-fix` korunuyor.
- `dev/release-polish-v1` → production AAB success + release/store hazırlığı.
- `test/production-rc-apk-1.0.0-1` → production RC APK SUCCESS; runtime AAB snapshot ile aynı.
- `main` → privacy/support + production AAB workflow dispatch tanımı.

## Sıradaki iş — KİLİTLİ SIRA
1. Kullanıcı `Takip-Analizi-1.0.0-production-rc.apk` dosyasını Samsung cihazına **temiz kurulum** ile yükler.
2. Tek kritik production fiziksel test: uygulama açılışı + exact launcher; Instagram gerçek export import/listeler; uygulamayı tamamen kapat/aç ve local persistence; gerçek X arşivi; profil linki; Yok say/geri al; geçmiş/karşılaştırma temel smoke.
3. Fiziksel PASS sonrası Play Console → Play App Signing fingerprint doğrulaması.
4. AAB `1.0.0 (1)` Internal testing sürümüne yüklenir.
5. Data Safety / IARC / 18+ / app access alanları tamamlanır.
6. Feature graphic final onayı + production RC ile sentetik demo 8 store screenshot.
