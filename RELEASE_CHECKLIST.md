# Takip Analizi — Production Release Checklist

Son güncelleme: 2 Eylül 2026

Bu checklist, **v2-39 release-hardening CI baseline** üzerinden Google Play production yayınına geçiş kapılarını izler.

## A. Kod / kalite

- [x] Analyze temiz — v2-39.
- [x] Tüm otomatik testler geçiyor — v2-39, 23 test.
- [x] Fiziksel-cihaz uyumluluk wiring kontrolü geçiyor.
- [x] Exact kullanıcı launcher asset’i hash ile kilitli.
- [x] Instagram gerçek arşivi fiziksel cihazda doğrulandı.
- [x] Gerçek Instagram snapshot farkları fiziksel cihazda doğrulandı.
- [x] X parser/import/snapshot akışı CI ile doğrulandı.
- [x] Uygulama içi `Gizlilik ve Hakkında` ekranı + Home girişi var.
- [x] Android backup / cleartext / production-source permission guard’ları v2-39 CI’da PASS.
- [x] Privacy ekranında backup ve user-initiated report export metni test edildi.
- [ ] Gerçek kullanıcı X arşiviyle tek kritik fiziksel doğrulama production RC turunda yapılacak.

## B. Android production kimliği

- [x] Production applicationId: `com.zmilastudio.takipanalizi`.
- [x] Device-test applicationId: `com.zmilastudio.takipanalizi.dev`.
- [x] Uygulama etiketi: `Takip Analizi`.
- [x] Launcher simgesi hazır ve hash ile korunuyor.
- [x] İlk production versionName/versionCode: **`1.0.0` / `1`**.
- [x] `apps/mobile/pubspec.yaml`: `version: 1.0.0+1`.
- [x] Production RC workflow varsayılan inputları `1.0.0` / `1`.
- [x] v2-39 badging: compileSdk 36 / targetSdk 36 / Android 16.
- [ ] Gerçek production AAB üzerinde package/version/targetSdk son kez doğrulanacak.

## C. Android privacy / security manifest sözleşmesi

Production kaynak manifesti:

- [x] App-defined `<uses-permission>` yok.
- [x] `android:allowBackup="false"`.
- [x] `android:fullBackupContent="@xml/backup_rules"`.
- [x] `android:dataExtractionRules="@xml/data_extraction_rules"`.
- [x] Android 11 ve altı backup rules: `root/file/database/sharedpref/external` exclude.
- [x] Android 12+ rules: aynı domainler `cloud-backup` + `device-transfer` için exclude.
- [x] `android:usesCleartextTraffic="false"`.

Merged release sözleşmesi:

- [x] AndroidX Core’un `${applicationId}.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` adlı app-scoped **signature-level internal** izni beklenen library davranışı olarak tanındı.
- [x] Bu izin runtime/user-data izni değildir; AndroidX’in non-exported dynamic receiver güvenliği içindir.
- [x] Production workflow yalnız bu AndroidX internal iznine tolerans gösterecek.
- [x] `android.permission.INTERNET` kesin olarak reddedilecek.
- [x] AndroidX internal izin dışında başka merged `uses-permission` reddedilecek.
- [x] `debuggable=true` ve `testOnly=true` reddedilecek.
- [x] `allowBackup=false`, cleartext=false ve targetSdk36 merged manifestte doğrulanacak.
- [ ] Bu merged-release kontrolleri gerçek production AAB workflow’unda PASS alacak.

## D. İmzalama

- [x] Device-test için ayrı sabit test sertifikası var.
- [x] Public test keystore production release’e bağlanmıyor.
- [x] Private signing dosyaları `.gitignore` ile korunuyor.
- [x] Release signing yalnız `PLAY_UPLOAD_*` secure environment değerleriyle bağlanıyor; test key fallback yok.
- [x] `SIGNING_SETUP.md` güncel Play App Signing / upload key modeline göre hazır.
- [x] Manuel `production-rc-aab.yml` signing secret + fingerprint kontrolleriyle hazır.
- [x] **Yeni private production upload key oluşturuldu — 2 Eylül 2026.**
- [x] Keystore: JKS; alias `takip-upload`; RSA 3072; `SHA256withRSA`; validity 10000 gün.
- [x] Upload certificate SHA-256: `def6c59b9a84f51af6ea5c768f21927ecbadb868ec5dbcd17dc031876b5cca65`.
- [x] Keystore fingerprint ile export edilen PEM fingerprint’i bağımsız olarak eşleşti.
- [x] Private key gerçek JAR imzalama self-testini geçti.
- [x] Private keystore/parolalar repoya commit edilmedi; yalnız güvenli yerel signing paketi oluşturuldu.
- [ ] Google Play App Signing durumu Console’da doğrulanacak.
- [ ] `PLAY_UPLOAD_*` GitHub Secrets gerçek değerlerle tanımlanacak.
- [ ] İlk signed production RC AAB workflow’u çalıştırılacak.

## E. Gizlilik ve Play politikaları

- [x] Final privacy policy TR + EN public `main` branch’te yayınlandı.
- [x] Privacy URL: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md`.
- [x] Support URL: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md`.
- [x] Destek / gizlilik e-postası: `zmilastudio@gmail.com`.
- [x] Policy local processing, backup exclusions, cleartext=false, AndroidX internal permission ve user-initiated report export ile eşleştirildi.
- [x] `PLAY_STORE_DATA_SAFETY.md` güncel.
- [x] `PLAY_CONSOLE_FORM_ANSWERS.md` güncel.
- [x] Reklam/analytics/cloud SDK’sı yok.
- [x] Uygulama içi yerel veri silme mekanizması var.
- [ ] Play Console Veri Güvenliği formu gerçek production AAB ile son kez karşılaştırılacak.
- [ ] IARC içerik derecelendirmesi Console’da tamamlanacak.
- [ ] Hedef kitle `18+` Console’da uygulanacak.
- [ ] App access: özel erişim gerekmez beyanı Console’da uygulanacak.

## F. Play Store mağaza içeriği

- [x] Türkçe listing: `PLAY_STORE_LISTING_TR.md`.
- [x] İngilizce listing: `PLAY_STORE_LISTING_EN.md`.
- [x] Uygulama adı: `Takip Analizi`.
- [x] TR kısa açıklama 68/80.
- [x] EN kısa açıklama 77/80.
- [x] Kategori: `Araçlar / Tools`.
- [x] Contact alanları privacy/support URL ve e-posta ile hazır.
- [x] `STORE_VISUAL_CAPTURE_PLAN.md`: 8 gerçek-app screenshot planı.
- [x] Sentetik Instagram/X store-demo snapshot ZIP’leri hazır.
- [x] 512×512 exact mağaza simgesi hazır.
  - RGB PNG, 169.565 byte.
  - SHA-256: `c838ffe6ef39bab9cab0176951334f8dc79e0158fc02755cb27ca28c856ae717`.
- [ ] Telefon screenshot’ları production RC’den alınacak.
- [ ] Gerekirse 7/10 inç tablet görselleri hazırlanacak.
- [ ] 1024×500 feature graphic hazırlanacak.
- [ ] Play Console’dan en fazla 5 gerçek ilgili tag seçilecek.

## G. Device Test release-hardening baseline

- [x] Commit: `0816b8811aae6cf7aa2be67e63c524156093507b`.
- [x] Run: `33551771267` — **SUCCESS**.
- [x] Prerelease: `device-test-v2-39`.
- [x] Package: `com.zmilastudio.takipanalizi.dev`.
- [x] versionName: `1.0.0-dev`.
- [x] VersionCode: `300039`.
- [x] APK size: `180,743,127` byte.
- [x] APK SHA-256: `d18151fbc8c75897abd14934cc71b9ef29911b1d035cb6c1670a176fac9dde97`.
- [x] Test signer SHA-256: `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`.
- [x] Exact launcher source SHA-256: `7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`.
- [x] Backup: `backup/device-v2-39-release-hardening-ci-working`.
- [x] Analyze + 23 tests + production-source backup/permission/cleartext preflight + APK signing/package/icon checks PASS.

Not: v2-39 debug APK’da `INTERNET` Flutter debug tooling nedeniyle ve `${applicationId}.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` AndroidX internal güvenlik mekanizması nedeniyle görünür. Production sözleşmesi ayrı merged release manifestte uygulanır.

## H. Production release build

- [x] Production RC workflow manuel; push’ta otomatik çalışmaz.
- [x] `flutter analyze` + tüm testler production build öncesi çalışır.
- [x] Private upload sertifikası fingerprint’i build öncesi ve AAB sonrası doğrulanır.
- [x] Exact launcher source guard var.
- [x] Merged release manifest targetSdk / izin / backup / cleartext / debuggable/testOnly guard’ları var.
- [x] AAB artifact retention 1 gün.
- [x] Private upload key hazır ve locally self-tested.
- [ ] GitHub repository secrets tanımlandıktan sonra signed production AAB üretilecek.
- [ ] AAB package id = `com.zmilastudio.takipanalizi` doğrulanacak.
- [ ] versionName/versionCode gerçek AAB üzerinde doğrulanacak.
- [ ] Upload signer fingerprint `def6c59b9a84f51af6ea5c768f21927ecbadb868ec5dbcd17dc031876b5cca65` olarak PASS olacak.
- [ ] AAB boyutu ve native kütüphaneler kontrol edilecek.

## I. Son cihaz testi — ilk production 1.0.0

**Önemli:** `.dev` device-test ve production farklı applicationId’dir. İlk production `1.0.0`, v2-39 `.dev` üstüne upgrade değildir ve `.dev` verisini devralmamalıdır.

İlk production RC turunda:

- [ ] Production package temiz kurulum olarak Play Internal Testing / uygun production-signed dağıtım üzerinden yüklenir.
- [ ] Package id `com.zmilastudio.takipanalizi` doğrulanır.
- [ ] Instagram demo snapshot 1 + snapshot 2 aynı hesapla import edilir.
- [ ] 5 analiz sekmesi.
- [ ] Arama/sıralama.
- [ ] Profil açma.
- [ ] Yok say / geri yükle.
- [ ] Analiz geçmişi + manuel snapshot karşılaştırma.
- [ ] Raporu kopyala / TXT kaydet.
- [ ] Yerel Veri Yönetimi.
- [ ] Güncel Gizlilik ve Hakkında ekranı.
- [ ] X demo snapshot 1 + snapshot 2.
- [ ] X direct JS fallback + X rehberi.
- [ ] Uygulama kapat/aç ile aynı production kurulumunda local geçmiş kalıcılığı.
- [ ] Gerçek kullanıcı X arşiviyle tek kritik fiziksel doğrulama.

Gerçek production upgrade/veri koruma testi, ancak production `1.0.0` sonrasında versionCode>1 aynı package üzerinde yapılabilir.

## J. Yayın kararı

Aşağıdaki dört madde tamamlanmadan production rollout yapılmayacak:

1. Private Play upload signing tamamlanmış olmalı.
2. Play Data Safety / IARC / target audience / app access formları tamamlanmış olmalı.
3. Store screenshot’ları + feature graphic tamamlanmış olmalı.
4. Production RC temiz kurulum + local persistence + gerçek X kritik fiziksel testten PASS almalı.
