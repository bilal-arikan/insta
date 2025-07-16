# Instagram Benzeri Mobil Uygulama - PRD (Product Requirements Document)

## 1. Proje Genel Bakış

### 1.1 Proje Adı
InstaClone - Sosyal Medya Mobil Uygulaması

### 1.2 Proje Açıklaması
Instagram benzeri özelliklere sahip, kullanıcıların fotoğraf ve video paylaşabileceği, beğeni ve yorum yapabileceği, takip sistemi olan bir sosyal medya mobil uygulaması.

### 1.3 Teknoloji Stack
- **Frontend**: Flutter (Dart) (`insta_app` klasörü)
- **Backend**: Supabase (`insta_backend` klasörü)
- **Veritabanı**: PostgreSQL (Supabase)
- **Depolama**: Supabase Storage
- **Kimlik Doğrulama**: Supabase Auth
- **Gerçek Zamanlı**: Supabase Realtime

## 2. Hedef Kitle
- 16-35 yaş arası kullanıcılar
- Fotoğraf ve video paylaşmayı seven kişiler
- Sosyal medya kullanıcıları
- İçerik üreticileri

## 3. Temel Özellikler

### 3.1 Kullanıcı Yönetimi
- Kayıt olma ve giriş yapma
- Profil düzenleme
- Profil fotoğrafı ekleme
- Kullanıcı adı ve bio düzenleme

### 3.2 İçerik Yönetimi
- Fotoğraf ve video paylaşma
- Filtreler ve düzenleme araçları
- Açıklama ekleme
- Konum etiketi ekleme
- Hashtag sistemi

### 3.3 Sosyal Özellikler
- Kullanıcı takip etme/takibi bırakma
- Gönderi beğenme/beğenmeme
- Yorum yapma ve yanıtlama
- Beğeni ve yorum sayılarını görme

### 3.4 Keşfet ve Arama
- Kullanıcı arama
- Hashtag arama
- Popüler gönderiler
- Keşfet sayfası

### 3.5 Bildirimler
- Beğeni bildirimleri
- Yorum bildirimleri
- Takip bildirimleri
- Push notification desteği

## 4. Teknik Gereksinimler

### 4.1 Performans
- Uygulama başlatma süresi < 3 saniye
- Fotoğraf yükleme süresi < 5 saniye
- Smooth scrolling (60 FPS)

### 4.2 Güvenlik
- Kullanıcı verilerinin şifrelenmesi
- Güvenli dosya yükleme
- Rate limiting
- Input validation

### 4.3 Uyumluluk
- iOS 12.0+
- Android 6.0+
- Responsive tasarım

## 5. UI/UX Gereksinimleri

### 5.1 Tasarım Prensipleri
- Modern ve temiz tasarım
- Instagram benzeri arayüz
- Dark/Light mode desteği
- Accessibility uyumluluğu

### 5.2 Ana Ekranlar
- Giriş/Kayıt ekranları
- Ana feed
- Keşfet sayfası
- Kamera
- Bildirimler
- Profil

## 6. Veritabanı Şeması

### 6.1 Ana Tablolar
- users (kullanıcı bilgileri)
- posts (gönderiler)
- comments (yorumlar)
- likes (beğeniler)
- follows (takip ilişkileri)
- notifications (bildirimler)

## 7. API Endpoints

### 7.1 Kimlik Doğrulama
- POST /auth/register
- POST /auth/login
- POST /auth/logout

### 7.2 Kullanıcı İşlemleri
- GET /users/profile
- PUT /users/profile
- GET /users/{id}/posts

### 7.3 Gönderi İşlemleri
- POST /posts
- GET /posts/feed
- GET /posts/{id}
- DELETE /posts/{id}

### 7.4 Sosyal İşlemler
- POST /posts/{id}/like
- DELETE /posts/{id}/like
- POST /posts/{id}/comments
- POST /users/{id}/follow

## 8. Geliştirme Fazları

### Faz 1 (MVP - 4 hafta)
- Temel kimlik doğrulama
- Basit profil yönetimi
- Fotoğraf paylaşma
- Temel feed

### Faz 2 (4 hafta)
- Beğeni ve yorum sistemi
- Takip sistemi
- Arama özelliği

### Faz 3 (3 hafta)
- Bildirimler
- Keşfet sayfası
- Video desteği

### Faz 4 (2 hafta)
- Optimizasyon
- Bug fixes
- Final testing

## 9. Test Stratejisi
- Unit testler
- Widget testler
- Integration testler
- User acceptance testing

## 10. Deployment
- iOS App Store
- Google Play Store
- Supabase production environment

## 11. Monitoring ve Analytics
- Crash reporting
- User analytics
- Performance monitoring
- Error tracking

## 12. Güvenlik ve Gizlilik
- GDPR uyumluluğu
- Veri şifreleme
- Güvenli API endpoints
- Kullanıcı gizlilik ayarları 