import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/models/authorization_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final userTypeProvider =
    StateNotifierProvider<UserTypeNotifier, AuthorizationModel?>((ref) {
  return UserTypeNotifier();
});

class UserTypeNotifier extends StateNotifier<AuthorizationModel?> {
  UserTypeNotifier() : super(null) {
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final personalDataJson = prefs.getString('personalData');
    if (personalDataJson != null) {
      final personalData =
          AuthorizationModel.fromJson(json.decode(personalDataJson));
      state = personalData;
    }
  }

  Future<void> setUserType(String userType) async {
    final personalData = AuthorizationModel(userType: userType);
    state = personalData;

    final prefs = await SharedPreferences.getInstance();
    final personalDataJson = json.encode(personalData.toJson());
    await prefs.setString('personalData', personalDataJson);
  }

  Future<void> clearUserType() async {
    state = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('personalData');
  }
}
