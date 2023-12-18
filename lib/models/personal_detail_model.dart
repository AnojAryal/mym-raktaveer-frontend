class PersonalDetailModel {
  final String? bloodGroupAbo;
  final String? bloodGroupRh;
  final DateTime? lastDonationDate;
  final DateTime? lastDonationReceived;
  final Map<String, bool>? healthConditions;

  PersonalDetailModel({
    this.bloodGroupAbo,
    this.bloodGroupRh,
    this.lastDonationDate,
    this.lastDonationReceived,
    this.healthConditions,
  });

  PersonalDetailModel copyWith({
    String? bloodGroupAbo,
    String? bloodGroupRh,
    DateTime? lastDonationDate,
    DateTime? lastDonationReceived,
    Map<String, bool>? healthConditions,
  }) {
    return PersonalDetailModel(
      bloodGroupAbo: bloodGroupAbo ?? this.bloodGroupAbo,
      bloodGroupRh: bloodGroupRh ?? this.bloodGroupRh,
      lastDonationDate: lastDonationDate ?? this.lastDonationDate,
      lastDonationReceived: lastDonationReceived ?? this.lastDonationReceived,
      healthConditions: healthConditions ?? this.healthConditions,
    );
  }
}
