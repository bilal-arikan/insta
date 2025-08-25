import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/api_service_wrapper.dart';
import 'app/instagram_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('⚠️ .env file not found, using default values');
  }
  
  // Initialize API Services
  try {
    await ApiServiceWrapper.initialize();
    print('✅ API Services initialized successfully');
  } catch (e) {
    print('⚠️ API Service initialization failed: $e');
    print('! Using mock data configuration');
  }
  
  runApp(
    const ProviderScope(
      child: InstagramApp(),
    ),
  );
}

// InstagramApp sınıfı app/instagram_app.dart dosyasına taşındı
// SplashScreen sınıfı screens/splash_screen.dart dosyasına taşındı
// LoginScreen sınıfı screens/login_screen.dart dosyasına taşındı
// MainScreen sınıfı screens/main_screen.dart dosyasına taşındı
// SearchScreen sınıfı screens/search_screen.dart dosyasına taşındı
// CameraScreen sınıfı screens/camera_screen.dart dosyasına taşındı
// ActivityScreen sınıfı screens/activity_screen.dart dosyasına taşındı
// ProfileScreen sınıfı screens/profile_screen.dart dosyasına taşındı
