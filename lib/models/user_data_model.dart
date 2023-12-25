class UserData {
  final String? uid;
  final String? accessToken;

  UserData({this.uid, this.accessToken});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'accessToken': accessToken,
      };

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        uid: json['uid'] as String?,
        accessToken: json['accessToken'] as String?,
      );
}
