import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Register new user
  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _apiService.post('/auth/register', data: {
        'username': username,
        'email': email,
        'password': password,
        if (fullName != null) 'fullName': fullName,
      });

      if (response.statusCode == 201) {
        final data = response.data;
        final user = UserModel.fromJson(data['user']);
        
        // Store tokens
        await _apiService.setToken(data['token']);
        await _apiService.setRefreshToken(data['refreshToken']);
        
        return AuthResult.success(user);
      } else {
        return AuthResult.failure(data['error'] ?? 'Kayıt başarısız');
      }
    } on DioException catch (e) {
      return AuthResult.failure(_apiService.getErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('Beklenmeyen hata: $e');
    }
  }

  // Login user
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        final user = UserModel.fromJson(data['user']);
        
        // Store tokens
        await _apiService.setToken(data['token']);
        await _apiService.setRefreshToken(data['refreshToken']);
        
        return AuthResult.success(user);
      } else {
        return AuthResult.failure(data['error'] ?? 'Giriş başarısız');
      }
    } on DioException catch (e) {
      return AuthResult.failure(_apiService.getErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('Beklenmeyen hata: $e');
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

  // Forgot password
  Future<ApiResult> forgotPassword({required String email}) async {
    try {
      final response = await _apiService.post('/auth/forgot-password', data: {
        'email': email,
      });

      if (response.statusCode == 200) {
        return ApiResult.success(response.data['message']);
      } else {
        return ApiResult.failure(response.data['error'] ?? 'Şifre sıfırlama başarısız');
      }
    } on DioException catch (e) {
      return ApiResult.failure(_apiService.getErrorMessage(e));
    } catch (e) {
      return ApiResult.failure('Beklenmeyen hata: $e');
    }
  }

  // Reset password
  Future<ApiResult> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post('/auth/reset-password', data: {
        'token': token,
        'password': newPassword,
      });

      if (response.statusCode == 200) {
        return ApiResult.success(response.data['message']);
      } else {
        return ApiResult.failure(response.data['error'] ?? 'Şifre sıfırlama başarısız');
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
      final response = await _apiService.post('/auth/verify-email', data: {
        'token': token,
      });

      if (response.statusCode == 200) {
        return ApiResult.success(response.data['message']);
      } else {
        return ApiResult.failure(response.data['error'] ?? 'Email doğrulama başarısız');
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
      final response = await _apiService.put('/auth/change-password', data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });

      if (response.statusCode == 200) {
        return ApiResult.success(response.data['message']);
      } else {
        return ApiResult.failure(response.data['error'] ?? 'Şifre değiştirme başarısız');
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

  AuthResult.success(this.user) : isSuccess = true, error = null;
  AuthResult.failure(this.error) : isSuccess = false, user = null;
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