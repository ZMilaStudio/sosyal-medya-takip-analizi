# PROJE_OZETI

Son güncelleme: 2 Eylül 2026

## Çalışma protokolü
- Her yeni iş başlangıcında bu dosya + canlı GitHub repo okunur.
- Çalışan CI/fiziksel baseline korunur; gereksiz Actions çalıştırılmaz.
- Küçük değişiklikler için ayrı fiziksel PASS turu yapılmaz; yalnız production RC noktasında tek kritik cihaz doğrulaması yapılır.
- Exact launcher/logo kullanıcı onaylı rasterdır; yeniden çizilmez, image generation ile regenerate edilmez.

## Ürün
Android öncelikli Flutter + Dart, local-first Instagram ve X/Twitter takip analizi.
- Instagram: resmi Meta export ZIP içindeki JSON/HTML; scraping/private API/şifre/otomatik follow-unfollow yok.
- X: resmi arşiv ZIP; büyük arşivlerde `follower.js` + `following.js`; `window.YTD.*`; ID-only hesaplar sahte handle olmadan tutulur.
- 5 kategori: Takip Etmeyenler, Karşılıklı, Seni Takip Edenler, Takibi Bırakanlar, Yeni Takipçiler.
- Snapshot/geçmiş, otomatik ve manuel karşılaştırma, arama/sıralama, profil linki, Yok say, son hesaplar, geçmiş filtreleri/silme, rapor kopyala/TXT, Yerel Veri Yönetimi, rehberler, Gizlilik ve Hakkında.

## Fiziksel doğrulama
- Gerçek Meta export örneği: 569 takipçi / 1053 takip edilen / 792 takip etmeyen / 261 karşılıklı / 308 yalnız takipçi.
- `gece02.19`: 75/53 → 74/46; Takibi Bırakanlar 6 + Yeni Takipçiler 5; `75 - 6 + 5 = 74`.
- Gerçek listeler Samsung fiziksel cihazda render edildi ve kullanıcı PASS verdi.

## Güvenli baseline — v2-39
- Tested commit `0816b8811aae6cf7aa2be67e63c524156093507b`.
- Actions run `33551771267` / #39 — SUCCESS.
- Test package `com.zmilastudio.takipanalizi.dev`; versionName `1.0.0-dev`; VersionCode `300039`; API36.
- APK SHA-256 `d18151fbc8c75897abd14934cc71b9ef29911b1d035cb6c1670a176fac9dde97`.
- Test signer SHA-256 `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`.
- Exact launcher SHA-256 `7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`.
- Analyze PASS, 23/23 tests PASS, package/version/API36/signing/launcher/backup/cleartext guards PASS.
- Backup `backup/device-v2-39-release-hardening-ci-working`.

## Production privacy/security
- Production source manifest: app-defined permission yok, INTERNET yok, `allowBackup=false`, `usesCleartextTraffic=false`.
- Android backup/data-transfer app-managed local veri alanları exclude.
- Production merged manifest guard: targetSdk36, backup=false, cleartext=false, INTERNET yok, debuggable/testOnly yok.
- Yalnız `com.zmilastudio.takipanalizi.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` AndroidX internal signature izni toleranslı.
- Impeller kapalı mevcut fiziksel uyumluluk kararı korunur.

## Production kimliği
- Production package `com.zmilastudio.takipanalizi`.
- İlk production `1.0.0+1` / versionName `1.0.0` / versionCode `1` / API36.
- `.dev` paketinden farklıdır; ilk production RC temiz kurulum olarak test edilecek.

## Production signing — HAZIR
- 2 Eylül 2026 private Play upload key oluşturuldu.
- JKS; alias `takip-upload`; RSA 3072; SHA256withRSA.
- Upload certificate SHA-256 `def6c59b9a84f51af6ea5c768f21927ecbadb868ec5dbcd17dc031876b5cca65`.
- Keystore ↔ PEM fingerprint PASS; private-key signing self-test PASS.
- Keystore SHA-256 `4ff8c92eb4ca8074d75791d3a753c1290232bb13b79aa121c26fe059f788a192`.
- Private keystore/parolalar repoya commit edilmedi; güvenli signing bundle mevcut.

## Repository secrets — 5/5 TAMAM
Kullanıcı GitHub Settings → Secrets and variables → Actions üzerinden manuel girdi:
- `PLAY_UPLOAD_KEYSTORE_B64` — TAMAM.
- `PLAY_UPLOAD_STORE_PASSWORD` — TAMAM.
- `PLAY_UPLOAD_KEY_ALIAS` — TAMAM (`takip-upload`).
- `PLAY_UPLOAD_KEY_PASSWORD` — TAMAM.
- `PLAY_UPLOAD_CERT_SHA256` — TAMAM.
- Secret değerleri sohbet veya repo içine yazılmadı.

## Production RC workflow
- Workflow: `.github/workflows/production-rc-aab.yml`.
- Dev branch sürümü son kontrolde sağlam: signing secret doğrulama, upload certificate fingerprint, source guards, analyze, 23 test, signed AAB build, merged manifest güvenlik guard, AAB signer doğrulama, exact launcher kontrolü, SHA256 üretimi, 1 gün artifact retention.
- `workflow_dispatch` inputs: `version_name=1.0.0`, `version_code=1`.
- GitHub manual workflow görünürlüğü için workflow aynı güvenli içerikle `main` branch’e eklendi.
- `main` commit: `d20b6312660a9d94ac29074e224c3371cb208822`.
- Production kodu/runtime hâlâ `dev/release-polish-v1` branch’te; workflow çalıştırılırken bu branch seçilecek.
- Bu oturumdaki GitHub connector `workflow_dispatch` başlatma action’ı sunmuyor; workflow başlatmak için GitHub UI’da tek manuel `Run workflow` gerekir. Run oluştuktan sonra connector ile run/job/log/artifact takibi yapılabilir.

## Privacy / Play hazırlığı
Hazır: `PRIVACY_POLICY.md`, `SUPPORT.md`, `PLAY_STORE_DATA_SAFETY.md`, `PLAY_CONSOLE_FORM_ANSWERS.md`, `PLAY_STORE_LISTING_TR.md`, `PLAY_STORE_LISTING_EN.md`, `PLAY_RELEASE_NOTES.md`, `PLAY_CONSOLE_LAUNCH_PACK.md`, `RELEASE_CHECKLIST.md`, `SIGNING_SETUP.md`, `STORE_VISUAL_CAPTURE_PLAN.md`, `STORE_ICON_DERIVATION.md`, `FEATURE_GRAPHIC.md`.
- Data Safety önerisi mevcut local-only mimari için collection/sharing No.
- Ads No; özel login/app access No; kendi user account’u yok; target audience 18+; Tools/Araçlar.
- IARC sonucu Play Console tarafından üretilecek.

## Store görselleri
- Exact 512×512 icon hazır; SHA-256 `c838ffe6ef39bab9cab0176951334f8dc79e0158fc02755cb27ca28c856ae717`.
- TR feature graphic 1024×500 SHA-256 `73d4e9eec5564945813f2d6fc9aa9206693979a7c68c126dcf5cce63a4afc838`.
- EN feature graphic 1024×500 SHA-256 `e6b2da9520d4a95a2762337f0e09d558e5aeacb91cb3902e371a8453a12f0bf1`.
- 8 gerçek-app screenshot hedefi: 1080×1920, 9:16, sentetik demo verisi, production RC üzerinden.

## Branch durumu
- `test/device-apk` → tested v2-39 `0816b8811aae6cf7aa2be67e63c524156093507b`.
- `backup/device-v2-39-release-hardening-ci-working` korunuyor.
- `dev/release-polish-v1` → production workflow/docs/signing/store hazırlığı; runtime değişiklik yok.
- `main` → privacy/support + production workflow dispatch tanımı.

## Sıradaki iş
1. GitHub Actions → `Production RC AAB` → `Run workflow`.
2. Branch olarak **`dev/release-polish-v1`** seç.
3. `version_name`: **`1.0.0`**.
4. `version_code`: **`1`**.
5. Run başlayınca run/job/log/artifact durumunu connector ile doğrula.
6. SUCCESS sonrası production AAB’yi indir; ardından Play App Signing, internal test ve tek kritik fiziksel production RC doğrulamasına geç.
