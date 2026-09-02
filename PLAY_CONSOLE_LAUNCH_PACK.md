# Takip Analizi — Play Console Launch Pack

Son güncelleme: 2 Eylül 2026

Bu dosya Google Play Console'da production `1.0.0 (1)` yayını hazırlanırken izlenecek **tek sıra**dır. Amaç; aynı bilgiyi farklı ekranlarda tekrar üretmemek ve form cevaplarını gerçek production AAB ile tutarlı tutmaktır.

## 0. Production build kapısı

Play Console'a AAB yüklemeden önce:

- [x] Private upload key oluşturuldu ve self-test edildi.
- [ ] GitHub repository Actions secret'ları girildi.
- [ ] `Production RC AAB` workflow'u `1.0.0 / 1` ile çalıştırıldı.
- [ ] Workflow SUCCESS.
- [ ] AAB signer fingerprint upload certificate ile eşleşti.
- [ ] package = `com.zmilastudio.takipanalizi`.
- [ ] versionName = `1.0.0`.
- [ ] versionCode = `1`.
- [ ] targetSdk = 36.
- [ ] merged release manifestte `INTERNET` yok.
- [ ] merged release manifestte AndroidX internal receiver izni dışında başka `uses-permission` yok.
- [ ] `allowBackup=false`.
- [ ] cleartext=false.
- [ ] debuggable/testOnly=false.

Bu blok tamamlanmadan Data Safety cevapları final gönderim olarak kilitlenmeyecek.

## 1. App integrity / Play App Signing

Play Console → **Setup / App integrity** alanında:

- [ ] Play App Signing durumu doğrula.
- [ ] App signing certificate ile **upload certificate'in farklı roller olduğunu** kontrol et.
- [ ] Upload certificate SHA-256 beklenen değer:
  `def6c59b9a84f51af6ea5c768f21927ecbadb868ec5dbcd17dc031876b5cca65`
- [ ] Google Play'in istediği upload certificate kaydı/ilk yükleme akışı tamamlanmış olsun.

Private `.jks` hiçbir zaman Play Console'a veya repoya düz dosya olarak yüklenmeyecek; gerektiğinde yalnız public certificate kullanılacak.

## 2. App content — önce ön koşullar

Google Play target audience bölümünden önce Ads ve App access beyanlarının tamamlanmasını ister. Privacy policy de hazır olmalıdır.

### Privacy policy

URL:
`https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md`

- [ ] URL anonim/incognito tarayıcıda açılıyor.
- [ ] Play Console privacy alanına girildi.

### Ads

**Does your app contain ads? → No**

- [ ] Kaydet.

### App access

**All functionality is available without special access / login.**

Reviewer note:

`No login or special access is required. Archive analysis is performed locally on files explicitly selected by the user.`

- [ ] Kaydet.

## 3. Target audience and content

Önerilen hedef grup:

**18 and over / 18 yaş ve üstü**

Neden:

- çocuklara yönelik tasarım yok,
- oyun/eğitim/çocuk içeriği yok,
- ürün yetişkin sosyal medya kullanıcılarının kendi arşivini analiz eden yardımcı araçtır.

- [ ] 18+ seçildi.
- [ ] Çocukları hedefleyen ek yaş grubu seçilmedi.
- [ ] Console ek bir minor restriction seçeneği gösterirse ürün davranışına göre ayrıca değerlendirildi; otomatik işaretlenmedi.

## 4. Content rating / IARC

Uygulama tipi için utility/productivity/other yönünde en yakın kategori seçilir.

Mevcut ürün davranışına göre temel cevaplar:

- Violence → No
- Sexual content / nudity → No
- Profanity → No
- Controlled substances → No
- Gambling → No
- Horror / fear → No
- Location sharing → No
- Digital purchases → No
- Takip Analizi kullanıcıları arasında native messaging / content exchange → No
- Uygulama içinde host edilen user-generated content → No

Harici Instagram/X profilini açmak Takip Analizi kullanıcıları arasında native sosyal özellik değildir.

- [ ] Questionnaire tamamlandı.
- [ ] IARC'ın ürettiği gerçek rating kaydedildi.
- [ ] Rating önceden tahmin edilmedi/uydurulmadı.

## 5. Data Safety

Gerçek production AAB workflow'u PASS ise mevcut mimari için temel beyan:

**Does your app collect or share any of the required user data types? → No**

Teknik dayanak:

- arşiv verileri cihazda işlenir,
- developer backend yok,
- analytics/reklam/cloud SDK yok,
- production INTERNET yok,
- local data Android auto backup dışında tutulur,
- rapor clipboard/TXT export'u kullanıcı tarafından açıkça başlatılır,
- external profile open kullanıcı tarafından başlatılır.

- [ ] `PLAY_CONSOLE_FORM_ANSWERS.md` ile cevaplar karşılaştırıldı.
- [ ] `PLAY_STORE_DATA_SAFETY.md` ile production AAB manifest sonucu karşılaştırıldı.
- [ ] Form tamamlandı.

Mimari production AAB ile bu tanımdan saparsa `No` cevabı otomatik kullanılmayacak; önce belgeler güncellenecek.

## 6. Diğer App Content deklarasyonları

Mevcut ürün için:

- News app → No
- Government app / affiliation → No
- Health features → No
- Financial features → No
- Uygulama kendi kullanıcı hesabını oluşturuyor mu? → No

Sensitive/high-risk Android permission declaration ekranı yalnız Play gerçek AAB'de buna ihtiyaç tespit ederse ele alınır. Mevcut release sözleşmesinde böyle permission yoktur.

- [ ] Görünen ilgili deklarasyonlar tamamlandı.

## 7. Main store listing — Türkçe

Kaynak:
`PLAY_STORE_LISTING_TR.md`

### App name

`Takip Analizi`

### Short description

`Instagram ve X takip ilişkilerini arşivlerinden cihazında analiz et.`

### Category

`Araçlar / Tools`

### Contact

E-posta:
`zmilastudio@gmail.com`

Website/support:
`https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md`

Privacy:
`https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md`

- [ ] TR listing metni girildi.
- [ ] Support email girildi.
- [ ] Support URL girildi.
- [ ] Privacy URL girildi.
- [ ] Araçlar kategorisi seçildi.
- [ ] Console'un gerçek tag listesinden en fazla 5 alakalı tag seçildi; tag adı uydurulmadı.

## 8. English store listing

Kaynak:
`PLAY_STORE_LISTING_EN.md`

- [ ] English localization eklendi.
- [ ] App name aynı: `Takip Analizi`.
- [ ] EN short/full description girildi.

## 9. Store graphics

### 512×512 icon

Exact source-derived store icon:

- 512×512 RGB PNG
- SHA-256:
  `c838ffe6ef39bab9cab0176951334f8dc79e0158fc02755cb27ca28c856ae717`

- [ ] Upload öncesi hash doğrulandı.
- [ ] Icon yüklendi.

### Feature graphic

Türkçe aday:
`takip-analizi-feature-graphic-1024x500-v2.png`

SHA-256:
`73d4e9eec5564945813f2d6fc9aa9206693979a7c68c126dcf5cce63a4afc838`

English aday:
`takip-analizi-feature-graphic-1024x500-en.png`

SHA-256:
`e6b2da9520d4a95a2762337f0e09d558e5aeacb91cb3902e371a8453a12f0bf1`

- [ ] Kullanıcı final görseli onayladı.
- [ ] 1024×500 RGB/alfa yok kontrol edildi.
- [ ] İlgili localization'a yüklendi.

### Phone screenshots

Kaynak plan:
`STORE_VISUAL_CAPTURE_PLAN.md`

- [ ] Production RC ile sentetik demo verisi kullanıldı.
- [ ] 8 adet gerçek-app screenshot hazır.
- [ ] 1080×1920 / 9:16.
- [ ] Gerçek kullanıcı adı/takipçi/bildirim yok.
- [ ] Görüntü esnetilmedi.
- [ ] Alt text girildi.

## 10. İlk release hazırlığı

Önerilen release adı:

`Takip Analizi 1.0.0 (1)`

Release notes kaynağı:
`PLAY_RELEASE_NOTES.md`

- [ ] Signed AAB yüklendi.
- [ ] Play'in otomatik package/version incelemesi beklenen değerleri gösteriyor.
- [ ] TR release notes girildi.
- [ ] EN release notes girildi.
- [ ] Play pre-review / policy warning'leri incelendi.

## 11. Önce Internal Testing

İlk production package `.dev` test paketinden farklıdır. Bu nedenle ilk fiziksel production RC kontrolü için uygun yol Play **Internal Testing** üzerinden production package'ı temiz kurmaktır.

- [ ] Internal Testing release oluşturuldu.
- [ ] Yetkili test cihazına Play üzerinden kuruldu.
- [ ] Package: `com.zmilastudio.takipanalizi`.
- [ ] Instagram demo snapshot1 + snapshot2.
- [ ] 5 analiz sekmesi.
- [ ] Arama/sıralama.
- [ ] Profil açma.
- [ ] Yok say / geri yükle.
- [ ] Geçmiş + manuel snapshot comparison.
- [ ] TXT kaydet / panoya kopyala.
- [ ] Yerel Veri Yönetimi.
- [ ] X demo snapshot1 + snapshot2.
- [ ] X direct JS fallback.
- [ ] Uygulama kapat/aç → local persistence.
- [ ] Gerçek kullanıcı X arşivi tek kritik fiziksel doğrulama.

Bu tek final RC turudur; küçük ayrı PASS döngülerine dönülmez.

## 12. Production rollout kapısı

Aşağıdakilerin tamamı olmadan production rollout başlatılmaz:

- [ ] Production AAB CI SUCCESS.
- [ ] Play App Signing / upload certificate doğru.
- [ ] App Content + Data Safety + IARC + target audience tamam.
- [ ] TR/EN listing + graphics tamam.
- [ ] Internal Testing final RC fiziksel PASS.
- [ ] Play Console'da çözülmemiş blocking warning yok.

## Resmi Google Play referansları

- App content / review readiness: https://support.google.com/googleplay/android-developer/answer/9859455
- Prepare and roll out a release / release notes: https://support.google.com/googleplay/android-developer/answer/9859348
- Data Safety: https://support.google.com/googleplay/android-developer/answer/10787469
- Target audience: https://support.google.com/googleplay/android-developer/answer/9867159
- Content ratings: https://support.google.com/googleplay/android-developer/answer/9859655
