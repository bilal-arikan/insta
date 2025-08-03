import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'api_service.dart';
import 'mock_api_service.dart';
import '../models/user_model.dart';

/// API Service Wrapper - Gerçek API ile Mock API arasında geçiş yapar
/// Development sırasında backend hazır olmadığında mock data kullanır
class ApiServiceWrapper {
  static bool _useMockData = false;
  static late ApiService _realApiService;
  
  /// Initialize wrapper with configuration
  static Future<void> initialize() async {
    // Environment'dan mock mode kontrolü
    try {
      final useMock = dotenv.env['USE_MOCK_DATA']?.toLowerCase() == 'true';
      _useMockData = useMock;
    } catch (e) {
      // .env dosyası yoksa veya hata varsa, varsayılan olarak mock kullan
      _useMockData = true;
      print('! Using mock data due to env configuration error');
    }
    
    // Real API service'i initialize et
    if (!_useMockData) {
      try {
        _realApiService = ApiService();
        
        // Backend bağlantısını test et
        await _testBackendConnection();
      } catch (e) {
        print('! Backend connection failed, switching to mock data: $e');
        _useMockData = true;
      }
    }
    
    print(_useMockData 
        ? '🎭 Mock API Service aktif - Fake data kullanılıyor'
        : '🌐 Real API Service aktif - Backend bağlantısı kuruldu');
  }
  
  /// Test backend connection
  static Future<void> _testBackendConnection() async {
    try {
      // Basit bir health check endpoint'i çağır
      final response = await _realApiService.get('/health');
      if (response.statusCode != 200) {
        throw Exception('Backend health check failed');
      }
    } catch (e) {
      throw Exception('Cannot connect to backend: $e');
    }
  }
  
  /// Mock mode'u manuel olarak değiştir
  static void setMockMode(bool useMock) {
    _useMockData = useMock;
    print(_useMockData 
        ? '🎭 Switched to Mock API Service'
        : '🌐 Switched to Real API Service');
  }
  
  /// Current mode'u kontrol et
  static bool get isUsingMockData => _useMockData;
  
  // Authentication Methods
  
  /// Kullanıcı girişi
  static Future<Map<String, dynamic>> login(String email, String password) async {
    if (_useMockData) {
      return await MockApiService.login(email, password);
    } else {
      try {
        final response = await _realApiService.post('/auth/login', data: {
          'email': email,
          'password': password,
        });
        
        return {
          'success': response.statusCode == 200,
          'data': response.data,
          'message': response.data['message'] ?? 'Login successful',
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'API Error: $e',
        };
      }
    }
  }
  
  /// Kullanıcı kaydı
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    if (_useMockData) {
      return await MockApiService.register(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
      );
    } else {
      try {
        final response = await _realApiService.post('/auth/register', data: {
          'username': username,
          'email': email,
          'password': password,
          'full_name': fullName,
        });
        
        return {
          'success': response.statusCode == 201,
          'data': response.data,
          'message': response.data['message'] ?? 'Registration successful',
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'API Error: $e',
        };
      }
    }
  }
  
  /// Şifre sıfırlama
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    if (_useMockData) {
      return await MockApiService.forgotPassword(email);
    } else {
      try {
        final response = await _realApiService.post('/auth/forgot-password', data: {
          'email': email,
        });
        
        return {
          'success': response.statusCode == 200,
          'message': response.data['message'] ?? 'Password reset email sent',
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'API Error: $e',
        };
      }
    }
  }
  
  // User Methods
  
  /// Kullanıcı profili getirme
  static Future<Map<String, dynamic>> getUserProfile(String userId) async {
    if (_useMockData) {
      return await MockApiService.getUserProfile(userId);
    } else {
      try {
        final response = await _realApiService.get('/users/$userId');
        
        return {
          'success': response.statusCode == 200,
          'data': response.data,
        };
      } catch (e) {
        throw Exception('API Error: $e');
      }
    }
  }
  
  /// Kullanıcı arama
  static Future<Map<String, dynamic>> searchUsers(String query) async {
    if (_useMockData) {
      return await MockApiService.searchUsers(query);
    } else {
      try {
        final response = await _realApiService.get('/users/search', queryParameters: {
          'q': query,
        });
        
        return {
          'success': response.statusCode == 200,
          'data': response.data,
        };
      } catch (e) {
        throw Exception('API Error: $e');
      }
    }
  }
  
  // Post Methods
  
  /// Ana feed getirme
  static Future<Map<String, dynamic>> getFeed({int page = 1, int limit = 10}) async {
    if (_useMockData) {
      return await MockApiService.getFeed(page: page, limit: limit);
    } else {
      try {
        final response = await _realApiService.get('/posts/feed', queryParameters: {
          'page': page,
          'limit': limit,
        });
        
        return {
          'success': response.statusCode == 200,
          'data': response.data,
        };
      } catch (e) {
        throw Exception('API Error: $e');
      }
    }
  }
  
  /// Post beğenme/beğenmeme
  static Future<Map<String, dynamic>> toggleLike(String postId) async {
    if (_useMockData) {
      return await MockApiService.toggleLike(postId);
    } else {
      try {
        final response = await _realApiService.post('/posts/$postId/like');
        
        return {
          'success': response.statusCode == 200,
          'data': response.data,
        };
      } catch (e) {
        throw Exception('API Error: $e');
      }
    }
  }
  
  /// Post yorumları getirme
  static Future<Map<String, dynamic>> getComments(String postId) async {
    if (_useMockData) {
      return await MockApiService.getComments(postId);
    } else {
      try {
        final response = await _realApiService.get('/posts/$postId/comments');
        
        return {
          'success': response.statusCode == 200,
          'data': response.data,
        };
      } catch (e) {
        throw Exception('API Error: $e');
      }
    }
  }
  
  /// Yorum ekleme
  static Future<Map<String, dynamic>> addComment(String postId, String content) async {
    if (_useMockData) {
      return await MockApiService.addComment(postId, content);
    } else {
      try {
        final response = await _realApiService.post('/posts/$postId/comments', data: {
          'content': content,
        });
        
        return {
          'success': response.statusCode == 201,
          'data': response.data,
        };
      } catch (e) {
        throw Exception('API Error: $e');
      }
    }
  }
  
  // Follow Methods
  
  /// Kullanıcı takip etme/etmeme
  static Future<Map<String, dynamic>> toggleFollow(String userId) async {
    if (_useMockData) {
      return await MockApiService.toggleFollow(userId);
    } else {
      try {
        final response = await _realApiService.post('/users/$userId/follow');
        
        return {
          'success': response.statusCode == 200,
          'data': response.data,
        };
      } catch (e) {
        throw Exception('API Error: $e');
      }
    }
  }
  
  /// Takipçi listesi getirme
  static Future<Map<String, dynamic>> getFollowers(String userId) async {
    if (_useMockData) {
      return await MockApiService.getFollowers(userId);
    } else {
      try {
        final response = await _realApiService.get('/users/$userId/followers');
        
        return {
          'success': response.statusCode == 200,
          'data': response.data,
        };
      } catch (e) {
        throw Exception('API Error: $e');
      }
    }
  }
  
  /// Takip edilen listesi getirme
  static Future<Map<String, dynamic>> getFollowing(String userId) async {
    if (_useMockData) {
      return await MockApiService.getFollowing(userId);
    } else {
      try {
        final response = await _realApiService.get('/users/$userId/following');
        
        return {
          'success': response.statusCode == 200,
          'data': response.data,
        };
      } catch (e) {
        throw Exception('API Error: $e');
      }
    }
  }
  
  // Utility Methods
  
  /// Network connectivity check
  static Future<bool> checkConnectivity() async {
    if (_useMockData) {
      return true; // Mock data her zaman available
    }
    
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
  
  /// Get current API status
  static Map<String, dynamic> getApiStatus() {
    return {
      'is_mock': _useMockData,
      'mode': _useMockData ? 'Mock Data' : 'Real API',
      'description': _useMockData 
          ? 'Using fake data for development'
          : 'Connected to backend server',
    };
  }
  
  /// Force refresh API connection
  static Future<void> refreshConnection() async {
    if (!_useMockData) {
      try {
        await _testBackendConnection();
        print('✅ Backend connection refreshed successfully');
      } catch (e) {
        print('❌ Backend connection refresh failed: $e');
        print('🎭 Switching to mock data');
        _useMockData = true;
      }
    }
  }
}