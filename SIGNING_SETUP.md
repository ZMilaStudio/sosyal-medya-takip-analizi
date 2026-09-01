# Takip Analizi — Production Signing Setup

Son güncelleme: 1 Eylül 2026

Bu proje iki tamamen ayrı imza zinciri kullanır:

1. **Device-test signing** — yalnız fiziksel test APK’ları için, public test fixture.
2. **Production / Play upload signing** — private anahtar; repoya asla commit edilmez.

## Kesin güvenlik kuralı

`.github/test-signing` altındaki device-test anahtarı veya sertifikası **production APK/AAB imzalamak için kullanılmayacaktır**.

Production upload key yalnız güvenli bir secret store veya yerel güvenli ortamdan sağlanır.

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

Google Play App Signing kurulumu sırasında mevcut bir upload key yoksa güvenli bir bilgisayarda yeni Java keystore oluşturulabilir. Örnek:

```bash
keytool -genkeypair \
  -v \
  -keystore takip-analizi-upload.jks \
  -alias takip-upload \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

Parola ve kimlik bilgileri repoya, issue’ya, commit mesajına veya sohbet metnine yazılmamalıdır.

## Sertifika SHA-256 alma

```bash
keytool -list -v \
  -keystore takip-analizi-upload.jks \
  -alias takip-upload
```

Çıktıdaki `SHA256` fingerprint değeri `PLAY_UPLOAD_CERT_SHA256` secret’ı olarak kaydedilir. Production workflow keystore sertifikasını ve oluşan AAB imzasını bu fingerprint ile karşılaştırır.

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

Bu yalnız ek korumadır; private anahtarın doğru saklanması yine operasyonel sorumluluktur.

## Production RC workflow

`.github/workflows/production-rc-aab.yml` yalnız `workflow_dispatch` ile manuel çalışır.

Girdi olarak:

- `version_name` — ör. `1.0.0`
- `version_code` — pozitif integer

ister.

Workflow sırasıyla:

1. signing secrets varlığını kontrol eder,
2. private keystore’u runner’a geçici olarak kurar,
3. beklenen sertifika SHA-256 ile karşılaştırır,
4. production package/source guard’larını doğrular,
5. `flutter analyze` çalıştırır,
6. tüm testleri çalıştırır,
7. signed release AAB üretir,
8. AAB signer sertifikasını tekrar doğrular,
9. AAB + SHA-256 dosyasını **1 gün retention** ile artifact olarak yükler.

## Play App Signing

Production rollout öncesi Google Play Console tarafında App Signing durumu doğrulanmalıdır. Bu repodaki upload key, Play App Signing etkinse uygulamanın dağıtım imzası değil **yükleme (upload) anahtarıdır**; son kullanıcıya dağıtılan imzayı Google Play yönetebilir.

## Recovery

Upload key kaybolursa Play Console’un desteklediği upload-key reset süreci kullanılmalıdır. Bu nedenle:

- private key’in güvenli offline yedeği tutulmalı,
- parolalar ayrı güvenli parola yöneticisinde saklanmalı,
- test keystore hiçbir koşulda recovery alternatifi sayılmamalıdır.
