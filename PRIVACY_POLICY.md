# Takip Analizi — Gizlilik Politikası

Son güncelleme: 1 Eylül 2026

Bu gizlilik politikası, ZMila Studio tarafından geliştirilen **Takip Analizi** Android uygulamasının verileri nasıl işlediğini açıklar.

Kalıcı gizlilik politikası adresi:
https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md

Gizlilik ve destek iletişimi:
**zmilastudio@gmail.com**

## 1. Uygulamanın çalışma biçimi

Takip Analizi, Instagram ve X / Twitter takip ilişkilerini **local-first** yaklaşımıyla analiz eder.

Uygulama:

- Instagram veya X şifresi istemez.
- Instagram private API kullanmaz.
- Sosyal medya hesaplarına otomatik giriş yapmaz.
- Otomatik takip etme veya takip bırakma işlemi yapmaz.
- Kullanıcının açıkça seçtiği resmi Instagram / X veri arşivlerini cihaz üzerinde işler.

## 2. Cihaz üzerinde işlenen veriler

Kullanıcı uygulamaya bir sosyal medya arşivi seçtiğinde aşağıdaki veriler cihaz üzerinde işlenebilir:

- sosyal medya platformu,
- hesap kullanıcı adı veya platform tarafından sağlanan hesap kimliği,
- takipçi listesi,
- takip edilenler listesi,
- analiz sonuçları,
- analiz tarihi ve yerel snapshot geçmişi,
- kullanıcının “Yok say” olarak işaretlediği hesaplar.

X arşivinde takip ilişkisi analizi için gerekli olmayan medya, gönderi ve doğrudan mesaj geçmişi analiz amacıyla kullanılmaz.

## 3. Veri toplama, ağ erişimi ve izinler

Mevcut uygulama mimarisinde analiz verileri ZMila Studio tarafından işletilen bir sunucuya gönderilmez ve uygulama tarafından üçüncü taraflarla paylaşılmaz.

Production kaynak manifesti uygulama tarafından tanımlanmış Android `uses-permission` girdisi içermez ve `INTERNET` izni istemez. Flutter’ın debug/profile geliştirme build’leri hot reload, debugger ve geliştirme araçları için kendi geliştirme manifestlerinden `INTERNET` izni ekleyebilir; bu production davranışı değildir.

AndroidX Core, eski Android sürümlerinde dışa aktarılmamış dinamik alıcıları güvenli biçimde desteklemek için merged manifestte uygulama paket adına bağlı `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` adlı **signature-level internal permission** ekleyebilir. Bu izin kullanıcıdan istenen bir runtime izni değildir, kullanıcı verisine erişim sağlamaz ve Android permission istemi göstermez. Production CI yalnız bu AndroidX internal iznine tolerans gösterir; `INTERNET` ve başka merged `uses-permission` girdileri production adayı için reddedilir.

Production Android yapılandırması `android:usesCleartextTraffic="false"` kullanır. Ayrıca uygulama verileri için `android:allowBackup="false"` kullanır ve eski/yeni Android backup kurallarında yerel uygulama verilerini cloud backup ile cihazlar arası veri aktarımından hariç tutar. Bu yapılandırma, analiz geçmişi ve uygulama tercihlerini Android’in otomatik yedekleme altyapısına dahil etmemeyi amaçlar. Bazı cihaz üreticilerinin sistem seviyesindeki doğrudan cihaz taşıma davranışları Android tarafından kontrol edilebilir ve uygulamanın tam denetimi dışında olabilir.

Analiz, geçmiş ve kullanıcı tercihleri cihazın yerel depolamasında tutulur.

Kullanıcı bir profil bağlantısını açmayı seçerse bağlantı cihazdaki harici tarayıcıya veya ilgili sosyal medya uygulamasına yönlendirilir. Bu işlem kullanıcı tarafından açıkça başlatılır. Bu noktadan sonraki veri işleme ilgili üçüncü taraf hizmetin kendi gizlilik politikasına tabidir.

## 4. Dosya erişimi

Uygulama yalnızca kullanıcının Android sistem dosya seçicisi üzerinden açıkça seçtiği arşiv veya takip dosyalarına erişir.

Uygulama cihazdaki tüm dosyalara genel erişim istemez.

## 5. Rapor kopyalama ve TXT dışa aktarma

Takip Analizi analiz raporunu uygulama dışına çıkarmak için iki kullanıcı kontrollü seçenek sunabilir:

- **Raporu kopyala:** analiz metnini Android sistem panosuna yazar.
- **TXT olarak kaydet:** analiz metnini Android dosya seçicisi üzerinden kullanıcının seçtiği dosya hedefine yazar.

Rapor; analiz edilen hesap adını, kategori sonuçlarını ve listelerdeki sosyal medya kullanıcı adlarını içerebilir. Bu işlemler yalnız kullanıcı açıkça seçtiğinde gerçekleşir ve rapor ZMila Studio sunucusuna gönderilmez.

Sistem panosuna kopyalanan içerik ve kullanıcının seçtiği harici konuma kaydedilen TXT dosyası uygulamanın private veri alanının dışında olabilir. Bunların daha sonra saklanması, paylaşılması veya silinmesi kullanıcının cihazı, seçtiği dosya hedefi ve ilgili sistem/üçüncü taraf uygulamaları tarafından yönetilebilir.

## 6. Yerel veri saklama ve silme

Analiz snapshot’ları ve “Yok say” tercihleri cihazda yerel olarak saklanabilir. Bu veriler, takip değişikliklerini zaman içinde karşılaştırabilmek için kullanılır.

Kullanıcı uygulama içindeki **Yerel Veri Yönetimi** ekranından:

- tüm analiz geçmişini,
- yok sayılan hesapları,
- tüm yerel uygulama verisini

silebilir.

Uygulamanın silme işlemleri Instagram veya X hesabındaki gerçek verilere dokunmaz.

Yerel Veri Yönetimi, kullanıcının daha önce sistem panosuna kopyaladığı içeriği veya uygulama dışındaki bir hedefe kaydettiği TXT raporunu otomatik olarak silemez; bunlar kullanıcı tarafından ilgili hedefte yönetilir.

Uygulama kaldırıldığında Android’in uygulama verisi yönetimi kapsamında yerel uygulama verileri de cihazdan kaldırılabilir.

## 7. Çocukların gizliliği

Takip Analizi çocuklara yönelik olarak tasarlanmamıştır ve bilerek çocuklardan kişisel veri toplamayı amaçlamaz.

## 8. Güvenlik

Uygulamanın temel güvenlik yaklaşımı; sosyal medya kimlik bilgilerini hiç toplamamak, analizi cihaz üzerinde tutmak, production sürümünde `INTERNET` veya kullanıcı verisine erişen runtime Android izinları istememek, cleartext trafiği kapatmak ve uygulama tarafından yönetilen yerel analiz verisini Android otomatik backup kapsamının dışında tutmaktır. AndroidX’in paket-kapsamlı signature-level internal receiver izni bu veri erişim sınırlarını değiştirmez. Bununla birlikte hiçbir cihaz veya yazılım ortamı mutlak güvenlik garantisi veremez.

## 9. Üçüncü taraf hizmetler ve dış bağlantılar

Takip Analizi Instagram veya X hesabında işlem yapmaz. Kullanıcı isteğiyle açılan harici profil bağlantıları Instagram, X, tarayıcı veya cihazdaki başka bir uygulama tarafından işlenebilir. Bu hizmetlerin veri işleme uygulamaları kendi gizlilik politikalarına tabidir.

Kullanıcı tarafından dışa aktarılan TXT raporunun üçüncü taraf bir dosya sağlayıcısı, bulut sürücüsü veya başka bir uygulama üzerinden saklanması/paylaşılması halinde sonraki veri işleme ilgili hizmetin politikasına tabidir.

## 10. Politika değişiklikleri

Uygulamanın veri işleme davranışı değişirse bu gizlilik politikası da güncellenecektir. Özellikle ileride canlı API, bulut senkronizasyonu, reklam, analitik veya başka bir ağ tabanlı özellik eklenirse bu metin ve Play Console Veri Güvenliği beyanları yeniden değerlendirilmelidir.

## 11. Geliştirici ve iletişim

Geliştirici: **ZMila Studio**  
Uygulama: **Takip Analizi**  
Gizlilik / destek e-postası: **zmilastudio@gmail.com**

Destek sayfası:
https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md

---

# Takip Analizi — Privacy Policy

Last updated: September 1, 2026

This privacy policy explains how the **Takip Analizi** Android application developed by **ZMila Studio** handles data.

Permanent privacy-policy URL:
https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md

Privacy and support contact:
**zmilastudio@gmail.com**

## 1. How the app works

Takip Analizi analyzes Instagram and X / Twitter follow relationships using a **local-first** approach.

The app:

- does not request Instagram or X passwords,
- does not use Instagram private APIs,
- does not automatically sign in to social-media accounts,
- does not perform automated follow or unfollow actions,
- processes only official Instagram / X archive files explicitly selected by the user on the device.

## 2. Data processed on the device

Depending on the selected archive, the app may process on the device:

- social-media platform,
- account username or platform-provided account identifier,
- followers,
- following accounts,
- analysis results,
- analysis date and local snapshot history,
- accounts the user chooses to ignore.

X archive content unrelated to follow-relationship analysis, such as media, posts, or direct-message history, is not used for follow analysis.

## 3. Collection, network access, and permissions

Under the current architecture, analysis data is not sent to a server operated by ZMila Studio and is not shared with third parties by the app.

The production source manifest declares no app-defined Android `uses-permission` entries and does not request `INTERNET`. Flutter debug/profile builds may add `INTERNET` through their development manifests for hot reload, debugging, and tooling; this is not production behavior.

AndroidX Core can merge an application-scoped `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` **signature-level internal permission** to safely emulate non-exported dynamic receivers on older Android versions. This is not a user-granted runtime permission, does not grant access to user data, and does not display a permission prompt. Production CI allows only this AndroidX internal permission and rejects `INTERNET` or any other merged `uses-permission` entry.

The production Android configuration sets `android:usesCleartextTraffic="false"`. It also sets `android:allowBackup="false"` and defines legacy/current Android backup rules that exclude app-managed local data from cloud backup and device-transfer extraction. This is intended to keep analysis history and app preferences out of Android automatic backup infrastructure. Some system-level direct device migration behavior can be controlled by Android or the device manufacturer and may be outside the app’s complete control.

Analysis results, history, and user preferences are stored locally on the device.

If the user chooses to open a social profile, the link is handed off to an external browser or social-media application as an explicit user-initiated action. Any subsequent processing is governed by that third party’s privacy policy.

## 4. File access

The app accesses only archive or relationship files explicitly selected through the Android system file picker. It does not request broad access to all files on the device.

## 5. Report copy and TXT export

Takip Analizi can offer two user-controlled ways to export an analysis report:

- **Copy report:** writes the analysis text to the Android system clipboard.
- **Save as TXT:** writes the analysis text to a file destination explicitly selected by the user through the Android file picker.

A report can contain the analyzed account name, category results, and social-media usernames shown in the analysis lists. These actions occur only when initiated by the user, and the report is not sent to a ZMila Studio server.

Clipboard content and a TXT file saved to a user-selected external destination can exist outside the app’s private data area. Their later storage, sharing, or deletion can be handled by the user’s device, selected storage provider, or other applications.

## 6. Local storage and deletion

Analysis snapshots and ignored-account preferences may be stored locally to support historical comparisons.

The **Local Data Management** screen allows the user to delete:

- all analysis history,
- ignored-account data,
- all local application data managed by the app.

These actions do not alter data on Instagram or X.

Local Data Management cannot automatically delete content previously copied to the system clipboard or a TXT report saved to a destination outside the app; those are managed by the user at the relevant destination.

Local application data may also be removed through Android app-data management or when the app is uninstalled, subject to Android device behavior.

## 7. Children’s privacy

Takip Analizi is not designed for children and does not intentionally seek to collect personal data from children.

## 8. Security

The app’s security approach is to avoid collecting social-media credentials, keep analysis on the device, request no `INTERNET` or user-data runtime permissions in production, disable cleartext traffic, and exclude app-managed local analysis data from Android automatic backup rules. AndroidX’s application-scoped signature-level internal receiver permission does not change these data-access boundaries. No device or software environment can provide an absolute security guarantee.

## 9. Third-party services and external links

Takip Analizi does not perform actions on Instagram or X accounts. External profile links opened at the user’s request may be handled by Instagram, X, a browser, or another installed application. Their data practices are governed by their own privacy policies.

If the user saves or shares an exported TXT report through a third-party file provider, cloud drive, or another application, subsequent processing is governed by that service’s privacy practices.

## 10. Changes to this policy

If network APIs, cloud sync, advertising, analytics, or other data-processing features are added later, this policy and the Google Play Data safety declarations must be reviewed and updated.

## 11. Developer and contact

Developer: **ZMila Studio**  
App: **Takip Analizi**  
Privacy / support email: **zmilastudio@gmail.com**

Support page:
https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md
