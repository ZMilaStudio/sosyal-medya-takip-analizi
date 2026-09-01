# Takip Analizi — Store Screenshot Demo Archives

Bu klasördeki arşivler yalnız Google Play mağaza ekran görüntüleri ve release-demo akışı için hazırlanmış **tamamen sentetik** verilerdir.

Gerçek Instagram/X hesabı, gerçek takipçi adı, gerçek kişisel veri veya kullanıcı şifresi içermez.

## Kullanılacak demo hesap adları

Instagram input alanı:

`demo_analiz_2026`

X input alanı:

`demo_x_analiz_2026`

Aynı platformda snapshot 1 ve snapshot 2 mutlaka aynı demo kullanıcı adıyla içe aktarılmalıdır; aksi halde geçmiş karşılaştırma oluşmaz.

## Instagram

### `instagram/snapshot_1.zip`

Beklenen ham durum:

- Takipçi: 10
- Takip edilen: 11
- Karşılıklı: 6
- Takip Etmeyenler: 5
- Seni Takip Edenler: 4
- Takibi Bırakanlar: 0 — ilk snapshot olduğu için
- Yeni Takipçiler: 0 — ilk snapshot olduğu için

SHA-256:

`9f9938022e3a25b6463c86090439da877412ac96f9c230547368c54904c1a10d`

### `instagram/snapshot_2.zip`

Snapshot 1’in üstüne aynı `demo_analiz_2026` hesabıyla import edilmelidir.

Beklenen ham durum:

- Takipçi: 11
- Takip edilen: 12
- Karşılıklı: 6
- Takip Etmeyenler: 6
- Seni Takip Edenler: 5
- Takibi Bırakanlar: 2
- Yeni Takipçiler: 3

Değişim kontrolü:

`10 - 2 + 3 = 11`

SHA-256:

`cbc1271712f37b5e1fe02c87ef97b5f6a1bfe868dc1a525a531de901a1be44ab`

Kullanılan sentetik adlar `demo_mutual..`, `demo_fan..`, `demo_out..`, `demo_new..` şablonundadır.

## X

### `x/snapshot_1.zip`

Beklenen ham durum:

- Takipçi: 8
- Takip edilen: 9
- Karşılıklı: 5
- Takip Etmeyenler: 4
- Seni Takip Edenler: 3
- Takibi Bırakanlar: 0
- Yeni Takipçiler: 0

SHA-256:

`2aaa0c99237c6f1e0a685fd69181b345fd1705f6a184e5b5f60a5dc5f0c78937`

### `x/snapshot_2.zip`

Snapshot 1’in üstüne aynı `demo_x_analiz_2026` hesabıyla import edilmelidir.

Beklenen ham durum:

- Takipçi: 9
- Takip edilen: 10
- Karşılıklı: 5
- Takip Etmeyenler: 5
- Seni Takip Edenler: 4
- Takibi Bırakanlar: 1
- Yeni Takipçiler: 2

Değişim kontrolü:

`8 - 1 + 2 = 9`

SHA-256:

`cda0e451b5f79c6ab830b195b90fb4475627c07f6765534cb72c03c6a8d7f038`

Kullanılan sentetik adlar `demo_x_mutual..`, `demo_x_fan..`, `demo_x_out..`, `demo_x_new..` şablonundadır.

## Mağaza çekiminde veri güvenliği

- Gerçek `gece02.19` veya başka kişisel hesap mağaza görsellerinde kullanılmayacak.
- Gerçek takipçi listesi, profil fotoğrafı, DM, e-posta veya cihaz bildirimi görünmeyecek.
- Profil linki düğmeleri ekran görüntüsünde bulunabilir fakat demo hesaplara dokunularak gerçek sosyal medya profili açılmayacak.
- Status bar’da kişisel bildirim görünüyorsa çekimden önce rahatsız etmeyin / bildirim gizleme kullanılacak.
- Ekran görüntülerine sonradan sahte uygulama UI’si çizilmeyecek; gerçek production RC ekranı kullanılacak.

## Arşivlerin amacı

Bu dosyalar production kullanıcı özelliği değildir ve APK/AAB içine asset olarak eklenmez. Yalnız mağaza materyali üretimi ve kontrollü demo doğrulaması için repo tarafında tutulur.
