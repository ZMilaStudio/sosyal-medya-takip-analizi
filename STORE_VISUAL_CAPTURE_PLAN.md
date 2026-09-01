# Takip Analizi — Google Play Görsel Yakalama Planı

Son güncelleme: 1 Eylül 2026

Amaç: Google Play mağaza görsellerini sahte UI/mockup üretmeden, gerçek production RC uygulama ekranlarından ve kişisel veri göstermeden hazırlamak.

## 1. Google Play screenshot teknik hedefi

Telefon mağaza görselleri için üretim standardımız:

- Dikey: **1080×1920**
- En boy oranı: **9:16**
- Dosya: 24-bit PNG, alfa kanalı yok; gerekirse yüksek kaliteli JPEG
- En az: 4 kaliteli telefon screenshot’ı
- Hedef: 8 telefon screenshot’ı
- Cihaz frame/mockup eklenmeyecek
- İlk üç görsel doğrudan uygulama UI’sini güçlü biçimde gösterecek
- Bildirim, operatör adı veya kişisel status-bar içeriği görünmeyecek
- Her görsele Play Console’da 140 karakteri aşmayan alt text girilecek

Google Play genel şartı 320–3840px aralığıdır ve uzun kenar kısa kenarın iki katından fazla olamaz. 1080×1920 bu şartı ve önerilen 9:16 formatını karşılar.

Resmi kaynak:
https://support.google.com/googleplay/android-developer/answer/9866151?hl=tr

## 2. Ham cihaz görüntüsü

Samsung S25 Ultra gibi 1440×3120 / yaklaşık 19.5:9 ham ekran görüntüsü **doğrudan Play’e yüklenmeyecek**; uzun kenar kısa kenarın iki katını geçtiği için Play screenshot şartına uygun değildir.

Güvenli üretim yolları:

1. Production RC’yi 1080×1920 / 9:16 Android ortamında açıp doğrudan screenshot almak; veya
2. Fiziksel cihazdaki gerçek uygulama screenshot’ını UI’yi bozmayacak şekilde 9:16 kadrajlayıp 1080×1920’e dönüştürmek.

Görüntü esnetilmeyecek.

## 3. Demo veri seti

Mağaza screenshot’larında gerçek kullanıcı hesabı veya gerçek takipçi adı kullanılmayacak.

Repo içinde hazır sentetik arşivler:

### Instagram

- `store_assets/demo_archives/instagram/snapshot_1.zip`
- `store_assets/demo_archives/instagram/snapshot_2.zip`
- Demo kullanıcı adı: `demo_analiz_2026`
- İkinci snapshot sonrası beklenen: 11 takipçi / 12 takip edilen / 2 bırakan / 3 yeni

### X

- `store_assets/demo_archives/x/snapshot_1.zip`
- `store_assets/demo_archives/x/snapshot_2.zip`
- Demo kullanıcı adı: `demo_x_analiz_2026`
- İkinci snapshot sonrası beklenen: 9 takipçi / 10 takip edilen / 1 bırakan / 2 yeni

Detaylar ve SHA-256 değerleri:
`store_assets/demo_archives/README.md`

## 4. Temiz çekim hazırlığı

Production RC mağaza çekim oturumundan önce:

1. Gerçek kişisel app verisi kullanılan test build’den screenshot alma.
2. Mümkünse store çekimi için temiz uygulama verisi / kontrollü test cihazı kullan.
3. Instagram demo hesabına `snapshot_1.zip`, sonra `snapshot_2.zip` import et.
4. X demo hesabına `snapshot_1.zip`, sonra `snapshot_2.zip` import et.
5. Uygulamayı kapat/aç ve geçmişin korunduğunu doğrula.
6. Bildirimleri kapat veya hassas notification içeriğini gizle.
7. Pil/Wi-Fi/hücresel sistem simgeleri normal görünsün; kişisel bildirim görünmesin.
8. Klavyeyi yalnız gerçekten özellik göstermek istediğimiz search screenshot’ında açık tut; diğerlerinde kapat.

## 5. Telefon screenshot sırası — 8 görsel

### 01 — Ana ekran / iki platform

Gösterilecek:

- `Takip Analizi`
- local-first açıklama
- Instagram kartı
- X / Twitter kartının başlangıcı mümkünse aynı kadrajda
- Cihazda / güvenlik görsel dili

Amaç:

Ürünün Instagram + X arşiv analizi olduğunu ilk bakışta anlatmak.

Alt text:

`Instagram ve X arşivlerini cihazda analiz etmeye yarayan Takip Analizi ana ekranı.`

### 02 — Takip Etmeyenler

Instagram `snapshot_2` analizi açık.

Gösterilecek:

- hesap `demo_analiz_2026`
- follower/following özetleri
- `Takip Etmeyenler (6)`
- birkaç `demo_out..` satırı
- arama/sıralama kontrolleri

Amaç:

En temel kullanıcı değerini göstermek.

Alt text:

`Takip etmeyen hesapların sayısını ve sentetik demo kullanıcı listesini gösteren analiz ekranı.`

### 03 — Takibi Bırakanlar

Aynı Instagram ikinci snapshot analizi.

Gösterilecek:

- `Takibi Bırakanlar (2)` sekmesi seçili
- `demo_fan01`, `demo_fan02`

Amaç:

Snapshot geçmişi değerini doğrudan anlatmak.

Alt text:

`İki yerel snapshot arasındaki takibi bırakan hesapları gösteren geçmiş karşılaştırması.`

### 04 — Yeni Takipçiler

Aynı analiz.

Gösterilecek:

- `Yeni Takipçiler (3)` seçili
- `demo_new01`, `demo_new02`, `demo_new03`

Alt text:

`Son arşiv karşılaştırmasında yeni takipçileri gösteren analiz sekmesi.`

### 05 — Arama ve sıralama

`Takip Etmeyenler` veya `Karşılıklı` sekmesinde:

- search alanına `demo_out` gibi sentetik sorgu
- filtrelenmiş satırlar
- A-Z / Z-A kontrolü görünür

Alt text:

`Takip listesini kullanıcı adına göre arama ve alfabetik sıralama kontrolleri.`

### 06 — Analiz Geçmişi / manuel karşılaştırma

Gösterilecek:

- Instagram + X platform filtreleri
- `demo_analiz_2026` snapshot kayıtları
- iki snapshot karşılaştırma akışının görünür kontrolü

Alt text:

`Yerel analiz geçmişini filtreleme ve iki snapshot seçerek karşılaştırma ekranı.`

### 07 — Yerel Veri Yönetimi

Gösterilecek:

- Analiz / Hesap / Yok sayılan sayaçları
- Tüm analiz geçmişini sil
- Yok sayılanları temizle
- Tüm yerel veriyi temizle
- cihaz dışındaki Instagram/X verisine dokunmadığı açıklaması

Alt text:

`Cihazdaki analiz geçmişi ve yerel tercihleri kontrollü biçimde silmeye yarayan veri yönetimi ekranı.`

### 08 — X arşivi / gizlilik

İki adaydan daha güçlü olan production RC’de seçilecek:

**Aday A: X Analizi**

- `demo_x_analiz_2026`
- X analizi
- Takibi Bırakanlar (1) veya Yeni Takipçiler (2)

Alt text:

`X veri arşivinden hesaplanan takip değişikliklerini gösteren yerel analiz ekranı.`

**Aday B: Gizlilik ve Hakkında**

- Local-first
- Şifre istemiyoruz
- Yalnız seçtiğin dosyalar
- Yerel geçmiş

Alt text:

`Takip Analizi uygulamasının local-first gizlilik yaklaşımını açıklayan ekran.`

İlk yayın için Aday A tercih edilir; gizlilik ekranı gerekirse 8. veya ek localization materyalinde kullanılabilir.

## 6. Ekran görüntüsü kalite kontrolü

Her screenshot için:

- [ ] Gerçek app UI’si mi?
- [ ] Gerçek kişi/kullanıcı adı yok mu?
- [ ] Demo hesap adı doğru mu?
- [ ] Bildirim veya e-posta görünmüyor mu?
- [ ] Status bar’da operatör/özel notification yok mu?
- [ ] 1080×1920 mı?
- [ ] 9:16 mı?
- [ ] Görüntü esnetilmemiş mi?
- [ ] Alfa kanalı yok mu?
- [ ] Yazılar okunabilir mi?
- [ ] Aynı ekran gereksiz tekrar edilmiyor mu?
- [ ] Uygulamada olmayan özellik çağrışımı yok mu?

## 7. Tablet / büyük ekran

İlk production yayınında Play Console tablet screenshot alanı zorunlu hale gelirse:

- 7 inç ve 10 inç ayrı gerçek app deneyimi yakalanacak.
- Google’ın büyük ekran önerisine göre 1080–7680px, 9:16 dikey veya 16:9 yatay kullanılacak.
- Telefon screenshot’ı sadece büyütülüp tablet görüntüsü gibi sunulmayacak.
- Uygulama tablet düzeni gerçek cihaz/emülatörde kontrol edilmeden tablet görseli yüklenmeyecek.

## 8. 512×512 mağaza simgesi

Kural:

- Yeni logo üretme yok.
- Kaynak yalnız kilitli exact launcher raster:
  `apps/mobile/android/app/src/main/res/drawable-nodpi/takip_launcher_user.webp`
- Kaynak SHA-256:
  `7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`
- 512×512 PNG türevi oluşturulacak.
- İç tasarım yeniden çizilmeyecek, AI ile regenerate edilmeyecek, başka icon kullanılmayacak.

Teknik binary çıkarma/ölçekleme hattı hazır olduğunda türev hash’i ayrıca kaydedilecek.

## 9. 1024×500 feature graphic

Henüz üretilmedi.

İlk tasarım ilkeleri:

- 1024×500
- alfa yok
- Takip Analizi görsel kimliği
- exact launcher tasarımını referans alabilir fakat yeniden logo çizmez
- Instagram/X resmi marka ilişkisi ima etmez
- fiyat, indirim, `#1`, mağaza badge’i yok
- çok küçük metne yaslanma yok

Feature graphic görsel tasarımı ayrı iş olarak ele alınacak; user onayı olmadan yayın materyali olarak kilitlenmeyecek.

## 10. Final operasyon sırası

1. Private Play upload signing’i tamamla.
2. Production RC AAB `1.0.0 / 1` üret.
3. Tek kritik RC fiziksel testini yap.
4. Sentetik store arşivlerini RC’ye import et.
5. 8 telefon screenshot’ını çek.
6. 1080×1920 çıktıları kalite kontrolünden geçir.
7. Exact launcher’dan 512×512 store icon türet.
8. 1024×500 feature graphic’i hazırla.
9. TR/EN listing + privacy/support + Data Safety cevaplarıyla Play Console’u tamamla.
