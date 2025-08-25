import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final List<Map<String, dynamic>> _activities = [
    {
      'username': 'ahmet23',
      'action': 'gönderini beğendi',
      'time': '2 saat önce',
      'userImage': null,
    },
    {
      'username': 'mehmet_34',
      'action': 'seni takip etmeye başladı',
      'time': '3 saat önce',
      'userImage': null,
    },
    {
      'username': 'ayse_tasarim',
      'action': 'gönderine yorum yaptı: "Harika!"',
      'time': '5 saat önce',
      'userImage': null,
    },
    {
      'username': 'fatma_yildiz',
      'action': 'gönderini beğendi',
      'time': '1 gün önce',
      'userImage': null,
    },
    {
      'username': 'can_aydın',
      'action': 'seni takip etmeye başladı',
      'time': '2 gün önce',
      'userImage': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktivite'),
      ),
      body: _activities.isEmpty
          ? const Center(
              child: Text('Henüz bir aktivite yok'),
            )
          : ListView.builder(
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                final activity = _activities[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: activity['userImage'] != null
                        ? NetworkImage(activity['userImage'])
                        : null,
                    child: activity['userImage'] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: activity['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' ${activity['action']}'),
                      ],
                    ),
                  ),
                  subtitle: Text(activity['time']),
                  trailing: activity['action'].contains('takip')
                      ? ElevatedButton(
                          onPressed: () {},
                          child: const Text('Takip Et'),
                        )
                      : null,
                );
              },
            ),
    );
  }
}