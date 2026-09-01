# PROJE_OZETI

Son güncelleme: 2 Eylül 2026

## Çalışma protokolü
- Her yeni çalışma başlangıcında bu dosya okunur; bu dosya + canlı GitHub repo gerçeklik kaynağıdır.
- Çalışan fiziksel/CI baseline korunur; riskli değişiklik öncesi backup branch oluşturulur.
- Kullanıcı istemedikçe görsel mockup gönderilmez; gerçek uygulama üzerinden ilerlenir.
- **1 Eylül 2026 kararı:** her küçük değişiklik için ayrı fiziksel test/PASS turu yapılmayacak. Geliştirmeler toplu ilerletilecek; yalnız kritik production RC noktasında tek fiziksel doğrulama yapılacak.
- GitHub Actions kotası korunacak; gereksiz workflow çalıştırılmayacak.
- Exact launcher/logo kullanıcı tarafından onaylı rasterdır; **yeniden çizilmeyecek, image generation ile üretilmeyecek, yaklaşık/alternatif simgeyle değiştirilmeyecek**.

## Proje amacı
Android öncelikli Flutter + Dart, local-first Instagram ve X/Twitter takip analizi uygulaması.

### Instagram
- Yalnız resmi Meta veri dışa aktarma ZIP içindeki JSON/HTML takip ilişkisi dosyaları analiz edilir.
- Scraping, private API, Instagram şifresi, otomatik follow/unfollow yok.
- Multipart followers dosyaları ve `following.json` varyasyonları desteklenir.

### X / Twitter
- Resmi X veri arşivi üzerinden local analiz.
- Küçük/orta arşiv ZIP; büyük arşivlerde `follower.js` + `following.js` doğrudan seçilebilir.
- X şifresi istenmez.
- X `window.YTD.*` JS formatları ve accountId tabanlı kimlik desteklenir.
- Handle bulunmuyorsa sahte @handle üretilmez; ID açık gösterilir.
- Canlı API/OAuth ancak ileride maliyet ve politika uygunluğu ayrıca değerlendirilirse eklenebilir.

### Ortak analiz özellikleri
- 5 kategori: Takip Etmeyenler, Karşılıklı, Seni Takip Edenler, Takibi Bırakanlar, Yeni Takipçiler.
- Snapshot/geçmiş cihazda tutulur; yeni import önceki snapshot ile otomatik karşılaştırılır.
- Aynı platform + aynı hesaptaki iki keyfi snapshot manuel karşılaştırılabilir.
- Yok sayılan hesaplar platform + hesap bazında local tutulur; ham snapshot sayıları değişmez.
- Kullanıcı satırına dokununca platform profil bağlantısı harici uygulamada açılır.
- Arama, A-Z/Z-A sıralama.
- Son hesaplar hızlı seçim.
- Geçmişte platform + hesap filtreleri.
- Tek snapshot ve seçili hesap geçmişini silme.
- Analiz raporu: `Raporu kopyala` + `TXT olarak kaydet`.
- Yerel Veri Yönetimi: tüm analiz geçmişi, Yok say verisi veya tüm local app verisini onaylı silme.
- Instagram ve X arşiv rehberleri.
- `Gizlilik ve Hakkında` ekranı.

## Gerçek Instagram fiziksel doğrulaması
- Gerçek Meta export örneği: 569 takipçi, 1053 takip edilen, 792 takip etmeyen, 261 karşılıklı, 308 yalnız takipçi.
- Instagram canlı UI takip edilen 967 iken export 1053 gösterdi; export/live UI farkının normal olabileceği görüldü.
- `gece02.19`: ilk snapshot 75 takipçi / 53 takip edilen; ikinci 74 / 46.
- Gerçek geçmiş sonucu: `Takibi Bırakanlar (6)` + `Yeni Takipçiler (5)`; matematik `75 - 6 + 5 = 74`.
- Gerçek listeler Samsung fiziksel cihazda render edildi ve kullanıcı PASS verdi.

## Önemli eski baseline’lar
- v2-16 liste: backup `backup/device-v2-16-working-baseline`, fiziksel PASS.
- v2-17 profil linki: `backup/device-v2-17-links-working`, fiziksel PASS.
- v2-21 Yok say: `backup/device-v2-21-ignored-working`, fiziksel PASS.
- v2-22 arama/sıralama: `backup/device-v2-22-search-sort-working`, fiziksel PASS.
- v2-23 5 sekme: `backup/device-v2-23-five-tabs-working`, fiziksel PASS.
- v2-26 exact launcher: `backup/device-v2-26-exact-icon-working`, fiziksel PASS.
- v2-28 X archive CI: `backup/device-v2-28-x-archive-ci-working`.
- v2-29 recent/history filters: `backup/device-v2-29-recent-history-filters-ci-working`.
- v2-30 history data management: `backup/device-v2-30-history-data-management-ci-working`.
- v2-32 report export: `backup/device-v2-32-report-export-ci-working`.
- v2-37 product polish: `backup/device-v2-37-product-polish-ci-working`.
- v2-38 release polish: commit `e79355e5b7a21e19825f55c8f5f51ac79d2d5ebe`, run `33543687577`, backup `backup/device-v2-38-release-polish-ci-working`, TAM CI SUCCESS.

# GÜNCEL GÜVENLİ CI BASELINE — v2-39

Release-hardening batch tek Actions run ile doğrulandı.

- Tested commit: `0816b8811aae6cf7aa2be67e63c524156093507b`.
- Actions run: `33551771267`.
- Run number: `39`.
- Sonuç: **SUCCESS**.
- Prerelease tag: `device-test-v2-39`.
- Test package: `com.zmilastudio.takipanalizi.dev`.
- versionName: `1.0.0-dev`.
- VersionCode: `300039`.
- compileSdkVersion: `36`.
- targetSdkVersion: `36`.
- APK: `takip-analizi-device-test.apk`.
- APK boyutu: `180,743,127` byte.
- APK SHA-256: `d18151fbc8c75897abd14934cc71b9ef29911b1d035cb6c1670a176fac9dde97`.
- Test signing certificate SHA-256: `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`.
- Exact launcher source SHA-256: `7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`.
- Release URL: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/releases/tag/device-test-v2-39`.
- Backup: `backup/device-v2-39-release-hardening-ci-working`.
- Pre-CI backup: `backup/pre-production-hardening-ci`.

### v2-39’da PASS olan kapılar
- Flutter dependencies resolve.
- `flutter analyze`: **No issues found**.
- `flutter test`: **23/23 PASS**.
- Exact launcher wiring + SHA guard PASS.
- Main source manifestte app-defined `<uses-permission>` bulunmaması PASS.
- `android:allowBackup="false"` PASS.
- `@xml/backup_rules` PASS.
- `@xml/data_extraction_rules` PASS.
- `root/file/database/sharedpref/external` exclusion kuralları PASS.
- `android:usesCleartextTraffic="false"` PASS.
- Deterministic device-test signing PASS.
- Signed debug APK build PASS.
- Package/version/API36 PASS.
- Exact launcher APK içinde PASS.
- Stable test signer fingerprint PASS.
- Prerelease publish PASS.

### Debug APK permission notu
v2-39 debug APK badging iki permission gösterdi:
1. `android.permission.INTERNET` — Flutter debug tooling/hot reload nedeniyle beklenen development izni.
2. `com.zmilastudio.takipanalizi.dev.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` — AndroidX Core’un eski Android sürümlerinde `RECEIVER_NOT_EXPORTED` güvenliğini emüle etmek için merged manifestte eklediği **app-scoped signature-level internal permission**.

Bu AndroidX izni kullanıcıdan istenen runtime izni değildir, kullanıcı verisine erişim sağlamaz ve permission dialog oluşturmaz. AndroidX’in resmi Core manifestinde tanımlıdır.

## Production Android privacy/security hardening

### Production source manifest
`apps/mobile/android/app/src/main/AndroidManifest.xml`:
- app-defined `<uses-permission>` yok,
- `INTERNET` yok,
- `android:allowBackup="false"`,
- `android:fullBackupContent="@xml/backup_rules"`,
- `android:dataExtractionRules="@xml/data_extraction_rules"`,
- `android:usesCleartextTraffic="false"`,
- Impeller kapalı mevcut fiziksel uyumluluk kararı korunuyor.

### Backup/data transfer kuralları
`apps/mobile/android/app/src/main/res/xml/backup_rules.xml`:
- Android 11 ve altı için `root/file/database/sharedpref/external` alanlarının tamamı exclude.

`apps/mobile/android/app/src/main/res/xml/data_extraction_rules.xml`:
- Android 12+ `cloud-backup` için aynı alanlar exclude.
- Android 12+ `device-transfer` için aynı alanlar exclude.

Amaç: Drift snapshot DB, SharedPreferences Yok say tercihleri ve app-managed local veriyi Android otomatik backup kapsamının dışında tutmak.

### Production merged manifest izin sözleşmesi
`.github/workflows/production-rc-aab.yml` artık:
- targetSdk 36 doğrular,
- `allowBackup=false` doğrular,
- `usesCleartextTraffic=false` doğrular,
- `android.permission.INTERNET` görülürse fail olur,
- `debuggable=true` / `testOnly=true` görülürse fail olur,
- merged `uses-permission` listesinde **yalnız** şu AndroidX internal signature iznine tolerans gösterir:
  `com.zmilastudio.takipanalizi.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`,
- bunun dışında başka permission görülürse fail olur.

Bu production merged-manifest guard’ı gerçek private signing ile production AAB üzerinde henüz çalıştırılmadı.

## Uygulama içi gizlilik güncellemesi
`Gizlilik ve Hakkında` ekranı artık açıkça anlatır:
- production analiz mimarisi local-first,
- debug/profile INTERNET ile production davranışı ayrıdır,
- sosyal medya şifresi istenmez,
- yalnız kullanıcı seçtiği dosyalar okunur,
- local snapshot geçmişi vardır,
- production Android automatic backup kapalıdır,
- `Raporu kopyala` sistem panosuna, `TXT olarak kaydet` kullanıcının seçtiği konuma yazar,
- bu export kullanıcı tarafından başlatılır ve geliştirici sunucusuna gönderilmez,
- harici profil linkleri üçüncü taraf uygulamaya devredilir,
- destek: `zmilastudio@gmail.com`.

Privacy widget testi v2-39 CI’da PASS aldı.

## Rapor export privacy sınırı
- `Raporu kopyala` → Android system clipboard.
- `TXT olarak kaydet` → `FilePicker.saveFile` ile kullanıcının seçtiği hedef.
- Rapor analiz hesap adını, kategori sonuçlarını ve sosyal kullanıcı adlarını içerebilir.
- ZMila Studio sunucusuna gönderilmez.
- Kullanıcı harici bir hedefe TXT kaydederse veya clipboard’a kopyalarsa bu veri app private sandbox dışında olabilir.
- `Yerel Veri Yönetimi`, daha önce dışa aktarılmış TXT dosyasını veya sistem panosundaki içeriği otomatik silemez.

## Production kimliği ve sürüm
- Production applicationId: `com.zmilastudio.takipanalizi`.
- Device-test applicationId: `com.zmilastudio.takipanalizi.dev`.
- İlk production sürümü: **`1.0.0+1`**.
- versionName: `1.0.0`.
- versionCode: `1`.
- API hedefi: 36 / Android 16.

### İlk production install testi hakkında kritik düzeltme
`.dev` ile production package farklı applicationId olduğu için production 1.0.0, v2-39 `.dev` uygulamasının üstüne upgrade **değildir** ve `.dev` verisini devralmaz.

İlk production RC:
- temiz production kurulum olarak test edilecek,
- aynı production kurulumda demo snapshot import → app kapat/aç → local persistence doğrulanacak.

Gerçek production upgrade/veri-koruma testi ancak production 1.0.0 yayımlandıktan sonra versionCode>1 aynı `com.zmilastudio.takipanalizi` package üzerinde yapılabilir.

## Production signing — UPLOAD KEY HAZIR
- Device-test public key production için kullanılmaz.
- Kullanıcının açık onayıyla **2 Eylül 2026** tarihinde yeni private production upload key oluşturuldu.
- Private keystore/parolalar **repoya commit edilmedi**.
- Yerel güvenli signing paketi oluşturuldu; içinde `.jks`, public PEM certificate, GitHub Secrets değer dosyası, recovery bilgisi ve checksum listesi bulunur.
- Keystore türü: JKS.
- Alias: `takip-upload`.
- Key algorithm: RSA 3072.
- Signature algorithm: `SHA256withRSA`.
- Validity: 10000 gün.
- DN: `CN=Takip Analizi Upload, OU=Android Release, O=ZMila Studio, C=TR`.
- Upload certificate SHA-256: `def6c59b9a84f51af6ea5c768f21927ecbadb868ec5dbcd17dc031876b5cca65`.
- Keystore certificate fingerprint ile export edilen PEM fingerprint’i bağımsız olarak birebir eşleşti: **PASS**.
- Private key ile gerçek JAR signing self-test: **PASS**.
- Keystore dosya SHA-256: `4ff8c92eb4ca8074d75791d3a753c1290232bb13b79aa121c26fe059f788a192`.
- Google Play App Signing modelinde:
  - geliştiricide bu private **upload key**,
  - Google Play’de ayrı **app signing key** bulunur.
- `SIGNING_SETUP.md` bu ayrımı, SHA fingerprint kontrolünü, PEM certificate export ve upload-key reset/recovery akışını açıklar.
- Production workflow beklenen secrets:
  - `PLAY_UPLOAD_KEYSTORE_B64`
  - `PLAY_UPLOAD_STORE_PASSWORD`
  - `PLAY_UPLOAD_KEY_ALIAS`
  - `PLAY_UPLOAD_KEY_PASSWORD`
  - `PLAY_UPLOAD_CERT_SHA256`
- GitHub bağlı aracında repository secret write API güvenlik nedeniyle desteklenmiyor; secret değerleri güvenli dosyada hazırlandı ancak GitHub hesabına henüz girilmedi.
- Production workflow secret’lar girilmeden çalıştırılmayacak.

## Privacy / support — TAMAMLANDI
Public `main`:
- Privacy: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md`
- Support: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md`
- Support/privacy e-mail: `zmilastudio@gmail.com`.

Public privacy policy TR+EN şu davranışlarla güncel:
- local-first processing,
- `INTERNET`/debug-production ayrımı,
- AndroidX internal signature receiver permission açıklaması,
- backup exclusions,
- cleartext=false,
- report clipboard/TXT export,
- external export dosyasının app silme alanı dışında kalabilmesi,
- harici profil/dosya sağlayıcısı third-party behavior.

## Play Console hazırlığı
Hazır belgeler:
- `PRIVACY_POLICY.md`
- `SUPPORT.md`
- `PLAY_STORE_DATA_SAFETY.md`
- `PLAY_CONSOLE_FORM_ANSWERS.md`
- `PLAY_STORE_LISTING_TR.md`
- `PLAY_STORE_LISTING_EN.md`
- `RELEASE_CHECKLIST.md`
- `SIGNING_SETUP.md`
- `PRIVACY_SUPPORT_PUBLISH_PLAN.md`
- `STORE_VISUAL_CAPTURE_PLAN.md`
- `STORE_ICON_DERIVATION.md`

Mevcut öneriler:
- Data Safety collection/sharing: current local-only architecture için **No**.
- Ads: No.
- App access / özel login: No.
- Uygulama kendi user account’unu oluşturmaz.
- Target audience: 18+.
- Category: Araçlar / Tools.
- News/government/health/financial: No.
- IARC sonucu Console tarafından üretilecek; yaş derecesi uydurulmayacak.
- Final form cevapları **gerçek production AAB merged manifest** ile son kez karşılaştırılmadan gönderilmeyecek.

## Play Store listing
- App name: `Takip Analizi` — 13/30.
- TR short: `Instagram ve X takip ilişkilerini arşivlerinden cihazında analiz et.` — 68/80.
- EN short: 77/80.
- Kategori: Araçlar / Tools.
- Kesin tag adları uydurulmayacak; Console’un sunduğu listeden en fazla 5 gerçek ilgili tag seçilecek.

## Store görselleri
### Screenshot planı
`STORE_VISUAL_CAPTURE_PLAN.md`:
- hedef 8 gerçek-app telefon screenshot’ı,
- 1080×1920,
- 9:16,
- 24-bit PNG/JPEG, alfa yok,
- gerçek kişisel takipçi verisi kullanılmayacak.

S25 Ultra ham screenshot 1440×3120 olduğu için ratio>2; Play’e doğrudan yüklenmeyecek. Gerçek UI 9:16 / 1080×1920 çıktıya esnetmeden hazırlanacak.

### Sentetik store demo arşivleri
Repo: `store_assets/demo_archives/`.

Instagram demo username: `demo_analiz_2026`.
- snapshot1: 10 takipçi / 11 takip edilen.
- snapshot2: 11 / 12; **2 Takibi Bırakan + 3 Yeni Takipçi**.

X demo username: `demo_x_analiz_2026`.
- snapshot1: 8 takipçi / 9 takip edilen.
- snapshot2: 9 / 10; **1 Takibi Bırakan + 2 Yeni Takipçi**.

Tüm demo isimleri sentetiktir; gerçek kişi verisi yok. ZIP’ler APK/AAB içine asset olarak girmez; store screenshot kontrollü demo içindir.

### Exact store icon
- Orijinal kullanıcı rasterı: `92065.png`, 1536×1536 RGB, SHA-256 `ebada937553521ffcff3a92f6a8ff88d040c11ccc289f826de8fd91020b14c90`.
- Bu kaynak 192×192 Lanczos + WebP quality95/method6 ile işlendiğinde final Android launcher hash’i byte-for-byte üretildi.
- 512×512 store icon sadece resize ile üretildi; logo yeniden çizilmedi.
- `takip-analizi-store-icon-512.png`: 512×512 RGB PNG, 169.565 byte.
- Store icon SHA-256: `c838ffe6ef39bab9cab0176951334f8dc79e0158fc02755cb27ca28c856ae717`.
- `STORE_ICON_DERIVATION.md` kayıtlı.

### Feature graphic
- 1024×500 feature graphic halen açık iş.
- Instagram/X ile resmi ilişki ima etmeyecek.
- Exact launcher yeniden çizilmeyecek.
- Kullanıcı onayı olmadan final yayın materyali olarak kilitlenmeyecek.

## Branch durumu
- `test/device-apk` → **tested v2-39 commit** `0816b8811aae6cf7aa2be67e63c524156093507b`.
- `backup/device-v2-39-release-hardening-ci-working` → aynı tested commit.
- `backup/pre-production-hardening-ci` → aynı pre/post-batch tested head `0816b881...`.
- `backup/device-v2-38-release-polish-ci-working` önceki güvenli baseline olarak korunuyor.
- `dev/release-polish-v1` v2-39 tested commitin ilerisinde production workflow/docs/signing hazırlığı içeriyor; son v2-39 sonrası değişiklikler yeni Device Test run gerektirmiyor çünkü app runtime kodu değişmedi.
- Public `main` privacy/support yayın belgelerini içeriyor.

## Production’a kalan ana kapılar
1. Google Play App Signing durumunu Play Console’da doğrula.
2. **TAMAMLANDI:** private production upload key oluşturuldu ve self-test edildi.
3. `PLAY_UPLOAD_*` GitHub Secrets değerlerini hazırlanmış güvenli dosyadan repository secrets alanına gir.
4. Manuel production RC AAB workflow’unu `1.0.0 / 1` ile çalıştır.
5. Gerçek production AAB’de package/version/API36/signing/merged manifest permission-backup-cleartext guard’larını PASS kapat.
6. Play Console Data Safety / IARC / target audience / app access alanlarını tamamla.
7. 1024×500 feature graphic’i kullanıcı onayıyla hazırla.
8. Production RC ile sentetik demo arşivlerinden store screenshot’larını al.
9. Production RC temiz kurulum + persistence + gerçek X arşivi tek kritik fiziksel PASS.

## Sıradaki iş
- v2-39 CI başarılı; **yeni Device Test Actions çalıştırma**.
- Private upload key artık hazır.
- Sıradaki blocker: GitHub repository secrets’in güvenli biçimde girilmesi + Play Console App Signing durumunun doğrulanması.
- GitHub bağlı araç secret write API sunmadığı için secret değerlerini repoya veya sohbete yazma; `GITHUB_SECRETS.txt` güvenli paketinden kullanıcı GitHub Settings’e girmeli.
- Secret’lar girilmeden production workflow çalıştırma.
- Production signing aşaması dışında runtime geliştirmeyi gereksiz yere açma.