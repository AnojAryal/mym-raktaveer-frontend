import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';

class DonationRequest extends StatefulWidget {
  const DonationRequest({super. key});

  @override
  State<DonationRequest> createState() => _DonationRequestState();
}

class _DonationRequestState extends State<DonationRequest> {
  // Mock data for demonstration
  Future<List<Map<String, String>>> fetchData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    return [
      {'name': 'User1', 'sex': 'Male', 'age': '25'},
      {'name': 'User2', 'sex': 'Female', 'age': '30'},
      {'name': 'User3', 'sex': 'Male', 'age': '22'},
      
     
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Center(
              child: Text(
                'Donation Request',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, String>>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Loading state
                  return const  Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  // Error state
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  // Data loaded successfully
                  List<Map<String, String>> donationRequests = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: donationRequests.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5.0,
                        margin:const  EdgeInsets.all(16.0),
                        child: Container(
                          padding:const  EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading:const CircleAvatar(
                                  backgroundColor: Colors.blue,
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      donationRequests[index]['name'] ?? '',
                                      style:const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 50.0),
                                    Text(
                                      donationRequests[index]['sex'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 12.0, // Set the font size
                                        // Remove the FontWeight.bold for normal weight
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  'Age: ${donationRequests[index]['age'] ?? ''}',
                                  style:const  TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  margin:const  EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      // Handle view details button press
                                    },
                                    child:const Text(
                                      'View Details',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
