import 'dart:async';
import 'dart:math';
import '../models/user_model.dart';

/// Mock API Service - Fake data ile web requestleri simule eder
/// Backend hazır olmadığında frontend geliştirme için kullanılır
class MockApiService {
  static const Duration _mockDelay = Duration(milliseconds: 800);
  static final Random _random = Random();
  
  // Mock kullanıcı verileri
  static final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': '1',
      'username': 'john_doe',
      'email': 'john@example.com',
      'full_name': 'John Doe',
      'bio': 'Photographer & Travel Enthusiast 📸✈️',
      'profile_picture_url': 'https://picsum.photos/200/200?random=1',
      'is_verified': true,
      'is_private': false,
      'followers_count': 1250,
      'following_count': 890,
      'posts_count': 156,
      'created_at': '2023-01-15T10:30:00Z',
      'updated_at': '2024-01-15T10:30:00Z',
    },
    {
      'id': '2',
      'username': 'jane_smith',
      'email': 'jane@example.com',
      'full_name': 'Jane Smith',
      'bio': 'Digital Artist 🎨 | Coffee Lover ☕',
      'profile_picture_url': 'https://picsum.photos/200/200?random=2',
      'is_verified': false,
      'is_private': true,
      'followers_count': 567,
      'following_count': 234,
      'posts_count': 89,
      'created_at': '2023-03-20T14:15:00Z',
      'updated_at': '2024-01-10T09:20:00Z',
    },
    {
      'id': '3',
      'username': 'travel_mike',
      'email': 'mike@example.com',
      'full_name': 'Mike Johnson',
      'bio': 'World Traveler 🌍 | Adventure Seeker',
      'profile_picture_url': 'https://picsum.photos/200/200?random=3',
      'is_verified': true,
      'is_private': false,
      'followers_count': 3420,
      'following_count': 1200,
      'posts_count': 298,
      'created_at': '2022-11-05T08:45:00Z',
      'updated_at': '2024-01-12T16:30:00Z',
    },
  ];

  // Mock post verileri
  static final List<Map<String, dynamic>> _mockPosts = [
    {
      'id': '1',
      'user_id': '1',
      'caption': 'Beautiful sunset at the beach 🌅 #sunset #beach #photography',
      'image_url': 'https://picsum.photos/400/400?random=10',
      'likes_count': 245,
      'comments_count': 18,
      'is_liked': false,
      'created_at': '2024-01-15T18:30:00Z',
    },
    {
      'id': '2',
      'user_id': '2',
      'caption': 'New digital artwork! What do you think? 🎨✨',
      'image_url': 'https://picsum.photos/400/400?random=11',
      'likes_count': 89,
      'comments_count': 12,
      'is_liked': true,
      'created_at': '2024-01-14T12:15:00Z',
    },
    {
      'id': '3',
      'user_id': '3',
      'caption': 'Amazing view from the mountain top! 🏔️ #adventure #hiking',
      'image_url': 'https://picsum.photos/400/400?random=12',
      'likes_count': 567,
      'comments_count': 34,
      'is_liked': false,
      'created_at': '2024-01-13T09:45:00Z',
    },
  ];

  // Mock yorumlar
  static final List<Map<String, dynamic>> _mockComments = [
    {
      'id': '1',
      'post_id': '1',
      'user_id': '2',
      'content': 'Absolutely stunning! 😍',
      'created_at': '2024-01-15T19:00:00Z',
    },
    {
      'id': '2',
      'post_id': '1',
      'user_id': '3',
      'content': 'Great shot! Where was this taken?',
      'created_at': '2024-01-15T19:15:00Z',
    },
  ];

  /// Simulated network delay
  static Future<void> _simulateNetworkDelay() async {
    await Future.delayed(_mockDelay);
  }

  /// Random success/failure simulation
  static bool _shouldSimulateError({double errorRate = 0.1}) {
    return _random.nextDouble() < errorRate;
  }

  /// Mock Authentication Methods
  
  /// Kullanıcı girişi simülasyonu
  static Future<Map<String, dynamic>> login(String email, String password) async {
    await _simulateNetworkDelay();
    
    if (_shouldSimulateError(errorRate: 0.05)) {
      throw Exception('Network error occurred');
    }
    
    // Basit email/password kontrolü
    if (email.isEmpty || password.isEmpty) {
      return {
        'success': false,
        'message': 'Email and password are required',
      };
    }
    
    if (password.length < 6) {
      return {
        'success': false,
        'message': 'Invalid credentials',
      };
    }
    
    // Mock kullanıcı bulma
    final user = _mockUsers.firstWhere(
      (u) => u['email'] == email,
      orElse: () => _mockUsers.first, // Fallback to first user
    );
    
    return {
      'success': true,
      'message': 'Login successful',
      'data': {
        'user': user,
        'access_token': 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        'refresh_token': 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        'expires_in': 3600,
      },
    };
  }
  
  /// Kullanıcı kaydı simülasyonu
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    await _simulateNetworkDelay();
    
    if (_shouldSimulateError(errorRate: 0.05)) {
      throw Exception('Network error occurred');
    }
    
    // Basit validasyon
    if (username.isEmpty || email.isEmpty || password.isEmpty || fullName.isEmpty) {
      return {
        'success': false,
        'message': 'All fields are required',
      };
    }
    
    if (password.length < 6) {
      return {
        'success': false,
        'message': 'Password must be at least 6 characters',
      };
    }
    
    // Username kontrolü
    final existingUser = _mockUsers.where((u) => u['username'] == username).isNotEmpty;
    if (existingUser) {
      return {
        'success': false,
        'message': 'Username already exists',
      };
    }
    
    // Yeni kullanıcı oluştur
    final newUser = {
      'id': '${_mockUsers.length + 1}',
      'username': username,
      'email': email,
      'full_name': fullName,
      'bio': '',
      'profile_picture_url': 'https://picsum.photos/200/200?random=${_mockUsers.length + 10}',
      'is_verified': false,
      'is_private': false,
      'followers_count': 0,
      'following_count': 0,
      'posts_count': 0,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    
    _mockUsers.add(newUser);
    
    return {
      'success': true,
      'message': 'Registration successful',
      'data': {
        'user': newUser,
        'access_token': 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        'refresh_token': 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        'expires_in': 3600,
      },
    };
  }
  
  /// Şifre sıfırlama simülasyonu
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    await _simulateNetworkDelay();
    
    if (_shouldSimulateError(errorRate: 0.05)) {
      throw Exception('Network error occurred');
    }
    
    if (email.isEmpty) {
      return {
        'success': false,
        'message': 'Email is required',
      };
    }
    
    return {
      'success': true,
      'message': 'Password reset email sent successfully',
    };
  }
  
  /// Mock User Methods
  
  /// Kullanıcı profili getirme
  static Future<Map<String, dynamic>> getUserProfile(String userId) async {
    await _simulateNetworkDelay();
    
    if (_shouldSimulateError()) {
      throw Exception('Failed to fetch user profile');
    }
    
    final user = _mockUsers.firstWhere(
      (u) => u['id'] == userId,
      orElse: () => _mockUsers.first,
    );
    
    return {
      'success': true,
      'data': user,
    };
  }
  
  /// Kullanıcı arama
  static Future<Map<String, dynamic>> searchUsers(String query) async {
    await _simulateNetworkDelay();
    
    if (_shouldSimulateError()) {
      throw Exception('Search failed');
    }
    
    final results = _mockUsers.where((user) {
      final username = user['username'].toString().toLowerCase();
      final fullName = user['full_name'].toString().toLowerCase();
      final searchQuery = query.toLowerCase();
      
      return username.contains(searchQuery) || fullName.contains(searchQuery);
    }).toList();
    
    return {
      'success': true,
      'data': results,
    };
  }
  
  /// Mock Post Methods
  
  /// Ana feed getirme
  static Future<Map<String, dynamic>> getFeed({int page = 1, int limit = 10}) async {
    await _simulateNetworkDelay();
    
    if (_shouldSimulateError()) {
      throw Exception('Failed to fetch feed');
    }
    
    // Sayfalama simülasyonu
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    
    final paginatedPosts = _mockPosts.length > startIndex 
        ? _mockPosts.sublist(startIndex, endIndex.clamp(0, _mockPosts.length))
        : <Map<String, dynamic>>[];
    
    // Her post için kullanıcı bilgisi ekle
    final postsWithUsers = paginatedPosts.map((post) {
      final user = _mockUsers.firstWhere(
        (u) => u['id'] == post['user_id'],
        orElse: () => _mockUsers.first,
      );
      
      return {
        ...post,
        'user': user,
      };
    }).toList();
    
    return {
      'success': true,
      'data': {
        'posts': postsWithUsers,
        'has_more': endIndex < _mockPosts.length,
        'total_count': _mockPosts.length,
      },
    };
  }
  
  /// Post beğenme/beğenmeme
  static Future<Map<String, dynamic>> toggleLike(String postId) async {
    await _simulateNetworkDelay();
    
    if (_shouldSimulateError(errorRate: 0.02)) {
      throw Exception('Failed to toggle like');
    }
    
    final postIndex = _mockPosts.indexWhere((p) => p['id'] == postId);
    if (postIndex == -1) {
      return {
        'success': false,
        'message': 'Post not found',
      };
    }
    
    final post = _mockPosts[postIndex];
    final isLiked = post['is_liked'] as bool;
    final likesCount = post['likes_count'] as int;
    
    // Toggle like durumu
    _mockPosts[postIndex] = {
      ...post,
      'is_liked': !isLiked,
      'likes_count': isLiked ? likesCount - 1 : likesCount + 1,
    };
    
    return {
      'success': true,
      'data': {
        'is_liked': !isLiked,
        'likes_count': _mockPosts[postIndex]['likes_count'],
      },
    };
  }
  
  /// Post yorumları getirme
  static Future<Map<String, dynamic>> getComments(String postId) async {
    await _simulateNetworkDelay();
    
    if (_shouldSimulateError()) {
      throw Exception('Failed to fetch comments');
    }
    
    final comments = _mockComments.where((c) => c['post_id'] == postId).toList();
    
    // Her yorum için kullanıcı bilgisi ekle
    final commentsWithUsers = comments.map((comment) {
      final user = _mockUsers.firstWhere(
        (u) => u['id'] == comment['user_id'],
        orElse: () => _mockUsers.first,
      );
      
      return {
        ...comment,
        'user': user,
      };
    }).toList();
    
    return {
      'success': true,
      'data': commentsWithUsers,
    };
  }
  
  /// Yorum ekleme
  static Future<Map<String, dynamic>> addComment(String postId, String content) async {
    await _simulateNetworkDelay();
    
    if (_shouldSimulateError(errorRate: 0.02)) {
      throw Exception('Failed to add comment');
    }
    
    if (content.trim().isEmpty) {
      return {
        'success': false,
        'message': 'Comment cannot be empty',
      };
    }
    
    final newComment = {
      'id': '${_mockComments.length + 1}',
      'post_id': postId,
      'user_id': '1', // Current user ID (mock)
      'content': content,
      'created_at': DateTime.now().toIso8601String(),
    };
    
    _mockComments.add(newComment);
    
    // Post'un yorum sayısını artır
    final postIndex = _mockPosts.indexWhere((p) => p['id'] == postId);
    if (postIndex != -1) {
      final post = _mockPosts[postIndex];
      _mockPosts[postIndex] = {
        ...post,
        'comments_count': (post['comments_count'] as int) + 1,
      };
    }
    
    return {
      'success': true,
      'data': newComment,
    };
  }
  
  /// Mock Follow Methods
  
  /// Kullanıcı takip etme/etmeme
  static Future<Map<String, dynamic>> toggleFollow(String userId) async {
    await _simulateNetworkDelay();
    
    if (_shouldSimulateError(errorRate: 0.02)) {
      throw Exception('Failed to toggle follow');
    }
    
    // Basit takip simülasyonu
    final isFollowing = _random.nextBool();
    
    return {
      'success': true,
      'data': {
        'is_following': !isFollowing,
        'message': !isFollowing ? 'Now following user' : 'Unfollowed user',
      },
    };
  }
  
  /// Takipçi listesi getirme
  static Future<Map<String, dynamic>> getFollowers(String userId) async {
    await _simulateNetworkDelay();
    
    if (_shouldSimulateError()) {
      throw Exception('Failed to fetch followers');
    }
    
    // Random takipçi listesi
    final followers = _mockUsers.take(2).toList();
    
    return {
      'success': true,
      'data': followers,
    };
  }
  
  /// Takip edilen listesi getirme
  static Future<Map<String, dynamic>> getFollowing(String userId) async {
    await _simulateNetworkDelay();
    
    if (_shouldSimulateError()) {
      throw Exception('Failed to fetch following');
    }
    
    // Random takip edilen listesi
    final following = _mockUsers.take(2).toList();
    
    return {
      'success': true,
      'data': following,
    };
  }
  
  /// Mock Auth Methods
  
  /// Mevcut kullanıcı bilgilerini getir
  static Future<Map<String, dynamic>> getCurrentUser() async {
    await _simulateNetworkDelay();
    
    if (_shouldSimulateError(errorRate: 0.05)) {
      throw Exception('Failed to get current user');
    }
    
    // Varsayılan olarak ilk kullanıcıyı döndür
    final currentUser = _mockUsers.first;
    
    return {
      'success': true,
      'data': {
        'user': currentUser,
      },
      'message': 'User data retrieved successfully',
    };
  }
  
  /// Şifre sıfırlama (token ile)
  static Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _simulateNetworkDelay();
    
    if (_shouldSimulateError(errorRate: 0.05)) {
      throw Exception('Failed to reset password');
    }
    
    if (token.isEmpty || newPassword.isEmpty) {
      return {
        'success': false,
        'message': 'Token and new password are required',
      };
    }
    
    if (newPassword.length < 6) {
      return {
        'success': false,
        'message': 'Password must be at least 6 characters',
      };
    }
    
    return {
      'success': true,
      'message': 'Password has been reset successfully',
    };
  }
  
  /// Email doğrulama
  static Future<Map<String, dynamic>> verifyEmail({required String token}) async {
    await _simulateNetworkDelay();
    
    if (_shouldSimulateError(errorRate: 0.05)) {
      throw Exception('Failed to verify email');
    }
    
    if (token.isEmpty) {
      return {
        'success': false,
        'message': 'Verification token is required',
      };
    }
    
    return {
      'success': true,
      'message': 'Email has been verified successfully',
    };
  }
  
  /// Şifre değiştirme
  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _simulateNetworkDelay();
    
    if (_shouldSimulateError(errorRate: 0.05)) {
      throw Exception('Failed to change password');
    }
    
    if (currentPassword.isEmpty || newPassword.isEmpty) {
      return {
        'success': false,
        'message': 'Current password and new password are required',
      };
    }
    
    if (newPassword.length < 6) {
      return {
        'success': false,
        'message': 'New password must be at least 6 characters',
      };
    }
    
    return {
      'success': true,
      'message': 'Password has been changed successfully',
    };
  }
  
  /// Mock Utility Methods
  
  /// Mock data reset (test için)
  static void resetMockData() {
    // Mock verileri orijinal haline döndür
    // Bu method test senaryolarında kullanılabilir
  }
  
  /// Mock error simulation toggle
  static bool _errorSimulationEnabled = true;
  
  static void enableErrorSimulation() {
    _errorSimulationEnabled = true;
  }
  
  static void disableErrorSimulation() {
    _errorSimulationEnabled = false;
  }
}