# Sosyal Medya Takip Analizi

Android öncelikli, local-first Instagram ve X / Twitter takip ilişkisi analiz uygulaması.

## Mevcut özellikler

- Resmi Instagram veri dışa aktarma ZIP/JSON/HTML dosyalarını cihaz üzerinde analiz etme.
- Resmi X veri arşivi ZIP veya `follower.js` + `following.js` dosyalarını cihaz üzerinde analiz etme.
- Takip Etmeyenler, Karşılıklı, Seni Takip Edenler, Takibi Bırakanlar ve Yeni Takipçiler kategorileri.
- Yerel snapshot geçmişi ve otomatik değişim karşılaştırması.
- İki snapshot’ı manuel karşılaştırma.
- Kullanıcı arama ve A-Z / Z-A sıralama.
- Profil bağlantılarını harici Instagram/X uygulaması veya tarayıcıda açma.
- “Yok say” listesi ve geri yükleme.
- Analiz geçmişi ve yerel veri yönetimi.
- Analiz raporunu kopyalama veya TXT olarak kaydetme.
- Instagram ve X arşivi alma rehberleri.
- Uygulama içi Gizlilik ve Hakkında açıklaması.

## Gizlilik yaklaşımı

- Sosyal medya kullanıcı adı/şifresi toplanmaz.
- Instagram private API veya scraping kullanılmaz.
- Kullanıcının seçtiği arşivler cihaz üzerinde işlenir.
- Mevcut Android build’i `INTERNET` izni istemez.
- Reklam, analytics veya bulut senkronizasyon SDK’sı yoktur.
- Yerel geçmiş ve “Yok say” verileri uygulama içinden silinebilir.

Ayrıntılar: [`PRIVACY_POLICY.md`](PRIVACY_POLICY.md)

## Google Play hazırlığı

- Veri Güvenliği teknik taslağı: [`PLAY_STORE_DATA_SAFETY.md`](PLAY_STORE_DATA_SAFETY.md)
- Production yayın kapıları: [`RELEASE_CHECKLIST.md`](RELEASE_CHECKLIST.md)
- Production upload-key kurulumu: [`SIGNING_SETUP.md`](SIGNING_SETUP.md)

## Android kimlikleri

- Production package: `com.zmilastudio.takipanalizi`
- Device-test package: `com.zmilastudio.takipanalizi.dev`

Device-test build’leri production imzasından tamamen ayrıdır. Production signing yalnız private `PLAY_UPLOAD_*` environment/secrets değerleri mevcutsa devreye girer.

## Geliştirme düzeni

Çalışan CI/fiziksel baseline’lar backup branch’lerde korunur. Özellikler dev branch’lerinde toplu hazırlanır; GitHub Actions kotasını korumak için `test/device-apk` yalnız kritik doğrulama noktalarında güncellenir.

Canlı proje durumu ve rollback noktaları için `PROJE_OZETI.md` esas alınır.
