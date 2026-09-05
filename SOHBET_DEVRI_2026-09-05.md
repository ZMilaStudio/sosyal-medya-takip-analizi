# SOHBET DEVRİ — 5 Eylül 2026

Bu dosya `ZMilaStudio/sosyal-medya-takip-analizi` projesinin yeni sohbete güvenli devri içindir.

## Yeni sohbet ilk talimatı
Yeni sohbette önce:
1. `PROJE_OZETI.md`
2. `SOHBET_DEVRI_2026-09-05.md`
3. canlı `dev/ads-v1` branch durumu
okunmalı; sonra aşağıdaki **Sıradaki kesin iş** bölümünden devam edilmelidir.

## Kritik çalışma kuralları
- Exact launcher/logo kullanıcı onaylı rasterdır; yeniden çizilmez, regenerate edilmez, yaklaşık ikonla değiştirilmez.
- CI SUCCESS fiziksel PASS değildir.
- Kullanıcıyı sürekli test operatörü yapma; yalnız kritik production RC kapısında fiziksel doğrulama iste.
- Gereksiz GitHub Actions çalıştırma; büyük ve mantıklı paketler halinde ilerle.
- Analiz ekranının fiziksel çalışan mimarisini bozma: 5 tab, basit `Column + Expanded(TabBarView) + _UserList`, `ListView.separated`, `ListTile`, `CircleAvatar`.
- Sosyal medya şifresi/private API/scraping/otomatik follow-unfollow yok.

## Ürün özeti
Flutter + Dart Android uygulaması. Instagram ve X/Twitter resmi kullanıcı arşivlerinden local-first takip ilişkisi analizi yapar.

5 kategori:
- Takip Etmeyenler
- Karşılıklı
- Seni Takip Edenler
- Takibi Bırakanlar
- Yeni Takipçiler

Ek özellikler: snapshot/geçmiş, otomatik ve manuel karşılaştırma, arama/sıralama, profil linki, Yok say, son hesaplar, geçmiş filtreleri/silme, rapor kopyala/TXT, Yerel Veri Yönetimi, Instagram/X rehberleri, Gizlilik ve Hakkında.

## Reklam modeli — KİLİTLİ
Kullanıcıyla birlikte karar verildi:
- Google Mobile Ads / AdMob.
- Dengeli reklam modeli.
- App Open reklamı yok.
- Rewarded reklam yok.
- Banner uygun mümkün olduğunca çok ekranda olacak.
- Takipçi listelerinde banner satır aralarında değil, ekran altında anchored/adaptive olarak kalacak.
- Dosya seçme, ZIP/JS okuma ve analiz yükleme sırasında banner bastırılacak.
- İlk analiz sonucu görülmeden interstitial yok.
- Interstitial yalnız analizden doğal çıkışta değerlendirilecek.
- Minimum interstitial aralığı 10 dakika.
- Oturum başına maksimum 2 interstitial.
- Sosyal medya arşiv içeriği/takip listeleri/snapshot verileri reklam amacıyla Google'a gönderilmeyecek; reklam SDK trafiği analiz verisinden ayrı tutulacak.

## Exact launcher kilidi
Kaynak:
`apps/mobile/android/app/src/main/res/drawable-nodpi/takip_launcher_user.webp`

SHA-256:
`7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`

Manifest doğrudan `@drawable/takip_launcher_user` kullanır.

## Bilinen fiziksel çalışan baseline
`v2-39` test package: `com.zmilastudio.takipanalizi.dev`
- Tested commit: `0816b8811aae6cf7aa2be67e63c524156093507b`
- Actions: `33551771267` SUCCESS
- APK SHA-256: `d18151fbc8c75897abd14934cc71b9ef29911b1d035cb6c1670a176fac9dde97`
- Samsung fiziksel cihazda gerçek listeler ve temel akışlar PASS.

## Reklamsız production baseline — ARŞİV, FINAL DEĞİL
Reklam kararı öncesi production RC başarılıydı ancak artık final yayın adayı değildir.
- Package: `com.zmilastudio.takipanalizi`
- Reklamsız AAB success run: `33627604993`
- Reklamsız APK success run: `33658171635`
- Reklamsız APK SHA-256: `355a9687b72fc080b1b3d23d5e06fab2149c185d6142f31c02a5532fad765aca`
- Backup: `backup/pre-ads-v1`

## Ads RC 1.0.0 (2) — CI SUCCESS, FİZİKSEL FAIL
Branch: `dev/ads-v1`

CI:
- Run `33804644499`
- Job `100812076200`
- Head `066881777128e9c855334298caaf3aaba4b1c29c`
- Analyze clean
- 23/23 test PASS
- Signed release APK PASS
- Package/version/targetSdk/signer/launcher/manifest PASS

Artifact:
- `takip-analizi-ads-rc-apk-1.0.0-2`
- ID `9912704423`
- APK SHA-256 `4dee1e0f955508ff9b12990bebf69a0803f15c6696331b78e858b007c98bce23`

### 5 Eylül 2026 fiziksel kanıt
Kullanıcı Samsung cihazda `(2)` APK'yı kurdu. İki ayrı ekran görüntüsünde uygulama Flutter ana ekranına geçemeden splash/startup aşamasında Android tarafından kapatıldı:
- İlk ekran yaklaşık 14:00: `Takip Analizi sürekli olarak duruyor`.
- İkinci ekran 15:36: aynı crash tekrarlandı.

Bu nedenle `(2)` kesin **FİZİKSEL FAIL** ve yayın adayı değildir.

Kesin Android stack trace/logcat alınmadı; bu yüzden hataya kanıtsız kesin exception adı verilmemeli. Regresyon reklam entegrasyonu/startup yoluna izole edildi. Güçlü şüphe Google Mobile Ads'in Flutter ilk frame'inden önce çalışan `MobileAdsInitProvider` erken startup yoluydu. Test AdMob App ID merged manifestte mevcuttu; sorun sadece “App ID yok” diye etiketlenmedi.

Backup:
`backup/ads-v1-startup-crash-baseline`

## Startup-safe Ads RC 1.0.0 (3) — CURRENT CANDIDATE
Bu, yeni sohbetin esas devam noktasıdır.

Çalışma önce `dev/ads-startup-safe-v1` üzerinde hazırlandı ve sonra `dev/ads-v1` üzerine fast-forward taşındı.

Runtime/code head:
`7da23dfd61564d2bb28efa653c1489d22ff3ae50`

Yapılan startup güvenlik düzeltmeleri:
- Version `1.0.0+3`.
- Aynı package: `com.zmilastudio.takipanalizi`.
- Aynı production upload signer; `(2)` üzerine update kurulabilir.
- Google Mobile Ads library'nin erken `com.google.android.gms.ads.MobileAdsInitProvider` provider'ı manifest merge'de `tools:node="remove"` ile kaldırıldı.
- AdMob App ID metadata korunuyor.
- `MobileAds.instance.initialize()` ve UMP işlemleri Flutter ilk frame'den sonra 750 ms gecikmeli başlatılıyor.
- `AdsCoordinator` startup/consent/MobileAds init hatalarında fail-closed: reklamlar devre dışı kalmalı, ana analiz uygulaması çalışmaya devam etmeli.
- Interstitial load/show ve privacy options exception-safe hale getirildi.
- Exact launcher ve çalışan analiz mimarisi değiştirilmedi.
- Reklam permission seti exact whitelist ile CI'da kilitlendi.

### `(3)` CI sonucu
Run: `33962525980`
Job: `101296777913`
Conclusion: **SUCCESS**

PASS:
- private Play upload key + certificate fingerprint
- package `com.zmilastudio.takipanalizi`
- versionName `1.0.0`, versionCode `3`
- target/compile SDK 36
- `flutter analyze` clean
- 23/23 test
- signed release APK
- signer doğrulama
- `allowBackup=false`
- `usesCleartextTraffic=false`
- Google test AdMob App ID
- debuggable/testOnly yok
- merged release manifestte `MobileAdsInitProvider` yok
- exact reklam permission whitelist
- exact launcher resource table
- artifact upload

Artifact:
- Ad: `takip-analizi-ads-startup-safe-rc-apk-1.0.0-3`
- ID: `9968483492`
- ZIP: `31,114,323` byte
- ZIP digest: `sha256:21e1497977974f645db73e2097b387e815693fef6290ef179987c9fe38b3e8f1`
- APK: `64,743,709` byte
- APK SHA-256: `e0185d2f33f643e0c14814f8f812df00d84787a995e08f2adee0c4a8d6a723b7`
- Kullanıcıya hazırlanmış dosya adı: `Takip-Analizi-1.0.0-3-ads-startup-safe-test-rc.apk`

**Önemli:** `(3)` CI SUCCESS olmasına rağmen henüz kullanıcı cihazında fiziksel PASS almadı.

## Reklamlı merged Android permission whitelist
`(3)` için kilitli set:
- `android.permission.ACCESS_ADSERVICES_AD_ID`
- `android.permission.ACCESS_ADSERVICES_ATTRIBUTION`
- `android.permission.ACCESS_ADSERVICES_TOPICS`
- `android.permission.ACCESS_NETWORK_STATE`
- `android.permission.FOREGROUND_SERVICE`
- `android.permission.INTERNET`
- `android.permission.WAKE_LOCK`
- `com.google.android.gms.permission.AD_ID`
- `com.zmilastudio.takipanalizi.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`

Yok:
- MANAGE_EXTERNAL_STORAGE
- READ/WRITE_EXTERNAL_STORAGE
- contacts
- camera
- microphone
- location
- SMS
- call log

## Production signing
Private Play upload key hazır ve GitHub Secrets 5/5 tamam.
- Alias: `takip-upload`
- RSA 3072
- Upload certificate SHA-256: `def6c59b9a84f51af6ea5c768f21927ecbadb868ec5dbcd17dc031876b5cca65`
- Private keystore/parolalar repoya commit edilmedi.

## Privacy / Play durumu
Reklamlı modele göre `dev/ads-v1` üzerinde güncellendi:
- `PRIVACY_POLICY.md`
- `PLAY_STORE_DATA_SAFETY.md`
- `PLAY_CONSOLE_FORM_ANSWERS.md`
- uygulama içi `Gizlilik ve Hakkında`

Play Console:
- Ads beyanı **Yes** olacak.
- Final canlı reklam build fiziksel PASS almadan Play Console final yüklemesine geçme.
- Public `main` privacy metni final canlı build kilitlenince reklamlı sürüme taşınacak.
- Canlı AdMob App ID / banner unit ID / interstitial unit ID henüz oluşturulup bağlanmadı.

## Aktif branchler
- `test/device-apk` → v2-39 fiziksel çalışan baseline.
- `backup/device-v2-39-release-hardening-ci-working` → fiziksel baseline backup.
- `backup/pre-ads-v1` → reklam entegrasyonu öncesi güvenli production hazırlığı.
- `backup/ads-v1-startup-crash-baseline` → `(2)` startup crash dönemi.
- `dev/release-polish-v1` → reklamsız production/store baseline.
- `dev/ads-v1` → **aktif**, startup-safe `1.0.0 (3)` CI SUCCESS, fiziksel PASS bekliyor.
- `dev/ads-startup-safe-v1` → startup fix hazırlık branch'i.
- `main` → public privacy/support + eski production workflow; reklamlı final privacy henüz taşınmadı.

## Sıradaki kesin iş
**Kod değiştirmeden önce `(3)` fiziksel açılış doğrulaması.**

1. Kullanıcı Samsung cihazda `1.0.0 (3)` startup-safe APK'yı kurmalı.
2. İlk ve en kritik kontrol yalnız şu: uygulama splash ekranını geçip normal ana ekrana açılıyor mu?
3. Açılış hala crash ise yeni varsayım üretip rastgele kod değiştirme; mümkünse Android hata ayrıntısı/logcat edin ve startup provider/native initialization katmanını yeniden incele.
4. Açılış PASS ise aynı tek fiziksel turda:
   - anchored banner görünümü ve UI'yı kapatmaması,
   - Instagram gerçek arşiv analizi,
   - 5 liste,
   - profil/Yok say temel smoke,
   - analizden doğal geri çıkışta test interstitial,
   - kapat/aç persistence,
   - X gerçek arşiv smoke
   doğrulanır.
5. Bu tur PASS olduktan sonra AdMob Console'da gerçek Android app kaydı + canlı App ID + banner + interstitial unit ID oluşturulur.
6. Canlı ID'ler güvenli CI inputs/secrets ile final signed AAB'ye verilir; repoya sabit secret yazılmaz.
7. Sonra Play App Signing / Internal testing / Ads + Data Safety + IARC + app access / store görselleri tamamlanır.

## Yeni sohbete kısa başlangıç cümlesi
`PROJE_OZETI.md ve SOHBET_DEVRI_2026-09-05.md dosyalarını oku. dev/ads-v1 üzerindeki startup-safe 1.0.0 (3) RC'den devam et. Önce fiziksel startup PASS durumunu esas al; (2) sürümünün splash aşamasında fiziksel FAIL olduğunu unutma.`
