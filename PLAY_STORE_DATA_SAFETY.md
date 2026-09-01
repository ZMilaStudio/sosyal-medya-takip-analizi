# Google Play — Veri Güvenliği Taslağı

Son güncelleme: 1 Eylül 2026

Bu dosya Play Console **Veri güvenliği** formunu doldururken kullanılacak teknik taslaktır. Nihai beyan, production build ve mağaza yayını öncesi yeniden doğrulanmalıdır.

## Mevcut build için teknik gerçekler

- Uygulama local-first çalışır.
- Android manifestinde `INTERNET` izni yoktur.
- Kullanıcının sosyal medya şifresi uygulamaya girilmez.
- Dosyalar Android sistem dosya seçicisi üzerinden kullanıcı tarafından seçilir.
- Analiz snapshot’ları ve “Yok say” tercihleri cihaz üzerinde saklanır.
- Uygulama geliştirici sunucusuna analiz verisi yüklemez.
- Reklam SDK’sı yoktur.
- Analytics/telemetri SDK’sı yoktur.
- Bulut senkronizasyonu yoktur.

## Play Console için önerilen mevcut beyan

### Uygulama kullanıcı verisi topluyor veya paylaşıyor mu?

**Mevcut production adayı mimaride: Hayır.**

Gerekçe: Sosyal medya arşivindeki veriler yalnız cihaz üzerinde işlenir; geliştiriciye veya üçüncü taraf sunucuya aktarılmaz.

> Play Console’daki “collection” tanımı yayın anında yeniden kontrol edilmelidir. Google’ın form/metin tanımı değişirse beyan buna göre uyarlanmalıdır.

### Veriler cihaz dışına aktarılıyor mu?

Takip analizi verileri açısından **hayır**.

Kullanıcı bir sosyal profil bağlantısını açmayı seçerse uygulama yalnız bağlantıyı harici tarayıcı veya platform uygulamasına devreder. Bu, Takip Analizi’nin kendi sunucusuna veri aktarımı değildir.

### Hesap oluşturma var mı?

**Hayır.**

Takip Analizi kendi kullanıcı hesabını oluşturmaz ve sosyal medya hesabına giriş yapmaz.

### Veri silme mekanizması

Uygulama içinde **Yerel Veri Yönetimi** ekranı vardır. Kullanıcı:

- analiz geçmişini,
- yok sayılan hesapları,
- tüm yerel uygulama verisini

silebilir.

Uygulama hesabı olmadığı için sunucu tarafı hesap silme akışı yoktur.

## İşlenen fakat cihazdan çıkmayan veri türleri

Bunlar “toplanan veri” olarak beyan edilmeyebilir; yine de iç denetim için kaydedilmiştir:

- sosyal medya kullanıcı adı / hesap kimliği,
- takipçi ilişkileri,
- takip edilen ilişkileri,
- analiz sonuçları,
- analiz zamanı,
- yerel geçmiş snapshot’ları,
- yok sayılan hesap tercihleri.

## Production öncesi tekrar kontrol edilmesi gereken değişiklikler

Aşağıdakilerden herhangi biri eklenirse Veri Güvenliği formu ve gizlilik politikası mutlaka yeniden değerlendirilmelidir:

- reklam veya AdMob,
- Firebase Analytics / Crashlytics veya başka telemetri,
- canlı Instagram/X API bağlantısı,
- OAuth,
- bulut yedekleme veya senkronizasyon,
- kullanıcı hesabı,
- push notification altyapısı,
- ücretli üyelik / ödeme,
- uzaktan hata loglama.

## Yayın kapısı

Play Store’a production gönderimi yapılmadan önce:

1. Production AAB’nin manifest izinleri tekrar kontrol edilmeli.
2. Bağımlılık ağacı reklam/analytics SDK’sı açısından kontrol edilmeli.
3. Gizlilik politikası kalıcı public URL’ye taşınmalı.
4. Play Console Veri Güvenliği formu bu dosya ile karşılaştırılarak son kez doldurulmalı.
