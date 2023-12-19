class BloodRequestModel {
  String patientName;
  String age;
  String sex;
  String hospitalName;
  String location;
  String roomNo;
  String opdNo;
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
    required this.description,
    required this.urgencyLevel,
    required this.dateAndTime,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientName': patientName,
      'age': age,
      'sex': sex,
      'hospitalName': hospitalName,
      'location': location,
      'roomNo': roomNo,
      'opdNo': opdNo,
      'description': description,
      'urgencyLevel': urgencyLevel,
      'dateAndTime': dateAndTime,
      'quantity': quantity,
    };
  }
}
