# Teknik PRD - InstaClone (App)

## 1. Mimari Tasarım

### 1.1 Genel Mimari
```
┌───────────────┐    HTTP    ┌────────────────────┐    ┌───────────────┐
│  Flutter App  │◄──────────►│  Backend (API)     │◄──►│  PostgreSQL   │
│  (insta_app)  │   REST     │  (insta_backend)   │    │  (Supabase)   │
└───────────────┘            └────────────────────┘    └───────────────┘
```

### 1.2 Flutter Proje Yapısı
```
insta_app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── utils/
│   │   ├── services/
│   │   └── widgets/
│   ├── features/
│   │   ├── auth/
│   │   ├── home/
│   │   ├── profile/
│   │   ├── camera/
│   │   ├── search/
│   │   └── notifications/
│   ├── models/
│   ├── repositories/
│   └── providers/
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
├── test/
└── pubspec.yaml
```

### 1.3 API İletişimi
- Tüm backend ile iletişim REST API üzerinden sağlanacak.
- Supabase ile ilgili herhangi bir Flutter paketi kullanılmayacak.
- HTTP istekleri için `http`, `dio` veya benzeri bir paket kullanılabilir.
- API endpointleri backend tarafından sağlanacak.

### 1.4 State Management
- Provider, Riverpod veya Bloc kullanılabilir.
- Tüm veri akışı API üzerinden olacak.

### 1.5 Model Sınıfları
- User
- Post
- Comment
- Like
- Notification
- Follow

### 1.6 Güvenlik
- API token ile kimlik doğrulama
- HTTPS üzerinden iletişim

### 1.7 Test Stratejisi
- Unit testler
- Widget testler
- Integration testler

### 1.8 Ortam Değişkenleri
```
API_BASE_URL=https://api.example.com
```

### 1.9 Bağımlılıklar
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  provider: ^6.0.5
  image_picker: ^1.0.0
  cached_network_image: ^3.3.0
  go_router: ^10.0.0
  flutter_staggered_grid_view: ^0.7.0
  video_player: ^2.7.0
  permission_handler: ^10.4.0
``` 