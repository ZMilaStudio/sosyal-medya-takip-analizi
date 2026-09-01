# Takip Analizi — Privacy & Support Yayın Planı

Son güncelleme: 1 Eylül 2026

Amaç: Google Play production yayını öncesi kalıcı, herkese açık gizlilik politikası ve destek kanallarını güvenli biçimde tamamlamak.

## Production blocker’lar

Şu üç alan kesinleşmeden production mağaza girişi tamamlanmış sayılmayacak:

1. Kalıcı gizlilik politikası URL’si.
2. Resmi destek e-postası.
3. Tercihen resmi destek web sayfası / iletişim sayfası.

Google Play mağaza iletişim bilgilerinde e-posta zorunludur; website güçlü biçimde önerilir.

## 1. Gizlilik politikası sayfası

Kaynak metin: `PRIVACY_POLICY.md`.

Yayın hedefi:

- HTTPS üzerinden herkese açık olmalı.
- Giriş yapmadan erişilebilmeli.
- Mobil tarayıcıda rahat okunmalı.
- Kalıcı ve tahmin edilebilir bir URL kullanılmalı.
- URL uygulama sürümleri arasında gereksiz yere değiştirilmemeli.

Önerilen URL yolu örneği:

`https://<resmi-zmila-studio-domaini>/privacy/takip-analizi`

Bu yalnız yol önerisidir; gerçek domain production öncesi resmi web mülkü üzerinden teyit edilecektir.

Sayfada bulunması gerekenler:

- uygulama adı: Takip Analizi,
- geliştirici: ZMila Studio,
- hangi verilerin cihaz üzerinde işlendiği,
- sosyal medya şifrelerinin alınmadığı,
- mevcut mimaride analiz arşivlerinin geliştirici sunucusuna yüklenmediği,
- yerel veri silme mekanizması,
- dış profil bağlantılarının üçüncü taraf uygulamalara devredildiği,
- politika güncelleme tarihi,
- resmi destek iletişim kanalı.

## 2. Destek e-postası

Google Play listing için zorunlu alan.

Kurallar:

- ZMila Studio tarafından kontrol edilen kalıcı bir adres olmalı.
- Kişisel/geçici test adresi kullanılmamalı.
- Şifre, ZIP arşivi veya hassas sosyal medya verisi e-postayla istenmemeli.
- Kullanıcıya hata raporunda yalnız gerekli teknik bilgileri paylaşması söylenmeli.
- Production öncesi gönderme/alma testi yapılmalı.

Repo içine gerçek destek adresi ancak resmi olarak seçildikten sonra yazılacaktır.

Durum: **BEKLİYOR**.

## 3. Destek web sayfası

Önerilen URL yolu örneği:

`https://<resmi-zmila-studio-domaini>/support/takip-analizi`

Önerilen içerik:

### Hızlı yardım

- Instagram arşivi nasıl alınır?
- X arşivi nasıl alınır?
- ZIP neden okunmuyor?
- Takipçi sayısı neden Instagram/X uygulamasındaki canlı sayıdan farklı olabilir?
- Takibi Bırakanlar / Yeni Takipçiler nasıl hesaplanır?
- Verilerimi nasıl silebilirim?

### Gizlilik

- Uygulama şifre istemez.
- Arşiv dosyalarını destek ekibine göndermeyin.
- Yerel veriler uygulama içinden silinebilir.

### İletişim

- Resmi destek e-postası.
- Beklenen yanıt süresi ancak gerçekten uygulanabilir bir destek süreci belirlendikten sonra yazılmalı; sahte SLA verilmemeli.

## 4. Uygulama içi bağlantı

Mevcut v2-38’de `Gizlilik ve Hakkında` ekranı kullanıcıya local-first yaklaşımı açıklar fakat henüz internet bağlantısı gerektirmeyen uygulama mimarisi nedeniyle public privacy URL’sine doğrudan ağ bağlantısı eklenmedi.

Production öncesi iki güvenli seçenek var:

### Seçenek A — mevcut offline ekranı koru

- Uygulama içi privacy özeti cihazda kalır.
- Play Store listing’de public privacy URL bulunur.
- Uygulamaya INTERNET izni eklenmez.

### Seçenek B — public policy bağlantısını uygulamaya ekle

- Kullanıcı butona basınca sistem tarayıcısı açılır.
- Bunun için Android manifest/network davranışı tekrar gözden geçirilir.
- Veri Güvenliği ve `INTERNET` izni beyanı yeniden doğrulanır.

**Mevcut local-first ürün yaklaşımı için Seçenek A tercih edilir.** Public policy URL Play Store’da bulunur; uygulamanın analiz akışı internetsiz kalır.

## 5. Yayına alma kontrolü

Gizlilik/support sayfaları yayına alındıktan sonra:

- [ ] URL’leri anonim/incognito tarayıcıdan aç.
- [ ] HTTPS sertifikasını kontrol et.
- [ ] Mobil görünümü kontrol et.
- [ ] Sayfada uygulama adı ve ZMila Studio doğru mu kontrol et.
- [ ] Destek e-postasına test mesajı gönder ve alındığını doğrula.
- [ ] Play Console Store settings → contact email alanına resmi destek adresini gir.
- [ ] Main store listing → privacy policy alanına kalıcı URL’yi gir.
- [ ] `PRIVACY_POLICY.md`, `PLAY_STORE_LISTING_TR.md`, `RELEASE_CHECKLIST.md` içindeki `BEKLİYOR` alanlarını gerçek bilgilerle güncelle.
- [ ] Production RC öncesi Play Data safety ile policy metnini son kez karşılaştır.

## 6. Değişiklik yönetimi

İleride aşağıdakilerden biri eklenirse privacy/support içeriği production yayını öncesi tekrar gözden geçirilecek:

- reklam,
- analytics veya crash reporting,
- canlı Instagram/X API veya OAuth,
- bulut senkronizasyonu,
- kullanıcı hesabı,
- push notification,
- ödeme/abonelik,
- geliştirici sunucusuna veri aktarımı.
