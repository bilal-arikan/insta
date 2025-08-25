import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Gönderi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'Kamera erişimi gerekiyor',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Kamera erişimi ve fotoğraf çekme işlemleri burada yapılacak
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bu özellik henüz uygulanmadı'),
                  ),
                );
              },
              child: const Text('Fotoğraf Çek'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                // Galeriden fotoğraf seçme işlemleri burada yapılacak
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bu özellik henüz uygulanmadı'),
                  ),
                );
              },
              child: const Text('Galeriden Seç'),
            ),
          ],
        ),
      ),
    );
  }
}