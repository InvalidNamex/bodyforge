class AdBannerModel {
  final int? bannerID;
  final String? bannerImage;
  final String? bannerURL;

  const AdBannerModel({
    this.bannerID,
    this.bannerImage,
    this.bannerURL,
  });
  static AdBannerModel fromJson(Map<String, dynamic> json) => AdBannerModel(
        bannerID: json['id'] as int,
        bannerImage: json['banner_image'] as String,
        bannerURL: json['banner_url'] as String?,
      );
}
