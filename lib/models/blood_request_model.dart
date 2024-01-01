import 'package:firebase_auth/firebase_auth.dart';
import 'package:mym_raktaveer_frontend/models/user_model.dart';

class BloodRequestModel {
  final int? id;
  String patientName;
  String age;
  String sex;
  String hospitalName;
  String location;
  String roomNo;
  String opdNo;
  final String bloodGroupAbo;
  final String bloodGroupRh;
  final String filePath;
  String description;
  String urgencyLevel;
  String dateAndTime;
  String quantity;
  final UserModel? user;
  String? status;

  BloodRequestModel({
    this.id,
    required this.patientName,
    required this.age,
    required this.sex,
    required this.hospitalName,
    required this.location,
    required this.roomNo,
    required this.opdNo,
    required this.bloodGroupAbo,
    required this.bloodGroupRh,
    this.filePath = '',
    required this.description,
    required this.urgencyLevel,
    required this.dateAndTime,
    required this.quantity,
    this.user,
    this.status,
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
      'document_path': filePath,
      'description': description,
      'urgency_level': urgencyLevel,
      'preferred_datetime': dateAndTime,
      'quantity': quantity,
      'status' : status,
    };
  }

  factory BloodRequestModel.fromJson(Map<String, dynamic> json) {
    return BloodRequestModel(
      id: json['id'] as int,
      patientName: json['patient_name'] as String,
      age: json['age'].toString(),
      sex: json['sex'] as String,
      hospitalName: json['hospital_name'] as String,
      location: json['location_id'].toString(),
      roomNo: json['room_no'] as String,
      opdNo: json['opd_bed_no'] as String,
      bloodGroupAbo: json['blood_group_abo'] as String,
      bloodGroupRh: json['blood_group_rh'] as String,
      filePath: json['document_path'] as String? ?? '',
      description: json['description'] as String,
      urgencyLevel: json['urgency_level'] as String,
      dateAndTime: json['preferred_datetime'] as String,
      quantity: json['quantity'].toString(),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      status: json['status'] as String,
    );
  }
}
