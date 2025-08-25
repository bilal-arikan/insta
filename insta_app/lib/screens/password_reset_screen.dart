import 'package:flutter/material.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String _message = '';
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = '';
      _isSuccess = false;
    });

    // Fake şifre sıfırlama işlemi için gecikme ekleyelim
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Gerçek uygulamada bu kısım AuthService.resetPassword ile değiştirilecek
      final email = _emailController.text.trim();
      
      // Fake başarılı şifre sıfırlama
      setState(() {
        _isLoading = false;
        _isSuccess = true;
        _message = '$email adresine şifre sıfırlama bağlantısı gönderildi. Lütfen e-postanızı kontrol edin.';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isSuccess = false;
        _message = 'Bir hata oluştu: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifre Sıfırlama'),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: Colors.purple,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Şifreni mi unuttun?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'E-posta adresini gir ve şifre sıfırlama bağlantısı gönderelim.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-posta',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'E-posta gerekli';
                    }
                    // Basit bir e-posta doğrulama
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Geçerli bir e-posta adresi girin';
                    }
                    return null;
                  },
                ),
                if (_message.isNotEmpty) ...[  
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isSuccess ? Colors.green.shade200 : Colors.red.shade200,
                      ),
                    ),
                    child: Text(
                      _message,
                      style: TextStyle(
                        color: _isSuccess ? Colors.green.shade800 : Colors.red.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _resetPassword,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Şifre Sıfırlama Bağlantısı Gönder'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Giriş ekranına dön'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}