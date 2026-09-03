# Takip Analizi — Play Console Form Cevap Taslağı

Son güncelleme: 3 Eylül 2026

Bu dosya **reklamlı Takip Analizi 1.0.0 (2)** adayı için Play Console cevap taslağıdır. Final AAB ve canlı AdMob kimlikleri doğrulanmadan Console’a körlemesine kopyalanmamalıdır.

## 1. Privacy policy

Privacy policy URL:
`https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md`

Gizlilik / destek:
`zmilastudio@gmail.com`

Support URL:
`https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md`

Uygulama içinde `Gizlilik ve Hakkında` ekranı ve gerektiğinde Google UMP privacy-options girişi vardır.

## 2. Ads

**Uygulama reklam içeriyor mu? → Evet / Yes**

Formatlar:
- anchored adaptive banner,
- seyrek interstitial.

Başlangıçta App Open ve rewarded kullanılmaz.

Interstitial ürün kuralı:
- ilk analiz sonucu görünmeden gösterilmez,
- yalnız analiz tamamlandıktan sonraki doğal çıkış/geçişte,
- iki interstitial arasında en az 10 dakika,
- oturum başına en fazla 2.

## 3. App access

**Özel erişim / üyelik / login gerekiyor mu? → Hayır / No**

- Takip Analizi kendi kullanıcı hesabını oluşturmaz.
- Instagram/X hesabına giriş yapmaz.
- Sosyal medya şifresi istemez.
- Arşiv analizi için kullanıcı kendi resmi dışa aktarma dosyasını seçer; bu özel uygulama erişimi değildir.

Reviewer note:
`No login or special access is required. Archive analysis is performed locally on files explicitly selected by the user.`

## 4. Data safety — temel cevap

### Does your app collect or share any required user data types?

**Yes / Evet.**

Sebep: Google Mobile Ads SDK reklam sunumu, analytics ve fraud prevention için cihaz dışına veri aktarabilir. Sosyal medya arşiv içeriği ise cihazda kalır ve reklam isteğine eklenmez.

### Önerilen data-type cevapları

Google Mobile Ads’in güncel resmi data disclosure belgesine göre muhafazakâr Play eşlemesi:

- **Location → Approximate location** — Collected: Yes, Shared: Yes. IP address genel konum tahmini için kullanılabilir.
- **App activity → App interactions** — Collected: Yes, Shared: Yes.
- **App info and performance → Diagnostics** — Collected: Yes, Shared: Yes.
- **Device or other IDs** — Collected: Yes, Shared: Yes.

Amaçlar, Console’daki güncel seçeneklere göre:
- Advertising or marketing,
- Analytics,
- Fraud prevention, security and compliance.

Google Mobile Ads resmi kaynak:
https://developers.google.com/admob/android/privacy/play-data-disclosure

### Is data encrypted in transit?

**Yes / Evet.** Google Mobile Ads SDK bu aktarımların TLS ile şifrelendiğini belirtir.

### User choice / consent

Uygulama UMP kullanır:
- her launch’ta consent info update,
- gerekliyse consent form,
- `canRequestAds()` false ise reklam isteği yapılmaz,
- gerekli olduğunda uygulama içinden privacy options tekrar açılabilir.

Final Console’daki “optional/required” alanı, o günkü form ifadesi ve aktif AdMob consent yapılandırmasıyla yeniden doğrulanacaktır.

### Local-only social archive data

Aşağıdaki analiz verileri ZMila Studio sunucusuna gönderilmez ve AdMob reklam request’ine eklenmez:
- Instagram/X kullanıcı adı veya hesap kimliği,
- followers/following listeleri,
- analiz kategorileri,
- snapshot geçmişi,
- Yok say tercihleri.

### External profile links

Kullanıcı profil açmayı açıkça kendisi başlatır; Android bağlantıyı ilgili sosyal uygulamaya/tarayıcıya devreder. Sonraki veri işleme üçüncü tarafın politikasına tabidir.

### Report copy / TXT export

Kullanıcı açıkça başlatır:
- `Raporu kopyala` → sistem panosu,
- `TXT olarak kaydet` → kullanıcının seçtiği dosya hedefi.

Rapor ZMila Studio sunucusuna gönderilmez.

### Local deletion

`Yerel Veri Yönetimi` ekranı analiz geçmişini, Yok say tercihlerini ve app-managed yerel veriyi silebilir. ZMila Studio tarafında kullanıcı hesabı veya analiz verisi backend’i yoktur.

Reklam ağı tarafından işlenen veriler Google’ın privacy/ad-ID/consent kontrollerine tabidir.

## 5. Target audience and content

**Önerilen hedef yaş: 18 and over / 18 yaş ve üstü**

Uygulama çocuklara yönelik değildir. Çocuklara yönelik karakter, oyunlaştırma veya eğitim içeriği yoktur.

## 6. Content rating / IARC

En yakın kategori: **Utility / Productivity / Other**.

Mevcut içerik için başlangıç cevapları:
- Violence → No
- Sexual content / nudity → No
- Profanity → No
- Controlled substances → No
- Gambling → No
- Horror/fear → No
- App-hosted user-generated content → No
- Native user-to-user communication → No
- Location sharing feature → No
- Digital goods / purchases → No

IARC sonucu Console tarafından üretilecek.

## 7. App category

**Tools / Araçlar**

## 8. News app

**No**

## 9. Government app

**No**

## 10. Health features

**No**

## 11. Financial features

**No**

## 12. Account creation / deletion

Takip Analizi kendi kullanıcı hesabını oluşturmaz. Bu nedenle uygulama hesabı silme akışı yoktur. Yerel uygulama verileri uygulama içinden silinebilir.

## 13. Permissions / network

Reklamlı production sözleşmesi:
- source main manifestte geniş kullanıcı-verisi runtime izinları eklenmez,
- Google Mobile Ads merged manifest üzerinden ağ/reklam izinları ekleyebilir,
- `INTERNET` artık reklamlı production’da beklenen bir izindir,
- `android:usesCleartextTraffic="false"` korunur,
- `android:allowBackup="false"` korunur,
- broad storage / contacts / SMS / call logs / camera / microphone / location runtime izinları kullanılmaz,
- `debuggable=true` ve `testOnly=true` production’da reddedilir,
- exact launcher korunur.

İlk reklamlı RC build gerçek merged permission setini çıkaracak; final CI whitelist bu sete göre kilitlenecek.

## 14. Target API

Final aday:
- compileSdk 36,
- targetSdk 36,
- Android 16 target.

Reklamlı AAB ve APK üzerinde yeniden doğrulanacaktır.

## 15. AdMob / UMP yayın kapısı

Production’a geçmeden önce:
1. Test App ID + Google test ad unit ID’leriyle reklamlı RC APK başarıyla build edilmeli.
2. Fiziksel cihazda banner, listeler, import sırasında reklam suppression ve capped interstitial kontrol edilmeli.
3. AdMob’da gerçek uygulama oluşturulmalı.
4. Canlı `ADMOB_APP_ID`, `ADMOB_BANNER_UNIT_ID`, `ADMOB_INTERSTITIAL_UNIT_ID` güvenli CI secrets olarak girilmeli.
5. Final AAB `ADMOB_USE_TEST_IDS=false` ile build edilmeli; sample/test IDs final pakette reddedilmeli.
6. Public privacy policy reklamlı metne güncellenmiş olmalı.
7. Ads ve Data Safety Console cevapları bu dokümanla final kez karşılaştırılmalı.

## Resmi referanslar

- Google Mobile Ads Data Safety disclosure: https://developers.google.com/admob/android/privacy/play-data-disclosure
- Google UMP Flutter: https://developers.google.com/admob/flutter/privacy
- Google Play Data Safety: https://support.google.com/googleplay/android-developer/answer/10787469
- Google Play User Data: https://support.google.com/googleplay/android-developer/answer/10144311
- Target audience: https://support.google.com/googleplay/android-developer/answer/9867159
- Content ratings: https://support.google.com/googleplay/android-developer/answer/9898843
