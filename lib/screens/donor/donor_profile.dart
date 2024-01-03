import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';

class DonorProfile extends StatelessWidget {
  final Map<String, dynamic> participantData;

  const DonorProfile({super.key, required this.participantData});

  @override
  Widget build(BuildContext context) {
    String fullName = participantData['full_name'] ?? "N/A";
    String email = participantData['email'] ?? "N/A";
    String mobileNumber = participantData['mobile_number'] ?? "N/A";
    String gender = participantData['gender'] ?? "N/A";
    int age = participantData['age'] ?? 0;

    String? bloodGroupAbo = participantData['blood_detail']?['blood_group_abo'];
    String? bloodGroupRh = participantData['blood_detail']?['blood_group_rh'];

    String bloodGroup = (bloodGroupAbo != null && bloodGroupRh != null)
        ? bloodGroupAbo + bloodGroupRh
        : 'N/A';

    int? donationCount =
        participantData['blood_detail']?['donation_count'] ?? 0;
    int? donatedQuantity =
        participantData['blood_detail']?['donated_quantity'] ?? 0;

    Map<String, dynamic>? healthCondition = participantData['health_condition'];
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
        return null;
      }).toList();
    }

    return Background(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double containerWidth = constraints.maxWidth * 0.9;
          bool isSmallScreen = constraints.maxWidth < 600;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button, Admin Button, and Sign Out Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 100.0,
                      ),
                      child: IconButton(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFD1A00),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(50, 25),
                        ),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(fontSize: isSmallScreen ? 10 : 12),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16.0),

                // DonorProfile Picture, Name, and Email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                      ),
                      const SizedBox(width: 16),
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
                const SizedBox(height: 10.0),

                // Phone, Age, and Gender
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mobileNumber,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Age',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$age',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),

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
                        CustomRichText(label: "Blood Group", value: bloodGroup),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomRichText(
                                label: "Donation Count",
                                value: "$donationCount"),
                            const SizedBox(height: 8),
                            CustomRichText(
                              label: "Donated Quantity",
                              value: "$donatedQuantity",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: containerWidth,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Health Conditions',
                            style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: isSmallScreen ? 10 : 14),
                          for (int index = 0;
                              index < conditions.length;
                              index++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
          );
        },
      ),
    );
  }
}

class CustomRichText extends StatelessWidget {
  final String label;
  final String value;

  const CustomRichText({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
