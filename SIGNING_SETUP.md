# Takip Analizi — Production Signing Setup

Son güncelleme: 2 Eylül 2026

Bu proje iki tamamen ayrı imza zinciri kullanır:

1. **Device-test signing** — yalnız fiziksel test APK’ları için, public test fixture.
2. **Production / Play upload signing** — private anahtar; repoya asla commit edilmez.

## Kesin güvenlik kuralı

`.github/test-signing` altındaki device-test anahtarı veya sertifikası **production APK/AAB imzalamak için kullanılmayacaktır**.

Production upload key yalnız güvenli bir secret store veya yerel güvenli ortamdan sağlanır.

## Güncel production upload key — 2 Eylül 2026

Kullanıcının açık onayıyla yeni private upload key oluşturuldu ve yerel signing paketi içinde saklandı. Private keystore ve parolalar bu repoya commit edilmedi.

Public/secret olmayan kimlik bilgileri:

- Keystore type: `JKS`
- Alias: `takip-upload`
- Key algorithm: `RSA 3072`
- Signature algorithm: `SHA256withRSA`
- Validity: `10000` gün
- DN: `CN=Takip Analizi Upload, OU=Android Release, O=ZMila Studio, C=TR`
- Upload certificate SHA-256: `def6c59b9a84f51af6ea5c768f21927ecbadb868ec5dbcd17dc031876b5cca65`
- Keystore file SHA-256: `4ff8c92eb4ca8074d75791d3a753c1290232bb13b79aa121c26fe059f788a192`

Doğrulamalar:

1. Keystore içindeki certificate fingerprint ile dışa aktarılan PEM certificate fingerprint’i bağımsız olarak karşılaştırıldı — **PASS**.
2. Private key ile gerçek JAR signing self-test yapıldı — **PASS**.
3. Private değerler repo, commit mesajı ve public loglara yazılmadı.

GitHub bağlı araç repository secret write işlemini güvenlik nedeniyle desteklemediğinden `PLAY_UPLOAD_*` değerleri henüz GitHub hesabına otomatik girilmedi. Değerler özel `GITHUB_SECRETS.txt` dosyasında hazırlandı.

## Play App Signing — güncel model

Google Play’in güncel yeni-uygulama akışında yeni uygulama Play App Signing’e dahil edilir. İki ayrı anahtar rolü vardır:

### Upload key — geliştiricide

- Java keystore (`.jks` / `.keystore`) içinde tutulur.
- RSA en az 2048 bit olmalıdır.
- Geliştirici AAB’yi bu key ile imzalar.
- Google Play bu imzayı yükleyenin yetkisini doğrulamak için kullanır.
- Upload key kaybolur veya compromise olursa Play App Signing altında reset süreci vardır.

### App signing key — Google Play’de

- Son kullanıcı cihazlarına dağıtılan APK’ların imzasını Google Play yönetir.
- Yeni uygulamalarda Google-generated app signing key kullanmak önerilen/default akıştır.
- Bu repodaki `PLAY_UPLOAD_*` secret’ları **Google’ın app signing private key’i değildir**; yalnız geliştiricinin upload key’idir.

Resmi referans:
https://support.google.com/googleplay/android-developer/answer/9842756

## Gradle environment değişkenleri

`apps/mobile/android/app/build.gradle.kts` production release imzasını yalnız aşağıdaki environment değişkenleri mevcutsa bağlar:

- `PLAY_UPLOAD_KEYSTORE_PATH`
- `PLAY_UPLOAD_STORE_PASSWORD`
- `PLAY_UPLOAD_KEY_ALIAS`
- `PLAY_UPLOAD_KEY_PASSWORD`

Bu değişkenler yoksa release signing config `null` kalır; public device-test key’e fallback yapılmaz.

## GitHub Actions secret adları

Manuel `.github/workflows/production-rc-aab.yml` workflow’u aşağıdaki repository secrets değerlerini bekler:

- `PLAY_UPLOAD_KEYSTORE_B64`
- `PLAY_UPLOAD_STORE_PASSWORD`
- `PLAY_UPLOAD_KEY_ALIAS`
- `PLAY_UPLOAD_KEY_PASSWORD`
- `PLAY_UPLOAD_CERT_SHA256`

Workflow bu secret’lardan biri eksikse build’e başlamadan fail olur.

## Private upload key oluşturma

Google Play App Signing kurulumu sırasında mevcut bir upload key yoksa **kullanıcının açık onayıyla** güvenli bir bilgisayarda yeni Java keystore oluşturulur.

Örnek:

```bash
keytool -genkeypair \
  -v \
  -keystore takip-analizi-upload.jks \
  -alias takip-upload \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

Google minimum RSA 2048 ister. Daha güçlü bir RSA key kullanılabilir; ancak Play Console’un güncel kabul kuralları production zamanı tekrar kontrol edilir.

Parola ve private key bilgileri:

- repoya,
- issue’ya,
- commit mesajına,
- public loga,
- normal sohbet metnine

yazılmamalıdır.

## Sertifika SHA-256 alma

```bash
keytool -list -v \
  -keystore takip-analizi-upload.jks \
  -alias takip-upload
```

Çıktıdaki `SHA256` fingerprint değeri normalize edilerek `PLAY_UPLOAD_CERT_SHA256` secret’ı olarak kaydedilir.

Production workflow:

1. runner’a kurulan keystore sertifikasını bu fingerprint ile karşılaştırır,
2. oluşan signed AAB signer sertifikasını aynı fingerprint ile karşılaştırır.

## Upload certificate PEM dışa aktarma

Play Console’da upload-key reset veya certificate kaydı gerektiğinde public sertifika PEM olarak dışa aktarılabilir:

```bash
keytool -export -rfc \
  -keystore takip-analizi-upload.jks \
  -alias takip-upload \
  -file takip-analizi-upload-certificate.pem
```

Bu `.pem` dosyası public sertifikadır; private keystore değildir. Yine de repo içine gereksiz yere commit edilmeyecek.

## Keystore’u base64 secret’a hazırlama

Linux/macOS:

```bash
base64 < takip-analizi-upload.jks | tr -d '\n'
```

Windows PowerShell:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes('takip-analizi-upload.jks'))
```

Elde edilen base64 metin yalnız `PLAY_UPLOAD_KEYSTORE_B64` GitHub Secret alanına girilir. Dosyanın kendisi repoya yüklenmez.

## Repository koruması

`.gitignore` aşağıdaki private signing dosyalarını engeller:

- `*.jks`
- `*.keystore`
- `*.p12`
- `*.pem`
- `*.key`
- `key.properties`
- `.env*`

Bu yalnız ek korumadır; private anahtarın güvenli saklanması yine operasyonel sorumluluktur.

## Production RC workflow

`.github/workflows/production-rc-aab.yml` yalnız `workflow_dispatch` ile manuel çalışır.

Varsayılan production girdileri:

- `version_name = 1.0.0`
- `version_code = 1`

Workflow sırasıyla:

1. signing secrets varlığını kontrol eder,
2. private upload keystore’u runner’a geçici olarak kurar,
3. beklenen upload sertifikası SHA-256 ile karşılaştırır,
4. production package/source guard’larını doğrular,
5. `flutter analyze` çalıştırır,
6. tüm testleri çalıştırır,
7. signed release AAB üretir,
8. merged release manifestte targetSdk 36 doğrular,
9. merged release manifestte `android.permission.INTERNET` varsa fail olur,
10. yalnız beklenen AndroidX internal signature permission’a tolerans gösterir; başka permission varsa fail olur,
11. `allowBackup=false`, `usesCleartextTraffic=false`, `debuggable/testOnly` guard’larını doğrular,
12. AAB signer sertifikasını tekrar doğrular,
13. exact launcher source guard’ını korur,
14. AAB + SHA-256 dosyasını **1 gün retention** ile artifact olarak yükler.

## İlk Play upload operasyonu

Private upload key hazır olduktan sonra önerilen sıra:

1. Play Console’da Takip Analizi uygulamasını aç.
2. Play App Signing / App integrity durumunu kontrol et.
3. Upload key certificate fingerprint / certificate beklentisini belirle.
4. Güncel upload certificate SHA-256 değerinin `def6c59b9a84f51af6ea5c768f21927ecbadb868ec5dbcd17dc031876b5cca65` olduğunu doğrula.
5. GitHub repository secrets `PLAY_UPLOAD_*` alanlarını güvenli `GITHUB_SECRETS.txt` dosyasından doldur.
6. `Production RC AAB` workflow’unu `1.0.0 / 1` ile manuel çalıştır.
7. Artifact AAB SHA-256 + signer fingerprint + package/version/manifest guard sonuçlarını kaydet.
8. AAB’yi önce uygun test/release track’ine yükle.
9. Play Console’un signing certificate ekranındaki fingerprints ile beklenen rolleri karıştırma: upload certificate ile app signing certificate farklı olabilir.

## Recovery — upload key kaybolursa

Play App Signing kullanılıyorsa upload key kaybı app signing key kaybı değildir.

Google’ın güncel süreci özetle:

1. Yeni bir upload key oluştur.
2. Public certificate’i PEM olarak dışa aktar.
3. Play Console → Play App Signing yönetim alanına git.
4. `Upload key certificate` bölümündeki upload key reset sürecini kullan.
5. Yeni certificate’i kaydettikten sonra GitHub secrets ve beklenen fingerprint’i güncelle.

Reset işlemi için hesap sahibi / gerekli Play Console yetkisi gerekebilir.

Bu nedenle:

- private upload key’in güvenli offline yedeği tutulmalı,
- parolalar ayrı güvenli parola yöneticisinde saklanmalı,
- test keystore hiçbir koşulda recovery alternatifi sayılmamalı,
- upload key ile Google Play app signing key aynı şey sanılmamalıdır.

Resmi recovery referansı:
https://support.google.com/googleplay/android-developer/answer/9842756
