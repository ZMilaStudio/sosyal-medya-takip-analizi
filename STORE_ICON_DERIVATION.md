# Takip Analizi — Exact Store Icon Türetme Kaydı

Son güncelleme: 1 Eylül 2026

Bu kayıt, Google Play 512×512 mağaza simgesinin yeni bir logo üretmeden kullanıcının exact onaylı raster kaynağından türetildiğini doğrular.

## Orijinal kullanıcı kaynağı

Aktif proje çalışma ortamındaki orijinal yükleme:

`92065.png`

Özellikler:

- 1536×1536
- RGB
- PNG
- SHA-256: `ebada937553521ffcff3a92f6a8ff88d040c11ccc289f826de8fd91020b14c90`

Bu dosya yeniden çizilmiş veya AI ile regenerate edilmiş bir logo değildir; kullanıcının exact onay verdiği raster kaynaktır.

## Kilitli Android launcher ile byte doğrulaması

Repo içindeki final launcher:

`apps/mobile/android/app/src/main/res/drawable-nodpi/takip_launcher_user.webp`

Kilitli SHA-256:

`7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`

Orijinal `92065.png` üzerinde şu deterministik işlem uygulandığında repo launcher dosyasının exact hash’i elde edildi:

1. RGB olarak aç.
2. 192×192 boyutuna Lanczos ile küçült.
3. WebP kaydet:
   - lossless: false
   - quality: 95
   - method: 6

Sonuç:

- boyut: 6.798 byte
- SHA-256: `7543b6233c3d23a139b94ecad6058ddd5ff861773339055268ccc85873923de0`

Bu eşleşme, `92065.png` dosyasının mevcut kilitli launcher tasarımının gerçek yüksek çözünürlüklü kaynağı olduğunu doğrular.

## Google Play 512×512 store icon

Orijinal 1536×1536 PNG’den yalnız boyut dönüşümü yapıldı:

1. RGB kaynak korunur.
2. 512×512 Lanczos resize.
3. PNG optimize kaydı.
4. Alfa yok.
5. Görsel içerik, renk, obje veya logo tasarımı değiştirilmez.

Üretilen dosya:

`takip-analizi-store-icon-512.png`

Özellikler:

- 512×512
- RGB PNG
- 169.565 byte
- SHA-256: `c838ffe6ef39bab9cab0176951334f8dc79e0158fc02755cb27ca28c856ae717`
- Google Play 1.024 KB mağaza simgesi sınırının altında.

## Kilit kuralı

- Store icon için image generation kullanılmayacak.
- Simge yeniden çizilmeyecek.
- Renkler veya simge kompozisyonu değiştirilmeyecek.
- Başka launcher/logo ile değiştirilmeyecek.
- Final Play upload öncesi dosya SHA-256 değeri yukarıdaki değerle karşılaştırılacak.

## Repo / artifact notu

Binary 512 PNG çalışma artifact’i olarak üretildi. Repo connector’ünün text-first dosya yazma sınırı nedeniyle bu aşamada binary PNG branch’e eklenmedi; türetme parametreleri ve exact SHA burada kalıcı olarak kaydedildi.

Google Play yüklemesinde kullanılacak dosya yukarıdaki SHA ile doğrulanmalıdır.
