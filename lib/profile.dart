import 'package:flutter/material.dart';
import 'widgets/background.dart';

class Profile extends StatelessWidget {
  // Placeholder data
  String userName = 'John Doe';
  String userEmail = 'john.doe.overflow@example.com';
  String userPhone = '+977 1234567890'; // Add actual phone number
  int userAge = 25; // Add actual age
  String userGender = 'Male'; // Add actual gender

  // Blood details
  String bloodGroup = 'O+';
  int requestQuantity = 20000;
  String urgencyLevel = 'Medium';

  // Remaining form data
  String hospitalName = 'Sample Hospital';
  String location = 'Hospital Street, City';
  String dateRequired = '2023-12-31';
  String additionalNotes = 'Sample additional notes...';

  // Patient details
  String patientName = 'Patient Doe';
  int patientAge = 45;
  String patientSex = 'Female';
  String roomNumber = '301';
  String opdNumber = 'OPD123';

  // Container widths
  double containerWidth = 400.0;

  // Uncomment the following lines when integrating with the actual API
  // @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  // Future<void> fetchData() async {
  //   // Your API fetching logic
  // }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Handle back button press
                  // You can use Navigator.pop(context) to go back
                },
              ),
            ),
          ),
          // Profile Picture, Name, and Email
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 16.0, top: 0.0),
            child: Row(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 40,
                  // Placeholder for the profile picture
                  // Replace the next line with the actual image URL once it's available
                  // backgroundImage: AssetImage('assets/profile_placeholder.png'),
                ),
                SizedBox(
                  width: 16,
                ), // Add spacing between the profile picture and text
                // User Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$userName',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$userEmail',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Phone, Age, and Gender
          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 16.0, top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Phone
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone Number',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('$userPhone', style: TextStyle(fontSize: 16)),
                  ],
                ),
                // Age
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gender',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('$userGender', style: TextStyle(fontSize: 16)),
                  ],
                ),
                // Gender
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Age',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('$userAge', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
          // First Container with drop shadow and circular edges
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: containerWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bold text for Blood Details
                  Text('Blood Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  // Blood Group
                  Text('Blood Group: $bloodGroup',
                      style: TextStyle(fontSize: 16)),
                  // Request Quantity and Urgency Level side by side
                  SizedBox(height: 8),
                  Row(
                    children: [
                      // Request Quantity
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quantity: $requestQuantity',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      SizedBox(width: 30), // Add spacing between the text
                      // Urgency Level
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Urgency: $urgencyLevel ',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Second Container below the first one
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: containerWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bold text for Blood Request Details
                  Text('Blood Request Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  // Patient Name
                  Text('Patient Name: $patientName',
                      style: TextStyle(fontSize: 16)),
                  // Patient Age, Sex, Room Number, and OPD Number
                  SizedBox(height: 8),
                  Row(
                    children: [
                      // Age
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Age: $patientAge',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      SizedBox(width: 16), // Add spacing between the text
                      // Sex
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sex: $patientSex',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  //Hospital Name
                  Text('Hospital Name: $hospitalName',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      // Age
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Room No: $roomNumber',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      SizedBox(width: 16), // Add spacing between the text
                      // Sex
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('OPD No: $opdNumber',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // Room Number
                  Text('Location: $location', style: TextStyle(fontSize: 16)),
                  // OPD Number
                  SizedBox(height: 8),
                  Text('Date and Time: $dateRequired',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          // Add more widgets as needed
        ],
      ),
    );
  }
}
