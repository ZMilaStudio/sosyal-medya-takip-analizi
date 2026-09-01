# Takip Analizi — Play Console Form Cevap Taslağı

Son güncelleme: 1 Eylül 2026

Bu dosya, mevcut **local-first v2-38 / release-polish** mimarisine göre Google Play Console formlarında kullanılacak cevap taslağıdır. Production AAB davranışı değişirse cevaplar yeniden kontrol edilmelidir.

## 1. Privacy policy

Privacy policy URL:

`https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md`

Geliştirici / gizlilik iletişimi:

`zmilastudio@gmail.com`

Support URL:

`https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md`

Uygulama içinde ayrıca güncel `Gizlilik ve Hakkında` ekranı vardır.

## 2. Ads

**Uygulama reklam içeriyor mu? → Hayır**

Mevcut bağımlılıklarda reklam SDK’sı yoktur ve uygulama reklam göstermez.

## 3. App access

**Uygulamanın tamamı veya bir bölümü özel erişim / üyelik / giriş bilgisi gerektiriyor mu? → Hayır**

- Takip Analizi kendi kullanıcı hesabını oluşturmaz.
- Instagram veya X hesabına giriş yapmaz.
- Sosyal medya şifresi istemez.
- Uygulama ekranları özel demo hesabı olmadan açılabilir.
- Arşiv analizi özelliğinin çalışması için kullanıcı kendi resmi Instagram/X dışa aktarma dosyasını seçer; bu bir uygulama erişim kısıtı değildir.

Reviewer notes gerekiyorsa:

`No login or special access is required. Archive analysis is performed locally on files explicitly selected by the user.`

## 4. Data safety — temel cevap

### Does your app collect or share any of the required user data types?

**Önerilen cevap: No**

Gerekçe:

- Instagram/X arşiv verileri yalnız cihaz üzerinde işlenir.
- Analiz/snapshot verileri uygulama tarafından cihazda tutulur.
- Mevcut mimaride ZMila Studio sunucusuna veri gönderilmez.
- Analytics, reklam veya cloud SDK’sı yoktur.
- Production release’in merged manifestinde **hiç Android permission bulunmaması** CI ile zorunlu tutulacaktır.
- Production manifestte `android:allowBackup="false"` vardır ve backup/data-transfer extraction rule’ları app-managed local data domainlerini hariç tutar.
- Google Play’in Data Safety tanımında yalnız cihazda erişilen/işlenen ve cihaz dışına gönderilmeyen veri “collected” olarak beyan edilmek zorunda değildir.

### External profile links

Kullanıcı bir hesap satırına dokunarak profil açmayı **kendisi başlatır**. URL, Android üzerinden ilgili sosyal uygulamaya veya tarayıcıya devredilir. Bu kullanıcı tarafından açıkça başlatılan ve beklenen bir eylemdir; Google’ın user-initiated transfer istisnası kapsamında “sharing” olarak beyan edilmesi gerekmeyen akış olarak değerlendirilmiştir.

### Report copy / TXT export

Kullanıcı analiz ekranındaki `Raporu kopyala` veya `TXT olarak kaydet` eylemini **kendisi başlatır**.

- `Raporu kopyala` analiz metnini Android sistem panosuna yazar.
- `TXT olarak kaydet` analiz metnini Android file picker üzerinden kullanıcının seçtiği dosya hedefine yazar.
- Rapor hesap kullanıcı adlarını ve kategori sonuçlarını içerebilir.
- Uygulama bu export’u ZMila Studio sunucusuna göndermez.
- Bu, kullanıcının kendi verisini açıkça seçtiği hedefe aktardığı user-initiated local export olarak değerlendirilir.

### Android automatic backup

Production release için:

- `android:allowBackup="false"`
- Android 11 ve altı `backup_rules.xml`
- Android 12+ `data_extraction_rules.xml`

ile app-managed local analiz verisi cloud backup / backup extraction kapsamı dışında bırakılmıştır.

Android dokümantasyonuna göre bazı OEM/system-level device-to-device migration davranışları uygulamanın tam kontrolü dışında olabilir. Bu nedenle mutlak bir “hiçbir sistem aktarımı olamaz” iddiası kullanılmaz; uygulama tarafından kontrol edilen backup policy’nin kapalı olduğu belirtilir.

### Local deletion

- Uygulama kendi cloud hesabını oluşturmaz.
- Geliştirici sunucusunda kullanıcı verisi tutulmaz.
- Kullanıcı `Yerel Veri Yönetimi` ekranından analiz geçmişini, yok sayılanları veya tüm yerel uygulama verisini silebilir.
- Android uygulama veri yönetimi / uygulama kaldırma da yerel veriyi temizlemek için kullanılabilir.
- Kullanıcının ayrıca dışa aktardığı TXT dosyası veya panoya kopyaladığı içerik uygulama sandbox’ı dışında olduğundan bunların silinmesi kullanıcının seçtiği hedef/sistem panosu üzerinden yönetilir.

### Encryption in transit

Mevcut local analysis akışında geliştirici sunucusuna veri transferi olmadığı için uygulama veri toplama akışına ilişkin “encryption in transit” beyanı uygulanabilir bir geliştirici veri transferi değildir.

Harici Instagram/X profili açma işlemi ilgili üçüncü taraf uygulama/tarayıcı tarafından yönetilir.

## 5. Target audience and content

### Target age groups

**Önerilen seçim: 18 and over / 18 yaş ve üstü**

Gerekçe:

- Uygulama çocuklar için tasarlanmamıştır.
- Çocuklara yönelik karakter, görsel dil, oyunlaştırma veya eğitim içeriği yoktur.
- Gizlilik politikası da ürünün çocuklara yönelik olmadığını belirtir.
- 13–17 yaş gruplarını sırf erişimi genişletmek için hedef kitleye eklememek Google’ın hedef kitle doğruluğu yaklaşımıyla uyumludur.

Ek `Restrict minors` seçeneği Console’da görünürse yalnız uygulamanın 18 yaş altına teknik olarak kapatılması isteniyorsa etkinleştirilecektir; sırf 18+ hedef kitle seçildi diye otomatik işaretlenmeyecektir.

## 6. Content rating / IARC

Kategori seçimi için en uygun başlangıç:

**Utility, Productivity, Communication, or Other**

Mevcut uygulama davranışına göre questionnaire yaklaşımı:

- Violence → No
- Sexual content / nudity → No
- Language / profanity → No
- Controlled substances → No
- Gambling → No
- Horror / fear → No
- User-generated content hosted/shared inside the app → No
- Native online interaction/content exchange between Takip Analizi users → No
- Location sharing → No
- Purchases / digital goods → No

Not: Uygulama kullanıcıları birbirleriyle iletişim kurmaz. Harici Instagram/X profil açma işlemi ikinci bir uygulamada gerçekleştiği için Takip Analizi’nin native online interaction özelliği değildir.

IARC sonucu Console tarafından üretilecektir; herhangi bir yaş derecesi önceden uydurulmayacaktır.

## 7. App category

**Tools / Araçlar**

Uygulama sosyal ağ değildir; kullanıcının resmi veri arşivini yerel olarak analiz eden yardımcı araçtır.

## 8. News app declaration

**News app? → No**

## 9. Government app declaration

**Government app / government affiliation? → No**

## 10. Health apps declaration

**Health-related features? → No**

## 11. Financial features declaration

**Financial features? → No**

Uygulama ödeme, kredi, yatırım, kripto, para transferi veya finansal hesap işlevi sunmaz.

## 12. Account creation / account deletion

Takip Analizi kendi kullanıcı hesabını oluşturmaz.

Bu nedenle Play’in uygulama-içi hesap oluşturan ürünlere yönelik account-deletion gereksinimi uygulanmaz. Yerel uygulama verisi için uygulama içi silme mekanizması mevcuttur.

## 13. Permissions / data access notları

Production sözleşmesi: **release merged manifestte `<uses-permission>` bulunmayacak.**

- Dosyalar Android sistem file picker üzerinden kullanıcı tarafından seçilir.
- `MANAGE_EXTERNAL_STORAGE` kullanılmaz.
- `READ/WRITE_EXTERNAL_STORAGE` kullanılmaz.
- `READ_MEDIA_*` kullanılmaz.
- Contacts / SMS / Call Log / Location / Camera / Microphone izinleri istenmez.
- Production kaynak manifestinde `android:usesCleartextTraffic="false"` vardır.
- Debug ve profile Flutter build’leri geliştirme araçları için `INTERNET` iznini kendi manifestlerinden ekleyebilir; bu production davranışı değildir.
- Production workflow gerçek merged release manifestte herhangi bir `<uses-permission>` görülürse fail olur.
- Production workflow `android:debuggable="true"` veya `android:testOnly="true"` görülürse fail olur.

## 14. Target API

v2-38 CI debug APK badging doğrulaması:

- `compileSdkVersion = 36`
- `targetSdkVersion = 36`
- platform build = Android 16

Bu, 31 Ağustos 2026’dan itibaren yeni mobil uygulamalar için geçerli API 36 hedefleme gereksinimiyle uyumludur.

Production AAB üzerinde de aynı targetSdk final release kontrol listesinde yeniden doğrulanacaktır.

## 15. Console’a girerken tekrar kontrol edilecekler

Aşağıdaki durumlarda bu dosyadaki cevapları otomatik kullanma; yeniden değerlendir:

- canlı Instagram/X API veya OAuth eklenirse,
- production release’e herhangi bir Android permission girerse,
- `usesCleartextTraffic`, `allowBackup` veya backup/data-extraction policy gevşetilirse,
- analytics/crash reporting/reklam SDK’sı eklenirse,
- cloud sync veya kullanıcı hesabı eklenirse,
- uygulama içi destek formu kişisel veri göndermeye başlarsa,
- uygulama çocuk/genç hedef kitleye özel olarak yeniden tasarlanırsa,
- kullanıcılar arasında mesajlaşma/paylaşım gibi native sosyal özellik eklenirse.

## Resmi referanslar

Google Play:
- Data Safety: https://support.google.com/googleplay/android-developer/answer/10787469
- User Data / Privacy Policy: https://support.google.com/googleplay/android-developer/answer/10144311
- Target audience: https://support.google.com/googleplay/android-developer/answer/9867159
- Content ratings: https://support.google.com/googleplay/android-developer/answer/9898843
- Target API requirements: https://support.google.com/googleplay/android-developer/answer/11926878

Android:
- Application manifest / allowBackup: https://developer.android.com/guide/topics/manifest/application-element
- Android 12 backup/data transfer rules: https://developer.android.com/about/versions/12/behavior-changes-12
