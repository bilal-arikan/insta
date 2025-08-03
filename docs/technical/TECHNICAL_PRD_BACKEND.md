# Teknik PRD - InstaClone (Backend)

## 1. Mimari Tasarım

### 1.1 Genel Mimari
```
┌────────────────────┐    ┌───────────────┐
│  Backend (API)     │    │  PostgreSQL   │
│  (insta_backend)   │◄──►│  (Supabase)   │
└────────────────────┘    └───────────────┘
```

### 1.2 Backend Proje Yapısı
```
insta_backend/
├── supabase/
│   ├── migrations/
│   ├── functions/
│   ├── policies/
│   └── config/
├── docs/
└── README.md
```

## 2. Veritabanı Şeması

### 2.1 Users Tablosu
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR UNIQUE NOT NULL,
  username VARCHAR UNIQUE NOT NULL,
  full_name VARCHAR,
  bio TEXT,
  avatar_url VARCHAR,
  website VARCHAR,
  phone VARCHAR,
  is_verified BOOLEAN DEFAULT FALSE,
  is_private BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 2.2 Posts Tablosu
```sql
CREATE TABLE posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  caption TEXT,
  media_urls TEXT[],
  media_type VARCHAR CHECK (media_type IN ('image', 'video')),
  location VARCHAR,
  hashtags TEXT[],
  is_public BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 2.3 Comments Tablosu
```sql
CREATE TABLE comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  parent_id UUID REFERENCES comments(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 2.4 Likes Tablosu
```sql
CREATE TABLE likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(post_id, user_id)
);
```

### 2.5 Follows Tablosu
```sql
CREATE TABLE follows (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  follower_id UUID REFERENCES users(id) ON DELETE CASCADE,
  following_id UUID REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(follower_id, following_id)
);
```

### 2.6 Notifications Tablosu
```sql
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  from_user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  type VARCHAR CHECK (type IN ('like', 'comment', 'follow', 'mention')),
  content TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## 3. API Endpoints

### 3.1 Kimlik Doğrulama
- POST /auth/register
- POST /auth/login
- POST /auth/logout

### 3.2 Kullanıcı İşlemleri
- GET /users/profile
- PUT /users/profile
- GET /users/{id}/posts

### 3.3 Gönderi İşlemleri
- POST /posts
- GET /posts/feed
- GET /posts/{id}
- DELETE /posts/{id}

### 3.4 Sosyal İşlemler
- POST /posts/{id}/like
- DELETE /posts/{id}/like
- POST /posts/{id}/comments
- POST /users/{id}/follow

## 4. Supabase Fonksiyonları ve Güvenlik
- Row Level Security (RLS) ve policy tanımları
- Storage bucket yönetimi (avatars, posts, stories)
- Edge Functions ile özel işlevler (örn. medya işleme)

## 5. Test ve Deployment
- API testleri
- Migration ve fonksiyon testleri
- Supabase production ortamına deployment 