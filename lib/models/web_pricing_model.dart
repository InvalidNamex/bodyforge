class WebPricingModel {
  final String planText;
  final String planName;
  final String planTitle;
  final int planPrice;
  const WebPricingModel({
    required this.planText,
    required this.planTitle,
    required this.planName,
    required this.planPrice,
  });
  static WebPricingModel fromJson(Map<String, dynamic> json) => WebPricingModel(
        planText: json['plan-text'] as String,
        planTitle: json['plan-title'] as String,
        planPrice: json['plan-price'] as int,
        planName: json['plan-name'] as String,
      );
}
