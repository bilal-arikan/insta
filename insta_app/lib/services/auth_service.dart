import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'api_service_wrapper.dart';

class AuthService {
  static final ApiService _apiService = ApiService();
  
  // Initialize API service
  static void initialize() {
    _apiService.initialize();
  }

  /// Kullanıcı kaydı
  static Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final result = await ApiServiceWrapper.register(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
      );

      if (result['success'] == true) {
        final userData = result['data'];
        final user = UserModel.fromJson(userData['user']);

        // Token'ları kaydet (sadece gerçek API'de)
        if (!ApiServiceWrapper.isUsingMockData &&
            userData['access_token'] != null) {
          await _apiService.setToken(userData['access_token']);
          await _apiService.setRefreshToken(userData['refresh_token']);
        }

        return AuthResult.success(
          user,
          result['message'] ?? 'Registration successful',
        );
      } else {
        return AuthResult.failure(result['message'] ?? 'Registration failed');
      }
    } catch (e) {
      return AuthResult.failure('Registration error: $e');
    }
  }

  /// Kullanıcı girişi
  static Future<AuthResult> login(String email, String password) async {
    try {
      final result = await ApiServiceWrapper.login(email, password);

      if (result['success'] == true) {
        final userData = result['data'];
        final user = UserModel.fromJson(userData['user']);

        // Token'ları kaydet (sadece gerçek API'de)
        if (!ApiServiceWrapper.isUsingMockData &&
            userData['access_token'] != null) {
          await _apiService.setToken(userData['access_token']);
          await _apiService.setRefreshToken(userData['refresh_token']);
        }

        return AuthResult.success(
          user,
          result['message'] ?? 'Login successful',
        );
      } else {
        return AuthResult.failure(result['message'] ?? 'Login failed');
      }
    } catch (e) {
      return AuthResult.failure('Login error: $e');
    }
  }

  // Logout user
  static Future<void> logout() async {
    try {
      // Call logout endpoint to invalidate token on server
      await _apiService.post('/auth/logout');
    } catch (e) {
      print('Logout API call failed: $e');
    } finally {
      // Always clear local tokens
      await _apiService.clearTokens();
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await _apiService.getToken();
    return token != null;
  }

  // Get current user profile
  static Future<UserResult> getCurrentUser() async {
    try {
      final result = await ApiServiceWrapper.getCurrentUser();
      
      if (result['success'] == true) {
        final userData = result['data'];
        final user = UserModel.fromJson(userData['user']);
        return UserResult.success(user);
      } else {
        return UserResult.failure(result['message'] ?? 'Kullanıcı bilgileri alınamadı');
      }
    } catch (e) {
      return UserResult.failure('Beklenmeyen hata: $e');
    }
  }

  /// Şifre sıfırlama
  static Future<ApiResult> forgotPassword(String email) async {
    try {
      final result = await ApiServiceWrapper.forgotPassword(email);

      if (result['success'] == true) {
        return ApiResult.success(
          result['message'] ?? 'Password reset email sent successfully',
        );
      } else {
        return ApiResult.failure(
          result['message'] ?? 'Failed to send reset email',
        );
      }
    } catch (e) {
      return ApiResult.failure('Password reset error: $e');
    }
  }

  // Reset password
  static Future<ApiResult> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final result = await ApiServiceWrapper.resetPassword(
        token: token,
        newPassword: newPassword,
      );

      if (result['success'] == true) {
        return ApiResult.success(result['message'] ?? 'Şifre başarıyla sıfırlandı');
      } else {
        return ApiResult.failure(result['message'] ?? 'Şifre sıfırlama başarısız');
      }
    } catch (e) {
      return ApiResult.failure('Beklenmeyen hata: $e');
    }
  }

  // Verify email
  static Future<ApiResult> verifyEmail({required String token}) async {
    try {
      final result = await ApiServiceWrapper.verifyEmail(token: token);

      if (result['success'] == true) {
        return ApiResult.success(result['message'] ?? 'Email başarıyla doğrulandı');
      } else {
        return ApiResult.failure(result['message'] ?? 'Email doğrulama başarısız');
      }
    } catch (e) {
      return ApiResult.failure('Beklenmeyen hata: $e');
    }
  }

  // Change password
  static Future<ApiResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final result = await ApiServiceWrapper.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (result['success'] == true) {
        return ApiResult.success(result['message'] ?? 'Şifre başarıyla değiştirildi');
      } else {
        return ApiResult.failure(result['message'] ?? 'Şifre değiştirme başarısız');
      }
    } catch (e) {
      return ApiResult.failure('Beklenmeyen hata: $e');
    }
  }
}

// Result classes
class AuthResult {
  final bool isSuccess;
  final UserModel? user;
  final String? error;
  final String? message;

  AuthResult.success(this.user, this.message) : isSuccess = true, error = null;
  AuthResult.failure(this.error)
    : isSuccess = false,
      user = null,
      message = null;
}

class UserResult {
  final bool isSuccess;
  final UserModel? user;
  final String? error;

  UserResult.success(this.user) : isSuccess = true, error = null;
  UserResult.failure(this.error) : isSuccess = false, user = null;
}

class ApiResult {
  final bool isSuccess;
  final String? message;
  final String? error;

  ApiResult.success(this.message) : isSuccess = true, error = null;
  ApiResult.failure(this.error) : isSuccess = false, message = null;
}
