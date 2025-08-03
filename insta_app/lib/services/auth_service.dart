import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'api_service_wrapper.dart';

class AuthService {
  static final ApiService _apiService = ApiService();

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
        if (!ApiServiceWrapper.isUsingMockData && userData['access_token'] != null) {
          await _apiService.saveTokens(
            userData['access_token'],
            userData['refresh_token'],
          );
        }
        
        return AuthResult.success(user, result['message'] ?? 'Registration successful');
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
        if (!ApiServiceWrapper.isUsingMockData && userData['access_token'] != null) {
          await _apiService.saveTokens(
            userData['access_token'],
            userData['refresh_token'],
          );
        }
        
        return AuthResult.success(user, result['message'] ?? 'Login successful');
      } else {
        return AuthResult.failure(result['message'] ?? 'Login failed');
      }
    } catch (e) {
      return AuthResult.failure('Login error: $e');
    }
  }

  // Logout user
  Future<void> logout() async {
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
  Future<bool> isLoggedIn() async {
    final token = await _apiService.getToken();
    return token != null;
  }

  // Get current user profile
  Future<UserResult> getCurrentUser() async {
    try {
      final response = await _apiService.get('/auth/me');

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data['user']);
        return UserResult.success(user);
      } else {
        return UserResult.failure('Kullanıcı bilgileri alınamadı');
      }
    } on DioException catch (e) {
      return UserResult.failure(_apiService.getErrorMessage(e));
    } catch (e) {
      return UserResult.failure('Beklenmeyen hata: $e');
    }
  }

  /// Şifre sıfırlama
  static Future<ApiResult> forgotPassword(String email) async {
    try {
      final result = await ApiServiceWrapper.forgotPassword(email);
      
      if (result['success'] == true) {
        return ApiResult.success(result['message'] ?? 'Password reset email sent successfully');
      } else {
        return ApiResult.failure(result['message'] ?? 'Failed to send reset email');
      }
    } catch (e) {
      return ApiResult.failure('Password reset error: $e');
    }
  }

  // Reset password
  Future<ApiResult> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/reset-password',
        data: {'token': token, 'password': newPassword},
      );

      if (response.statusCode == 200) {
        return ApiResult.success(response.data['message']);
      } else {
        return ApiResult.failure(
          response.data['error'] ?? 'Şifre sıfırlama başarısız',
        );
      }
    } on DioException catch (e) {
      return ApiResult.failure(_apiService.getErrorMessage(e));
    } catch (e) {
      return ApiResult.failure('Beklenmeyen hata: $e');
    }
  }

  // Verify email
  Future<ApiResult> verifyEmail({required String token}) async {
    try {
      final response = await _apiService.post(
        '/auth/verify-email',
        data: {'token': token},
      );

      if (response.statusCode == 200) {
        return ApiResult.success(response.data['message']);
      } else {
        return ApiResult.failure(
          response.data['error'] ?? 'Email doğrulama başarısız',
        );
      }
    } on DioException catch (e) {
      return ApiResult.failure(_apiService.getErrorMessage(e));
    } catch (e) {
      return ApiResult.failure('Beklenmeyen hata: $e');
    }
  }

  // Change password
  Future<ApiResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.put(
        '/auth/change-password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );

      if (response.statusCode == 200) {
        return ApiResult.success(response.data['message']);
      } else {
        return ApiResult.failure(
          response.data['error'] ?? 'Şifre değiştirme başarısız',
        );
      }
    } on DioException catch (e) {
      return ApiResult.failure(_apiService.getErrorMessage(e));
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
  AuthResult.failure(this.error) : isSuccess = false, user = null, message = null;
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
