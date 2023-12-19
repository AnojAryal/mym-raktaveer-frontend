import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/blood_request_model.dart';


class BloodRequestService {
  Future<void> sendDataToBackend(BloodRequestModel requestData) async {
    final response = await http.post(
      Uri.parse('https://71f9-2400-1a00-b030-d590-dedf-3b84-2bdc-7c0e.ngrok-free.app/api/blood-donation-request'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestData.toJson()),
    );

    if (response.statusCode == 200) {
      print('Request sent successfully');
    } else {
      print('Failed to send request. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
