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
- Snapshot/geçmiş karşılaştırması.

## Güncel teknik kararlar

1. Instagram için ana veri kaynağı resmi Instagram/Meta veri dışa aktarma arşividir.
2. Instagram kullanıcı adı/şifre toplama, private API, scraping ve güvenlik mekanizması aşma yöntemleri kullanılmaz.
3. Instagram resmi API'sinde follower sayısı gibi alanlar bulunabilse de tam follower/following kullanıcı listesi bu ürünün ihtiyacını karşılayacak genel bir resmi endpoint olarak sunulmadığından MVP buna bağlanmaz.
4. X için resmi API follower/following endpointleri mevcuttur; ancak 2026 pay-per-use fiyatlandırması genel tüketici uygulaması için önemli maliyet riski oluşturur.
5. X'in resmi veri arşivi follower ve following listelerini içerdiği için X entegrasyonunda öncelikli düşük maliyetli yol arşiv importudur. OAuth/API entegrasyonu daha sonra maliyet hesabı ve ürün gereksinimi doğrulanırsa eklenir.
6. Varsayılan veri yaklaşımı local-first'tür. Sunucu zorunlu değilse sosyal grafik verisi sunucuya gönderilmez.
7. Analiz motoru platform bağımsız saf Dart çekirdeği olarak ayrılır.
8. Snapshot karşılaştırmasında mümkün olduğunda platform kullanıcı ID'si kimlik anahtarıdır; ID yoksa normalize edilmiş kullanıcı adı kullanılır.
9. Instagram ZIP ilk MVP'de diske çıkarılmadan bellekte işlenir ve 128 MiB arşiv limiti uygulanır. Kullanıcıya Meta'dan yalnız “Followers and following” verisini dışa aktarması önerilir. Daha büyük arşiv ihtiyacı doğrulanırsa streaming importer'a geçilir.
10. Instagram JSON ve HTML ilişki exportları aynı ortak modele çevrilir; HTML parser CSS sınıflarına değil profil URL'lerine dayanır.
11. Flutter sunum katmanı import veya set karşılaştırma mantığı içermez. `InstagramFollowAnalysisUseCase`, ZIP importundan snapshot ve analiz sonucuna kadar tüm akışı tek noktada yürütür.
12. İlk Flutter uygulama katmanı Flutter 3.47.2 hedefiyle geliştirilir. State management Riverpod, routing go_router, Android sistem dosya seçimi file_picker üzerinden yapılır.

## Önemli ürün riski

Instagram arşivinde sabit platform kullanıcı ID'si bulunmayan kayıtlarda yalnız kullanıcı adına göre eşleştirme yapılabilir. Bir kişi kullanıcı adını değiştirirse geçmiş karşılaştırmasında yanlışlıkla “takibi bıraktı + yeni takipçi” olarak görünebilir. Bu sınırlama kullanıcıya açıkça belirtilmelidir.

## X maliyet riski

X API 2026 fiyatlandırmasında Following/Followers okumaları genel olarak kaynak başına ücretlidir. Resmi fiyat sayfasında standart Following/Followers okuması 0,010 USD/resource olarak listelenmektedir. “Owned Reads” 0,001 USD/resource indirimlidir ancak resmi açıklamada authenticated user'ın developer app owner olması şartı yer alır; bu nedenle genel son kullanıcı ürünü için bu indirime güvenilmez.

Sonuç: Canlı X senkronizasyonu MVP şartı değildir. Önce resmi X arşiv importu yapılacaktır.

## Mimari

### Katmanlar
- presentation: Flutter ekranları, routing, state.
- application: use-case/provider katmanı.
- domain: SocialAccount, SocialUser, FollowSnapshot, FollowAnalysis ve analiz kuralları.
- data: Instagram/X importer, local database, secure storage, opsiyonel API servisleri.

### Çekirdek
`packages/follow_core`
- saf Dart
- platform bağımsız analiz motoru
- Instagram JSON ilişki parser'ı
- Instagram HTML ilişki parser'ı
- Instagram ZIP keşif/doğrulama importer'ı
- Instagram ZIP -> snapshot -> analiz use-case'i
- unit testler

### Mobil uygulama
`apps/mobile`
- Flutter sunum katmanı
- Riverpod import state'i
- go_router navigasyonu
- sistem ZIP dosya seçici
- Instagram ana kartı
- Takip Etmeyenler / Karşılıklı / Seni Takip Edenler sonuç ekranı
- X için pasif “Yakında” kartı

Not: Flutter/Dart kaynak uygulama kabuğu repodadır. Android'in Flutter tarafından üretilen `android/` platform wrapper dosyaları ayrı adımda Flutter 3.47.2 ile oluşturulacaktır; eski Gradle şablonları elle kopyalanmayacaktır.

## MVP sırası

### MVP 1 — Instagram
- [x] Ortak analiz modeli tasarımı.
- [x] Set tabanlı analiz motoru.
- [x] Instagram JSON ilişki parser'ı.
- [x] ZIP doğrulama ve güvenli bellek limitleri.
- [x] Export dosya yollarını otomatik keşfetme.
- [x] Çok parçalı followers dosyalarını birleştirme.
- [x] HTML export desteği.
- [x] Temel ve güvenlik unit testleri.
- [x] Import -> `FollowSnapshot` -> `FollowAnalysisEngine` use-case'i.
- [x] Flutter uygulama kaynak kabuğu.
- [x] Sistem ZIP dosya seçici entegrasyon kodu.
- [x] İlk üç analiz sonuç listesi.
- [ ] Android platform wrapper (`flutter create --platforms=android`).
- [ ] Gerçek cihazda dosya seçme ve analiz testi.
- [ ] Local snapshot kaydı.

### MVP 2 — geçmiş
- [ ] Drift/SQLite şeması.
- [ ] Snapshot geçmişi.
- [ ] Takibi bırakanlar/yeni takipçiler.
- [ ] Geçmiş temizleme ve saklama politikası.

### MVP 3 — X
- [ ] X resmi arşiv formatının fixture'larla doğrulanması.
- [ ] X ZIP/JSON importer.
- [ ] Canlı API için gerçek kullanıcı başına maliyet modeli.
- [ ] Gerekliyse OAuth 2.0 PKCE + follows.read.
- [ ] Harcama limiti ve cache politikası.

## GitHub stratejisi

Repo: `ZMilaStudio/sosyal-medya-takip-analizi` (public).

Branch düzeni:
- `main`: her zaman stabil.
- `feat/<konu>`: özellik geliştirme.
- `fix/<konu>`: hata düzeltme.
- PR olmadan main'e özellik kodu taşınmaz.

CI:
- `Core CI`: yalnız `packages/follow_core/**` değişikliklerinde `dart analyze` + `dart test`.
- `App CI`: yalnız `apps/mobile/**` değişikliklerinde Flutter 3.47.2 ile `flutter analyze` + `flutter test`.
- İki workflow da aynı branch'teki eski run'ı iptal eder.
- Artifact upload yok.
- Doküman-only değişikliklerde workflow çalışmaz.
- Release APK/AAB ayrı, manuel veya tag tabanlı workflow olacaktır.

## Açık problemler

1. Meta export dosya yapısı zamanla değişebilir. Parser'lar gerçek ve anonimleştirilmiş export fixture'larıyla korunmalıdır.
2. Kullanıcı adı değişiklikleri archive-only kimlik eşlemesini bozabilir.
3. 128 MiB bellek içi ZIP limiti, kullanıcının tüm Instagram arşivini seçmesi durumunda yetersiz olabilir. MVP kullanıcıyı yalnız takip verisini export etmeye yönlendirecek; ihtiyaç oluşursa streaming dosya okuma eklenecek.
4. Flutter kaynak kabuğu hazır olsa da Android platform wrapper oluşturulmadan APK üretilemez.

## Son durum

- Instagram analiz çekirdeği `main` üzerinde stabil ve testli.
- JSON + HTML resmi export ZIP desteği mevcut.
- ZIP -> snapshot -> analiz uçtan uca use-case'i mevcut.
- Flutter ana ekranı, ZIP seçme akışı ve ilk sonuç ekranı kaynak kod olarak eklendi.
- App CI Flutter 3.47.2'ye sabitlendi; artifact üretmez.
- Instagram tarafında sunucu, API anahtarı, şifre veya scraping yoktur.

## Sıradaki işler

1. App CI sonucunu doğrulamak ve Flutter kaynak kabuğunu `main`e almak.
2. Flutter 3.47.2 ile Android platform wrapper oluşturmak.
3. Gerçek Android cihazda Meta ZIP seçme ve sonuç doğrulaması yapmak.
4. Drift tabanlı local snapshot kaydını eklemek.
5. Snapshot geçmiş ekranlarını eklemek.
