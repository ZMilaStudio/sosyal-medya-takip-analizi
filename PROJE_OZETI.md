# PROJE_OZETI

Son güncelleme: 31 Ağustos 2026

## Çalışma protokolü

- Her yeni sohbetin başlangıcında bu `PROJE_OZETI.md` dosyası okunarak proje buradan devralınır.
- Bu proje sohbetinde her kullanıcı mesajından sonra yeni kararlar, tamamlanan işler, açık sorunlar ve güncel durum gerekiyorsa bu dosyaya işlenir.
- Yeni karar eski kararı geçersiz kılar; güncelliğini yitiren veya çelişen bilgiler temizlenir.
- Ana gerçeklik kaynağı canlı GitHub repo + bu özet dosyasıdır; eski sohbetlerdeki durum, güncel repo ile çelişirse repo esas alınır.

## Proje amacı

Android öncelikli Flutter + Dart, local-first sosyal medya takip analizi uygulaması. İlk çekirdek Instagram'ın resmi Meta veri dışa aktarma ZIP/JSON/HTML dosyalarını cihaz üzerinde analiz eder. Sonraki aşamada snapshot/geçmiş karşılaştırması ve X resmi veri arşivi desteği genişletilir.

Temel sonuçlar:
- Ben takip ediyorum, beni takip etmiyor.
- Karşılıklı takip.
- Beni takip ediyor, ben takip etmiyorum.
- Yeni takipçiler.
- Takibi bırakanlar.
- Önceki analizlerle karşılaştırma.

## Sabit ürün ve güvenlik kararları

1. Instagram kullanıcı adı/şifre toplama, scraping, private API, otomatik follow/unfollow veya platform güvenlik mekanizması aşma kullanılmaz.
2. Instagram için ana veri kaynağı resmi Meta veri dışa aktarma arşividir.
3. X tarafı önce resmi veri arşivi importu ile yapılır; canlı API/OAuth ancak maliyet ve politika açısından uygun olursa sonradan değerlendirilir.
4. Uygulama local-first'tür; sosyal grafik verisi zorunlu olmadıkça cihazdan çıkmaz.
5. Analiz motoru platform bağımsız saf Dart çekirdeğidir.
6. Kimlik eşlemede platform kullanıcı ID'si varsa o, yoksa normalize edilmiş kullanıcı adı kullanılır.
7. Instagram ZIP bellekte işlenir; hedef ilişki dosyaları dışındaki içerikler çıkarılmaz. JSON ve HTML export, multipart follower dosyaları ve güncel `following.json` üst seviye `title` varyasyonu desteklenir.
8. Profil fotoğrafı scraping/unofficial API ile çekilmez; deterministik renkli monogram avatarlar kullanılır.
9. Tema mor ağırlığı azaltılmış slate/teal açık temadır. Dark mode şimdilik kapsam dışıdır.
10. `Nasıl yapılır?` rehberi Meta akışını, `Takipçiler ve takip edilenler`, tarih aralığı `Her zaman` ve tercihen JSON formatını anlatır.
11. `Yok sayılan hesaplar` hesap bazında cihazda saklanır. Ham snapshot takipçi/takip edilen sayılarını değiştirmez; yalnız analiz listelerini filtreler.
12. Analiz ekranının sağ üstündeki `visibility_off` simgesi bir gizlilik/göster-gizle modu değildir; kullanıcının isteğiyle eklenen **Yok sayılan hesaplar** yönetim ekranına gider. Bu ikon liste render bug'ının nedeni olarak değerlendirilmemelidir.

## Gerçek Meta export doğrulaması

Levent'in gerçek `Her zaman` Instagram arşivinde:
- `followers_1.json`: 569 benzersiz takipçi — Instagram profilindeki 569 ile birebir.
- `following.json`: 1053 benzersiz takip edilen — kayıtların kullanıcı adları üst seviye `title` alanında.
- Instagram profil ekranı takip edileni 967 gösteriyor; Meta export ile UI sayaç arasında 86 hesap farkı var.
- Uygulama ham arşiv verisini değiştirmez; gerekirse kullanıcı hesapları `Yok say` ile analizden çıkarır.
- Bu veriyle analiz sonucu 792 takip etmeyen, 261 karşılıklı ve 308 yalnız takipçi kategorilerini üretir.

## Mobil mimari

`apps/mobile`:
- Flutter 3.47.2
- Riverpod + go_router
- file_picker
- Drift/SQLite yerel geçmiş
- merkezi `AppTheme`
- Instagram import
- analiz ekranı
- arama ve A-Z/Z-A sıralama
- resmi Instagram profilini dış uygulamada açma
- monogram avatarlar
- yok say / geri al / yönetim ekranı
- analiz geçmişi
- Instagram export rehberi
- X için pasif `Yakında` alanı

`packages/follow_core`:
- `SocialPlatform`, `SocialAccount`, `SocialUser`
- `FollowSnapshot`, `FollowAnalysis`, `FollowAnalysisEngine`
- Instagram JSON/HTML parser
- güvenli ZIP importer
- import -> snapshot -> analiz use-case
- unit/regression testleri

## Yerel geçmiş

- `StoredAccounts`: sosyal hesabı bir kez saklar.
- `StoredSocialUsers`: sosyal kullanıcıyı `identityKey` ile deduplicate eder.
- `StoredSnapshots`: analiz zamanı, hesap ve kaynak formatı.
- `StoredSnapshotRelations`: snapshot içindeki follower/following bitmask ilişkileri.
- Snapshot saatleri UTC normalize edilir.
- Varsayılan retention hesap başına son 30 snapshot'tır.
- Eski snapshot açıldığında kendi önceki snapshot'ı bulunup değişim analizi yeniden hesaplanır.

## Güncel hata düzeltmeleri / regresyonlar

### Following parser
Meta'nın gerçek `following.json` dosyasında kullanıcı adı `string_list_data.value` yerine `title` alanında geldiği için önce 569/0 sonucu oluşuyordu. Parser `title` fallback ile düzeltildi ve regression testi eklendi.

### Fiziksel cihazda boş analiz listesi
Gerçek Samsung cihazda kategori sayıları doğru olmasına rağmen açıklama, arama ve kullanıcı satırları görünmüyordu. Önceki `SliverList` ve `TabBarView` kaldırma denemeleri fiziksel cihazda yeterli olmadı.

PR #18 ile sonuç ekranı daha kökten sadeleştirildi:
- özet kartları,
- açıklama,
- arama/sıralama,
- kullanıcı satırları

tek bir `ListView.builder` içinde render ediliyor. Ayrı/nested scroll ve `Expanded + CustomScrollView` bağımlılığı kaldırıldı.

Regression testi 360×800 viewportta gerçek ölçeğe yakın 569 follower / 1053 following / 792 non-follower / 261 mutual / 308 fan veri üretir; arama alanının ve kullanıcı satırının gerçekten `hitTestable()` olduğunu doğrular. PR #18 App CI tamamen başarılıdır.

31 Ağustos 2026 fiziksel Samsung doğrulamasında `device-test-v2-9` ile sekmeler ve kategori sayaçları görünmüş, fakat sonuç içeriği tamamen boş kalmıştır. Dolayısıyla PR #18 fiziksel cihazdaki liste sorununu çözmemiştir. Sağ üstteki üzeri çizili göz simgesi bu sorunun nedeni değildir; bu simge yalnızca `Yok sayılan hesaplar` ekranına gider.

### Android launcher simgesi — PR #18 regresyonu
Kullanıcının onayladığı launcher tasarımı **simge seçenek 4'ün koyu versiyonudur**. PR #15 açıklamasında da seçilen koyu takip-analiz launcher simgesinin uygulandığı kayıtlıdır.

PR #15 adaptive icon foreground olarak `@mipmap/ic_launcher_foreground` PNG varlığını kullanıyordu. PR #18 bunu `@drawable/ic_launcher_foreground` olarak değiştirdi ve yeni teal kişi + açık büyüteç + indigo sap vektörünü ekledi. Bu vektör, kullanıcının seçtiği tasarım değildir.

31 Ağustos 2026 fiziksel cihaz ekran görüntüsünde launcher simgesi teknik olarak özel bir simge olarak görünse de **yanlış tasarım görünmektedir**. Bu yüzden ikon işi tamamlanmış sayılmaz. Doğru çözüm, PR #15'teki kullanıcı tarafından seçilmiş koyu seçenek 4 tasarımını yeniden adaptive/legacy launcher kaynaklarına bağlamak ve PR #18'de eklenen yanlış vektör tasarımı devreden çıkarmaktır.

## Test APK imza ve güncelleme sistemi

Önceki `stable-signing` yaklaşımında keystore yalnız debug konumuna bırakılmış, Gradle'a açık signing config ile bağlanmamıştı; bu yüzden APK güncellemesi garanti değildi.

PR #17 ile deterministic device-test v2 sistemi kuruldu:
- paket: `com.zmilastudio.takipanalizi.dev`
- production paketinden ayrı
- Gradle debug build doğrudan sabit device-test keystore'una bağlı
- sabit sertifika SHA-256: `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`
- versionCode her device-test build'de `300000 + GITHUB_RUN_NUMBER`
- release yayınlanmadan önce AAPT ile paket/versionCode ve apksigner ile sertifika doğrulanır
- production signing daha sonra ayrı keystore/secrets ile kurulacaktır; test anahtarı production için kullanılmayacaktır.

Yeni v2 imza tabanına geçerken mevcut eski test uygulaması bir kez kaldırılıp v2 APK temiz kurulmalıdır. Bundan sonraki v2 APK'lar aynı paket + aynı sertifika + daha yüksek versionCode ile kaldırmadan güncellenebilmelidir.

## GitHub / CI

Repo: `ZMilaStudio/sosyal-medya-takip-analizi` — public.

Branch düzeni:
- `main`: stabil
- `feat/<konu>` / `fix/<konu>`: PR tabanlı geliştirme
- `test/device-apk`: güncel main + device-test dağıtım dosyaları

CI:
- Core CI: `dart analyze` + `dart test`
- App CI: Flutter 3.47.2 `pub get` + `analyze` + `test`
- normal CI artifact upload yapmaz
- docs-only değişiklikler workflow tetiklemez
- fiziksel cihaz APK'ları GitHub prerelease asset olarak yayınlanır

## Doğrulanmış son durum

- Core CI ✅
- App CI ✅
- PR #14 güncel Meta following parser fix ✅
- PR #15 tema + yok sayılan hesaplar + seçilen koyu launcher simgesi + ilk render çalışması ✅
- PR #16 ikinci render düzenlemesi ✅ fakat fiziksel cihazda liste hâlâ boş kaldı
- PR #17 deterministic test signing ✅ ve main'e merge edildi
- PR #18 tek `ListView.builder` render düzenlemesi + büyük liste testi ✅ fakat fiziksel cihazda liste yine boş kaldı
- PR #18 launcher değişikliği ❌ seçilen koyu seçenek 4 yerine farklı bir vector tasarım bağladı
- Device Test run #9 tüm CI aşamalarında başarılı
- Güncel prerelease: `device-test-v2-9`
- VersionCode: `300009`
- APK SHA-256: `5b1462ec41ac150f8965c3eefc6115613d25734e1d7c3b5e873f99c3c4ddd6f8`
- 31 Ağustos 2026 fiziksel cihaz:
  - kategori sekmeleri ve sayaçlar görünüyor ✅
  - sonuç listesi/arama/açıklama görünmüyor ❌
  - launcher özel simge gösteriyor ancak tasarım yanlış ❌
  - sağ üst `visibility_off` = Yok sayılan hesaplar yönetimi ✅

## MVP durumu

### Instagram MVP
- [x] Analiz modeli ve motoru
- [x] JSON/HTML parser
- [x] güvenli ZIP importer
- [x] güncel `following.json title` desteği
- [x] gerçek Meta export doğrulaması
- [x] Flutter import akışı
- [x] sonuç kategorileri
- [x] arama / sıralama
- [x] Instagram profilini açma
- [x] snapshot/geçmiş
- [x] yeni takipçiler / takibi bırakanlar
- [x] yok sayılan hesaplar
- [x] veri indirme rehberi
- [x] sade tema ve monogramlar
- [x] deterministic v2 test signing
- [ ] fiziksel Android cihazdaki boş liste bug'ını çözme
- [ ] seçilen koyu seçenek 4 launcher simgesini geri yükleme ve cihazda doğrulama
- [ ] v2 tabanını temiz kurduktan sonraki bir APK'nın kaldırmadan güncellendiğini doğrulama
- [ ] iki keyfi snapshot'ı elle seçerek karşılaştırma

### X
- [ ] gerçek resmi X arşiv fixture doğrulaması
- [ ] X ZIP/JSON importer
- [ ] X snapshot/geçmiş
- [ ] canlı API maliyet modeli
- [ ] gerekirse OAuth 2.0 PKCE

## Açık riskler / sıradaki işler

1. Launcher için PR #18'deki yanlış vector wiring geri alınacak; PR #15'teki seçilmiş koyu seçenek 4 foreground/launcher kaynakları tekrar kullanılacak.
2. Fiziksel cihazda liste yine boş olduğu için artık `Yok sayılan hesaplar` ikonundan şüphe edilmeyecek. Runtime/layout teşhisi yapılacak; görünür debug marker/placeholder ve gerekirse logcat ile gerçek render constraint'i tespit edilecek.
3. Sonraki v2 build aynı paket + aynı sertifika + daha yüksek versionCode ile çıkarılıp kaldırmadan `Güncelle` davranışı da aynı turda doğrulanacak.
4. Production release signing ve Play Store release düzeni daha sonra ayrı kurulacak.
5. 128 MiB bellek içi ZIP limiti tüm Instagram arşivlerinde yeterli olmayabilir; gerekirse streaming/target-entry yaklaşımı genişletilecek.
6. Username-only identity kullanıcı adı değişimlerinde yanlış `unfollow + new` sonucu üretebilir.
