import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/models/user_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final userDataProvider =
    StateNotifierProvider<UserDataNotifier, UserData?>((ref) {
  return UserDataNotifier();
});

class UserDataNotifier extends StateNotifier<UserData?> {
  UserDataNotifier() : super(null) {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('userData');
    if (userDataJson != null) {
      final userData = UserData.fromJson(json.decode(userDataJson));
      state = userData;
    }
  }

  Future<void> setUserData(String? uid, String? accessToken) async {
    final userData = UserData(uid: uid, accessToken: accessToken);
    state = userData;

    final prefs = await SharedPreferences.getInstance();
    final userDataJson = json.encode(userData.toJson());
    await prefs.setString('userData', userDataJson);
  }

  Future<void> clearUserData() async {
    state = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
  }
}
