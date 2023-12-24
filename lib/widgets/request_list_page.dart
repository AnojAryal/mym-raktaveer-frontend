import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/blood_request_service.dart';

class RequestListPage extends StatefulWidget {
  @override
  _RequestListPageState createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  List<String> bloodGroupDataList = []; // List to hold blood group data

  @override
  void initState() {
    super.initState();
    // Fetch blood group data when the widget is initialized
    fetchBloodGroupData();
  }

  Future<void> fetchBloodGroupData() async {
    print('Blood Group Data List Length: ${bloodGroupDataList.length}');
    // Instantiate BloodRequestService
    final bloodRequestService = BloodRequestService(ApiService());

    // Fetch a list of blood group data from the backend
    final resultList = await bloodRequestService.fetchBloodRequests();

    setState(() {
      bloodGroupDataList = resultList ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Request Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: bloodGroupDataList.length,
            itemBuilder: (context, index) {
              final bloodGroupData = bloodGroupDataList[index];
              final bloodGroupDetails = bloodGroupData.split(' ');

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Blood Group:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        bloodGroupDetails[0],
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Blood Group:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        bloodGroupDetails[1],
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
