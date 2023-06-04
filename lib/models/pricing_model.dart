class PricingModel {
  final int? planID;
  final int coachID;
  final String? planText;
  final String? planImage;
  final String? planName;
  final String? planTitle;
  final int? planPrice;
  const PricingModel({
    this.planID,
    required this.coachID,
    this.planText,
    this.planTitle,
    this.planName,
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
        planName: json['plan-name'] as String?,
      );
  Map<String, dynamic> toJson() => {
        'coach-id': coachID,
        'plan-name': planName,
        'plan-title': planTitle,
        'plan-text': planText,
        'plan-price': planPrice,
        'plan-image': planImage,
      };
}
