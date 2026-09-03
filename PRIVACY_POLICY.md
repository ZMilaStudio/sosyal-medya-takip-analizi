# Takip Analizi — Gizlilik Politikası

Son güncelleme: 3 Eylül 2026

Bu politika, ZMila Studio tarafından geliştirilen **Takip Analizi** Android uygulamasının verileri nasıl işlediğini açıklar.

Kalıcı adres: https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md  
İletişim: **zmilastudio@gmail.com**

## 1. Local-first takip analizi

Takip Analizi, kullanıcının açıkça seçtiği resmi Instagram ve X / Twitter dışa aktarma dosyalarını cihaz üzerinde analiz eder. Uygulama sosyal medya şifresi istemez, private API kullanmaz, hesaba otomatik giriş yapmaz ve otomatik takip/takip bırakma işlemi yapmaz.

Cihaz üzerinde işlenebilen veriler; sosyal medya kullanıcı adı veya hesap kimliği, takipçi ve takip edilen listeleri, analiz sonuçları, analiz tarihi, yerel snapshot geçmişi ve “Yok say” tercihleridir. Bu sosyal medya arşiv içeriği reklam amacıyla Google’a veya ZMila Studio sunucusuna gönderilmez.

## 2. Reklamlar ve Google Mobile Ads

Takip Analizi, uygulamanın ücretsiz sunulmasını desteklemek için **Google Mobile Ads / AdMob** kullanır. Reklam trafiği, sosyal medya arşiv analizi akışından ayrıdır.

Google Mobile Ads SDK; reklam sunumu, ölçüm, analiz ve kötüye kullanım/sahtekârlık önleme amaçlarıyla otomatik olarak aşağıdaki veri türlerini toplayabilir ve Google ile paylaşabilir:

- IP adresi; genel/yaklaşık konum tahmini için kullanılabilir,
- uygulama başlatma, dokunma ve reklam etkileşimi gibi kullanıcı ürün etkileşimleri,
- uygulama ve SDK performansına ilişkin tanılama bilgileri,
- Android reklam kimliği, App Set ID ve uygun olduğunda diğer cihaz/hesap tanımlayıcıları.

Google, Google Mobile Ads SDK tarafından aktarılan bu verilerin TLS ile aktarım sırasında şifrelendiğini belirtir. Reklam kimliğinin kullanımı Android ayarları, kullanıcı gizlilik tercihleri, izin/consent durumu ve Google’ın sınırlı reklam modları gibi koşullara göre değişebilir.

Google Mobile Ads veri işleme bilgisi: https://developers.google.com/admob/android/privacy/play-data-disclosure

## 3. Reklam gizlilik tercihleri / UMP

Uygulama, gerekli bölgelerde Google **User Messaging Platform (UMP)** üzerinden gizlilik ve reklam tercihlerini yönetir. Uygulama her açılışta güncel consent gereksinimini sorgular; reklam istemeden önce Google SDK’sının `canRequestAds` sonucuna göre hareket eder.

Google’ın gerektirdiği durumlarda uygulama içindeki **Gizlilik ve Hakkında** ekranında reklam gizlilik tercihlerini yeniden açmak için bir seçenek gösterilir.

UMP hakkında: https://developers.google.com/admob/flutter/privacy

## 4. Ağ erişimi ve Android izinleri

Reklam göstermek için Google Mobile Ads SDK ağ erişimi kullanır ve Android merged manifestine reklam/ağ işlevleri için gerekli izinleri ekleyebilir. Uygulama sosyal medya arşivini bir geliştirici sunucusuna yüklemek için bu ağ erişimini kullanmaz.

Production yapılandırmasında `android:usesCleartextTraffic="false"` korunur. Uygulama geniş depolama erişimi, kişi listesi, SMS, çağrı kayıtları, kamera, mikrofon veya konum için runtime izin istemez. Dosyalar Android sistem dosya seçicisi üzerinden kullanıcı tarafından seçilir.

## 5. Yerel saklama ve Android yedekleme

Analiz snapshot’ları ve “Yok say” tercihleri takip değişikliklerini karşılaştırmak için cihazda yerel olarak tutulabilir.

Production Android yapılandırması `android:allowBackup="false"` kullanır ve app-managed yerel veri alanlarını Android backup/data-transfer kurallarında hariç tutar. Bazı cihaz üreticilerinin sistem seviyesindeki taşıma davranışları uygulamanın tam kontrolü dışında olabilir.

## 6. Dosya erişimi

Uygulama yalnız kullanıcının Android sistem dosya seçicisi üzerinden açıkça seçtiği arşiv veya takip dosyalarına erişir. Tüm cihaz dosyalarına genel erişim istemez.

## 7. Rapor kopyalama ve TXT dışa aktarma

Kullanıcı isterse analiz raporunu sistem panosuna kopyalayabilir veya Android dosya seçicisiyle seçtiği hedefe TXT olarak kaydedebilir. Bu rapor sosyal medya kullanıcı adlarını ve kategori sonuçlarını içerebilir. Dışa aktarma yalnız kullanıcı tarafından başlatılır ve rapor ZMila Studio sunucusuna gönderilmez.

Panoya kopyalanan veya uygulama dışındaki bir konuma kaydedilen içerik app-private alan dışında olabilir; daha sonraki saklama, paylaşma ve silme işlemleri ilgili sistem veya hedef uygulama tarafından yönetilir.

## 8. Yerel verileri silme

**Yerel Veri Yönetimi** ekranından kullanıcı analiz geçmişini, yok sayılan hesapları veya uygulamanın yönettiği tüm yerel verileri silebilir. Bu işlemler Instagram/X üzerindeki gerçek verilere dokunmaz.

Uygulama kaldırıldığında Android uygulama veri yönetimi kapsamında yerel veriler de kaldırılabilir. Daha önce panoya kopyalanmış veya dış hedefe kaydedilmiş TXT dosyaları uygulama tarafından sonradan otomatik silinemez.

## 9. Dış bağlantılar

Kullanıcı bir sosyal medya profilini açmayı seçerse bağlantı Instagram, X, tarayıcı veya başka bir uygulamaya devredilir. Sonraki veri işleme ilgili hizmetin politikasına tabidir.

## 10. Çocukların gizliliği

Takip Analizi çocuklara yönelik tasarlanmamıştır ve hedef kitlesi 18 yaş ve üzeridir.

## 11. Güvenlik

Sosyal medya kimlik bilgileri toplanmaz; arşiv analizi cihaz üzerinde tutulur; cleartext trafik kapalıdır; app-managed analiz verileri otomatik Android backup kapsamı dışında tutulur. Reklam ağı veri akışı sosyal medya arşiv içeriğinden ayrı tutulur. Hiçbir cihaz veya yazılım ortamı mutlak güvenlik garantisi veremez.

## 12. Politika değişiklikleri

Uygulamanın reklam, SDK, ağ, depolama veya veri işleme davranışı değişirse bu politika ve Google Play Veri Güvenliği beyanları yeniden güncellenir.

## 13. Geliştirici

Geliştirici: **ZMila Studio**  
Uygulama: **Takip Analizi**  
Gizlilik / destek: **zmilastudio@gmail.com**  
Destek: https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md

---

# Takip Analizi — Privacy Policy

Last updated: September 3, 2026

This policy explains how the **Takip Analizi** Android app developed by **ZMila Studio** handles data.

Permanent URL: https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md  
Contact: **zmilastudio@gmail.com**

## 1. Local-first follow analysis

Takip Analizi analyzes official Instagram and X / Twitter export files explicitly selected by the user on the device. The app does not request social-media passwords, use private APIs, automatically sign in, or perform automated follow/unfollow actions.

Data processed locally can include the social-media username/account identifier, followers and following lists, analysis results, analysis time, local snapshot history, and ignored-account preferences. The contents of these social-media archives are not sent to Google for advertising and are not uploaded to a ZMila Studio server.

## 2. Advertising and Google Mobile Ads

Takip Analizi uses **Google Mobile Ads / AdMob** to support the free app. Advertising network traffic is separate from social-media archive analysis.

According to Google, the Google Mobile Ads SDK can automatically collect and share the following data for advertising, analytics, measurement, and fraud/abuse prevention:

- IP address, which may be used to estimate general/approximate location,
- user product interactions such as app launches, taps, and ad interactions,
- diagnostic information about app and SDK performance,
- Android advertising ID, App Set ID, and, where applicable, other device/account identifiers.

Google states that data transmitted by the Google Mobile Ads SDK is encrypted in transit using TLS. Advertising-ID use can vary according to Android settings, user privacy choices, consent status, and Google limited-ad modes.

Google Mobile Ads disclosure: https://developers.google.com/admob/android/privacy/play-data-disclosure

## 3. Advertising privacy choices / UMP

Where required, the app uses Google **User Messaging Platform (UMP)** to manage privacy and advertising choices. The app requests updated consent information on launch and checks the Google SDK's `canRequestAds` result before requesting ads.

When required by Google, a visible privacy-options entry point is available in the app's **Privacy & About** screen so the user can revisit advertising privacy choices.

UMP information: https://developers.google.com/admob/flutter/privacy

## 4. Network access and Android permissions

Google Mobile Ads uses network access and can add advertising/network-related permissions to the merged Android manifest. This network access is not used to upload the user's social-media archive to a developer server.

The production configuration keeps `android:usesCleartextTraffic="false"`. The app does not request broad storage access or runtime permissions for contacts, SMS, call logs, camera, microphone, or location. Files are selected through the Android system file picker.

## 5. Local storage and Android backup

Analysis snapshots and ignored-account preferences may be stored locally to support historical comparisons.

Production uses `android:allowBackup="false"` and excludes app-managed local data domains through Android backup/data-transfer rules. Some system-level device migration behavior can be controlled by Android or the device manufacturer and may be outside the app's complete control.

## 6. File access

The app accesses only archive or relationship files explicitly selected through the Android system file picker. It does not request broad access to all files on the device.

## 7. Report copy and TXT export

Users can explicitly copy an analysis report to the system clipboard or save it as TXT to a destination selected through the Android file picker. Reports can include account names, category results, and social-media usernames. These exports are user-initiated and are not uploaded to a ZMila Studio server.

Clipboard content or files saved outside the app-private area can later be managed by the operating system, storage provider, or other applications.

## 8. Local-data deletion

The **Local Data Management** screen lets users delete analysis history, ignored-account data, or all app-managed local data. These actions do not change data on Instagram or X.

Content previously copied to the system clipboard or TXT files saved outside the app cannot be automatically deleted later by the app.

## 9. External links

When a user chooses to open a social-media profile, the link is handed to Instagram, X, a browser, or another installed application. Subsequent processing is governed by that service's privacy policy.

## 10. Children's privacy

Takip Analizi is not designed for children and targets users aged 18 and over.

## 11. Security

Social-media credentials are not collected; archive analysis remains on-device; cleartext traffic is disabled; and app-managed analysis data is excluded from Android automatic backup. Advertising network data flow is kept separate from the social-media archive content. No device or software environment can provide an absolute security guarantee.

## 12. Policy changes

If advertising, SDK, networking, storage, or other data-processing behavior changes, this policy and the Google Play Data safety declarations will be reviewed and updated.

## 13. Developer

Developer: **ZMila Studio**  
App: **Takip Analizi**  
Privacy / support: **zmilastudio@gmail.com**  
Support: https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md
