import 'package:http/http.dart' as http;
import 'api_service.dart'; 
import '../models/blood_request_model.dart';

class BloodRequestService {
  final String baseUrl;

  // Inject ApiService into BloodRequestService
  BloodRequestService(ApiService apiService) : baseUrl = apiService.baseUrl ?? '';

  Future<void> sendDataToBackend(BloodRequestModel requestData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/blood-donation-request'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Request sent successfully');
    } else {
      print('Failed to send request. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
