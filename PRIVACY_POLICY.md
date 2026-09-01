# Takip Analizi — Gizlilik Politikası

Son güncelleme: 1 Eylül 2026

Bu gizlilik politikası, ZMila Studio tarafından geliştirilen **Takip Analizi** Android uygulamasının verileri nasıl işlediğini açıklar.

> Bu metin production yayını öncesi hazırlanmış gizlilik politikası taslağıdır. Play Store yayınına geçmeden önce herkese açık kalıcı gizlilik politikası URL’si ve resmi destek iletişim kanalı eklenmelidir.

## 1. Uygulamanın çalışma biçimi

Takip Analizi, Instagram ve X / Twitter takip ilişkilerini **local-first** yaklaşımıyla analiz eder.

Uygulama:

- Instagram kullanıcı adı veya şifresi istemez.
- X / Twitter kullanıcı adı veya şifresi istemez.
- Instagram private API kullanmaz.
- Sosyal medya hesaplarına otomatik giriş yapmaz.
- Otomatik takip etme veya takip bırakma işlemi yapmaz.
- Kullanıcının seçtiği resmi Instagram / X veri arşivlerini cihaz üzerinde işler.

## 2. İşlenen veriler

Kullanıcı uygulamaya bir sosyal medya arşivi seçtiğinde aşağıdaki veriler cihaz üzerinde işlenebilir:

- sosyal medya platformu,
- hesap kullanıcı adı veya platform tarafından sağlanan hesap kimliği,
- takipçi listesi,
- takip edilenler listesi,
- analiz sonuçları,
- analiz tarihi ve yerel snapshot geçmişi,
- kullanıcının “Yok say” olarak işaretlediği hesaplar.

X arşivinde takip ilişkisi analizi için gerekli olmayan medya, gönderi ve doğrudan mesaj geçmişi analiz amacıyla kullanılmaz.

## 3. Veri toplama ve paylaşma

Mevcut uygulama mimarisinde analiz verileri geliştirici sunucusuna gönderilmez ve üçüncü taraflarla paylaşılmaz.

Takip Analizi’nin mevcut Android build’i `INTERNET` izni istemez. Analiz, geçmiş ve kullanıcı tercihleri cihazın yerel depolamasında tutulur.

Kullanıcı bir profil bağlantısını açmayı seçerse bağlantı cihazdaki harici tarayıcıya veya ilgili sosyal medya uygulamasına yönlendirilir. Bu noktadan sonraki veri işleme ilgili üçüncü taraf hizmetin kendi gizlilik politikasına tabidir.

## 4. Dosya erişimi

Uygulama, yalnızca kullanıcının Android sistem dosya seçicisi üzerinden açıkça seçtiği arşiv veya takip dosyalarına erişir.

Uygulama cihazdaki tüm dosyalara genel erişim istemez.

## 5. Yerel veri saklama

Analiz snapshot’ları ve “Yok say” tercihleri cihazda yerel olarak saklanabilir. Bu veriler, takip değişikliklerini zaman içinde karşılaştırabilmek için kullanılır.

Kullanıcı uygulama içindeki **Yerel Veri Yönetimi** ekranından:

- tüm analiz geçmişini,
- yok sayılan hesapları,
- tüm yerel uygulama verisini

silebilir.

Uygulamanın silme işlemleri Instagram veya X hesabındaki gerçek verilere dokunmaz.

## 6. Çocukların gizliliği

Takip Analizi çocuklara yönelik olarak tasarlanmamıştır ve bilerek çocuklardan kişisel veri toplamayı amaçlamaz.

## 7. Güvenlik

Uygulamanın temel güvenlik yaklaşımı, sosyal medya kimlik bilgilerini hiç toplamamak ve analizi cihaz üzerinde tutmaktır. Bununla birlikte hiçbir cihaz veya yazılım ortamı mutlak güvenlik garantisi veremez.

## 8. Politika değişiklikleri

Uygulamanın veri işleme davranışı değişirse bu gizlilik politikası da güncellenecektir. Özellikle ileride canlı API, bulut senkronizasyonu, reklam, analitik veya başka bir ağ tabanlı özellik eklenirse bu metin ve Play Console Veri Güvenliği beyanları yeniden değerlendirilmelidir.

## 9. Geliştirici

Geliştirici: **ZMila Studio**

Production yayını öncesi resmi destek iletişim bilgisi ve kalıcı gizlilik politikası URL’si bu bölüme eklenecektir.

---

# Takip Analizi — Privacy Policy

Last updated: September 1, 2026

This policy explains how the **Takip Analizi** Android application developed by ZMila Studio handles data.

> This is a pre-release privacy-policy draft. A permanent public privacy-policy URL and official support contact must be added before Play Store publication.

## How the app works

Takip Analizi analyzes Instagram and X / Twitter follow relationships using a local-first approach. It does not request social-media passwords, does not use Instagram private APIs, does not automatically sign in to accounts, and does not perform automated follow or unfollow actions.

The app processes only the official export/archive files explicitly selected by the user.

## Data processed on the device

Depending on the selected archive, the app may process the platform name, account username or account identifier, follower/following relationships, analysis results, local snapshot history, and accounts the user chooses to ignore.

X archive content unrelated to follow-relationship analysis, such as media, posts, or direct-message history, is not used for the follow analysis.

## Collection and sharing

Under the current architecture, analysis data is not sent to a developer-operated server and is not shared with third parties. The current Android build does not request the `INTERNET` permission.

If the user chooses to open a social profile, the link is handed off to an external browser or social-media application. Any subsequent processing is governed by that third party’s privacy policy.

## File access

The app accesses only archive or relationship files explicitly selected through the Android system file picker. It does not request broad access to all files on the device.

## Local storage and deletion

Analysis snapshots and ignored-account preferences may be stored locally to support historical comparisons. The **Local Data Management** screen allows the user to delete analysis history, ignored-account data, or all local application data. These actions do not alter data on Instagram or X.

## Changes

If network APIs, cloud sync, advertising, analytics, or other data-processing features are added later, this policy and the Google Play Data safety declarations must be reviewed and updated.

Developer: **ZMila Studio**

An official support contact and permanent public policy URL will be added before production publication.
