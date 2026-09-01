# Takip Analizi — Production Release Checklist

Son güncelleme: 1 Eylül 2026

Bu checklist, v2-38 CI baseline’dan Google Play production yayınına geçerken kullanılacak kapı listesidir.

## A. Kod / kalite

- [x] Analyze temiz.
- [x] Otomatik testler geçiyor.
- [x] Fiziksel cihaz uyumluluk wiring kontrolü var.
- [x] Exact kullanıcı launcher asset’i hash ile kilitli.
- [x] Instagram gerçek arşivi fiziksel cihazda doğrulandı.
- [x] Snapshot farkları gerçek Instagram verisiyle doğrulandı.
- [x] X parser/import/snapshot akışı CI ile doğrulandı.
- [x] Uygulama içi `Gizlilik ve Hakkında` ekranı ve Home girişi eklendi.
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
- [x] Private signing dosyaları `.gitignore` ile ek olarak korunuyor.
- [x] Release signing config yalnız `PLAY_UPLOAD_*` secure environment değerleriyle bağlanacak şekilde hazırlandı.
- [x] `SIGNING_SETUP.md` güvenli kurulum ve recovery prosedürünü tanımlıyor.
- [x] Manuel `production-rc-aab.yml` workflow’u signing secret doğrulaması + signer fingerprint kontrolü ile hazırlandı.
- [ ] Google Play App Signing etkinleştirilecek / mevcut durum doğrulanacak.
- [ ] Ayrı private upload key oluşturulacak veya mevcut production upload key kullanılacak.
- [ ] `PLAY_UPLOAD_*` GitHub Secrets gerçek private key bilgileriyle tanımlanacak.
- [ ] İlk signed production RC AAB workflow’u çalıştırılacak.

## D. Gizlilik ve Play politikaları

- [x] `PRIVACY_POLICY.md` taslağı hazır.
- [x] `PLAY_STORE_DATA_SAFETY.md` teknik taslağı hazır.
- [x] `PRIVACY_SUPPORT_PUBLISH_PLAN.md` yayın planı hazır.
- [x] Mevcut Android manifestinde `INTERNET` izni yok.
- [x] Reklam/analytics/cloud SDK’sı mevcut uygulama bağımlılıklarında kullanılmıyor.
- [x] Uygulama içinde yerel veri silme mekanizması var.
- [x] Uygulama içinde gizlilik yaklaşımı kullanıcıya açıklanıyor.
- [ ] Gizlilik politikası kalıcı herkese açık URL’ye yayınlanacak.
- [ ] Resmi destek e-postası ve tercihen destek web sayfası kesinleştirilecek.
- [ ] Play Console Veri Güvenliği formu production build ile son kez karşılaştırılacak.
- [ ] İçerik derecelendirmesi ve hedef kitle formu doldurulacak.
- [ ] Uygulama erişimi / özel erişim gerekmiyor beyanı doğrulanacak.

## E. Play Store mağaza içeriği

- [x] Türkçe mağaza metni: `PLAY_STORE_LISTING_TR.md`.
- [x] İngilizce mağaza metni: `PLAY_STORE_LISTING_EN.md`.
- [x] Uygulama adı: `Takip Analizi`.
- [x] Türkçe kısa açıklama hazır — 68/80 karakter.
- [x] Türkçe tam açıklama hazır — yaklaşık 1.917/4.000 karakter.
- [x] İngilizce kısa açıklama hazır — 77/80 karakter.
- [x] Önerilen kategori: `Araçlar / Tools`.
- [x] Metadata yanıltıcılık ve resmi Instagram/X ilişkisi ima etmeme guardrail’leri yazıldı.
- [x] Mağaza görsel içerik planı ve ekran görüntüsü adayları yazıldı.
- [ ] Telefon ekran görüntüleri production RC’den alınacak.
- [ ] Gerekirse 7 inç / 10 inç tablet ekran görüntüleri hazırlanacak.
- [ ] 512×512 mağaza simgesi hazırlanacak; exact launcher tasarımından türetilecek.
- [ ] 1024×500 feature graphic hazırlanacak.
- [ ] Gizlilik politikası URL’si girilecek.
- [ ] Destek e-postası ve website girilecek.
- [ ] Play Console’daki mevcut tag listesinden en fazla 5 gerçekten ilgili etiket seçilecek.

## F. Release build

- [x] Production RC için manuel CI workflow tasarlandı; push’ta otomatik çalışmaz.
- [x] Workflow `flutter analyze` + tüm testleri production build öncesi çalıştırır.
- [x] Workflow private upload sertifikası SHA-256 fingerprint’ini build öncesi ve AAB sonrası doğrular.
- [x] AAB artifact retention 1 gün ile sınırlandı.
- [ ] Gerçek private signing secrets tanımlandıktan sonra `flutter build appbundle --release` çalıştırılacak.
- [ ] AAB package id = `com.zmilastudio.takipanalizi` son build üzerinde doğrulanacak.
- [ ] versionName/versionCode doğrulaması.
- [ ] Launcher asset doğrulaması.
- [ ] Release sertifika/upload key doğrulamasının gerçek AAB’de PASS olması.
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
- [ ] Gizlilik ve Hakkında ekranı.
- [ ] X arşivi import veya doğrudan JS fallback.
- [ ] X arşiv rehberi.
- [ ] Uygulama yeniden açıldıktan sonra local geçmiş kalıcılığı.

## H. Yayın kararı

Aşağıdaki dört madde tamamlanmadan production rollout yapılmayacak:

1. Private production/upload signing tamamlanmış olmalı.
2. Kalıcı privacy policy + destek iletişimi hazır olmalı.
3. Play Data safety ve store listing tamamlanmış olmalı.
4. Production RC tek kritik fiziksel testten PASS almalı.
