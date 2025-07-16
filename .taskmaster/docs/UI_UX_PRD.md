# UI/UX PRD - InstaClone

## 1. Tasarım Sistemi

### 1.1 Renk Paleti
```dart
// Ana Renkler
primary: #405DE6 (Instagram Blue)
secondary: #5851DB
accent: #833AB4
success: #4CAF50
error: #F44336
warning: #FF9800

// Nötr Renkler
background: #FFFFFF
surface: #F8F9FA
text_primary: #262626
text_secondary: #8E8E93
border: #DBDBDB
divider: #EFEFEF

// Dark Mode
background_dark: #000000
surface_dark: #121212
text_primary_dark: #FFFFFF
text_secondary_dark: #8E8E93
```

### 1.2 Tipografi
```dart
// Font Ailesi
fontFamily: 'SF Pro Display' // iOS
fontFamily: 'Roboto' // Android

// Font Boyutları
displayLarge: 32px
displayMedium: 28px
displaySmall: 24px
headlineLarge: 22px
headlineMedium: 20px
headlineSmall: 18px
titleLarge: 16px
titleMedium: 14px
titleSmall: 12px
bodyLarge: 16px
bodyMedium: 14px
bodySmall: 12px
caption: 10px
```

### 1.3 Spacing Sistemi
```dart
// Spacing Değerleri
xs: 4px
sm: 8px
md: 16px
lg: 24px
xl: 32px
xxl: 48px
```

### 1.4 Border Radius
```dart
// Border Radius Değerleri
xs: 4px
sm: 8px
md: 12px
lg: 16px
xl: 24px
full: 999px
```

## 2. Ekran Tasarımları

### 2.1 Splash Screen
```
┌─────────────────────────┐
│                         │
│                         │
│                         │
│        [LOGO]           │
│                         │
│     InstaClone          │
│                         │
│                         │
│                         │
└─────────────────────────┘
```

### 2.2 Onboarding Screens
```
┌─────────────────────────┐
│ [Skip]              [→] │
│                         │
│                         │
│    [Illustration]       │
│                         │
│   Başlık                │
│                         │
│   Açıklama metni        │
│   burada yer alacak     │
│                         │
│ [• ○ ○]                 │
└─────────────────────────┘
```

### 2.3 Login Screen
```
┌─────────────────────────┐
│                         │
│        [LOGO]           │
│                         │
│   ┌─────────────────┐   │
│   │   E-posta       │   │
│   └─────────────────┘   │
│                         │
│   ┌─────────────────┐   │
│   │   Şifre         │   │
│   └─────────────────┘   │
│                         │
│   ┌─────────────────┐   │
│   │   Giriş Yap     │   │
│   └─────────────────┘   │
│                         │
│   Şifremi Unuttum       │
│                         │
│   ────────────────      │
│                         │
│   Hesabın yok mu?       │
│   Kayıt ol              │
└─────────────────────────┘
```

### 2.4 Main Feed Screen
```
┌─────────────────────────┐
│ [LOGO]        [DM] [♥]  │
├─────────────────────────┤
│ ┌─────────────────────┐ │
│ │ [Avatar] Username   │ │
│ │ [Location]          │ │
│ └─────────────────────┘ │
│                         │
│ ┌─────────────────────┐ │
│ │                     │ │
│ │     [POST IMAGE]    │ │
│ │                     │ │
│ └─────────────────────┘ │
│                         │
│ [♥] [💬] [📤] [💾]      │
│                         │
│ Username  Caption...    │
│                         │
│ 123 beğenme             │
│                         │
│ Username  Comment...    │
│                         │
│ Tüm yorumları gör       │
│                         │
│ 2 saat önce             │
├─────────────────────────┤
│ [🏠] [🔍] [+] [♥] [👤]  │
└─────────────────────────┘
```

### 2.5 Camera Screen
```
┌─────────────────────────┐
│ [←] [Flash] [Settings]  │
│                         │
│                         │
│                         │
│                         │
│                         │
│                         │
│                         │
│                         │
│                         │
│                         │
│                         │
│                         │
│                         │
│ [Gallery] [●] [Flip]    │
│                         │
│ [Photo] [Video] [Story] │
└─────────────────────────┘
```

### 2.6 Profile Screen
```
┌─────────────────────────┐
│ [Settings]              │
│                         │
│ [Avatar] Username       │
│                         │
│ Bio description...      │
│                         │
│ [Edit Profile]          │
│                         │
│ 123 gönderi  1.2K       │
│ 456 takipçi  789        │
│                         │
│ ┌─────────────────────┐ │
│ │ [Grid] [Reels] [Tag]│ │
│ └─────────────────────┘ │
│                         │
│ ┌─────────────────────┐ │
│ │ [Post] [Post] [Post]│ │
│ │ [Post] [Post] [Post]│ │
│ │ [Post] [Post] [Post]│ │
│ └─────────────────────┘ │
└─────────────────────────┘
```

### 2.7 Search Screen
```
┌─────────────────────────┐
│ [←] ┌───────────────┐   │
│     │ 🔍 Arama...   │   │
│     └───────────────┘   │
│                         │
│ [Trending] [Recent]     │
│                         │
│ ┌─────────────────────┐ │
│ │ [User] [User] [User]│ │
│ │ [User] [User] [User]│ │
│ │ [User] [User] [User]│ │
│ └─────────────────────┘ │
│                         │
│ #trending #hashtags     │
│                         │
│ ┌─────────────────────┐ │
│ │ [Post] [Post] [Post]│ │
│ │ [Post] [Post] [Post]│ │
│ │ [Post] [Post] [Post]│ │
│ └─────────────────────┘ │
└─────────────────────────┘
```

## 3. Bileşen Tasarımları

### 3.1 Button Bileşenleri
```dart
// Primary Button
Container(
  width: double.infinity,
  height: 48,
  decoration: BoxDecoration(
    color: primary,
    borderRadius: BorderRadius.circular(8),
  ),
  child: Center(
    child: Text(
      'Giriş Yap',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
)

// Secondary Button
Container(
  width: double.infinity,
  height: 48,
  decoration: BoxDecoration(
    color: Colors.transparent,
    border: Border.all(color: border),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Center(
    child: Text(
      'Kayıt Ol',
      style: TextStyle(
        color: text_primary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
)
```

### 3.2 Input Field Bileşenleri
```dart
// Text Input
Container(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  decoration: BoxDecoration(
    color: surface,
    border: Border.all(color: border),
    borderRadius: BorderRadius.circular(8),
  ),
  child: TextField(
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: 'E-posta',
      hintStyle: TextStyle(color: text_secondary),
    ),
  ),
)
```

### 3.3 Post Card Bileşeni
```dart
// Post Card
Container(
  margin: EdgeInsets.only(bottom: 8),
  decoration: BoxDecoration(
    color: background,
    border: Border.all(color: border),
  ),
  child: Column(
    children: [
      // Header
      Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(radius: 16),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('username', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text('location', style: TextStyle(fontSize: 12, color: text_secondary)),
                ],
              ),
            ),
            Icon(Icons.more_vert),
          ],
        ),
      ),
      // Image
      AspectRatio(
        aspectRatio: 1,
        child: Image.network('image_url', fit: BoxFit.cover),
      ),
      // Actions
      Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.favorite_border),
            SizedBox(width: 16),
            Icon(Icons.chat_bubble_outline),
            SizedBox(width: 16),
            Icon(Icons.send),
            Spacer(),
            Icon(Icons.bookmark_border),
          ],
        ),
      ),
      // Caption
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('123 beğenme', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'username ', style: TextStyle(fontWeight: FontWeight.w600)),
                  TextSpan(text: 'caption text...'),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  ),
)
```

## 4. Animasyonlar

### 4.1 Sayfa Geçişleri
```dart
// Slide Transition
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => NextPage(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  },
)
```

### 4.2 Like Animasyonu
```dart
// Heart Animation
AnimatedBuilder(
  animation: _animationController,
  builder: (context, child) {
    return Transform.scale(
      scale: 1.0 + _animationController.value * 0.3,
      child: Icon(
        _isLiked ? Icons.favorite : Icons.favorite_border,
        color: _isLiked ? Colors.red : null,
      ),
    );
  },
)
```

## 5. Responsive Tasarım

### 5.1 Breakpoint'ler
```dart
// Mobile First Approach
const double mobileBreakpoint = 600;
const double tabletBreakpoint = 900;
const double desktopBreakpoint = 1200;

// Responsive Layout
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < mobileBreakpoint) {
      return MobileLayout();
    } else if (constraints.maxWidth < tabletBreakpoint) {
      return TabletLayout();
    } else {
      return DesktopLayout();
    }
  },
)
```

### 5.2 Grid Sistemi
```dart
// Responsive Grid
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: _getCrossAxisCount(context),
    crossAxisSpacing: 1,
    mainAxisSpacing: 1,
  ),
  itemBuilder: (context, index) => PostGridItem(),
)

int _getCrossAxisCount(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width < 600) return 3;
  if (width < 900) return 4;
  return 5;
}
```

## 6. Accessibility

### 6.1 Semantic Labels
```dart
// Accessibility Labels
IconButton(
  icon: Icon(Icons.favorite),
  onPressed: () {},
  tooltip: 'Beğen',
  semanticLabel: 'Bu gönderiyi beğen',
)
```

### 6.2 Color Contrast
```dart
// High Contrast Colors
final highContrastColors = {
  'text_primary': Color(0xFF000000),
  'text_secondary': Color(0xFF666666),
  'background': Color(0xFFFFFFFF),
  'surface': Color(0xFFF5F5F5),
}
```

## 7. Dark Mode

### 7.1 Theme Switching
```dart
// Theme Provider
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  ThemeData get theme => _isDarkMode ? darkTheme : lightTheme;
}
```

### 7.2 Dark Theme Colors
```dart
// Dark Theme
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF000000),
  cardColor: Color(0xFF121212),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
    bodyMedium: TextStyle(color: Color(0xFFCCCCCC)),
  ),
)
```

## 8. Loading States

### 8.1 Skeleton Loading
```dart
// Post Skeleton
Container(
  margin: EdgeInsets.only(bottom: 8),
  child: Column(
    children: [
      // Header Skeleton
      Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: 100,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 4),
                  Container(
                    height: 12,
                    width: 80,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Image Skeleton
      Container(
        height: 300,
        color: Colors.grey[300],
      ),
    ],
  ),
)
```

## 9. Error States

### 9.1 Error Widget'ları
```dart
// Network Error
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.wifi_off, size: 64, color: Colors.grey),
      SizedBox(height: 16),
      Text('İnternet bağlantısı yok'),
      SizedBox(height: 8),
      Text('Lütfen bağlantınızı kontrol edin'),
      SizedBox(height: 16),
      ElevatedButton(
        onPressed: () => _retry(),
        child: Text('Tekrar Dene'),
      ),
    ],
  ),
)
```

## 10. Micro-interactions

### 10.1 Pull to Refresh
```dart
// Custom Refresh Indicator
RefreshIndicator(
  onRefresh: () async {
    await _loadPosts();
  },
  child: ListView.builder(
    itemBuilder: (context, index) => PostCard(),
  ),
)
```

### 10.2 Infinite Scroll
```dart
// Pagination
NotificationListener<ScrollNotification>(
  onNotification: (ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      _loadMorePosts();
    }
    return true;
  },
  child: ListView.builder(
    itemBuilder: (context, index) => PostCard(),
  ),
)
``` 