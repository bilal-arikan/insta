import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Arama'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'Arama özelliği gerekiyor',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Kullanıcı arama işlemleri burada yapılacak
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bu özellik henüz uygulanmadı'),
                  ),
                );
              },
              child: const Text('Kullanıcı Ara'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                // Popüler kullanıcıları gösterme işlemleri burada yapılacak
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bu özellik henüz uygulanmadı'),
                  ),
                );
              },
              child: const Text('Popüler Kullanıcılar'),
            ),
          ],
        ),
      ),
    );
  }
}