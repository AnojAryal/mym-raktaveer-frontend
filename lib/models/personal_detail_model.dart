class PersonalDetailModel {
  PersonalDetailModel({
    this.bloodGroupAbo,
    this.bloodGroupRh,
    this.lastDonationDate,
    this.lastDonationReceived,
    this.healthConditions,
  });

  String? bloodGroupAbo;
  String? bloodGroupRh;
  DateTime? lastDonationDate;
  DateTime? lastDonationReceived;
  Map<String, bool>? healthConditions;
}
