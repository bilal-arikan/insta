import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktivite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.notifications,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'Aktivite bildirimleri gerekiyor',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Bildirim izinleri isteme işlemi burada yapılacak
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bu özellik henüz uygulanmadı'),
                  ),
                );
              },
              child: const Text('Bildirimleri Etkinleştir'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                // Bildirim ayarlarına yönlendirme işlemi burada yapılacak
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bu özellik henüz uygulanmadı'),
                  ),
                );
              },
              child: const Text('Bildirim Ayarları'),
            ),
          ],
        ),
      ),
    );
  }
}