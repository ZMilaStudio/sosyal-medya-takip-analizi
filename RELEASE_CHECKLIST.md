# Takip Analizi — Production Release Checklist

Son güncelleme: 1 Eylül 2026

Bu checklist, v2-37 CI baseline’dan Google Play production yayınına geçerken kullanılacak kapı listesidir.

## A. Kod / kalite

- [x] Analyze temiz.
- [x] Otomatik testler geçiyor.
- [x] Fiziksel cihaz uyumluluk wiring kontrolü var.
- [x] Exact kullanıcı launcher asset’i hash ile kilitli.
- [x] Instagram gerçek arşivi fiziksel cihazda doğrulandı.
- [x] Snapshot farkları gerçek Instagram verisiyle doğrulandı.
- [x] X parser/import/snapshot akışı CI ile doğrulandı.
- [ ] Gerçek kullanıcı X arşivi ile tek kritik fiziksel doğrulama yapılacak.

## B. Android production kimliği

- [x] Production applicationId: `com.zmilastudio.takipanalizi`.
- [x] Device-test applicationId: `com.zmilastudio.takipanalizi.dev`.
- [x] Uygulama etiketi: `Takip Analizi`.
- [x] Launcher simgesi hazır ve test hash’i ile korunuyor.
- [ ] Final production `version` değeri `apps/mobile/pubspec.yaml` içinde kararlaştırılacak.
- [ ] Production AAB oluşturulmadan önce versionName/versionCode son kez kontrol edilecek.

## C. İmzalama

- [x] Device-test için ayrı ve sabit test sertifikası var.
- [x] Public test keystore production release’e bağlanmıyor.
- [ ] Google Play App Signing etkinleştirilecek / mevcut durum doğrulanacak.
- [ ] Ayrı private upload key oluşturulacak veya mevcut production upload key kullanılacak.
- [ ] Upload key yalnız GitHub Secret / güvenli yerel ortamda tutulacak; repoya commit edilmeyecek.
- [ ] Release build signing config güvenli secret/env üzerinden bağlanacak.
- [ ] İmzalı `.aab` için sertifika ve package doğrulaması yapılacak.

## D. Gizlilik ve Play politikaları

- [x] `PRIVACY_POLICY.md` taslağı hazır.
- [x] `PLAY_STORE_DATA_SAFETY.md` teknik taslağı hazır.
- [x] Mevcut Android manifestinde `INTERNET` izni yok.
- [x] Reklam/analytics/cloud SDK’sı mevcut uygulama bağımlılıklarında kullanılmıyor.
- [x] Uygulama içinde yerel veri silme mekanizması var.
- [ ] Gizlilik politikası kalıcı herkese açık URL’ye yayınlanacak.
- [ ] Resmi destek iletişim kanalı gizlilik politikasına eklenecek.
- [ ] Play Console Veri Güvenliği formu production build ile son kez karşılaştırılacak.
- [ ] İçerik derecelendirmesi ve hedef kitle formu doldurulacak.
- [ ] Uygulama erişimi / özel erişim gerekmiyor beyanı doğrulanacak.

## E. Play Store mağaza içeriği

- [ ] Kısa açıklama.
- [ ] Tam açıklama.
- [ ] Uygulama kategorisi.
- [ ] Telefon ekran görüntüleri.
- [ ] Gerekirse 7 inç / 10 inç tablet ekran görüntüleri.
- [ ] 512×512 mağaza simgesi.
- [ ] 1024×500 feature graphic.
- [ ] Gizlilik politikası URL’si.
- [ ] Destek URL’si / destek e-postası.

## F. Release build

- [ ] `flutter analyze`.
- [ ] `flutter test`.
- [ ] `flutter build appbundle --release` production signing ile.
- [ ] AAB package id = `com.zmilastudio.takipanalizi` doğrulaması.
- [ ] versionName/versionCode doğrulaması.
- [ ] Launcher asset doğrulaması.
- [ ] Release sertifika/upload key doğrulaması.
- [ ] AAB boyutu ve native kütüphaneler kontrolü.

## G. Son cihaz testi

Tek kritik production RC test turunda:

- [ ] Mevcut app verisi korunarak upgrade kurulumu.
- [ ] Instagram ZIP import.
- [ ] 5 analiz sekmesi.
- [ ] Arama/sıralama.
- [ ] Profil açma.
- [ ] Yok say / geri yükle.
- [ ] Analiz geçmişi.
- [ ] Manuel snapshot karşılaştırma.
- [ ] Raporu kopyala / TXT kaydet.
- [ ] Yerel Veri Yönetimi.
- [ ] X arşivi import veya doğrudan JS fallback.
- [ ] X arşiv rehberi.
- [ ] Uygulama yeniden açıldıktan sonra local geçmiş kalıcılığı.

## H. Yayın kararı

Aşağıdaki dört madde tamamlanmadan production rollout yapılmayacak:

1. Private production/upload signing tamamlanmış olmalı.
2. Kalıcı privacy policy + destek iletişimi hazır olmalı.
3. Play Data safety ve store listing tamamlanmış olmalı.
4. Production RC tek kritik fiziksel testten PASS almalı.
