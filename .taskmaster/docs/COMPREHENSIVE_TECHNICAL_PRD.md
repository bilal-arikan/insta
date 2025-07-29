# Instagram Uygulaması - Kapsamlı Teknik PRD

## 📋 İçindekiler
1. [Proje Genel Bakış](#1-proje-genel-bakış)
2. [Sistem Mimarisi](#2-sistem-mimarisi)
3. [Teknoloji Stack](#3-teknoloji-stack)
4. [Veritabanı Tasarımı](#4-veritabanı-tasarımı)
5. [API Spesifikasyonu](#5-api-spesifikasyonu)
6. [Frontend Mimarisi](#6-frontend-mimarisi)
7. [Güvenlik Gereksinimleri](#7-güvenlik-gereksinimleri)
8. [Performans Gereksinimleri](#8-performans-gereksinimleri)
9. [Test Stratejisi](#9-test-stratejisi)
10. [Deployment ve DevOps](#10-deployment-ve-devops)
11. [Monitoring ve Analytics](#11-monitoring-ve-analytics)
12. [Skalabilite Planı](#12-skalabilite-planı)

---

## 1. Proje Genel Bakış

### 1.1 Proje Tanımı
**InstaClone** - Instagram benzeri sosyal medya mobil uygulaması

### 1.2 Teknik Hedefler
- **Performans**: 60 FPS smooth UI, <2s yükleme süreleri
- **Skalabilite**: 100K+ eşzamanlı kullanıcı desteği
- **Güvenilirlik**: %99.9 uptime, otomatik failover
- **Güvenlik**: End-to-end encryption, GDPR compliance

### 1.3 Platform Desteği
- **Mobil**: iOS 12+, Android 8+ (API 26+)
- **Web**: Chrome 90+, Safari 14+, Firefox 88+
- **Desktop**: Windows 10+, macOS 10.15+, Linux Ubuntu 20+

---

## 2. Sistem Mimarisi

### 2.1 Genel Mimari Diyagramı
```
┌─────────────────┐    HTTPS/WSS    ┌──────────────────┐    ┌─────────────────┐
│   Flutter App   │◄───────────────►│   Supabase API   │◄──►│   PostgreSQL    │
│   (Frontend)    │   REST/GraphQL   │   (Backend)      │    │   (Database)    │
└─────────────────┘                  └──────────────────┘    └─────────────────┘
         │                                    │                        │
         │                                    │                        │
         ▼                                    ▼                        ▼
┌─────────────────┐                  ┌──────────────────┐    ┌─────────────────┐
│   Push Notif.   │                  │   File Storage   │    │     Redis       │
│   (FCM/APNs)    │                  │   (Supabase)     │    │    (Cache)      │
└─────────────────┘                  └──────────────────┘    └─────────────────┘
```

### 2.2 Mikroservis Mimarisi
```
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│   Auth Service  │  │  Media Service  │  │  Social Service │
│   - Login/Reg   │  │  - Upload/Proc  │  │  - Follow/Like  │
│   - JWT Token   │  │  - Compression  │  │  - Comments     │
└─────────────────┘  └─────────────────┘  └─────────────────┘
         │                    │                    │
         └────────────────────┼────────────────────┘
                              │
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│  Notif Service  │  │  Search Service │  │ Analytics Serv. │
│  - Push Notif   │  │  - Elasticsearch│  │  - User Events  │
│  - Real-time    │  │  - Indexing     │  │  - Metrics      │
└─────────────────┘  └─────────────────┘  └─────────────────┘
```

### 2.3 Veri Akış Diyagramı
```
User Action → Frontend → API Gateway → Microservice → Database
     ↓              ↓           ↓            ↓           ↓
 Analytics ← Cache ← Event Bus ← Queue ← Validation ← Auth
```

---

## 3. Teknoloji Stack

### 3.1 Frontend Stack
```yaml
Framework: Flutter 3.32+
Language: Dart 3.8+
State Management: Riverpod 2.0+
Routing: GoRouter 10.0+
HTTP Client: Dio 5.0+
Local Storage: Hive 4.0+
Image Processing: image 4.0+
Video Player: video_player 2.7+
Camera: camera 0.10+
Permissions: permission_handler 10.4+
Push Notifications: firebase_messaging 14.0+
Crash Reporting: firebase_crashlytics 3.4+
Analytics: firebase_analytics 10.7+
```

### 3.2 Backend Stack
```yaml
Platform: Supabase
Database: PostgreSQL 15+
Auth: Supabase Auth (JWT)
Storage: Supabase Storage
Realtime: Supabase Realtime
Edge Functions: Deno Runtime
CDN: Supabase CDN
Search: PostgreSQL Full-Text Search
Queue: pg_cron + pg_net
Monitoring: Supabase Dashboard
```

### 3.3 DevOps Stack
```yaml
CI/CD: GitHub Actions
Containerization: Docker
Orchestration: Kubernetes
Monitoring: Prometheus + Grafana
Logging: ELK Stack
Error Tracking: Sentry
Load Testing: K6
Security Scanning: Snyk
```

---

## 4. Veritabanı Tasarımı

### 4.1 Veri Modeli ERD
```sql
-- Users Table (Kullanıcılar)
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  username VARCHAR(50) UNIQUE NOT NULL,
  full_name VARCHAR(100),
  bio TEXT,
  avatar_url TEXT,
  website VARCHAR(255),
  phone VARCHAR(20),
  birth_date DATE,
  gender VARCHAR(20),
  is_verified BOOLEAN DEFAULT FALSE,
  is_private BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  last_seen TIMESTAMP WITH TIME ZONE,
  followers_count INTEGER DEFAULT 0,
  following_count INTEGER DEFAULT 0,
  posts_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Posts Table (Gönderiler)
CREATE TABLE posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  caption TEXT,
  media_urls JSONB NOT NULL, -- [{"url": "", "type": "image/video", "thumbnail": ""}]
  location JSONB, -- {"name": "", "lat": 0, "lng": 0}
  hashtags TEXT[],
  mentions UUID[], -- user_ids
  is_public BOOLEAN DEFAULT TRUE,
  comments_enabled BOOLEAN DEFAULT TRUE,
  likes_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  shares_count INTEGER DEFAULT 0,
  views_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Comments Table (Yorumlar)
CREATE TABLE comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  parent_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  mentions UUID[],
  likes_count INTEGER DEFAULT 0,
  replies_count INTEGER DEFAULT 0,
  is_pinned BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Likes Table (Beğeniler)
CREATE TABLE likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  target_id UUID NOT NULL, -- post_id or comment_id
  target_type VARCHAR(20) NOT NULL CHECK (target_type IN ('post', 'comment')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, target_id, target_type)
);

-- Follows Table (Takip İlişkileri)
CREATE TABLE follows (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  follower_id UUID REFERENCES users(id) ON DELETE CASCADE,
  following_id UUID REFERENCES users(id) ON DELETE CASCADE,
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'pending', 'blocked')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(follower_id, following_id)
);

-- Stories Table (Hikayeler)
CREATE TABLE stories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  media_url TEXT NOT NULL,
  media_type VARCHAR(10) CHECK (media_type IN ('image', 'video')),
  duration INTEGER DEFAULT 15, -- seconds
  views_count INTEGER DEFAULT 0,
  expires_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() + INTERVAL '24 hours'),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notifications Table (Bildirimler)
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  from_user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  target_id UUID, -- post_id, comment_id, etc.
  target_type VARCHAR(20), -- 'post', 'comment', 'follow', etc.
  type VARCHAR(30) NOT NULL CHECK (type IN (
    'like_post', 'like_comment', 'comment_post', 'comment_reply',
    'follow_request', 'follow_accept', 'mention_post', 'mention_comment',
    'story_view', 'post_share'
  )),
  title VARCHAR(255),
  content TEXT,
  data JSONB, -- additional data
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Messages Table (Mesajlar)
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL,
  sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
  content TEXT,
  media_url TEXT,
  media_type VARCHAR(20),
  message_type VARCHAR(20) DEFAULT 'text' CHECK (message_type IN (
    'text', 'image', 'video', 'audio', 'file', 'post_share', 'story_share'
  )),
  reply_to_id UUID REFERENCES messages(id),
  is_read BOOLEAN DEFAULT FALSE,
  is_deleted BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Conversations Table (Sohbetler)
CREATE TABLE conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type VARCHAR(20) DEFAULT 'direct' CHECK (type IN ('direct', 'group')),
  name VARCHAR(100), -- for group chats
  avatar_url TEXT, -- for group chats
  participants UUID[] NOT NULL,
  last_message_id UUID REFERENCES messages(id),
  last_activity TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 4.2 İndeksler ve Optimizasyon
```sql
-- Performance Indexes
CREATE INDEX idx_posts_user_created ON posts(user_id, created_at DESC);
CREATE INDEX idx_posts_hashtags ON posts USING GIN(hashtags);
CREATE INDEX idx_posts_location ON posts USING GIN(location);
CREATE INDEX idx_comments_post_created ON comments(post_id, created_at DESC);
CREATE INDEX idx_likes_target ON likes(target_id, target_type);
CREATE INDEX idx_follows_follower ON follows(follower_id, status);
CREATE INDEX idx_follows_following ON follows(following_id, status);
CREATE INDEX idx_notifications_user_created ON notifications(user_id, created_at DESC);
CREATE INDEX idx_messages_conversation_created ON messages(conversation_id, created_at DESC);
CREATE INDEX idx_stories_user_expires ON stories(user_id, expires_at);

-- Full-text Search Indexes
CREATE INDEX idx_users_search ON users USING GIN(to_tsvector('english', username || ' ' || full_name));
CREATE INDEX idx_posts_search ON posts USING GIN(to_tsvector('english', caption));
```

### 4.3 Triggers ve Functions
```sql
-- Update counters trigger
CREATE OR REPLACE FUNCTION update_counters()
RETURNS TRIGGER AS $$
BEGIN
  -- Update posts count
  IF TG_TABLE_NAME = 'posts' THEN
    IF TG_OP = 'INSERT' THEN
      UPDATE users SET posts_count = posts_count + 1 WHERE id = NEW.user_id;
    ELSIF TG_OP = 'DELETE' THEN
      UPDATE users SET posts_count = posts_count - 1 WHERE id = OLD.user_id;
    END IF;
  END IF;
  
  -- Update likes count
  IF TG_TABLE_NAME = 'likes' THEN
    IF TG_OP = 'INSERT' THEN
      IF NEW.target_type = 'post' THEN
        UPDATE posts SET likes_count = likes_count + 1 WHERE id = NEW.target_id;
      ELSIF NEW.target_type = 'comment' THEN
        UPDATE comments SET likes_count = likes_count + 1 WHERE id = NEW.target_id;
      END IF;
    ELSIF TG_OP = 'DELETE' THEN
      IF OLD.target_type = 'post' THEN
        UPDATE posts SET likes_count = likes_count - 1 WHERE id = OLD.target_id;
      ELSIF OLD.target_type = 'comment' THEN
        UPDATE comments SET likes_count = likes_count - 1 WHERE id = OLD.target_id;
      END IF;
    END IF;
  END IF;
  
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Create triggers
CREATE TRIGGER posts_counter_trigger
  AFTER INSERT OR DELETE ON posts
  FOR EACH ROW EXECUTE FUNCTION update_counters();

CREATE TRIGGER likes_counter_trigger
  AFTER INSERT OR DELETE ON likes
  FOR EACH ROW EXECUTE FUNCTION update_counters();
```

---

## 5. API Spesifikasyonu

### 5.1 Authentication Endpoints
```yaml
# User Registration
POST /auth/register
Content-Type: application/json
Body:
  email: string (required)
  username: string (required, 3-30 chars, alphanumeric + underscore)
  password: string (required, min 8 chars)
  full_name: string (optional)
Response: 201
  user: User object
  access_token: string (JWT)
  refresh_token: string

# User Login
POST /auth/login
Content-Type: application/json
Body:
  email_or_username: string (required)
  password: string (required)
Response: 200
  user: User object
  access_token: string (JWT)
  refresh_token: string

# Token Refresh
POST /auth/refresh
Content-Type: application/json
Body:
  refresh_token: string (required)
Response: 200
  access_token: string (JWT)
  refresh_token: string

# Logout
POST /auth/logout
Authorization: Bearer {access_token}
Response: 200
  message: "Logged out successfully"

# Password Reset
POST /auth/forgot-password
Content-Type: application/json
Body:
  email: string (required)
Response: 200
  message: "Reset email sent"
```

### 5.2 User Management Endpoints
```yaml
# Get Current User Profile
GET /users/me
Authorization: Bearer {access_token}
Response: 200
  user: User object with private fields

# Update User Profile
PUT /users/me
Authorization: Bearer {access_token}
Content-Type: application/json
Body:
  full_name: string (optional)
  bio: string (optional, max 150 chars)
  website: string (optional)
  phone: string (optional)
  is_private: boolean (optional)
Response: 200
  user: Updated User object

# Upload Avatar
POST /users/me/avatar
Authorization: Bearer {access_token}
Content-Type: multipart/form-data
Body:
  avatar: file (required, max 5MB, jpg/png)
Response: 200
  avatar_url: string

# Get User Profile by ID
GET /users/{user_id}
Authorization: Bearer {access_token}
Response: 200
  user: User object (public fields only if private account)

# Search Users
GET /users/search?q={query}&limit={limit}&offset={offset}
Authorization: Bearer {access_token}
Query Parameters:
  q: string (required, min 2 chars)
  limit: integer (optional, default 20, max 50)
  offset: integer (optional, default 0)
Response: 200
  users: User[] array
  total: integer
  has_more: boolean
```

### 5.3 Posts Endpoints
```yaml
# Create Post
POST /posts
Authorization: Bearer {access_token}
Content-Type: multipart/form-data
Body:
  media: file[] (required, max 10 files, max 50MB each)
  caption: string (optional, max 2200 chars)
  location: string (optional, JSON format)
  hashtags: string[] (optional, max 30)
  mentions: string[] (optional, usernames)
Response: 201
  post: Post object

# Get Feed
GET /posts/feed?limit={limit}&cursor={cursor}
Authorization: Bearer {access_token}
Query Parameters:
  limit: integer (optional, default 20, max 50)
  cursor: string (optional, for pagination)
Response: 200
  posts: Post[] array with user and interaction data
  next_cursor: string (null if no more)

# Get Post by ID
GET /posts/{post_id}
Authorization: Bearer {access_token}
Response: 200
  post: Post object with user and interaction data

# Get User Posts
GET /users/{user_id}/posts?limit={limit}&cursor={cursor}
Authorization: Bearer {access_token}
Query Parameters:
  limit: integer (optional, default 20, max 50)
  cursor: string (optional, for pagination)
Response: 200
  posts: Post[] array
  next_cursor: string (null if no more)

# Delete Post
DELETE /posts/{post_id}
Authorization: Bearer {access_token}
Response: 200
  message: "Post deleted successfully"

# Like/Unlike Post
POST /posts/{post_id}/like
Authorization: Bearer {access_token}
Response: 200
  liked: boolean
  likes_count: integer

# Get Post Likes
GET /posts/{post_id}/likes?limit={limit}&offset={offset}
Authorization: Bearer {access_token}
Query Parameters:
  limit: integer (optional, default 20, max 50)
  offset: integer (optional, default 0)
Response: 200
  users: User[] array
  total: integer
```

### 5.4 Comments Endpoints
```yaml
# Add Comment
POST /posts/{post_id}/comments
Authorization: Bearer {access_token}
Content-Type: application/json
Body:
  content: string (required, max 500 chars)
  parent_id: string (optional, for replies)
  mentions: string[] (optional, usernames)
Response: 201
  comment: Comment object with user data

# Get Comments
GET /posts/{post_id}/comments?limit={limit}&offset={offset}
Authorization: Bearer {access_token}
Query Parameters:
  limit: integer (optional, default 20, max 50)
  offset: integer (optional, default 0)
Response: 200
  comments: Comment[] array with user and reply data
  total: integer

# Delete Comment
DELETE /comments/{comment_id}
Authorization: Bearer {access_token}
Response: 200
  message: "Comment deleted successfully"

# Like/Unlike Comment
POST /comments/{comment_id}/like
Authorization: Bearer {access_token}
Response: 200
  liked: boolean
  likes_count: integer
```

### 5.5 Social Endpoints
```yaml
# Follow/Unfollow User
POST /users/{user_id}/follow
Authorization: Bearer {access_token}
Response: 200
  following: boolean
  status: string ("active" | "pending")

# Get Followers
GET /users/{user_id}/followers?limit={limit}&offset={offset}
Authorization: Bearer {access_token}
Query Parameters:
  limit: integer (optional, default 20, max 50)
  offset: integer (optional, default 0)
Response: 200
  users: User[] array
  total: integer

# Get Following
GET /users/{user_id}/following?limit={limit}&offset={offset}
Authorization: Bearer {access_token}
Query Parameters:
  limit: integer (optional, default 20, max 50)
  offset: integer (optional, default 0)
Response: 200
  users: User[] array
  total: integer

# Get Follow Requests (for private accounts)
GET /users/me/follow-requests?limit={limit}&offset={offset}
Authorization: Bearer {access_token}
Query Parameters:
  limit: integer (optional, default 20, max 50)
  offset: integer (optional, default 0)
Response: 200
  users: User[] array
  total: integer

# Accept/Reject Follow Request
POST /users/me/follow-requests/{user_id}/respond
Authorization: Bearer {access_token}
Content-Type: application/json
Body:
  action: string (required, "accept" | "reject")
Response: 200
  message: string
```

### 5.6 Stories Endpoints
```yaml
# Create Story
POST /stories
Authorization: Bearer {access_token}
Content-Type: multipart/form-data
Body:
  media: file (required, max 50MB, image/video)
  duration: integer (optional, default 15, max 30 for video)
Response: 201
  story: Story object

# Get Stories Feed
GET /stories/feed
Authorization: Bearer {access_token}
Response: 200
  stories: Story[] array grouped by user

# Get User Stories
GET /users/{user_id}/stories
Authorization: Bearer {access_token}
Response: 200
  stories: Story[] array

# Mark Story as Viewed
POST /stories/{story_id}/view
Authorization: Bearer {access_token}
Response: 200
  message: "Story viewed"

# Delete Story
DELETE /stories/{story_id}
Authorization: Bearer {access_token}
Response: 200
  message: "Story deleted successfully"
```

### 5.7 Notifications Endpoints
```yaml
# Get Notifications
GET /notifications?limit={limit}&offset={offset}
Authorization: Bearer {access_token}
Query Parameters:
  limit: integer (optional, default 20, max 50)
  offset: integer (optional, default 0)
Response: 200
  notifications: Notification[] array with user data
  unread_count: integer

# Mark Notifications as Read
POST /notifications/mark-read
Authorization: Bearer {access_token}
Content-Type: application/json
Body:
  notification_ids: string[] (optional, if empty marks all as read)
Response: 200
  message: "Notifications marked as read"

# Get Notification Settings
GET /notifications/settings
Authorization: Bearer {access_token}
Response: 200
  settings: NotificationSettings object

# Update Notification Settings
PUT /notifications/settings
Authorization: Bearer {access_token}
Content-Type: application/json
Body:
  push_enabled: boolean (optional)
  email_enabled: boolean (optional)
  likes_enabled: boolean (optional)
  comments_enabled: boolean (optional)
  follows_enabled: boolean (optional)
Response: 200
  settings: Updated NotificationSettings object
```

### 5.8 Search Endpoints
```yaml
# Global Search
GET /search?q={query}&type={type}&limit={limit}&offset={offset}
Authorization: Bearer {access_token}
Query Parameters:
  q: string (required, min 2 chars)
  type: string (optional, "users" | "posts" | "hashtags", default "all")
  limit: integer (optional, default 20, max 50)
  offset: integer (optional, default 0)
Response: 200
  users: User[] array (if type is "users" or "all")
  posts: Post[] array (if type is "posts" or "all")
  hashtags: Hashtag[] array (if type is "hashtags" or "all")
  total: integer

# Get Trending Hashtags
GET /search/trending-hashtags?limit={limit}
Authorization: Bearer {access_token}
Query Parameters:
  limit: integer (optional, default 10, max 20)
Response: 200
  hashtags: Hashtag[] array with post counts

# Get Explore Posts
GET /explore?limit={limit}&cursor={cursor}
Authorization: Bearer {access_token}
Query Parameters:
  limit: integer (optional, default 20, max 50)
  cursor: string (optional, for pagination)
Response: 200
  posts: Post[] array
  next_cursor: string (null if no more)
```

---

## 6. Frontend Mimarisi

### 6.1 Proje Yapısı
```
insta_app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── app.dart                     # App configuration
│   ├── core/                        # Core utilities
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── api_constants.dart
│   │   │   └── ui_constants.dart
│   │   ├── utils/
│   │   │   ├── date_utils.dart
│   │   │   ├── image_utils.dart
│   │   │   ├── validation_utils.dart
│   │   │   └── network_utils.dart
│   │   ├── services/
│   │   │   ├── api_service.dart
│   │   │   ├── auth_service.dart
│   │   │   ├── storage_service.dart
│   │   │   ├── notification_service.dart
│   │   │   └── analytics_service.dart
│   │   ├── widgets/
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   ├── loading_widget.dart
│   │   │   ├── error_widget.dart
│   │   │   └── image_widget.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── colors.dart
│   │   │   └── text_styles.dart
│   │   └── extensions/
│   │       ├── context_extensions.dart
│   │       ├── string_extensions.dart
│   │       └── widget_extensions.dart
│   ├── features/                    # Feature modules
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── user_model.dart
│   │   │   │   │   └── auth_response_model.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── datasources/
│   │   │   │       └── auth_remote_datasource.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository_interface.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── login_usecase.dart
│   │   │   │       ├── register_usecase.dart
│   │   │   │       └── logout_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── auth_provider.dart
│   │   │       ├── pages/
│   │   │       │   ├── login_page.dart
│   │   │       │   ├── register_page.dart
│   │   │       │   └── forgot_password_page.dart
│   │   │       └── widgets/
│   │   │           ├── login_form.dart
│   │   │           └── register_form.dart
│   │   ├── home/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── profile/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── camera/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── search/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── notifications/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── messages/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   └── stories/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   ├── shared/                      # Shared components
│   │   ├── models/
│   │   ├── widgets/
│   │   └── providers/
│   └── config/                      # App configuration
│       ├── routes.dart
│       ├── environment.dart
│       └── dependency_injection.dart
├── assets/                          # Static assets
│   ├── images/
│   ├── icons/
│   ├── fonts/
│   └── animations/
├── test/                           # Tests
│   ├── unit/
│   ├── widget/
│   └── integration/
└── pubspec.yaml                    # Dependencies
```

### 6.2 State Management (Riverpod)
```dart
// Auth Provider Example
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<User?> build() {
    return const AsyncValue.loading();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(authRepositoryProvider).login(email, password);
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }
}

// Posts Provider Example
@riverpod
class PostsNotifier extends _$PostsNotifier {
  @override
  AsyncValue<List<Post>> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadFeed({bool refresh = false}) async {
    if (refresh) {
      state = const AsyncValue.loading();
    }
    
    try {
      final posts = await ref.read(postsRepositoryProvider).getFeed();
      state = AsyncValue.data(posts);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> likePost(String postId) async {
    final currentPosts = state.value ?? [];
    final updatedPosts = currentPosts.map((post) {
      if (post.id == postId) {
        return post.copyWith(
          isLiked: !post.isLiked,
          likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
        );
      }
      return post;
    }).toList();
    
    state = AsyncValue.data(updatedPosts);
    
    try {
      await ref.read(postsRepositoryProvider).likePost(postId);
    } catch (error) {
      // Revert optimistic update
      state = AsyncValue.data(currentPosts);
      rethrow;
    }
  }
}
```

### 6.3 Routing (GoRouter)
```dart
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.location == '/login' || state.location == '/register';
      
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }
      
      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchPage(),
          ),
          GoRoute(
            path: '/camera',
            builder: (context, state) => const CameraPage(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: '/post/:id',
        builder: (context, state) => PostDetailPage(
          postId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/user/:username',
        builder: (context, state) => UserProfilePage(
          username: state.pathParameters['username']!,
        ),
      ),
    ],
  );
});
```

### 6.4 API Service Implementation
```dart
class ApiService {
  final Dio _dio;
  final String _baseUrl;
  
  ApiService(this._baseUrl) : _dio = Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(ErrorInterceptor());
  }
  
  // Auth endpoints
  Future<AuthResponse> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email_or_username': email,
      'password': password,
    });
    return AuthResponse.fromJson(response.data);
  }
  
  Future<AuthResponse> register(String email, String username, String password) async {
    final response = await _dio.post('/auth/register', data: {
      'email': email,
      'username': username,
      'password': password,
    });
    return AuthResponse.fromJson(response.data);
  }
  
  // Posts endpoints
  Future<List<Post>> getFeed({String? cursor, int limit = 20}) async {
    final response = await _dio.get('/posts/feed', queryParameters: {
      if (cursor != null) 'cursor': cursor,
      'limit': limit,
    });
    return (response.data['posts'] as List)
        .map((json) => Post.fromJson(json))
        .toList();
  }
  
  Future<Post> createPost({
    required List<File> mediaFiles,
    String? caption,
    Map<String, dynamic>? location,
    List<String>? hashtags,
  }) async {
    final formData = FormData();
    
    for (int i = 0; i < mediaFiles.length; i++) {
      formData.files.add(MapEntry(
        'media',
        await MultipartFile.fromFile(
          mediaFiles[i].path,
          filename: 'media_$i.${mediaFiles[i].path.split('.').last}',
        ),
      ));
    }
    
    if (caption != null) formData.fields.add(MapEntry('caption', caption));
    if (location != null) formData.fields.add(MapEntry('location', jsonEncode(location)));
    if (hashtags != null) {
      for (final hashtag in hashtags) {
        formData.fields.add(MapEntry('hashtags[]', hashtag));
      }
    }
    
    final response = await _dio.post('/posts', data: formData);
    return Post.fromJson(response.data['post']);
  }
  
  Future<void> likePost(String postId) async {
    await _dio.post('/posts/$postId/like');
  }
  
  // User endpoints
  Future<User> getUserProfile(String userId) async {
    final response = await _dio.get('/users/$userId');
    return User.fromJson(response.data['user']);
  }
  
  Future<List<User>> searchUsers(String query, {int limit = 20, int offset = 0}) async {
    final response = await _dio.get('/users/search', queryParameters: {
      'q': query,
      'limit': limit,
      'offset': offset,
    });
    return (response.data['users'] as List)
        .map((json) => User.fromJson(json))
        .toList();
  }
}
```

---

## 7. Güvenlik Gereksinimleri

### 7.1 Authentication & Authorization
```yaml
JWT Token Security:
  - Access Token: 15 minutes expiry
  - Refresh Token: 30 days expiry
  - Token rotation on refresh
  - Secure storage (Keychain/Keystore)
  - Token blacklisting on logout

Password Security:
  - Minimum 8 characters
  - bcrypt hashing with salt rounds 12
  - Password strength validation
  - Rate limiting on login attempts
  - Account lockout after 5 failed attempts

Session Management:
  - Secure session cookies
  - CSRF protection
  - Session timeout
  - Concurrent session limits
```

### 7.2 Data Protection
```yaml
Encryption:
  - TLS 1.3 for data in transit
  - AES-256 for sensitive data at rest
  - End-to-end encryption for direct messages
  - File encryption for media uploads

Data Privacy:
  - GDPR compliance
  - Data anonymization
  - Right to be forgotten
  - Data export functionality
  - Privacy settings granular control

Input Validation:
  - Server-side validation
  - SQL injection prevention
  - XSS protection
  - File upload validation
  - Content sanitization
```

### 7.3 API Security
```yaml
Rate Limiting:
  - 100 requests/minute per user
  - 1000 requests/hour per IP
  - Exponential backoff
  - DDoS protection

API Security:
  - CORS configuration
  - API versioning
  - Request signing
  - IP whitelisting for admin
  - Audit logging

Content Security:
  - Media virus scanning
  - Content moderation AI
  - Spam detection
  - Inappropriate content filtering
  - User reporting system
```

### 7.4 Mobile Security
```yaml
App Security:
  - Certificate pinning
  - Root/jailbreak detection
  - App integrity verification
  - Obfuscation
  - Anti-debugging

Data Storage:
  - Encrypted local database
  - Secure keychain storage
  - No sensitive data in logs
  - Biometric authentication
  - Auto-lock functionality
```

---

## 8. Performans Gereksinimleri

### 8.1 Frontend Performance
```yaml
App Performance:
  - Cold start: <3 seconds
  - Hot start: <1 second
  - Frame rate: 60 FPS consistent
  - Memory usage: <200MB average
  - Battery optimization

UI Performance:
  - List scrolling: 60 FPS
  - Image loading: Progressive
  - Video playback: Smooth 30/60 FPS
  - Animations: 60 FPS
  - Touch response: <100ms

Network Performance:
  - API response: <500ms average
  - Image loading: <2 seconds
  - Video streaming: Adaptive bitrate
  - Offline support: Core features
  - Background sync
```

### 8.2 Backend Performance
```yaml
API Performance:
  - Response time: <200ms (95th percentile)
  - Throughput: 10,000 RPS
  - Concurrent users: 100,000+
  - Database queries: <50ms average
  - Cache hit ratio: >90%

Scalability:
  - Horizontal scaling
  - Load balancing
  - Auto-scaling
  - CDN integration
  - Database sharding

Resource Usage:
  - CPU usage: <70% average
  - Memory usage: <80% average
  - Disk I/O: Optimized
  - Network bandwidth: Efficient
```

### 8.3 Database Performance
```yaml
Query Performance:
  - Index optimization
  - Query execution: <50ms
  - Connection pooling
  - Read replicas
  - Caching strategy

Data Management:
  - Partitioning
  - Archiving old data
  - Backup strategy
  - Disaster recovery
  - Data compression
```

---

## 9. Test Stratejisi

### 9.1 Frontend Testing
```yaml
Unit Tests:
  - Coverage: >80%
  - Business logic testing
  - Utility functions
  - Model classes
  - Providers/State management

Widget Tests:
  - UI component testing
  - User interaction testing
  - Widget behavior
  - Accessibility testing
  - Visual regression testing

Integration Tests:
  - End-to-end workflows
  - API integration
  - Navigation testing
  - Performance testing
  - Device testing
```

### 9.2 Backend Testing
```yaml
API Tests:
  - Endpoint testing
  - Authentication testing
  - Authorization testing
  - Input validation
  - Error handling

Database Tests:
  - Query performance
  - Data integrity
  - Migration testing
  - Backup/restore
  - Concurrency testing

Load Tests:
  - Stress testing
  - Volume testing
  - Spike testing
  - Endurance testing
  - Scalability testing
```

### 9.3 Security Testing
```yaml
Security Tests:
  - Penetration testing
  - Vulnerability scanning
  - Authentication bypass
  - SQL injection testing
  - XSS testing

Compliance Tests:
  - GDPR compliance
  - Data protection
  - Privacy policy
  - Terms of service
  - Accessibility standards
```

---

## 10. Deployment ve DevOps

### 10.1 CI/CD Pipeline
```yaml
Continuous Integration:
  - Code quality checks
  - Automated testing
  - Security scanning
  - Dependency checking
  - Build automation

Continuous Deployment:
  - Staging deployment
  - Production deployment
  - Blue-green deployment
  - Rollback strategy
  - Feature flags

Environments:
  - Development
  - Testing
  - Staging
  - Production
  - Disaster recovery
```

### 10.2 Infrastructure
```yaml
Cloud Infrastructure:
  - Multi-region deployment
  - Load balancers
  - Auto-scaling groups
  - CDN distribution
  - Backup systems

Monitoring:
  - Application monitoring
  - Infrastructure monitoring
  - Log aggregation
  - Error tracking
  - Performance monitoring

Security:
  - Network security
  - Access control
  - Encryption
  - Compliance monitoring
  - Incident response
```

---

## 11. Monitoring ve Analytics

### 11.1 Application Monitoring
```yaml
Performance Metrics:
  - Response times
  - Error rates
  - Throughput
  - Resource usage
  - User experience

Business Metrics:
  - Daily active users
  - Monthly active users
  - User retention
  - Feature usage
  - Conversion rates

Technical Metrics:
  - API performance
  - Database performance
  - Cache hit rates
  - Error tracking
  - Security events
```

### 11.2 User Analytics
```yaml
User Behavior:
  - User journeys
  - Feature adoption
  - Session duration
  - Bounce rates
  - Engagement metrics

Content Analytics:
  - Post engagement
  - Popular content
  - Hashtag trends
  - User interactions
  - Content performance

Mobile Analytics:
  - App crashes
  - Performance issues
  - Device compatibility
  - OS version usage
  - Network conditions
```

---

## 12. Skalabilite Planı

### 12.1 Horizontal Scaling
```yaml
Application Scaling:
  - Microservices architecture
  - Load balancing
  - Auto-scaling
  - Container orchestration
  - Service mesh

Database Scaling:
  - Read replicas
  - Sharding strategy
  - Caching layers
  - Data partitioning
  - Archive strategy

Content Delivery:
  - CDN optimization
  - Image optimization
  - Video streaming
  - Edge computing
  - Global distribution
```

### 12.2 Performance Optimization
```yaml
Frontend Optimization:
  - Code splitting
  - Lazy loading
  - Image optimization
  - Caching strategy
  - Bundle optimization

Backend Optimization:
  - Query optimization
  - Caching strategy
  - Connection pooling
  - Resource optimization
  - Algorithm optimization

Infrastructure Optimization:
  - Resource allocation
  - Network optimization
  - Storage optimization
  - Monitoring optimization
  - Cost optimization
```

---

## 📚 Sonuç

Bu kapsamlı teknik PRD, Instagram benzeri sosyal medya uygulamasının tüm teknik yönlerini detaylandırmaktadır. Dokümanda yer alan:

- **Sistem mimarisi** ve teknoloji seçimleri
- **Veritabanı tasarımı** ve optimizasyonları
- **API spesifikasyonları** ve güvenlik önlemleri
- **Frontend mimarisi** ve state management
- **Performans gereksinimleri** ve skalabilite planı
- **Test stratejisi** ve kalite güvencesi
- **DevOps** ve deployment süreçleri

Bu dokümana göre geliştirilen uygulama, modern yazılım geliştirme standartlarına uygun, güvenli, performanslı ve skalabilir bir sosyal medya platformu olacaktır.

### Geliştirme Süreci
1. **Faz 1**: Temel altyapı ve authentication (4 hafta)
2. **Faz 2**: Core features (posts, likes, comments) (6 hafta)
3. **Faz 3**: Social features (follow, feed) (4 hafta)
4. **Faz 4**: Advanced features (stories, messages) (6 hafta)
5. **Faz 5**: Optimization ve production (4 hafta)

**Toplam Geliştirme Süresi**: 24 hafta (6 ay)

---

*Bu dokümanda belirtilen tüm teknik detaylar, en iyi pratikler ve endüstri standartları göz önünde bulundurularak hazırlanmıştır.*