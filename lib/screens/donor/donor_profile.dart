import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/widgets/profile_text.dart';

import '../../services/accept_donor_request_service.dart';
import '../../services/api_service.dart';
import '../../widgets/chat_page.dart';

class DonorProfile extends ConsumerWidget {
  final Map<String, dynamic> participantData;

  const DonorProfile({
    super.key,
    required this.participantData,
  });

  Future<void> _acceptRequest(WidgetRef ref, BuildContext context) async {
    final AcceptDonorRequestService acceptDonorRequestService =
        AcceptDonorRequestService(ApiService(), ref);

    try {
      await acceptDonorRequestService.acceptRequest(participantData['id']);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(
                  receiverUserEmail: participantData['email'],
                  receiverUserID: participantData['donor_firebase_uid'],
                )),
      );
    } catch (error) {
      print('Error accepting request: $error');
    }
  }

  Future<void> _rejectRequest(WidgetRef ref) async {
    final AcceptDonorRequestService acceptDonorRequestService =
        AcceptDonorRequestService(ApiService(), ref);
    await acceptDonorRequestService.rejectRequest(participantData['id']);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Background(
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600;
          double containerWidth =
              isSmallScreen ? constraints.maxWidth * 0.9 : 600;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
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
                                participantData['full_name'] ?? "N/A",
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
                                participantData['email'] ?? "N/A",
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
                            "N/A",
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
                          Text(
                            'Gender',
                            style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 16,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(participantData['gender'] ?? "N/A",
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
                            '${participantData['age'] ?? 0}',
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
                        CustomRichText(
                            label: "Blood Group",
                            value: _getBloodGroup(participantData)),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomRichText(
                                label: "Donation Count",
                                value:
                                    "${participantData['blood_details'][0]['donation_count'] ?? 0}"),
                            const SizedBox(height: 8),
                            CustomRichText(
                              label: "Donated Quantity",
                              value:
                                  "${participantData['blood_details'][0]['donated_quantity'] ?? 0}",
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
                              index <
                                  (participantData['health_conditions'][0]
                                              ?.keys
                                              .toList() ??
                                          [])
                                      .length;
                              index++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (participantData['health_conditions'][0]
                                            ?.keys
                                            .toList() ??
                                        [])[index],
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),
                                  Container(
                                    width: isSmallScreen ? 60 : 70,
                                    height: isSmallScreen ? 18 : 22,
                                    decoration: BoxDecoration(
                                      color: _getHealthConditionColor(
                                          participantData['health_conditions']
                                                  [0]
                                              ?.values
                                              .elementAt(index)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      _getHealthConditionText(
                                          participantData['health_conditions']
                                                  [0]
                                              ?.values
                                              .elementAt(index)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _rejectRequest(ref),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFFD1A00),
                        ),
                        fixedSize: MaterialStateProperty.all<Size>(
                          isSmallScreen
                              ? Size(constraints.maxWidth * 0.4, 40.0)
                              : const Size(145.0, 40.0),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(8.0),
                      ),
                      child: Center(
                        child: Text(
                          'Reject Request',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _acceptRequest(ref, context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF99FDD2),
                        ),
                        fixedSize: MaterialStateProperty.all<Size>(
                          isSmallScreen
                              ? Size(constraints.maxWidth * 0.4, 40.0)
                              : const Size(145.0, 40.0),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        elevation: MaterialStateProperty.all<double>(8.0),
                      ),
                      child: Center(
                        child: Text(
                          'Accept Request',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getBloodGroup(Map<String, dynamic> data) {
    String? bloodGroupAbo = data['blood_details'][0]['blood_group_abo'];
    String? bloodGroupRh = data['blood_details'][0]['blood_group_rh'];

    return (bloodGroupAbo != null && bloodGroupRh != null)
        ? bloodGroupAbo + bloodGroupRh
        : 'N/A';
  }

  Color _getHealthConditionColor(dynamic value) {
    return value == 1 ? const Color(0xFF99FDD2) : Colors.red;
  }

  String _getHealthConditionText(dynamic value) {
    return value == true
        ? 'Yes'
        : value == false
            ? 'No'
            : 'N/A';
  }
}
