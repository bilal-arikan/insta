import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/api_service_wrapper.dart';
import '../services/theme_service.dart';
import '../widgets/theme_switch.dart';
import 'login_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Geçici olarak sabit bir userId kullanıyoruz, gerçek uygulamada oturum açmış kullanıcının ID'si kullanılmalı
      final result = await ApiServiceWrapper.getUserProfile('1');

      if (result['success'] == true) {
        final userData = result['data'];
        setState(() {
          _user = UserModel.fromJson(userData);
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = result['message'] ?? 'Profil yüklenemedi';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Bir hata oluştu: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await AuthService.logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Çıkış yapılırken hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_user?.username ?? 'Profil'),
        actions: [
          const ThemeSwitch(),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUserProfile,
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    if (_user == null) {
      return const Center(child: Text('Kullanıcı bilgisi bulunamadı'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: _user?.profileImageUrl != null
                      ? NetworkImage(_user!.profileImageUrl!)
                      : null,
                  child: _user?.profileImageUrl == null
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn('Gönderiler', _user?.postsCount.toString() ?? '0'),
                      _buildStatColumn('Takipçiler', _user?.followersCount.toString() ?? '0'),
                      _buildStatColumn('Takip', _user?.followingCount.toString() ?? '0'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _user?.fullName ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (_user?.bio != null && _user!.bio!.isNotEmpty)
                  Text(_user!.bio!),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Navigate to edit profile
                },
                child: const Text('Profili Düzenle'),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Ayarlar'),
            onTap: () {
              _showSettingsBottomSheet(context);
            },
          ),
          const Divider(),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'Henüz gönderi yok',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
  
  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Ayarlar'),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Divider(),
              const ThemeSwitchListTile(),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Dil Ayarları'),
                onTap: () {
                  // Dil ayarları ekranına git
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Bildirim Ayarları'),
                onTap: () {
                  // Bildirim ayarları ekranına git
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Gizlilik Ayarları'),
                onTap: () {
                  // Gizlilik ayarları ekranına git
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}