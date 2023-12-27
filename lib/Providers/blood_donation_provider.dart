import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/models/personal_detail_model.dart';



final personalDetailProvider = StateNotifierProvider<PersonalDetailNotifier, PersonalDetailModel>((ref) {
  return PersonalDetailNotifier();
});


class PersonalDetailNotifier extends StateNotifier<PersonalDetailModel> {
  PersonalDetailNotifier() : super(PersonalDetailModel());

  void updateBloodType(String bloodType) {
    state = state.copyWith(bloodGroupAbo: bloodType);
  }

  void updateRhFactor(String rhFactor) {
    state = state.copyWith(bloodGroupRh: rhFactor);
  }

  void updateDonationDetails(DateTime? donationDate, DateTime? receivedDate) {
    state = state.copyWith(
        lastDonationDate: donationDate, lastDonationReceived: receivedDate);
  }

  void updateHealthConditions(Map<String, bool> conditions) {
    state = state.copyWith(healthConditions: conditions);
    print(state.healthConditions);
  }
}
