# PROJE_OZETI

Son güncelleme: 1 Eylül 2026, 00:40 (Europe/Istanbul)

## Çalışma protokolü
- Her yeni sohbet başlangıcında bu `PROJE_OZETI.md` okunarak proje devralınır.
- Bu proje sohbetinde her kullanıcı mesajından sonra önemli yeni kararlar, tamamlanan işler, açık sorunlar ve güncel durum bu dosyaya işlenir.
- Bu dosya + canlı GitHub repo proje gerçeklik kaynağıdır.
- Yeni karar eski kararı geçersiz kılar.
- Kullanıcı istemedikçe görsel mockup gönderilmez; uygulanmış APK üzerinden ilerlenir.
- Fiziksel cihazda doğrulanmayan bir düzeltme “çözüldü” sayılmaz.
- Çalışan fiziksel baseline korunur; özellikler tek tek geri eklenir.

## Proje amacı
Android öncelikli Flutter + Dart, local-first sosyal medya takip analizi uygulaması.

İlk çekirdek Instagram resmi Meta veri dışa aktarma ZIP/JSON/HTML dosyalarını cihaz üzerinde analiz eder. Daha sonra snapshot/geçmiş karşılaştırması ve X resmi veri arşivi desteği genişletilir.

Temel sonuçlar:
- Ben takip ediyorum, beni takip etmiyor.
- Karşılıklı takip.
- Beni takip ediyor, ben takip etmiyorum.
- Yeni takipçiler.
- Takibi bırakanlar.
- Önceki analizlerle karşılaştırma.

## Sabit ürün ve güvenlik kararları
1. Instagram kullanıcı adı/şifre toplama, scraping, private API ve otomatik follow/unfollow yok.
2. Ana Instagram kaynağı resmi Meta export arşividir.
3. X önce resmi veri arşivi importu ile ele alınır; canlı API/OAuth maliyet ve politika uygunsa sonra değerlendirilir.
4. Local-first; sosyal grafik verisi zorunlu olmadıkça cihazdan çıkmaz.
5. Analiz motoru saf Dart ve platform bağımsızdır.
6. Kimlik eşlemede platform ID varsa o, yoksa normalize kullanıcı adı kullanılır.
7. JSON/HTML ve multipart follower dosyaları ile güncel `following.json` üst seviye `title` varyasyonu desteklenir.
8. Profil fotoğrafı scraping ile çekilmez.
9. Tema mor ağırlığı azaltılmış slate/teal açık temadır. Dark mode şimdilik kapsam dışıdır.
10. `Yok sayılan hesaplar` hesap bazında cihazda saklanır; ham snapshot sayılarını değiştirmez, yalnız analiz sonuçlarını filtreler.
11. Sağ üst `visibility_off` simgesi gizlilik modu değil, **Yok sayılan hesaplar** yönetimidir.
12. Onaylanan launcher yönü: **simge seçenek 4'ün koyu versiyonu**. Launcher işi fiziksel cihazda doğru görünmeden tamamlanmış sayılmaz.
13. Kullanıcı satırına dokununca resmi `https://www.instagram.com/<kullanıcı>/` adresi harici uygulamada açılır; scraping/private API kullanılmaz.

## Gerçek Meta export doğrulaması
- `followers_1.json`: 569 benzersiz takipçi.
- `following.json`: 1053 benzersiz takip edilen; kullanıcı adı üst seviye `title` alanında.
- Instagram UI takip edilen sayısı 967; export ile UI arasında 86 hesap farkı var.
- Sonuç: 792 takip etmeyen, 261 karşılıklı, 308 yalnız takipçi.

## Following parser
Gerçek `following.json` içinde kullanıcı adı `string_list_data.value` yerine `title` alanında geldiği için ilk sürümlerde 569/0 sonucu oluşuyordu. `title` fallback ile düzeltildi ve regression testi eklendi. Bu veri/parser düzeltmesi korunacaktır.

## Fiziksel Samsung / Android 16 analiz ekranı sorunu
Başarısız fiziksel denemeler:
- PR #16 ❌
- PR #18 ❌
- PR #19 ❌
- `device-test-v2-11` ❌: sekme/sayılar var, liste yok; bazı düğmeler cevap vermiyor.
- `device-test-v2-14` ❌: AppBar dışında içerik tamamen kayboldu.
- `device-test-v2-15` ❌: sekmeler ve 569/1053 özet kartları geri geldi, fakat kullanıcı listesi yine görünmedi.

## İlk MVP rollback ve çalışan baseline
İlk Flutter MVP UI commit'i: `570961731b613ce7f2bc2fdaa790499b341adc17`.

İlk MVP analiz ekranı:
- 3 sekme: Takip Etmeyenler / Karşılıklı / Seni Takip Edenler,
- iki basit özet Card,
- açıklama + `Expanded(ListView.separated)`,
- kullanıcı satırı `CircleAvatar + @kullanıcıadı + opsiyonel displayName`,
- arama/sıralama yok,
- MonogramAvatar yok,
- yok sayılan UI yok,
- unfollower/new-follower sekmeleri yok.

### device-test-v2-16 — FİZİKSEL ÇALIŞAN LİSTE BASELINE
- kaynak commit: `90059b024cc844a101a84ac076e49a22d12b86b6`
- workflow run: `33435015331`
- VersionCode: `300016`
- APK SHA-256: `afeb7b72a7aa24aec4c5e106e424d1d8a4b1d63e7c4c6893b3cae8b5a8b920f5`
- Analyze / widget testi / signing / APK / package doğrulama ✅
- 31 Ağustos 2026 23:39 fiziksel Samsung: `Takip Etmeyenler (792)` kullanıcı satırları görünür ✅
- 569 takipçi / 1053 takip edilen görünür ✅

Dokunulmaz geri dönüş branch'i:
- `backup/device-v2-16-working-baseline` → `90059b024cc844a101a84ac076e49a22d12b86b6`

## device-test-v2-17 — FİZİKSEL ÇALIŞAN LİSTE + PROFİL BAĞLANTISI
v2-16 çalışan liste baseline'ına yalnız Instagram profil açma özelliği geri eklendi:
- `url_launcher` importu,
- mevcut `ListTile` üzerine `onTap`,
- hedef: `https://www.instagram.com/<username>/`,
- `LaunchMode.externalApplication`,
- açılamazsa SnackBar,
- basit `open_in_new` trailing ikonu.

Liste yapısı, CircleAvatar, sekmeler, özet Card'ları ve scroll düzeni değiştirilmedi.

Teknik durum:
- kaynak commit: `ac5cce4ac53cdc05b91a2db6b34765afc40a88e4`
- workflow run: `33437455787`
- VersionCode: `300017`
- APK SHA-256: `3b916cb4af3b4d12231786ece93d4365f1b7c8b3173e82265787bec4d0f8e30f`
- Analyze ✅
- baseline widget testleri ✅
- deterministic signing ✅
- APK / package / certificate doğrulama ✅
- prerelease ✅
- **1 Eylül 2026 00:40 fiziksel Samsung: kullanıcı satırına dokununca Instagram profil bağlantısı açıldı ✅**
- kullanıcı listesi v2-16'daki çalışan yapıyı koruyor ✅

Bu doğrulanmış nokta ayrıca yedeklendi:
- `backup/device-v2-17-links-working` → `ac5cce4ac53cdc05b91a2db6b34765afc40a88e4`

## Teşhis sonucu
Problem veri/parser katmanında değildir. Aynı gerçek export v2-16/v2-17'de 792 kullanıcıyı fiziksel cihazda çizmiştir. Regresyon ilk MVP'den sonra analiz ekranına topluca eklenen UI/render özelliklerindedir. Bundan sonra aynı anda yalnız bir özellik geri eklenecek ve fiziksel cihazda doğrulanacaktır.

## Test APK imza ve güncelleme sistemi
- paket: `com.zmilastudio.takipanalizi.dev`
- sabit test keystore
- sertifika SHA-256: `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`
- versionCode = `300000 + GITHUB_RUN_NUMBER`
- APK paket/versionCode ve sertifika CI'de doğrulanır.

## Launcher simgesi
Launcher konusu analiz listesinden ayrı tutulur.
- Önceki fiziksel sürümlerde Android robot/yanlış tasarım görüldü.
- Kullanıcının onayladığı tasarım: **4. seçeneğin koyu versiyonu**.
- Liste ve profil bağlantısı baseline'ı artık fiziksel olarak çalışıyor; ikon daha sonra tek başına ele alınacak.

## GitHub / CI
Repo: `ZMilaStudio/sosyal-medya-takip-analizi` — public.

Branchler:
- `main`: stabil hedef; fiziksel doğrulanmamış değişiklikler merge edilmeyecek.
- `test/device-apk`: fiziksel cihaz doğrulama branch'i.
- `backup/device-v2-16-working-baseline`: fiziksel çalışan liste baseline'ı.
- `backup/device-v2-17-links-working`: fiziksel çalışan liste + Instagram profil bağlantısı baseline'ı.
- diğer önceki bozuk/kısmi backup branch'leri korunuyor.

GitHub hosted runner erişimi 31 Ağustos'ta başarısız ödeme nedeniyle geçici kilitlenmişti. Visa $1 `Declined`, ardından MasterCard $1 `Success`; runner erişimi tekrar açıldı. Kapanmış sorun.

## MVP durumu
### Instagram MVP
- [x] Analiz modeli/motoru
- [x] JSON/HTML parser
- [x] güvenli ZIP importer
- [x] `following.json title` desteği
- [x] gerçek Meta export doğrulaması
- [x] Flutter import
- [x] snapshot/geçmiş veri katmanı
- [x] deterministic v2 signing
- [x] kullanıcı listesini fiziksel Samsung'da doğrulama
- [x] Instagram profil bağlantısını fiziksel Samsung'da doğrulama
- [ ] kategori sekmelerinin fiziksel geçişini ayrıca doğrulama
- [ ] yok sayılan hesap UI'sını geri ekleme
- [ ] arama/sıralamayı geri ekleme
- [ ] unfollower/new-follower sekmelerini geri ekleme
- [ ] koyu seçenek 4 launcher simgesini fiziksel cihazda doğrulama
- [ ] iki keyfi snapshot'ı elle seçerek karşılaştırma

### X
- [ ] gerçek resmi X arşiv fixture doğrulaması
- [ ] X ZIP/JSON importer
- [ ] X snapshot/geçmiş
- [ ] canlı API maliyet modeli
- [ ] gerekirse OAuth 2.0 PKCE

## Sıradaki iş
Çalışan v2-17 baseline korunacak. Sonraki tek özellik **Yok sayılan hesaplar UI'sı** olacak. Arama/sıralama, ek geçmiş sekmeleri ve launcher simgesi aynı build'e karıştırılmayacak. Yok sayılanlar fiziksel cihazda doğrulanırsa bir sonraki özelliğe geçilecek.
