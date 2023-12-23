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
                padding: EdgeInsets.only(top: 16, left: 16, bottom: 8),
                child: Text(
                  'Request List',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 250,
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
      decoration: BoxDecoration(
        color: Colors.white, // White background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text('ID: $id'),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Blood Group: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('$bloodGroup')
              ],
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                const Text(
                  'Urgency Level: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("$urgencyLevel")
              ],
            ),
          ],
        ),
        onTap: () {
          // Handle card tap
        },
      ),
    );
  }
}
