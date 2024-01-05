import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Mock data for demonstration
  Future<List<String>> fetchNotifications() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    return [
      'Notification 1',
      'Notification 2 with a longer message that might span multiple lines',
      'Notification 3',
      // Add more notifications as needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {},
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Center(
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<String>>(
              future: fetchNotifications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Loading state
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  // Error state
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  // Data loaded successfully
                  List<String> notifications = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(16.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: const Icon(Icons.notifications),
                          title: Text(notifications[index]),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
