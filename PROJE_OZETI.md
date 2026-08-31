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

## Güncel teknik ve ürün kararları

1. Instagram için ana veri kaynağı resmi Instagram/Meta veri dışa aktarma arşividir.
2. Instagram kullanıcı adı/şifre toplama, private API, scraping ve güvenlik mekanizması aşma yöntemleri kullanılmaz.
3. Instagram resmi API'si tam follower/following kullanıcı listesini ürün ihtiyacına uygun genel bir endpoint olarak sağlamadığından MVP buna bağlanmaz.
4. X'in resmi API follower/following endpointleri vardır ancak 2026 pay-per-use fiyatlandırması maliyet riski oluşturur. X tarafında önce resmi veri arşivi importu hedeflenir; OAuth/API daha sonra değerlendirilir.
5. Varsayılan yaklaşım local-first'tür. Sunucu zorunlu değilse sosyal grafik verisi cihazdan çıkmaz.
6. Analiz motoru platform bağımsız saf Dart çekirdeğidir.
7. Snapshot karşılaştırmasında mümkün olduğunda platform kullanıcı ID'si, yoksa normalize edilmiş kullanıcı adı kimlik anahtarıdır.
8. Instagram ZIP diske çıkarılmadan bellekte işlenir ve 128 MiB arşiv limiti uygulanır.
9. Instagram JSON ve HTML exportları ortak modele çevrilir. Multipart followers dosyaları desteklenir.
10. Meta'nın güncel `following.json` varyasyonunda kullanıcı adı üst seviye `title` alanında gelebilir; parser bu yapıyı destekler.
11. Flutter presentation katmanı parsing veya set karşılaştırma mantığı içermez. `InstagramFollowAnalysisUseCase` import -> snapshot -> analiz akışını yürütür.
12. Mobil uygulama Flutter 3.47.2, Riverpod, go_router ve sistem dosya seçimi için file_picker kullanır.
13. Yerel geçmiş Drift/SQLite ile tutulur. Sosyal kullanıcı kayıtları snapshot başına tam kopyalanmaz.
14. Snapshot zamanları UTC olarak normalize edilir.
15. Varsayılan retention her sosyal hesap için son 30 snapshot'tır.
16. Instagram sonuç listelerinde kullanıcı adı/profil adına göre arama, A-Z/Z-A sıralama ve yalnız resmi `instagram.com/<username>` profil bağlantısını dış uygulamada açma kullanılır.
17. Profil fotoğrafları scraping veya unofficial API ile çekilmez. Kullanıcı adına göre deterministik renkli monogram avatar sistemi kullanılır.
18. Tema mor ağırlığı azaltılmış, daha nötr slate/teal açık tema olarak güncellendi. Mor yalnız sınırlı vurgu alanlarında kullanılır. Dark mode şimdilik kapsam dışıdır.
19. Ana ekranda `Analiz Geçmişi` altında `Nasıl yapılır?` rehberi bulunur. Rehber güncel Meta akışında `Takipçiler ve takip edilenler`, tarih aralığı `Her zaman` ve tercihen `JSON` formatını anlatır.
20. `Yok sayılan hesaplar` cihazda ve Instagram sahibi hesap bazında saklanır. Yok sayma ham snapshot takipçi/takip edilen sayılarını değiştirmez; yalnız analiz listelerini filtreler.
21. Test sürümleri production paketinden ayrılmış `.dev` paket kimliği kullanır. Sabit device-test imzası sayesinde ilk `.dev` kurulumundan sonraki test APK'ları kaldırmadan güncellenebilir. Production signing bundan tamamen ayrı kurulacaktır.
22. Android launcher için seçilen koyu takip-analiz uygulama simgesi uygulanmıştır.

## Önemli ürün riskleri

- Instagram arşivinde sabit platform kullanıcı ID'si bulunmayan kayıtlarda yalnız kullanıcı adına göre eşleştirme yapılabilir. Kullanıcı adı değişen bir hesap geçmiş karşılaştırmasında yanlışlıkla “takibi bıraktı + yeni takipçi” olarak görünebilir.
- Meta exportundaki takip edilen sayısı Instagram profilindeki görünen sayaçtan farklı olabilir. Gerçek test arşivinde profil 967 gösterirken export `following.json` 1053 benzersiz hesap içerdi. Uygulama arşivin ham verisini değiştirmez; kullanıcı gerekirse hesapları `Yok say` ile analizden çıkarabilir.
- Meta export dosya yapısı ve menü adları gelecekte değişebilir; fixture testleri ve rehber gerektiğinde güncellenmelidir.

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
- merkezi `AppTheme`
- Instagram ana kartı
- `Nasıl yapılır?` Instagram export rehberi
- takipçi/takip edilen özetleri
- Takip Etmeyenler
- Karşılıklı
- Seni Takip Edenler
- Takibi Bırakanlar
- Yeni Takipçiler
- sonuç listelerinde arama ve A-Z/Z-A sıralama
- renkli monogram avatarlar
- kullanıcı satırından resmi Instagram profilini açma
- kullanıcı satırında `Yok say` işlemi
- `Yok Sayılan Hesaplar` yönetim ekranı, geri alma ve tümünü temizleme
- Analiz Geçmişi ekranı
- Drift/SQLite local snapshot storage
- X için pasif “Yakında” kartı

## Local geçmiş veri modeli

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
- [x] Güncel `following.json` `title` varyasyonu desteği.
- [x] ZIP doğrulama ve güvenlik limitleri.
- [x] Export dosyalarını otomatik keşfetme.
- [x] Multipart followers birleştirme.
- [x] Import -> snapshot -> analiz use-case.
- [x] Flutter uygulama kabuğu.
- [x] Sistem ZIP dosya seçici.
- [x] Instagram veri indirme rehberi (`Her zaman` + JSON önerisi).
- [x] Analiz sonuç ekranları.
- [x] Sonuç listelerinde arama.
- [x] A-Z / Z-A sıralama.
- [x] Resmi Instagram profilini dış uygulamada açma.
- [x] Sadeleştirilmiş slate/teal açık tema.
- [x] Deterministik renkli monogram avatarlar.
- [x] `Yok sayılan hesaplar` sistemi ve yönetim ekranı.
- [x] Koyu Android launcher simgesi.
- [x] Flutter 3.47.2 resmi Android platform wrapper.
- [x] Android debug APK build doğrulaması.
- [x] Fiziksel Android cihazda gerçek Meta export ZIP testi.
- [x] Sayılar görünürken kullanıcı satırlarının boş kaldığı liste render bug'ı için sliver tabanlı düzeltme ve regression testi.

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
- `test/device-apk`: güncel `main` + device-test dağıtım altyapısı.
- özellikler PR ile `main`e alınır.

CI:
- `Core CI`: yalnız `packages/follow_core/**` için `dart analyze` + `dart test`.
- `App CI`: `apps/mobile/**` değişikliklerinde Flutter 3.47.2 ile `flutter pub get`, `flutter analyze`, `flutter test`.
- `cancel-in-progress` aktif.
- Normal CI'da artifact upload yok.
- Doküman-only değişikliklerde workflow çalışmaz.
- Fiziksel cihaz APK'ları Actions artifact yerine GitHub prerelease asset olarak yayınlanır.
- Device-test workflow sabit test imzası ve `.dev` paket kimliği kullanır.

## Doğrulanmış durum

- Core CI başarılı.
- Flutter App CI başarılı.
- PR #11 tema/monogram başarılı ve `main`e alındı.
- PR #12 Instagram export rehberi başarılı ve `main`e alındı.
- PR #14 güncel Meta `following.json` parser düzeltmesi başarılı ve `main`e alındı.
- PR #15 tema sadeleştirme + liste render düzeltmesi + yok sayılan hesaplar + launcher simgesi başarılı ve `main`e alındı.
- PR #15 son App CI: `flutter pub get` ✅, `flutter analyze` ✅, tüm Flutter testleri ✅.
- Flutter 3.47.2 Android wrapper üretimi başarılı.
- Drift code generation ve database/history/retention testleri başarılı.
- Instagram JSON/HTML/ZIP ve snapshot karşılaştırma testleri başarılı.
- Gerçek `Her zaman` Meta exportunda 569 follower başarıyla okundu.
- Aynı exportun `following.json` dosyasında 1053 benzersiz takip edilen kayıt doğrulandı ve uygulama 1053 okudu.
- Device Test APK run #4 tamamen başarılı: dependency, analyze, test, stable test signing, debug APK build ve GitHub prerelease yayınlama adımlarının tamamı geçti.
- Güncel prerelease etiketi: `device-test-stable-signing-4`.
- Güncel test APK SHA-256: `b4eaba73141f06b8161aee169073b95379b46617eb68858d409ff9877ee8ee66`.

## Açık problemler / riskler

1. Güncel PR #15 build'i fiziksel cihazda tekrar kontrol edilmelidir: özellikle 792+ hesaplı listede kullanıcı satırlarının görünmesi ve `Yok say` davranışı.
2. Production release signing henüz kurulmadı; Play Store sürümünden önce ayrı release keystore/secrets düzeni kurulmalıdır. Device-test imzası production için kesinlikle kullanılmayacaktır.
3. Username-only identity eşlemesi kullanıcı adı değişikliklerinde hatalı değişim sonucu üretebilir.
4. 128 MiB bellek içi ZIP limiti tüm Instagram arşivi seçilirse yetersiz olabilir.
5. Kullanıcının iki keyfi snapshot'ı elle seçerek karşılaştırması henüz yoktur.

## Sıradaki işler

1. `device-test-stable-signing-4` APK'yı fiziksel Android cihazda kurup gerçek `Her zaman` ZIP ile kontrol etmek.
2. Kullanıcı listelerinin görünmesini ve `Yok say` / geri alma / yönetim ekranını doğrulamak.
3. Yeni `.dev` test sürümünden sonra bir sonraki APK'nın kaldırmadan güncelleme olduğunu doğrulamak.
4. Production release signing ve güvenli secret düzenini kurmak.
5. Ardından X resmi arşiv importer'ına geçmek.
