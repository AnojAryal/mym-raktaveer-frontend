class UserModel {
  final String fullName;
  final String mobileNumber;
  final String gender;
  final int age;
  final String email;

  UserModel({
    required this.fullName,
    required this.mobileNumber,
    required this.gender,
    required this.age,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'mobile_numer': mobileNumber,
        'gender': gender,
        'age': age,
        'email': email,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['full_name'] as String,
      mobileNumber: json['mobile_number'] as String,
      gender: json['gender'] as String,
      age: json['age'] as int,
      email: json['email'] as String,
    );
  }
}
