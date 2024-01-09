class AuthorizationModel {
  final String userType;

  AuthorizationModel({
    required this.userType,
  });

  Map<String, dynamic> toJson() => {
        'user_type': userType,
      };

  factory AuthorizationModel.fromJson(Map<String, dynamic> json) {
    return AuthorizationModel(
      userType: json['user_type'] as String,
    );
  }
}
