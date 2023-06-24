class WebPricingModel {
  final int planID;
  final String planText;
  final String planName;
  final String planTitle;
  final int planPrice;
  final int planPriceUSD;
  const WebPricingModel({
    required this.planID,
    required this.planText,
    required this.planTitle,
    required this.planName,
    required this.planPrice,
    required this.planPriceUSD,
  });
  static WebPricingModel fromJson(Map<String, dynamic> json) => WebPricingModel(
        planID: json['id'] as int,
        planText: json['plan_text'] as String,
        planTitle: json['plan_title'] as String,
        planPrice: json['plan_price'] as int,
        planPriceUSD: json['plan_priceUSD'] as int,
        planName: json['plan_name'] as String,
      );
}
