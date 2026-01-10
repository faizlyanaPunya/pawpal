class Donation {
  String? donationId;
  String? userId;
  String? petId;
  String? petName;
  String? donationType;
  String? donationDescription;
  String? donationDate;
  int? amountCents;

  Donation({
    this.donationId,
    this.userId,
    this.petId,
    this.petName,
    this.donationType,
    this.donationDescription,
    this.donationDate,
    this.amountCents,
  });

  Donation.fromJson(Map<String, dynamic> json) {
    donationId = json['donation_id'];
    userId = json['user_id'];
    petId = json['pet_id'];
    petName = json['pet_name'];
    donationType = json['donation_type'];
    donationDescription = json['donation_description'];
    donationDate = json['donation_date'];
    amountCents = json['amount'] != null ? int.tryParse(json['amount'].toString()) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['donation_id'] = donationId;
    data['user_id'] = userId;
    data['pet_id'] = petId;
    data['pet_name'] = petName;
    data['donation_type'] = donationType;
    data['donation_description'] = donationDescription;
    data['donation_date'] = donationDate;
    data['amount'] = amountCents;
    return data;
  }
}