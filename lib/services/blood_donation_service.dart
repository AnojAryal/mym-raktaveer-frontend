import 'dart:convert';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mym_raktaveer_frontend/models/personal_detail_model.dart';

class BloodDonationService {
  Future<void> sendPersonalDataToApi(
      String? userUid, PersonalDetailModel personalDetailModel) async {
    String? baseUrl = dotenv.env['BASE_URL'];
    String? apiUrl = '$baseUrl/api/personal-details';

    final personalData = {
      'blood_group_abo': personalDetailModel.bloodGroupAbo,
      'blood_group_rh': personalDetailModel.bloodGroupRh,
      'user_id': userUid,
      if (personalDetailModel.lastDonationDate != null)
        'last_donation_date': personalDetailModel.lastDonationDate,
      if (personalDetailModel.lastDonationReceived != null)
        'last_donation_received': personalDetailModel.lastDonationReceived,
      ...?personalDetailModel.healthConditions,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(personalData),
      );

      if (response.statusCode == 201) {
        print('User created successfully');
        print('Response: ${response.body}');
      } else {
        print(
          'Failed to create user. Status code: ${response.statusCode} data : $personalData',
        );
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error creating user: $error');
      print(personalData);
    }
  }

  void updateModelAndNavigate(
    PersonalDetailModel personalDetailModel,
    List<bool> isCheckedList,
    BuildContext context,
  ) {}
}
