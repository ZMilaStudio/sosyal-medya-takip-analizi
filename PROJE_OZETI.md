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
- ZIP import desteklenir.
- Çok büyük arşivlerde `follower.js` + `following.js` doğrudan seçilebilir.
- `window.YTD.*` JS formatı ve accountId tabanlı kimlik desteklenir.
- Handle yoksa sahte @handle üretilmez; ID açık gösterilir.
- X şifresi istenmez.

### Ortak özellikler
- 5 kategori: Takip Etmeyenler, Karşılıklı, Seni Takip Edenler, Takibi Bırakanlar, Yeni Takipçiler.
- Snapshot/geçmiş cihazda tutulur.
- Yeni import önceki snapshot ile otomatik karşılaştırılır.
- Aynı platform + aynı hesaptaki iki keyfi snapshot manuel karşılaştırılabilir.
- Arama + A-Z/Z-A.
- Profil bağlantısını harici Instagram/X uygulamasında/tarayıcıda açma.
- Yok say / geri yükle; platform + hesap bazlı local tercih.
- Son hesaplar hızlı seçim.
- Geçmişte platform + hesap filtreleri.
- Tek snapshot silme ve seçili hesap geçmişini silme.
- Analiz raporu: panoya kopyala + TXT kaydet.
- Yerel Veri Yönetimi: tüm geçmiş / Yok say / tüm local app verisini onaylı silme.
- Instagram ve X arşiv rehberleri.
- Gizlilik ve Hakkında ekranı.

## Gerçek Instagram fiziksel doğrulaması
- Gerçek Meta export örneği: 569 takipçi, 1053 takip edilen, 792 takip etmeyen, 261 karşılıklı, 308 yalnız takipçi.
- `gece02.19` eski snapshot: 75 takipçi / 53 takip edilen.
- Yeni snapshot: 74 / 46.
- Gerçek geçmiş sonucu: Takibi Bırakanlar 6 + Yeni Takipçiler 5.
- Matematik: `75 - 6 + 5 = 74`.
- Gerçek listeler Samsung fiziksel cihazda render edildi ve kullanıcı PASS verdi.

## Önemli baseline’lar
- v2-16 liste baseline: fiziksel PASS.
- v2-17 profil linki: fiziksel PASS.
- v2-21 Yok say: fiziksel PASS.
- v2-22 arama/sıralama: fiziksel PASS.
- v2-23 5 sekme: fiziksel PASS.
- v2-26 exact launcher: fiziksel PASS; `backup/device-v2-26-exact-icon-working`.
- v2-28 X archive: tam CI SUCCESS.
- v2-29 Son hesaplar + geçmiş filtreleri: tam CI SUCCESS.
- v2-30 geçmiş veri yönetimi: tam CI SUCCESS.
- v2-32 rapor export: tam CI SUCCESS.
- v2-37 product polish: tam CI SUCCESS.
- v2-38 release polish: tam CI SUCCESS.

# GÜNCEL GÜVENLİ CI BASELINE — v2-39
- Tested commit: `0816b8811aae6cf7aa2be67e63c524156093507b`.
- Actions run: `33551771267` / run #39.
- Sonuç: SUCCESS.
- Prerelease: `device-test-v2-39`.
- Test package: `com.zmilastudio.takipanalizi.dev`.
- versionName: `1.0.0-dev`.
- VersionCode: `300039`.
- compileSdk / targetSdk: 36 / 36.
- APK boyutu: 180,743,127 byte.
- APK SHA-256: `d18151fbc8c75897abd14934cc71b9ef29911b1d035cb6c1670a176fac9dde97`.
- Test signer SHA-256: `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`.
- Exact launcher source SHA-256: `7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`.
- Backup: `backup/device-v2-39-release-hardening-ci-working`.
- Analyze PASS.
- 23/23 test PASS.
- Backup/data-transfer source guard PASS.
- Cleartext source guard PASS.
- Exact launcher/signing/package/version/API36 checks PASS.

## Production Android privacy/security
### Source manifest
- App-defined uses-permission yok.
- INTERNET yok.
- `android:allowBackup="false"`.
- `android:fullBackupContent="@xml/backup_rules"`.
- `android:dataExtractionRules="@xml/data_extraction_rules"`.
- `android:usesCleartextTraffic="false"`.
- Impeller kapalı fiziksel uyumluluk kararı korunuyor.

### Backup / transfer
- Android 11 ve altı backup rules: root/file/database/sharedpref/external exclude.
- Android 12+ cloud-backup + device-transfer: aynı alanlar exclude.
- Amaç: Drift snapshot DB, SharedPreferences ve app-managed local veriyi Android otomatik backup/transfer dışında tutmak.

### Production merged-manifest sözleşmesi
`production-rc-aab.yml` gerçek release’te:
- targetSdk 36 doğrular.
- allowBackup=false doğrular.
- cleartext=false doğrular.
- INTERNET görülürse fail olur.
- debuggable=true / testOnly=true görülürse fail olur.
- Yalnız `com.zmilastudio.takipanalizi.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` AndroidX internal signature iznine tolerans vardır.
- Bunun dışında başka merged uses-permission görülürse fail olur.

Not: Debug APK’da Flutter tooling nedeniyle INTERNET ve AndroidX internal dynamic receiver izni görülebilir; bu production release sözleşmesi değildir.

## Production kimliği / sürümü
- Production package: `com.zmilastudio.takipanalizi`.
- Device-test package: `com.zmilastudio.takipanalizi.dev`.
- İlk production sürümü: `1.0.0+1`.
- versionName: `1.0.0`.
- versionCode: `1`.
- API 36 / Android 16.
- Production `.dev` uygulamasının üstüne upgrade değildir; ilk RC temiz production kurulum olarak test edilecek.

## Production signing — UPLOAD KEY HAZIR
Kullanıcının açık onayıyla 2 Eylül 2026’da private Play upload key oluşturuldu.

- Device-test public key production için kullanılmaz.
- Private keystore/parolalar repoya commit edilmedi.
- Keystore: JKS.
- Alias: `takip-upload`.
- RSA 3072.
- Signature algorithm: SHA256withRSA.
- Validity: 10000 gün.
- DN: `CN=Takip Analizi Upload, OU=Android Release, O=ZMila Studio, C=TR`.
- Upload certificate SHA-256: `def6c59b9a84f51af6ea5c768f21927ecbadb868ec5dbcd17dc031876b5cca65`.
- Keystore ↔ PEM fingerprint eşleşmesi: PASS.
- Private-key signing self-test: PASS.
- Keystore SHA-256: `4ff8c92eb4ca8074d75791d3a753c1290232bb13b79aa121c26fe059f788a192`.
- Private güvenli bundle hazır: keystore + public PEM + GitHub Secrets değer dosyası + recovery/checksum bilgileri.

Production workflow secrets:
- `PLAY_UPLOAD_KEYSTORE_B64`
- `PLAY_UPLOAD_STORE_PASSWORD`
- `PLAY_UPLOAD_KEY_ALIAS`
- `PLAY_UPLOAD_KEY_PASSWORD`
- `PLAY_UPLOAD_CERT_SHA256`

Önemli: Bu oturumdaki GitHub connector repository secrets yazma endpoint’i sunmuyor. Secret değerleri repoya/sohbete yazılmayacak; kullanıcı güvenli dosyadan GitHub Settings → Actions secrets alanına girecek. Secret’lar girilmeden production workflow çalıştırılmayacak.

## Privacy / support — TAMAMLANDI
Public `main`:
- Privacy: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md`
- Support: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md`
- Support/privacy: `zmilastudio@gmail.com`.

Privacy policy TR+EN; local-first processing, debug/production INTERNET ayrımı, backup exclusions, cleartext=false, AndroidX internal permission, report clipboard/TXT export ve harici profil akışlarını açıklar.

## Play Console hazırlığı
Hazır:
- `PRIVACY_POLICY.md`
- `SUPPORT.md`
- `PLAY_STORE_DATA_SAFETY.md`
- `PLAY_CONSOLE_FORM_ANSWERS.md`
- `PLAY_STORE_LISTING_TR.md`
- `PLAY_STORE_LISTING_EN.md`
- `RELEASE_CHECKLIST.md`
- `SIGNING_SETUP.md`
- `STORE_VISUAL_CAPTURE_PLAN.md`
- `STORE_ICON_DERIVATION.md`
- `FEATURE_GRAPHIC.md`

Mevcut Console önerileri:
- Data Safety collection/sharing: No — mevcut local-only mimari için.
- Ads: No.
- App access / özel login: No.
- Uygulama kendi user account’unu oluşturmaz.
- Target audience: 18+.
- Category: Araçlar / Tools.
- News/government/health/financial: No.
- IARC sonucu Console’dan alınacak; yaş derecesi uydurulmayacak.
- Final cevaplar gerçek production AAB merged manifest ile son kez karşılaştırılacak.

## Store listing
- App name: `Takip Analizi` — 13/30.
- TR short: `Instagram ve X takip ilişkilerini arşivlerinden cihazında analiz et.` — 68/80.
- EN short: 77/80.
- Kategori: Araçlar / Tools.

## Store görselleri
### Sentetik screenshot verisi
Repo: `store_assets/demo_archives/`.
- Instagram demo: `demo_analiz_2026`; snapshot1 10/11, snapshot2 11/12; 2 bırakan + 3 yeni.
- X demo: `demo_x_analiz_2026`; snapshot1 8/9, snapshot2 9/10; 1 bırakan + 2 yeni.
- Tüm demo kullanıcı adları sentetiktir; gerçek kişi verisi yok.

### Screenshot planı
- Hedef: 8 gerçek-app telefon screenshot’ı.
- 1080×1920, 9:16, alfa yok.
- Gerçek kişisel takipçi verisi kullanılmayacak.
- Production RC üzerinden çekilecek.

### Exact 512×512 store icon — HAZIR
- Exact orijinal kullanıcı rasterından yalnız resize ile türetildi.
- 512×512 RGB PNG, 169,565 byte.
- SHA-256: `c838ffe6ef39bab9cab0176951334f8dc79e0158fc02755cb27ca28c856ae717`.
- Logo yeniden çizilmedi.

### Feature graphic — TR + EN ADAYLAR HAZIR
Exact logo rasterı yalnız resize edilerek kullanıldı; logo yeniden çizilmedi/recolor edilmedi.

Türkçe aday:
- `takip-analizi-feature-graphic-1024x500-v2.png`
- 1024×500 RGB PNG.
- 147,360 byte.
- SHA-256: `73d4e9eec5564945813f2d6fc9aa9206693979a7c68c126dcf5cce63a4afc838`.
- Metin: Takip Analizi / Instagram + X takip ilişkilerini arşivlerinden cihazında analiz et. / Şifre yok / Cihazda analiz.

English candidate:
- `takip-analizi-feature-graphic-1024x500-en.png`
- 1024×500 RGB PNG.
- 153,161 byte.
- SHA-256: `e6b2da9520d4a95a2762337f0e09d558e5aeacb91cb3902e371a8453a12f0bf1`.
- Text: Analyze Instagram + X follow relationships from your archives, directly on your device. / No password / On-device.

- Instagram/X logosu kullanılmadı; resmi ortaklık/endorsement ima edilmedi.
- `FEATURE_GRAPHIC.md` kayıtlı.
- Teknik olarak Play ölçülerine hazır; kullanıcı görsel onayı verilmeden final yayın materyali olarak kilitlenmeyecek.

## Branch durumu
- `test/device-apk` → tested v2-39 commit `0816b8811aae6cf7aa2be67e63c524156093507b`.
- `backup/device-v2-39-release-hardening-ci-working` → aynı tested commit.
- `dev/release-polish-v1` → v2-39 üstünde production workflow/docs/signing/store materyal hazırlığı; runtime değişiklik yok.
- Public `main` → privacy/support docs.

## Production’a kalan ana kapılar
1. Google Play App Signing durumunu Play Console’da doğrula.
2. TAMAMLANDI: private upload key oluşturuldu ve self-test edildi.
3. `PLAY_UPLOAD_*` GitHub repository secrets değerlerini güvenli dosyadan gir.
4. Production RC AAB workflow’unu `1.0.0 / 1` ile çalıştır.
5. Gerçek AAB’de package/version/API36/signing/merged manifest guard’larını PASS kapat.
6. Play Console Data Safety / IARC / 18+ / app access deklarasyonlarını tamamla.
7. TR/EN feature graphic adaylarından finali görsel onayla kilitle.
8. Production RC ile 8 store screenshot’ı çek.
9. Production RC temiz kurulum + local persistence + gerçek X arşivi tek kritik fiziksel PASS.

## Sıradaki iş
- Yeni Device Test Actions çalıştırma; v2-39 güvenli baseline yeterli.
- Secret’lar girilmeden production workflow çalıştırma.
- Secret blocker beklerken runtime geliştirmeyi gereksiz yere açma.
- Feature graphic TR/EN adayları hazır; final kullanıcı görsel onayı bekliyor.
