# PROJE_OZETI

Son güncelleme: 1 Eylül 2026, 00:44 (Europe/Istanbul)

Çalışan fiziksel baseline: v2-17. Samsung/Android 16 cihazda kullanıcı listeleri, `Karşılıklı (261)` sekmesine geçiş ve Instagram profil bağlantısı doğrulandı. Gerçek export: 569 takipçi, 1053 takip edilen, 792 takip etmeyen, 261 karşılıklı, 308 yalnız takipçi.

Fiziksel geri dönüş branchleri:
- `backup/device-v2-16-working-baseline`
- `backup/device-v2-17-links-working`

Final sekme hedefi 5 adettir: Takip Etmeyenler, Karşılıklı, Seni Takip Edenler, Takibi Bırakanlar, Yeni Takipçiler. Şu an ilk 3 sekmeli rollback baseline kullanılıyor.

Sıradaki tek özellik: Yok sayılan hesaplar. Var olan `IgnoredAccountsStore` ve `/ignored-accounts` ekranı kullanılacak. Çalışan `ListView.separated + CircleAvatar + profil onTap` korunacak. Yalnız sağ üst Yok sayılanlar yönetim düğmesi, kullanıcı satırında üç nokta → Yok say, kategori listesinden anlık filtreleme ve SnackBar Geri al eklenecek. Arama/sıralama, son iki geçmiş sekmesi, MonogramAvatar ve launcher bu build'e eklenmeyecek.

Kod adayı için yeni regression testi: bir kullanıcı üç nokta menüsünden Yok sayıldığında satır kaybolmalı ve `Takip Etmeyenler (2)` sayısı `Takip Etmeyenler (1)` olmalı.

Launcher hedefi: kullanıcının seçtiği 4. seçeneğin koyu versiyonu; henüz fiziksel doğrulanmadı.

GitHub Actions ödeme sorunu kapanmıştır; public repo hosted runner tekrar çalışmaktadır. Test APK paketi `com.zmilastudio.takipanalizi.dev`, sabit sertifika SHA-256 `4735f6e6c0603ded3bfd6c236b625c08e116a8a38216088271997acdccc6d799`.
