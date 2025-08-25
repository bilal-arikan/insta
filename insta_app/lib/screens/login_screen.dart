import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'main_screen.dart';
import 'password_reset_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'john@example.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Fake login için gecikme ekleyelim
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Fake login - Herhangi bir kullanıcı adı ve şifre ile giriş yapılabilir
      // Gerçek uygulamada bu kısım AuthService.login ile değiştirilecek
      
      // Test için kullanılabilecek fake kullanıcılar:
      // Email: john@example.com, jane@example.com, mike@example.com
      // Şifre: herhangi bir 6 karakterden uzun şifre
      
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      
      if (password.length < 6) {
        setState(() {
          _errorMessage = 'Şifre en az 6 karakter olmalıdır';
          _isLoading = false;
        });
        return;
      }
      
      // Fake başarılı giriş
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Bir hata oluştu: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Instagram logo placeholder
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-posta',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'E-posta gerekli';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre gerekli';
                    }
                    return null;
                  },
                ),
                if (_errorMessage.isNotEmpty) ...[  
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Giriş Yap'),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Şifre sıfırlama ekranına git
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PasswordResetScreen(),
                          ),
                        );
                      },
                      child: const Text('Şifreni mi unuttun?'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Kaydol ekranına git
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text('Hesabın yok mu? Kaydol'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}