# Sosyal Medya Takip Analizi

Android öncelikli, local-first sosyal medya takip ilişkisi analiz uygulaması.

## İlk hedef

İlk çekirdek Instagram'ın resmi veri dışa aktarma dosyalarından takipçi/takip edilen listelerini okuyup ortak analiz motorunda karşılaştırır.

## Temel ilkeler

- Kullanıcı adı/şifre toplama yok.
- Instagram private API veya scraping yok.
- Instagram verisi varsayılan olarak cihazdan çıkmaz.
- Analiz motoru platform bağımsızdır.
- X entegrasyonunda önce resmi veri arşivi; canlı API yalnızca maliyet/politika açısından uygunsa değerlendirilir.

## Geliştirme düzeni

`main` stabil tutulur. Özellik geliştirmeleri `feat/*`, hata düzeltmeleri `fix/*` branch'lerinde yapılır ve PR ile `main`e alınır.
