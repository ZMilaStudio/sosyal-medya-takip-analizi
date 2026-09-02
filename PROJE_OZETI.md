# PROJE_OZETI

Son güncelleme: 2 Eylül 2026

## Çalışma protokolü
- Her yeni iş başlangıcında bu dosya + canlı GitHub repo okunur; bunlar gerçeklik kaynağıdır.
- Çalışan CI/fiziksel baseline korunur; riskli değişikliklerde backup branch kullanılır.
- Küçük değişiklikler için ayrı fiziksel PASS döngüsü yapılmaz. Geliştirme toplu ilerler; yalnız kritik production RC noktasında tek fiziksel doğrulama yapılır.
- GitHub Actions kotası korunur; dev branch’te toplu hazırlanıp gerektiğinde tek run çalıştırılır.
- Exact launcher/logo kullanıcının onaylı rasterıdır; yeniden çizilmez, image generation ile regenerate edilmez, yaklaşık/alternatif simgeyle değiştirilmez.

## Ürün
Android öncelikli Flutter + Dart, local-first Instagram ve X/Twitter takip analizi uygulaması.

### Instagram
- Yalnız resmi Meta veri dışa aktarma ZIP içindeki JSON/HTML takip ilişkisi dosyaları analiz edilir.
- Multipart followers ve `following.json` varyasyonları desteklenir.
- Scraping/private API/Instagram şifresi/otomatik follow-unfollow yok.

### X / Twitter
- Resmi X veri arşivi local analiz edilir.
- ZIP import desteklenir; çok büyük arşivlerde `follower.js` + `following.js` doğrudan seçilebilir.
- `window.YTD.*` JS formatı ve accountId tabanlı kimlik desteklenir.
- Handle yoksa sahte @handle üretilmez; ID açık gösterilir.
- X şifresi istenmez.

### Ortak özellikler
- 5 kategori: Takip Etmeyenler, Karşılıklı, Seni Takip Edenler, Takibi Bırakanlar, Yeni Takipçiler.
- Snapshot/geçmiş cihazda tutulur; yeni import önceki snapshot ile otomatik karşılaştırılır.
- Aynı platform + aynı hesaptaki iki keyfi snapshot manuel karşılaştırılabilir.
- Arama + A-Z/Z-A; profil bağlantısı harici uygulama/tarayıcıda açılır.
- Yok say / geri yükle platform + hesap bazında local tutulur.
- Son hesaplar hızlı seçim; geçmişte platform + hesap filtreleri.
- Tek snapshot / seçili hesap geçmişi silme.
- Analiz raporu: panoya kopyala + TXT kaydet.
- Yerel Veri Yönetimi: geçmiş / Yok say / tüm local app verisini onaylı silme.
- Instagram ve X arşiv rehberleri; Gizlilik ve Hakkında ekranı.

## Fiziksel doğrulama özeti
- Gerçek Meta export örneği: 569 takipçi, 1053 takip edilen, 792 takip etmeyen, 261 karşılıklı, 308 yalnız takipçi.
- `gece02.19`: eski 75/53, yeni 74/46; Takibi Bırakanlar 6 + Yeni Takipçiler 5; `75 - 6 + 5 = 74`.
- Gerçek listeler Samsung fiziksel cihazda render edildi ve kullanıcı PASS verdi.

## Önemli baseline’lar
- v2-16 liste, v2-17 profil linki, v2-21 Yok say, v2-22 arama/sıralama, v2-23 5 sekme, v2-26 exact launcher: fiziksel PASS.
- v2-28 X archive, v2-29 recent/history filters, v2-30 history data management, v2-32 report export, v2-37 product polish, v2-38 release polish: CI SUCCESS.

# GÜNCEL GÜVENLİ CI BASELINE — v2-39
- Tested commit: `0816b8811aae6cf7aa2be67e63c524156093507b`.
- Actions run: `33551771267` / run #39 — SUCCESS.
- Prerelease: `device-test-v2-39`.
- Test package: `com.zmilastudio.takipanalizi.dev`.
- versionName `1.0.0-dev`, VersionCode `300039`, compileSdk/targetSdk 36/36.
- APK SHA-256: `d18151fbc8c75897abd14934cc71b9ef29911b1d035cb6c1670a176fac9dde97`.
- Test signer SHA-256: `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`.
- Exact launcher SHA-256: `7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`.
- Backup: `backup/device-v2-39-release-hardening-ci-working`.
- Analyze PASS, 23/23 tests PASS, launcher/signing/package/version/API36/backup/cleartext guards PASS.

## Production Android privacy/security
- Source manifest: app-defined `uses-permission` yok, INTERNET yok, `allowBackup=false`, `fullBackupContent=@xml/backup_rules`, `dataExtractionRules=@xml/data_extraction_rules`, `usesCleartextTraffic=false`.
- Android 11 ve altı backup; Android 12+ cloud-backup + device-transfer alanları exclude.
- Production merged manifest guard: targetSdk36, backup=false, cleartext=false, INTERNET yok, debuggable/testOnly yok.
- Yalnız `com.zmilastudio.takipanalizi.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` AndroidX internal signature iznine tolerans vardır.
- Impeller kapalı fiziksel uyumluluk kararı korunur.

## Production kimliği / sürümü
- Production package: `com.zmilastudio.takipanalizi`.
- Device-test package: `com.zmilastudio.takipanalizi.dev`.
- İlk production: `1.0.0+1` / versionName `1.0.0` / versionCode `1` / API36.
- İlk production RC temiz production kurulum olarak test edilecek; `.dev` verisini devralmaz.

## Production signing — UPLOAD KEY HAZIR
2 Eylül 2026’da kullanıcı onayıyla private Play upload key oluşturuldu.
- Keystore: JKS; alias `takip-upload`; RSA 3072; SHA256withRSA; 10000 gün.
- Upload certificate SHA-256: `def6c59b9a84f51af6ea5c768f21927ecbadb868ec5dbcd17dc031876b5cca65`.
- Keystore ↔ PEM fingerprint eşleşmesi PASS; private-key signing self-test PASS.
- Keystore SHA-256: `4ff8c92eb4ca8074d75791d3a753c1290232bb13b79aa121c26fe059f788a192`.
- Private keystore/parolalar repoya commit edilmedi; güvenli bundle içinde keystore + public PEM + `GITHUB_SECRETS.txt` + recovery/checksum bilgileri var.

Production workflow secret adları:
- `PLAY_UPLOAD_KEYSTORE_B64`
- `PLAY_UPLOAD_STORE_PASSWORD`
- `PLAY_UPLOAD_KEY_ALIAS`
- `PLAY_UPLOAD_KEY_PASSWORD`
- `PLAY_UPLOAD_CERT_SHA256`

## Repository secret giriş durumu
2 Eylül 2026 manuel giriş oturumu:
- `PLAY_UPLOAD_KEYSTORE_B64` — TAMAM.
- `PLAY_UPLOAD_STORE_PASSWORD` — TAMAM.
- `PLAY_UPLOAD_KEY_ALIAS` — TAMAM (`takip-upload`).
- `PLAY_UPLOAD_KEY_PASSWORD` — TAMAM.
- `PLAY_UPLOAD_CERT_SHA256` — SIRADAKİ / henüz tamamlanmadı.

Kurallar:
- Secret değerleri sohbet metnine veya repoya yazılmaz.
- Bu oturumdaki GitHub connector repository secrets write endpoint’i sunmuyor; kullanıcı GitHub Settings → Secrets and variables → Actions üzerinden manuel giriyor.
- 5/5 tamamlanmadan production workflow çalıştırılmaz.

## Privacy / support — TAMAMLANDI
Public `main`:
- Privacy: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md`
- Support: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md`
- E-posta: `zmilastudio@gmail.com`.

## Play Console hazırlığı
Hazır dosyalar:
- `PRIVACY_POLICY.md`, `SUPPORT.md`, `PLAY_STORE_DATA_SAFETY.md`, `PLAY_CONSOLE_FORM_ANSWERS.md`.
- `PLAY_STORE_LISTING_TR.md`, `PLAY_STORE_LISTING_EN.md`, `PLAY_RELEASE_NOTES.md`.
- `PLAY_CONSOLE_LAUNCH_PACK.md`, `RELEASE_CHECKLIST.md`, `SIGNING_SETUP.md`.
- `STORE_VISUAL_CAPTURE_PLAN.md`, `STORE_ICON_DERIVATION.md`, `FEATURE_GRAPHIC.md`.

Mevcut Console önerileri:
- Data Safety collection/sharing: No — mevcut local-only mimari için.
- Ads: No; App access/login: No; kendi user account’u yok.
- Target audience: 18+; Category: Tools/Araçlar.
- News/government/health/financial: No.
- IARC sonucu Console’dan alınacak.

## Store listing / görseller
- App name: `Takip Analizi`.
- TR short: `Instagram ve X takip ilişkilerini arşivlerinden cihazında analiz et.`
- Exact 512×512 store icon hazır; SHA-256 `c838ffe6ef39bab9cab0176951334f8dc79e0158fc02755cb27ca28c856ae717`; yalnız resize, redraw yok.
- TR feature graphic 1024×500 SHA-256 `73d4e9eec5564945813f2d6fc9aa9206693979a7c68c126dcf5cce63a4afc838`.
- EN feature graphic 1024×500 SHA-256 `e6b2da9520d4a95a2762337f0e09d558e5aeacb91cb3902e371a8453a12f0bf1`.
- Feature graphic adayları final kullanıcı görsel onayı bekliyor.
- 8 gerçek-app store screenshot hedefi: 1080×1920, 9:16, sentetik demo verisi, production RC üzerinden.

## Branch durumu
- `test/device-apk` → tested v2-39 commit `0816b8811aae6cf7aa2be67e63c524156093507b`.
- `backup/device-v2-39-release-hardening-ci-working` → aynı tested commit.
- `dev/release-polish-v1` → v2-39 üstünde production workflow/docs/signing/store hazırlığı; runtime değişiklik yok.
- Public `main` → privacy/support docs.

## Production’a kalan ana kapılar
1. `PLAY_UPLOAD_CERT_SHA256` secret’ını ekle ve repository secrets’i 5/5 tamamla.
2. Google Play App Signing durumunu Play Console’da doğrula.
3. Production RC AAB workflow’unu `1.0.0 / 1` ile çalıştır.
4. Gerçek AAB’de package/version/API36/signing/merged manifest guard’larını PASS kapat.
5. Play Console Data Safety / IARC / 18+ / app access deklarasyonlarını tamamla.
6. Feature graphic finalini onayla; production RC ile 8 store screenshot çek.
7. Production RC temiz kurulum + local persistence + gerçek X arşivi tek kritik fiziksel PASS.

## Sıradaki iş
- Son secret: `PLAY_UPLOAD_CERT_SHA256`.
- Secret tamamlanınca production workflow öncesi branch/workflow son kontrolü yapılacak.
- Yeni Device Test Actions çalıştırılmayacak; v2-39 güvenli baseline yeterli.