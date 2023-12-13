import 'package:flutter/material.dart';

class RequestListPage extends StatefulWidget {
  const RequestListPage({super.key});

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  final String backendUrl = 'your_php_backend_url';

  Future<List<Map<String, dynamic>>> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      {'id': 1, 'bloodGroup': 'O+', 'urgencyLevel': 'Urgent'},
      {'id': 2, 'bloodGroup': 'AB-', 'urgencyLevel': 'Normal'},
      {'id': 3, 'bloodGroup': 'A+', 'urgencyLevel': 'Critical'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Map<String, dynamic>> data = snapshot.data ?? [];
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Request List',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return buildRequestCard(
                      data[index]['id'],
                      data[index]['bloodGroup'],
                      data[index]['urgencyLevel'],
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget buildRequestCard(int id, String bloodGroup, String urgencyLevel) {
    return Container(
    margin: const EdgeInsets.all(8),
    width: 200,
    child: Card(
      child: ListTile(
        title: Text('ID: $id'),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Blood Group: $bloodGroup'),
            const SizedBox(width: 16),
            Text('Urgency Level: $urgencyLevel'),
          ],
        ),
          onTap: () {
            // Handle card tap
          },
        ),
      ),
    );
  }
}
