# PROJE_OZETI

Son güncelleme: 1 Eylül 2026, 00:44 (Europe/Istanbul)

Çalışan fiziksel baseline: `device-test-v2-17`.
- Takip Etmeyenler listesi fiziksel Samsung/Android 16 cihazda görünür ✅
- Karşılıklı (261) sekmesine geçiş ve liste görünümü doğrulandı ✅
- Instagram profil bağlantısı açılıyor ✅
- 569 takipçi / 1053 takip edilen / 792 takip etmeyen / 261 karşılıklı / 308 yalnız takipçi değerleri doğru.
- geri dönüş: `backup/device-v2-17-links-working`

Final hedef 5 sekme: Takip Etmeyenler, Karşılıklı, Seni Takip Edenler, Takibi Bırakanlar, Yeni Takipçiler.

Sıradaki tek özellik `Yok sayılan hesaplar`:
- `IgnoredAccountsStore` ve `/ignored-accounts` kullanılacak.
- çalışan `ListView.separated`, CircleAvatar ve profil onTap korunacak.
- yalnız sağ üst yönetim düğmesi + satır üç nokta → Yok say + anlık filtre + SnackBar Geri al eklenecek.
- arama/sıralama, MonogramAvatar, son iki geçmiş sekmesi ve launcher aynı build'e eklenmeyecek.
- fiziksel cihazda doğrulanmadan sonraki özelliğe geçilmeyecek.

Launcher hedefi: seçilen 4. seçeneğin koyu versiyonu; fiziksel doğrulama bekliyor.
