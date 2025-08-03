# Instagram Clone Backend API

## 🚀 Özellikler

- **RESTful API**: Express.js ile modern API tasarımı
- **PostgreSQL**: Güçlü ilişkisel veritabanı
- **JWT Authentication**: Güvenli kimlik doğrulama
- **File Upload**: Cloudinary entegrasyonu
- **Rate Limiting**: API güvenliği
- **Input Validation**: Joi ile veri doğrulama
- **Error Handling**: Kapsamlı hata yönetimi

## 📁 Proje Yapısı

```
backend/
├── src/
│   ├── config/
│   │   ├── database.js      # PostgreSQL bağlantısı
│   │   └── migrate.js       # Veritabanı migration
│   ├── controllers/         # İş mantığı
│   ├── middleware/
│   │   └── auth.js          # JWT authentication
│   ├── models/              # Veritabanı modelleri
│   ├── routes/
│   │   └── auth.js          # Authentication routes
│   ├── utils/               # Yardımcı fonksiyonlar
│   └── app.js               # Ana uygulama dosyası
├── .env.example             # Environment variables örneği
├── package.json             # NPM bağımlılıkları
└── README.md                # Bu dosya
```

## 🛠️ Kurulum

### 1. Bağımlılıkları Yükle
```bash
cd backend
npm install
```

### 2. Environment Variables
```bash
cp .env.example .env
# .env dosyasını düzenle
```

### 3. PostgreSQL Kurulumu
```bash
# PostgreSQL'i yükle ve çalıştır
# Veritabanı oluştur
createdb instagram_clone
```

### 4. Veritabanı Migration
```bash
npm run migrate
```

### 5. Sunucuyu Başlat
```bash
# Development
npm run dev

# Production
npm start
```

## 📡 API Endpoints

### Authentication
- `POST /api/auth/register` - Kullanıcı kaydı
- `POST /api/auth/login` - Giriş yapma
- `POST /api/auth/forgot-password` - Şifre sıfırlama
- `POST /api/auth/verify-email` - Email doğrulama

### Users
- `GET /api/users/:id` - Kullanıcı profili
- `PUT /api/users/:id` - Profil güncelleme
- `GET /api/users/:id/followers` - Takipçiler
- `GET /api/users/:id/following` - Takip edilenler

### Posts
- `GET /api/posts/feed` - Ana akış
- `POST /api/posts` - Post oluşturma
- `GET /api/posts/:id` - Post detayı
- `PUT /api/posts/:id` - Post güncelleme
- `DELETE /api/posts/:id` - Post silme

### Comments
- `GET /api/comments/:postId` - Post yorumları
- `POST /api/comments` - Yorum ekleme
- `DELETE /api/comments/:id` - Yorum silme

### Likes
- `POST /api/likes` - Beğeni ekleme
- `DELETE /api/likes/:id` - Beğeni kaldırma

### Follows
- `POST /api/follows` - Takip etme
- `DELETE /api/follows/:id` - Takibi bırakma

### Stories
- `GET /api/stories` - Hikayeler
- `POST /api/stories` - Hikaye oluşturma
- `DELETE /api/stories/:id` - Hikaye silme

### Messages
- `GET /api/conversations` - Konuşmalar
- `POST /api/messages` - Mesaj gönderme
- `GET /api/conversations/:id/messages` - Mesajlar

### Search
- `GET /api/search/users` - Kullanıcı arama
- `GET /api/search/posts` - Post arama
- `GET /api/search/hashtags` - Hashtag arama

### Upload
- `POST /api/upload` - Medya yükleme

## 🔐 Authentication

API, JWT (JSON Web Token) kullanarak kimlik doğrulama yapar.

### Token Kullanımı
```javascript
// Header'da token gönderme
Authorization: Bearer YOUR_JWT_TOKEN
```

### Token Alma
```javascript
// Login response
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "johndoe",
    "email": "john@example.com"
  }
}
```

## 🗄️ Veritabanı Şeması

### Ana Tablolar
- **users**: Kullanıcı bilgileri
- **posts**: Gönderiler
- **comments**: Yorumlar
- **likes**: Beğeniler
- **follows**: Takip ilişkileri
- **stories**: Hikayeler
- **messages**: Mesajlar
- **notifications**: Bildirimler
- **hashtags**: Hashtag'ler

## 🛡️ Güvenlik

- **Helmet**: HTTP header güvenliği
- **CORS**: Cross-origin resource sharing
- **Rate Limiting**: API kötüye kullanım koruması
- **Input Validation**: Joi ile veri doğrulama
- **Password Hashing**: bcrypt ile şifre hashleme
- **JWT**: Güvenli token tabanlı authentication

## 📊 Performans

- **Connection Pooling**: PostgreSQL bağlantı havuzu
- **Compression**: Gzip sıkıştırma
- **Caching**: Response caching stratejisi
- **Indexing**: Veritabanı performans indeksleri

## 🧪 Testing

```bash
# Test çalıştırma
npm test

# Test coverage
npm run test:coverage
```

## 📝 Logging

- **Morgan**: HTTP request logging
- **Console**: Development logging
- **File**: Production log dosyaları

## 🚀 Deployment

### Environment Variables (Production)
```bash
NODE_ENV=production
PORT=3000
DB_HOST=your_db_host
DB_NAME=your_db_name
DB_USER=your_db_user
DB_PASSWORD=your_db_password
JWT_SECRET=your_super_secret_key
CLOUDINARY_CLOUD_NAME=your_cloud_name
```

### Docker (Opsiyonel)
```bash
# Docker image oluşturma
docker build -t instagram-backend .

# Container çalıştırma
docker run -p 3000:3000 instagram-backend
```

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit yapın (`git commit -m 'Add amazing feature'`)
4. Push yapın (`git push origin feature/amazing-feature`)
5. Pull Request açın

## 📄 Lisans

MIT License - Detaylar için [LICENSE](LICENSE) dosyasına bakın.