class PricingModel {
  final int planID;
  final int coachID;
  final String? planText;
  final String? planImage;
  final String planName;
  final String? planTitle;
  final int? planPrice;
  const PricingModel({
    required this.planID,
    required this.coachID,
    this.planText,
    this.planTitle,
    required this.planName,
    this.planImage,
    this.planPrice,
  });
  static PricingModel fromJson(Map<String, dynamic> json) => PricingModel(
        planID: json['id'] as int,
        coachID: json['coach-id'] as int,
        planText: json['plan-text'] as String?,
        planTitle: json['plan-title'] as String?,
        planImage: json['plan-image'] as String?,
        planPrice: json['plan-price'] as int?,
        planName: json['plan-name'] as String,
      );
}
