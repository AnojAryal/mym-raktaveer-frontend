import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/models/user_data_model.dart';

final userDataProvider =
    StateNotifierProvider<UserDataNotifier, UserData?>((ref) {
  return UserDataNotifier();
});

class UserDataNotifier extends StateNotifier<UserData?> {
  UserDataNotifier() : super(null);

  void setUserData(String? uid, String? accessToken) {
    print(uid);
    state = UserData(
      uid: uid,
      acessToken: accessToken,
    );
  }

  void clearUserData() {
    state = null;
  }
}
