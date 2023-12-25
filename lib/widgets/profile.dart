import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/widgets/profile_text.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> responseData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    String fullName = responseData['full_name'] ?? "N/A";
    String email = responseData['email'] ?? "N/A";
    String mobileNumber = responseData['mobile_number'] ?? "N/A";
    String gender = responseData['gender'] ?? "N/A";
    int age = responseData['age'] ?? 0;

    String? bloodGroupAbo = responseData['blood_detail']?['blood_group_abo'];
    String? bloodGroupRh = responseData['blood_detail']?['blood_group_rh'];

    String bloodGroup = (bloodGroupAbo != null && bloodGroupRh != null)
        ? bloodGroupAbo + bloodGroupRh
        : 'N/A';

    int? donationCount = responseData['blood_detail']?['donation_count'] ?? 0;
    int? donatedQuantity =
        responseData['blood_detail']?['donated_quantity'] ?? 0;

    Map<String, dynamic>? healthCondition = responseData['health_condition'];
    List<String> conditions = [];
    List<bool?> isCheckedList = [];

    if (healthCondition != null) {
      conditions = healthCondition.keys.toList();
      isCheckedList = conditions.map((key) {
        final value = healthCondition[key];
        if (value is bool) {
          return value;
        } else if (value is String) {
          return value.toLowerCase() == 'true';
        }
        return null; // Handle other cases if needed
      }).toList();
    }

    double containerWidth = MediaQuery.of(context).size.width * 0.9;
    bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button and Admin Button
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 115),
                IconButton(
                  icon: const Icon(
                    Icons.admin_panel_settings,
                    color: Color(0xFFFD1A00),
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/admin-dashboard',
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFD1A00),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(100, 25),
                  ),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            // Profile Picture, Name, and Email
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0),
              child: Row(
                children: [
                  // Profile Picture
                  const CircleAvatar(
                    radius: 40,
                    // Placeholder for the profile picture
                    // Replace the next line with the actual image URL once it's available
                    // backgroundImage: AssetImage('assets/profile_placeholder.png'),
                  ),
                  const SizedBox(width: 16),
                  // User Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            fullName,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            email,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w300,
                            ),
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
                      Text('Contact',
                          style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 16,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(mobileNumber,
                          style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 16,
                              fontWeight: FontWeight.w300)),
                    ],
                  ),
                  // Age
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gender',
                          style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 16,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(gender,
                          style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 16,
                              fontWeight: FontWeight.w300)),
                    ],
                  ),
                  // Gender
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Age',
                          style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 16,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text('$age',
                          style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 16,
                              fontWeight: FontWeight.w300)),
                    ],
                  ),
                ],
              ),
            ),
            // First Container with circular edges and box shadow
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
                    const SizedBox(height: 8),
                    // Blood Group
                    CustomRichText(label: "Blood Group", value: bloodGroup),
                    const SizedBox(height: 8),
                    // Donation Count and Donated Quantity
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomRichText(
                            label: "Donation Count", value: "$donationCount"),
                        const SizedBox(height: 8),
                        CustomRichText(
                            label: "Donated Quantity",
                            value: "$donatedQuantity"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Second Container below the first one (Scrollable)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: containerWidth,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Health Conditions
                      Text(
                        'Health Conditions',
                        style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 14),
                      // Display health conditions based on isCheckedList
                      for (int index = 0; index < conditions.length; index++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                conditions[index],
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                              ),
                              Container(
                                width: isSmallScreen ? 60 : 70,
                                height: isSmallScreen ? 18 : 22,
                                decoration: BoxDecoration(
                                  color: isCheckedList[index] ?? false
                                      ? const Color(0xFF99FDD2)
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  isCheckedList[index] == true
                                      ? 'Yes'
                                      : isCheckedList[index] == false
                                          ? 'No'
                                          : 'N/A',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 12 : 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
