# Takip Analizi — Google Play Mağaza Girişi (TR)

Son güncelleme: 1 Eylül 2026

Bu dosya production Google Play mağaza girişi için hazır Türkçe metin paketidir.

## Resmi sınırlar

- Uygulama adı: en fazla 30 karakter.
- Kısa açıklama: en fazla 80 karakter.
- Tam açıklama: en fazla 4.000 karakter.
- Mağaza simgesi: 512×512, 32-bit PNG, alfa destekli, en fazla 1.024 KB.
- Feature graphic: 1024×500, JPEG veya alfa kanalsız 24-bit PNG.
- Store listing destek e-postası zorunludur; website güçlü biçimde önerilir.

Resmi kaynaklar:
- https://support.google.com/googleplay/android-developer/answer/9859152?hl=tr
- https://support.google.com/googleplay/android-developer/answer/9866151?hl=tr
- https://support.google.com/googleplay/android-developer/answer/113477?hl=tr
- https://support.google.com/googleplay/android-developer/answer/9859673?hl=tr

## Önerilen mağaza adı

**Takip Analizi**

Karakter sayısı: 13 / 30.

Ad mevcut uygulama etiketiyle aynıdır ve Instagram/X ile resmi bir ilişki ima etmez.

## Önerilen kategori

**Araçlar**

Gerekçe: Takip Analizi bir sosyal ağ veya iletişim platformu değil; kullanıcının kendi resmi veri arşivini yerel olarak inceleyen bir yardımcı analiz aracıdır. Google Play kategori örneklerinde `Sosyal` sosyal ağ/check-in uygulamaları, `Araçlar` ise Android cihazları için araçlar olarak tanımlanır.

Alternatif olarak uygulamanın konumlandırması gelecekte görev/iş akışı odaklı hale gelirse `Verimlilik` yeniden değerlendirilebilir. Mevcut ürün için ilk tercih `Araçlar` olmalıdır.

## Kısa açıklama

**Instagram ve X takip ilişkilerini arşivlerinden cihazında analiz et.**

Karakter sayısı: 68 / 80.

## Tam açıklama

Takip Analizi, Instagram ve X takip ilişkilerini resmi veri arşivlerinden cihazında incelemeni sağlayan local-first bir analiz aracıdır.

### Şifre paylaşmadan analiz yap

Instagram veya X şifreni girmen gerekmez. Uygulama sosyal medya hesabına giriş yapmaz, private API kullanmaz ve otomatik takip etme/takip bırakma işlemi gerçekleştirmez.

### Resmi arşivlerini cihazında analiz et

• Instagram veri dışa aktarma ZIP, JSON ve HTML dosyalarını içe aktar.
• X veri arşivini ZIP olarak seç.
• Çok büyük X arşivlerinde follower.js ve following.js dosyalarını doğrudan seç.
• Analiz için gerekli olmayan X medya, gönderi ve mesaj geçmişi kullanılmaz.

### Takip ilişkilerini anlaşılır kategorilerde gör

• Takip Etmeyenler
• Karşılıklı
• Seni Takip Edenler
• Takibi Bırakanlar
• Yeni Takipçiler

### Değişiklikleri zaman içinde karşılaştır

Analiz snapshot’ları cihazında saklanabilir. Aynı hesabın yeni arşivini içe aktardığında önceki snapshot ile otomatik karşılaştırma yapılır. İstersen geçmişteki iki snapshot’ı manuel olarak da karşılaştırabilirsin.

### Liste yönetimi

Kullanıcı adına göre ara, A-Z / Z-A sırala, profil bağlantısını harici Instagram/X uygulamasında veya tarayıcıda aç ve görmek istemediğin hesapları “Yok say” listesine ekle.

### Rapor ve yerel veri yönetimi

Analiz sonucunu kopyalayabilir veya TXT dosyası olarak kaydedebilirsin. Analiz geçmişini, Yok say tercihlerini ya da tüm yerel uygulama verisini uygulama içinden silebilirsin. Bu silme işlemleri Instagram veya X hesabındaki gerçek verilere dokunmaz.

### Gizlilik yaklaşımı

Takip arşivleri geliştirici sunucusuna yüklenmez; analiz cihazda kalacak şekilde tasarlanmıştır. Flutter geliştirme build’leri debug araçları için internet izni içerebilir, ancak production release hattı merged release manifestinde Android INTERNET izni bulunursa build’i kabul etmeyecek şekilde hazırlanmıştır. Bir sosyal medya profilini açmayı seçersen bağlantı kullanıcı tarafından başlatılan bir işlem olarak ilgili üçüncü taraf uygulamaya veya tarayıcıya devredilir.

Takip Analizi bağımsız bir ZMila Studio uygulamasıdır; Instagram veya X tarafından geliştirilmiş, desteklenmiş ya da onaylanmış değildir.

Tam açıklama 4.000 karakter sınırının altındadır.

## Etiket yaklaşımı

Google Play, uygulamayla açıkça alakalı etiketlerin seçilmesini ister. Kesin etiket adları Play Console’un o anda sunduğu listeden seçilecektir.

Kurallar:

- En fazla 5 gerçekten ilgili etiket kullan.
- Uygulamada bulunmayan bir özelliği ima eden etiket seçme.
- Sırf daha fazla trafik almak için `Sosyal ağ`, mesajlaşma veya benzeri yanlış konumlandırma kullanma.
- Console’da mevcutsa analiz, araç/yardımcı araç ve yerel dosya işleme gibi gerçek işlevlere en yakın etiketleri tercih et.

## Mağaza görsel planı

### Uygulama simgesi

- 512×512 PNG hazırlanacak.
- Kullanıcının kilitli exact launcher tasarımından türetilecek; yeni/alternatif logo tasarlanmayacak.
- Play metadata kurallarına aykırı `#1`, fiyat, indirim, rozet veya resmi Instagram/X ilişkisi ima eden öğe eklenmeyecek.

### Feature graphic

- 1024×500.
- Ana değer: “Şifresiz • Local-first • Instagram + X takip analizi”.
- Küçük ekranda kaybolacak aşırı detay kullanılmayacak.
- Instagram/X logoları resmi ilişki varmış gibi baskın kullanılmayacak.

### Ekran görüntüsü adayları

Production RC’den sonra gerçek uygulama ekranlarından seçilecek:

1. Ana ekran — Instagram + X import seçenekleri.
2. Analiz — Takip Etmeyenler.
3. Analiz — Takibi Bırakanlar / Yeni Takipçiler.
4. Arama ve sıralama.
5. Analiz Geçmişi / snapshot karşılaştırma.
6. Yerel Veri Yönetimi.
7. Gizlilik ve Hakkında.
8. X arşiv rehberi veya büyük arşiv JS fallback.

Mockup yerine gerçek uygulama ekranları temel alınacak.

## Mağaza iletişim bilgileri

- Destek e-postası: `zmilastudio@gmail.com`
- Destek web sitesi: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/SUPPORT.md`
- Gizlilik politikası URL’si: `https://github.com/ZMilaStudio/sosyal-medya-takip-analizi/blob/main/PRIVACY_POLICY.md`

Bu sayfalar public repoda yayınlanmıştır ve uygulama hesabı/giriş gerektirmez.

## Metadata güvenlik kontrolü

Yayın metinlerinde:

- `en iyi`, `#1`, `resmi`, `ücretsiz sınırlı süre`, indirim/fiyat gibi promosyon ifadeleri kullanılmayacak.
- Instagram veya X tarafından destekleniyormuş gibi bir ifade kullanılmayacak.
- Uygulamada olmayan canlı takip, otomatik takip bırakma veya gerçek zamanlı API özelliği vaat edilmeyecek.
- Kısa açıklama ile tam açıklama gereksiz anahtar kelime tekrarına dönüştürülmeyecek.
