# Takip Analizi — Production Release Checklist

Son güncelleme: 1 Eylül 2026

Bu checklist, v2-38 CI baseline’dan Google Play production yayınına geçerken kullanılacak kapı listesidir.

## A. Kod / kalite

- [x] Analyze temiz — v2-38 baseline.
- [x] Otomatik testler geçiyor — v2-38 baseline.
- [x] Fiziksel cihaz uyumluluk wiring kontrolü var.
- [x] Exact kullanıcı launcher asset’i hash ile kilitli.
- [x] Instagram gerçek arşivi fiziksel cihazda doğrulandı.
- [x] Snapshot farkları gerçek Instagram verisiyle doğrulandı.
- [x] X parser/import/snapshot akışı CI ile doğrulandı.
- [x] Uygulama içi `Gizlilik ve Hakkında` ekranı ve Home girişi eklendi.
- [x] Release-hardening batch’inde Android backup / permission / cleartext guard’ları kaynakta hazırlandı.
- [x] Uygulama içi privacy ekranı backup ve kullanıcı-initiated report export davranışıyla güncellendi.
- [ ] Release-hardening batch tek Device Test CI turunda doğrulanacak.
- [ ] Gerçek kullanıcı X arşivi ile tek kritik fiziksel doğrulama production RC turunda yapılacak.

## B. Android production kimliği

- [x] Production applicationId: `com.zmilastudio.takipanalizi`.
- [x] Device-test applicationId: `com.zmilastudio.takipanalizi.dev`.
- [x] Uygulama etiketi: `Takip Analizi`.
- [x] Launcher simgesi hazır ve test hash’i ile korunuyor.
- [x] İlk production versionName/versionCode: **`1.0.0` / `1`**.
- [x] `apps/mobile/pubspec.yaml`: `version: 1.0.0+1`.
- [x] Production RC workflow varsayılan inputları `1.0.0` / `1`.
- [x] v2-38 CI badging: compileSdk 36 / targetSdk 36.
- [ ] Production AAB üzerinde versionName/versionCode ve targetSdk son kez doğrulanacak.

## C. Android privacy / security manifest sözleşmesi

Production release için hedef sözleşme:

- [x] `src/main/AndroidManifest.xml` içinde `<uses-permission>` yok.
- [x] `android:allowBackup="false"`.
- [x] `android:fullBackupContent="@xml/backup_rules"`.
- [x] `android:dataExtractionRules="@xml/data_extraction_rules"`.
- [x] Android 11 ve altı backup rules tüm `root/file/database/sharedpref/external` domainlerini exclude eder.
- [x] Android 12+ data-extraction rules aynı domainleri hem `cloud-backup` hem `device-transfer` için exclude eder.
- [x] `android:usesCleartextTraffic="false"`.
- [x] Production workflow merged release manifestte herhangi bir `<uses-permission>` görülürse fail olur.
- [x] Production workflow `android:debuggable="true"` veya `android:testOnly="true"` görülürse fail olur.
- [x] Production workflow merged release manifestte `allowBackup=false` ve cleartext=false değerlerini doğrular.
- [x] Device Test workflow production-source backup/permission/cleartext guard’larını preflight olarak kontrol edecek şekilde güncellendi.
- [ ] Bu yeni guard’lar tek Device Test CI run’ında doğrulanacak.

## D. İmzalama

- [x] Device-test için ayrı ve sabit test sertifikası var.
- [x] Public test keystore production release’e bağlanmıyor.
- [x] Private signing dosyaları `.gitignore` ile ek olarak korunuyor.
- [x] Release signing config yalnız `PLAY_UPLOAD_*` secure environment değerleriyle bağlanacak şekilde hazırlandı.
- [x] `SIGNING_SETUP.md` Google’ın güncel Play App Signing / upload key modeline göre güncel.
- [x] Manuel `production-rc-aab.yml` workflow’u signing secret doğrulaması + signer fingerprint kontrolü ile hazırlandı.
- [ ] Google Play App Signing etkinleştirilecek / mevcut durum doğrulanacak.
- [ ] Ayrı private upload key oluşturulacak veya mevcut doğru production upload key kullanılacak.
- [ ] `PLAY_UPLOAD_*` GitHub Secrets gerçek private key bilgileriyle tanımlanacak.
- [ ] İlk signed production RC AAB workflow’u çalıştırılacak.

## E. Gizlilik ve Play politikaları

- [x] Final privacy policy Türkçe + İngilizce public `main` branch’te yayınlandı.
- [x] Privacy URL: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md`.
- [x] Support URL: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md`.
- [x] Resmi destek / gizlilik e-postası: `zmilastudio@gmail.com`.
- [x] Privacy policy Android backup exclusion, permissionless production sözleşmesi ve cleartext=false davranışıyla eşleştirildi.
- [x] Privacy policy `Raporu kopyala` / `TXT olarak kaydet` user-initiated export akışını ve dışa aktarılan verinin app silme alanı dışında kalabileceğini açıklar.
- [x] `PLAY_STORE_DATA_SAFETY.md` teknik taslağı güncel.
- [x] `PLAY_CONSOLE_FORM_ANSWERS.md` backup, permissionless release ve report export ile güncel.
- [x] Reklam/analytics/cloud SDK’sı mevcut uygulama bağımlılıklarında kullanılmıyor.
- [x] Uygulama içinde yerel veri silme mekanizması var.
- [x] Uygulama içinde gizlilik yaklaşımı kullanıcıya açıklanıyor.
- [ ] Play Console Veri Güvenliği formu production build ile son kez karşılaştırılacak.
- [ ] İçerik derecelendirmesi / IARC formu Console’da doldurulacak.
- [ ] Hedef kitle `18+` seçimi Console’da uygulanacak.
- [ ] App access: özel erişim gerekmez beyanı Console’da uygulanacak.

## F. Play Store mağaza içeriği

- [x] Türkçe mağaza metni: `PLAY_STORE_LISTING_TR.md`.
- [x] İngilizce mağaza metni: `PLAY_STORE_LISTING_EN.md`.
- [x] Uygulama adı: `Takip Analizi`.
- [x] Türkçe kısa açıklama hazır — 68/80 karakter.
- [x] Türkçe tam açıklama 4.000 karakter sınırının altında.
- [x] İngilizce kısa açıklama hazır — 77/80 karakter.
- [x] Önerilen kategori: `Araçlar / Tools`.
- [x] Metadata yanıltıcılık ve resmi Instagram/X ilişkisi ima etmeme guardrail’leri yazıldı.
- [x] Store listing contact alanları gerçek privacy/support URL ve e-posta ile doldurulmaya hazır.
- [x] `STORE_VISUAL_CAPTURE_PLAN.md`: 8 gerçek uygulama screenshot’ı için çekim ve privacy planı hazır.
- [x] Sentetik Instagram/X store-demo snapshot ZIP’leri hazır; gerçek kişi verisi kullanılmayacak.
- [x] **512×512 mağaza simgesi hazırlandı**; exact orijinal kullanıcı rasterından yalnız Lanczos resize ile türetildi.
  - PNG: 512×512 RGB, 169.565 byte.
  - SHA-256: `c838ffe6ef39bab9cab0176951334f8dc79e0158fc02755cb27ca28c856ae717`.
  - Türetme kaydı: `STORE_ICON_DERIVATION.md`.
- [ ] Telefon ekran görüntüleri production RC’den alınacak.
- [ ] Gerekirse 7 inç / 10 inç tablet ekran görüntüleri hazırlanacak.
- [ ] 1024×500 feature graphic hazırlanacak.
- [ ] Play Console’daki mevcut tag listesinden en fazla 5 gerçekten ilgili etiket seçilecek.

## G. Release build

- [x] Production RC için manuel CI workflow tasarlandı; push’ta otomatik çalışmaz.
- [x] Workflow varsayılan production sürümü `1.0.0 / 1`.
- [x] Workflow `flutter analyze` + tüm testleri production build öncesi çalıştırır.
- [x] Workflow private upload sertifikası SHA-256 fingerprint’ini build öncesi ve AAB sonrası doğrular.
- [x] Workflow exact launcher source SHA-256 kilidini doğrular.
- [x] Workflow merged release manifestte targetSdk 36’yı doğrular.
- [x] Workflow merged release manifest için permissionless / non-debuggable / non-testOnly / no-backup / no-cleartext sözleşmesini doğrular.
- [x] AAB artifact retention 1 gün ile sınırlandı.
- [ ] Gerçek private signing secrets tanımlandıktan sonra `flutter build appbundle --release` çalıştırılacak.
- [ ] AAB package id = `com.zmilastudio.takipanalizi` son build üzerinde doğrulanacak.
- [ ] versionName/versionCode doğrulaması gerçek AAB/Play upload üzerinde tamamlanacak.
- [ ] Release sertifika/upload key doğrulamasının gerçek AAB’de PASS olması.
- [ ] AAB boyutu ve native kütüphaneler kontrolü.

## H. Son cihaz testi — ilk production 1.0.0

**Önemli:** `.dev` device-test paketi ile production paket farklı applicationId kullanır. Bu nedenle ilk production `1.0.0`, v2-38 `.dev` uygulamasının üstüne upgrade değildir ve `.dev` verisini devralmamalıdır.

İlk production RC test turunda:

- [ ] Production paket **temiz kurulum** olarak Play Internal Testing / uygun production-signed dağıtım üzerinden yüklenir.
- [ ] Package id `com.zmilastudio.takipanalizi` doğrulanır.
- [ ] Instagram demo snapshot 1 import.
- [ ] Instagram demo snapshot 2 aynı hesapla import; otomatik geçmiş karşılaştırma doğrulanır.
- [ ] 5 analiz sekmesi.
- [ ] Arama/sıralama.
- [ ] Profil açma.
- [ ] Yok say / geri yükle.
- [ ] Analiz geçmişi.
- [ ] Manuel snapshot karşılaştırma.
- [ ] Raporu kopyala / TXT kaydet; TXT dosyasının kullanıcı seçtiği hedefe gittiği doğrulanır.
- [ ] Yerel Veri Yönetimi.
- [ ] Gizlilik ve Hakkında ekranında backup/export güncel metinleri görünür.
- [ ] X demo snapshot 1 + snapshot 2 import.
- [ ] X arşivi direct JS fallback.
- [ ] X arşiv rehberi.
- [ ] Uygulama kapatılıp yeniden açıldığında **aynı production kurulumu içinde** local geçmiş kalıcılığı doğrulanır.
- [ ] Gerçek kullanıcı X arşiviyle tek kritik fiziksel doğrulama yapılır.

### Production upgrade testi

- İlk production sürümünde `.dev → production` upgrade testi **uygulanmaz**; paketler farklıdır.
- Gerçek production upgrade/veri koruma testi ancak production `1.0.0` yayınlandıktan sonra sonraki production sürümünde (`versionCode > 1`) aynı `com.zmilastudio.takipanalizi` package üzerinde yapılabilir.

## I. Yayın kararı

Aşağıdaki dört madde tamamlanmadan production rollout yapılmayacak:

1. Private Play upload signing tamamlanmış olmalı.
2. Play Data Safety / IARC / target audience / app access formları Console’da tamamlanmış olmalı.
3. Store screenshot’ları + feature graphic tamamlanmış olmalı.
4. Production RC temiz kurulum + local persistence + gerçek X kritik fiziksel testten PASS almalı.
