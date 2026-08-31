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

### İlk çekirdek
`packages/follow_core`
- saf Dart
- platform bağımsız analiz motoru
- Instagram JSON ilişki parser'ı
- Instagram HTML ilişki parser'ı
- Instagram ZIP keşif/doğrulama importer'ı
- unit testler

### Sonraki mobil yapı
Önerilen Flutter klasörleri:

lib/
  app/
    router/
    theme/
  core/
    error/
    utils/
  features/
    dashboard/
    instagram_import/
    analysis/
    history/
    settings/
  data/
    local/
    secure_storage/

## Ortak veri modelleri

### SocialPlatform
- instagram
- x

### SocialAccount
- platform
- accountId
- username
- displayName

### SocialUser
- platform
- platformUserId (varsa)
- username
- displayName (varsa)
- profileUrl (varsa)
- identityKey

### FollowSnapshot
- account
- capturedAt
- followers
- following
- sourceType (archive/api)
- sourceVersion/format bilgisi

### FollowAnalysis
- mutual
- nonFollowers
- fans
- unfollowers
- newFollowers
- newFollowing
- noLongerFollowing

## MVP sırası

### MVP 1 — Instagram çekirdeği
- [x] Ortak analiz modeli tasarımı.
- [x] Set tabanlı analiz motoru.
- [x] Instagram JSON ilişki parser'ı.
- [x] ZIP dosyasını doğrulama ve güvenli bellek limitleri.
- [x] Export dosya yollarını otomatik keşfetme.
- [x] Çok parçalı followers dosyalarını birleştirme.
- [x] HTML export desteği.
- [x] Temel ve güvenlik unit testleri.
- [ ] Flutter Android kabuğu.
- [ ] Android dosya seçici.
- [ ] Import sonucunu analiz motoruna bağlayan use-case.
- [ ] Sonuç listeleri.
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
- Sadece PR ve main core değişikliklerinde.
- `dart analyze` + `dart test`.
- Artifact upload yok.
- `concurrency.cancel-in-progress: true` ile aynı branch'teki eski run iptal edilir.
- Doküman-only değişikliklerde workflow çalışmaz.
- Release APK/AAB ayrı, manuel veya tag tabanlı workflow olacaktır.

## Açık problemler

1. Meta export dosya yapısı zamanla değişebilir. Parser'lar dosya yolu ve markup konusunda toleranslı tutulmalı ve gerçek export fixture'larıyla korunmalıdır.
2. Kullanıcı adı değişiklikleri archive-only kimlik eşlemesini bozabilir.
3. 128 MiB bellek içi ZIP limiti, kullanıcının tüm Instagram arşivini seçmesi durumunda yetersiz olabilir. MVP kullanıcıyı yalnız takip verisini export etmeye yönlendirecek; ihtiyaç oluşursa streaming dosya okuma eklenecek.
4. Gerçek kullanıcı export örnekleriyle uyumluluk testi yapılmalıdır; fixture'larda kişisel veri repoya eklenmemelidir.

## Son durum

- Analiz motoru `main` üzerinde stabil.
- Instagram JSON ZIP importer'ı `main` üzerinde stabil.
- ZIP imza doğrulaması, boyut limitleri, unsafe path koruması ve multipart discovery mevcut.
- HTML import desteği çekirdeğe eklenmiştir.
- Sunucu veya API anahtarı gerektiren bir Instagram bileşeni yoktur.

## Sıradaki işler

1. Flutter Android uygulama kabuğunu oluşturmak.
2. Android dosya seçiciden ZIP bytes/path alıp `InstagramArchiveImporter`a bağlamak.
3. Import sonucundan `FollowSnapshot` üretip `FollowAnalysisEngine` çalıştırmak.
4. “Takip Etmeyenler / Karşılıklı / Seni Takip Edenler” sonuç ekranlarını yapmak.
5. Gerçek ve anonimleştirilmiş Meta export fixture'larıyla uyumluluğu genişletmek.
6. Drift tabanlı local snapshot kaydını eklemek.
