# PROJE_OZETI

Son güncelleme: 31 Ağustos 2026, 23:39 (Europe/Istanbul)

## Çalışma protokolü
- Her yeni sohbet başlangıcında bu `PROJE_OZETI.md` okunarak proje devralınır.
- Bu proje sohbetinde her kullanıcı mesajından sonra önemli yeni kararlar, tamamlanan işler, açık sorunlar ve güncel durum bu dosyaya işlenir.
- Bu dosya + canlı GitHub repo proje gerçeklik kaynağıdır.
- Yeni karar eski kararı geçersiz kılar.
- Kullanıcı istemedikçe görsel mockup gönderilmez; uygulanmış APK üzerinden ilerlenir.
- Fiziksel cihazda doğrulanmayan bir düzeltme “çözüldü” sayılmaz.

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

## Gerçek Meta export doğrulaması
- `followers_1.json`: 569 benzersiz takipçi.
- `following.json`: 1053 benzersiz takip edilen; kullanıcı adı üst seviye `title` alanında.
- Instagram UI takip edilen sayısı 967; export ile UI arasında 86 hesap farkı var.
- Sonuç: 792 takip etmeyen, 261 karşılıklı, 308 yalnız takipçi.

## Following parser
Gerçek `following.json` içinde kullanıcı adı `string_list_data.value` yerine `title` alanında geldiği için ilk sürümlerde 569/0 sonucu oluşuyordu. `title` fallback ile düzeltildi ve regression testi eklendi. Bu veri/parser düzeltmesi korunacaktır.

## Fiziksel Samsung / Android 16 analiz ekranı sorunu
CI ve widget testleri geçmesine rağmen fiziksel Samsung cihazında kullanıcı listesi uzun süre görünmedi. Sonraki render denemeleri problemi çözmek yerine bazı sürümlerde üst UI ve etkileşimi de bozdu.

Başarısız fiziksel denemeler:
- PR #16 ❌
- PR #18 ❌
- PR #19 ❌
- `device-test-v2-11` ❌: sekme/sayılar var, liste yok; bazı düğmeler cevap vermiyor.
- `device-test-v2-14` ❌: AppBar dışında içerik tamamen kayboldu.
- `device-test-v2-15` ❌: `fa9ef4a` analiz ekranına rollback sonrası sekmeler ve 569/1053 özet kartları geri geldi, fakat açıklama/arama/kullanıcı listesi yine görünmedi. Bu nedenle `fa9ef4a` fiziksel çalışan son baseline değildir.

### İlk MVP'ye rollback
Commit geçmişi tarandı. İlk Flutter MVP UI commit'i:
- `570961731b613ce7f2bc2fdaa790499b341adc17` — `feat: add Flutter Instagram MVP UI`
- Android platform wrapper daha sonra `ba3341d21c4c6f782f8e2592e00fc3e002fe68af` ile eklendi.

İlk MVP analiz ekranı:
- yalnız 3 sekme: Takip Etmeyenler / Karşılıklı / Seni Takip Edenler,
- basit iki özet `Card`,
- `_UserList` stateless,
- açıklama + `Expanded(ListView.separated)`,
- kullanıcı satırı yalnız `CircleAvatar + @kullanıcıadı + opsiyonel displayName`,
- arama/sıralama yok,
- `MonogramAvatar` yok,
- profile `url_launcher` ile açma yok,
- yok sayılan hesap UI'sı yok,
- unfollower/new-follower sekmeleri yok.

Bu sade kod `device-test-v2-16` için birebir geri getirildi. Parser, veri okuma, history veri katmanı, deterministic signing, paket/version sistemi korundu.

### device-test-v2-16 — FİZİKSEL ÇALIŞAN BASELINE
- kaynak commit: `90059b024cc844a101a84ac076e49a22d12b86b6`
- workflow run: `33435015331`
- VersionCode: `300016`
- APK SHA-256: `afeb7b72a7aa24aec4c5e106e424d1d8a4b1d63e7c4c6893b3cae8b5a8b920f5`
- Analyze ✅
- ilk MVP liste görünürlük/tab widget testi ✅
- deterministic signing ✅
- APK build ✅
- package/version/icon-resource/certificate doğrulama ✅
- prerelease ✅
- **31 Ağustos 2026 23:39 fiziksel Samsung doğrulaması: Takip Etmeyenler (792) listesi gerçek kullanıcı satırlarıyla ekranda göründü ✅**
- özet değerleri fiziksel cihazda 569 takipçi / 1053 takip edilen olarak doğru göründü ✅
- kategori sekmesi fiziksel geçiş doğrulaması henüz ayrıca teyit edilmedi ⏳

Çalışan kaynak ayrı branch ile donduruldu:
- `backup/device-v2-16-working-baseline` → `90059b024cc844a101a84ac076e49a22d12b86b6`

Bu branch bundan sonra fiziksel çalışan analiz ekranı için dokunulmaz geri dönüş noktasıdır.

## Teşhis sonucu
Problem veri/parser katmanında değildir. Aynı gerçek export verisi v2-16'da 792 kullanıcıyı fiziksel cihazda çizmiştir. Regresyon ilk MVP'den sonra analiz ekranına eklenen UI/render özelliklerinden en az birindedir. Bundan sonra özellikler topluca değil **tek tek** geri eklenip her sürüm fiziksel cihazda doğrulanacaktır.

## Test APK imza ve güncelleme sistemi
Deterministic device-test v2:
- paket: `com.zmilastudio.takipanalizi.dev`
- sabit test keystore
- sertifika SHA-256: `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`
- versionCode = `300000 + GITHUB_RUN_NUMBER`
- AAPT paket/versionCode ve apksigner sertifika kontrolü

v2 tabanı kurulduktan sonraki APK'lar aynı paket + sertifika + daha yüksek versionCode ile kaldırmadan güncellenebilmelidir.

## Launcher simgesi
Launcher konusu analiz listesi teşhisinden ayrı tutulacak.
- Önceki fiziksel sürümlerde Android robot/yanlış tasarım görüldü.
- v2-14 sonrası manifest özel drawable'a bağlanmış durumda ancak bu kullanıcı tarafından seçilmiş koyu seçenek 4 tasarımının fiziksel olarak doğru göründüğünü kanıtlamıyor.
- v2-16 turunda launcher üzerinde yeni değişiklik yapılmadı.
- Liste baseline'ı artık bulundu; ikon daha sonra ayrı ve kontrollü ele alınacak.

## GitHub / CI
Repo: `ZMilaStudio/sosyal-medya-takip-analizi` — public.

Branchler:
- `main`: stabil hedef; fiziksel doğrulanmamış render denemeleri merge edilmeyecek.
- `test/device-apk`: fiziksel cihaz doğrulama branch'i.
- `backup/device-test-v2-9`: eski test tabanı.
- `backup/device-v2-14-broken`: v2-14 başarısız durum yedeği.
- `backup/device-v2-15-partial`: v2-15 kısmi rollback durum yedeği.
- `backup/device-v2-16-working-baseline`: fiziksel çalışan ilk MVP liste baseline'ı.

GitHub hosted runner erişimi 31 Ağustos'ta başarısız ödeme nedeniyle geçici kilitlenmişti. Payment History'de Visa $1 `Declined`, ardından MasterCard $1 `Success` oldu; runner erişimi açıldı. Bu sorun kapalıdır.

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
- [x] v2-16 `Takip Etmeyenler` listesini fiziksel Samsung'da doğrulama
- [ ] v2-16 kategori sekmelerinin fiziksel geçişini doğrulama
- [ ] özellikleri tek tek geri ekleyip her adımda fiziksel doğrulama
- [ ] yok sayılan hesap UI'sını geri ekleme
- [ ] arama/sıralamayı geri ekleme
- [ ] profil açmayı geri ekleme
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
Önce v2-16'da `Karşılıklı (261)` sekmesine dokunulduğunda listenin fiziksel cihazda değiştiği doğrulanacak. Bu da başarılıysa baseline tamamen kilitlenecek.

Ardından **tek özellik / tek fiziksel test** kuralıyla ilerleme sırası:
1. Yok sayılan hesap UI'sı.
2. Arama + A-Z/Z-A sıralama.
3. Instagram profilini açma.
4. Takibi bırakanlar / Yeni takipçiler sekmeleri.
5. Koyu seçenek 4 launcher simgesi.

Bir adım fiziksel cihazda bozulursa doğrudan `backup/device-v2-16-working-baseline` üzerine dönülür; aynı anda birden fazla özellik eklenmez.
