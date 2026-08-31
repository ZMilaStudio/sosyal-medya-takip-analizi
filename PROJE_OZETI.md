# PROJE_OZETI

Son güncelleme: 31 Ağustos 2026

## Proje amacı

Android öncelikli, Flutter + Dart tabanlı, local-first sosyal medya takip analizi uygulaması.

Temel sonuçlar:
- Ben takip ediyorum, beni takip etmiyor.
- Karşılıklı takip.
- Beni takip ediyor, ben takip etmiyorum.
- Yeni takipçiler.
- Takibi bırakanlar.
- Önceki analizlerle karşılaştırma.

## Güncel teknik kararlar

1. Instagram için ana veri kaynağı resmi Instagram/Meta veri dışa aktarma arşividir.
2. Instagram kullanıcı adı/şifre toplama, private API, scraping ve güvenlik mekanizması aşma yöntemleri kullanılmaz.
3. Instagram resmi API'si tam follower/following kullanıcı listesini ürünün ihtiyacına uygun genel bir endpoint olarak sağlamadığından MVP buna bağlanmaz.
4. X'in resmi API follower/following endpointleri vardır ancak 2026 pay-per-use fiyatlandırması maliyet riski oluşturur. X tarafında önce resmi veri arşivi importu hedeflenir; OAuth/API daha sonra değerlendirilir.
5. Varsayılan yaklaşım local-first'tür. Sunucu zorunlu değilse sosyal grafik verisi cihazdan çıkmaz.
6. Analiz motoru platform bağımsız saf Dart çekirdeğidir.
7. Snapshot karşılaştırmasında mümkün olduğunda platform kullanıcı ID'si, yoksa normalize edilmiş kullanıcı adı kimlik anahtarıdır.
8. Instagram ZIP diske çıkarılmadan bellekte işlenir ve 128 MiB arşiv limiti uygulanır. Daha büyük gerçek kullanım ihtiyacı doğrulanırsa streaming importer değerlendirilecektir.
9. Instagram JSON ve HTML exportları ortak modele çevrilir. Multipart followers dosyaları desteklenir.
10. Flutter presentation katmanı parsing veya set karşılaştırma mantığı içermez. `InstagramFollowAnalysisUseCase` import -> snapshot -> analiz akışını yürütür.
11. Mobil uygulama Flutter 3.47.2, Riverpod, go_router ve sistem dosya seçimi için file_picker kullanır.
12. Yerel geçmiş Drift/SQLite ile tutulur. Sosyal kullanıcı kayıtları snapshot başına tam kopyalanmaz; ortak kullanıcı tablosu ve snapshot ilişki tablosu kullanılır.
13. Snapshot zamanları UTC olarak normalize edilir.
14. Varsayılan retention her sosyal hesap için son 30 snapshot'tır. Veritabanı API'sinde limit parametrelidir; gelecekte Premium/sınırsız geçmiş için sınırsız mod desteklenebilir.
15. Instagram sonuç listelerinde kullanıcı adı/profil adına göre arama, A-Z/Z-A sıralama ve yalnız resmi `instagram.com/<username>` profil bağlantısını dış uygulamada açma kullanılır.

## Önemli ürün riski

Instagram arşivinde sabit platform kullanıcı ID'si bulunmayan kayıtlarda yalnız kullanıcı adına göre eşleştirme yapılabilir. Kullanıcı adı değişen bir hesap geçmiş karşılaştırmasında yanlışlıkla “takibi bıraktı + yeni takipçi” olarak görünebilir. Bu sınırlama kullanıcıya açıkça belirtilmelidir.

## Mimari

### Çekirdek — `packages/follow_core`
- `SocialPlatform`
- `SocialAccount`
- `SocialUser`
- `FollowSnapshot`
- `FollowAnalysis`
- `FollowAnalysisEngine`
- Instagram JSON parser
- Instagram HTML parser
- güvenli Instagram ZIP importer
- Instagram import + analiz use-case
- unit testler

### Mobil uygulama — `apps/mobile`
- Flutter 3.47.2
- Riverpod
- go_router
- sistem ZIP dosya seçici
- Instagram ana kartı
- takipçi/takip edilen özetleri
- Takip Etmeyenler
- Karşılıklı
- Seni Takip Edenler
- Takibi Bırakanlar
- Yeni Takipçiler
- sonuç listelerinde arama ve A-Z/Z-A sıralama
- kullanıcı satırından resmi Instagram profilini açma
- Analiz Geçmişi ekranı
- Drift/SQLite local snapshot storage
- X için pasif “Yakında” kartı

### Local geçmiş veri modeli

`StoredAccounts`: sosyal hesabı bir kez saklar.

`StoredSocialUsers`: sosyal kullanıcıyı `identityKey` ile bir kez saklar.

`StoredSnapshots`: analiz zamanı, hesap ve kaynak formatını saklar.

`StoredSnapshotRelations`: kullanıcının ilgili snapshot'taki follower/following durumunu bitmask ile saklar.

Yeni Instagram importunda uygulama aynı hesap için son snapshot'ı otomatik bulur, yeni snapshot ile karşılaştırır ve ardından yeni snapshot'ı cihazda saklar. Geçmiş ekranında kayıtlar tarih ve takip sayılarıyla listelenir. Eski bir snapshot açıldığında kendisinden önceki snapshot otomatik bulunur ve o dönemin değişim analizi yeniden hesaplanır.

## MVP durumu

### MVP 1 — Instagram temel analiz
- [x] Ortak analiz modeli.
- [x] Set tabanlı analiz motoru.
- [x] Instagram JSON parser.
- [x] Instagram HTML parser.
- [x] ZIP doğrulama ve güvenlik limitleri.
- [x] Export dosyalarını otomatik keşfetme.
- [x] Multipart followers birleştirme.
- [x] Import -> snapshot -> analiz use-case.
- [x] Flutter uygulama kabuğu.
- [x] Sistem ZIP dosya seçici.
- [x] Analiz sonuç ekranları.
- [x] Sonuç listelerinde arama.
- [x] A-Z / Z-A sıralama.
- [x] Resmi Instagram profilini dış uygulamada açma.
- [x] Flutter 3.47.2 resmi Android platform wrapper.
- [x] Android debug APK build doğrulaması.
- [ ] Fiziksel Android cihazda gerçek Meta export ZIP testi.

### MVP 2 — geçmiş ve değişim analizi
- [x] Drift/SQLite şeması.
- [x] Local snapshot kaydı.
- [x] Son snapshot'ı otomatik geri yükleme.
- [x] Takibi bırakanlar hesaplama.
- [x] Yeni takipçiler hesaplama.
- [x] Sosyal kullanıcıların snapshotlar arasında deduplicate edilmesi.
- [x] Database unit testleri.
- [x] Geçmiş analizleri listeleme ekranı.
- [x] Eski bir snapshot'ı kendi önceki snapshot'ıyla karşılaştırarak açma.
- [x] Varsayılan 30 snapshot retention ve otomatik temizleme.
- [x] Orphan sosyal kullanıcı kayıtlarını temizleme.
- [ ] Kullanıcının iki farklı snapshot'ı elle seçerek karşılaştırması.

### MVP 3 — X
- [ ] X resmi arşiv formatını gerçek fixture ile doğrulama.
- [ ] X ZIP/JSON importer.
- [ ] X snapshot/geçmiş desteği.
- [ ] Canlı API için gerçek kullanıcı başına maliyet modeli.
- [ ] Gerekliyse OAuth 2.0 PKCE + minimum izinler.

## GitHub / CI

Repo: `ZMilaStudio/sosyal-medya-takip-analizi` (public).

Branch düzeni:
- `main`: stabil.
- `feat/<konu>`: özellik.
- `fix/<konu>`: hata düzeltme.
- özellikler PR ile `main`e alınır.

CI:
- `Core CI`: yalnız `packages/follow_core/**` için `dart analyze` + `dart test`.
- `App CI`: yalnız `apps/mobile/**` için Flutter 3.47.2 ile `flutter pub get`, `flutter analyze`, `flutter test`.
- `cancel-in-progress` aktif.
- Artifact upload yok.
- Doküman-only değişikliklerde workflow çalışmaz.
- Android wrapper ve Drift generated code için kullanılan tek seferlik workflow'lar iş bitince kaldırıldı.

## Doğrulanmış durum

- Core CI başarılı.
- Flutter App CI başarılı.
- Flutter 3.47.2 Android wrapper üretimi başarılı.
- `flutter build apk --debug` başarılı.
- Drift code generation başarılı.
- Drift database/history/retention testleri başarılı.
- Instagram JSON/HTML/ZIP ve snapshot karşılaştırma testleri başarılı.
- Analiz ekranı arama/sıralama widget testi başarılı.
- Artifact saklanmıyor.

## Açık problemler / riskler

1. Meta export dosya yapısı gelecekte değişebilir; parser fixture testleri büyütülmelidir.
2. Username-only identity eşlemesi kullanıcı adı değişikliklerinde hatalı değişim sonucu üretebilir.
3. 128 MiB bellek içi ZIP limiti tüm Instagram arşivi seçilirse yetersiz olabilir.
4. Fiziksel Android cihazda gerçek Meta ZIP ile uçtan uca test henüz yapılmadı.
5. Production release signing henüz kurulmadı; Play Store sürümünden önce ayrı release keystore/secrets düzeni kurulmalıdır.
6. Kullanıcının iki keyfi snapshot'ı elle seçerek karşılaştırması henüz yoktur.

## Sıradaki işler

1. Fiziksel Android cihazda gerçek Instagram export ZIP ile import ve sonuç doğrulaması.
2. Test sürümü dağıtımı için güvenli ve kota-dostu yöntem belirlemek.
3. Gerekirse iki snapshot'ı elle karşılaştırma ekranı.
4. Gerçek Meta export fixture'larıyla parser dayanıklılığını genişletmek.
5. Ardından X resmi arşiv importer'ına geçmek.
