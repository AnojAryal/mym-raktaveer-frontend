import 'package:firebase_auth/firebase_auth.dart';

class BloodRequestModel {
  String patientName;
  String age;
  String sex;
  String hospitalName;
  String location;
  String roomNo;
  String opdNo;
  final String bloodGroupAbo;
  final String bloodGroupRh;
  String description;
  String urgencyLevel;
  String dateAndTime;
  String quantity;

  BloodRequestModel({
    required this.patientName,
    required this.age,
    required this.sex,
    required this.hospitalName,
    required this.location,
    required this.roomNo,
    required this.opdNo,
    required this.bloodGroupAbo,
    required this.bloodGroupRh,
    required this.description,
    required this.urgencyLevel,
    required this.dateAndTime,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    final currentUser = FirebaseAuth.instance.currentUser;
    final requestedBy = currentUser != null ? currentUser.uid : 'unknown';

    return {
      'requested_by': requestedBy,
      'patient_name': patientName,
      'age': age,
      'sex': sex,
      'hospital_name': hospitalName,
      'location_id': location,
      'room_no': roomNo,
      'opd_bed_no': opdNo,
      'blood_group_abo': bloodGroupAbo,
      'blood_group_rh': bloodGroupRh,
      'description': description,
      'urgency_level': urgencyLevel,
      'preferred_datetime': dateAndTime,
      'quantity': quantity,
    };
  }
}
