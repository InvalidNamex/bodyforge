class AppModel {
  final int appID;
  final String appName;
  final String appImage;
  final String androidUrl;
  final String iosUrl;
  const AppModel({
    required this.appName,
    required this.appImage,
    required this.appID,
    required this.androidUrl,
    required this.iosUrl,
  });
  static AppModel fromJson(Map<String, dynamic> json) => AppModel(
        appImage: json['app_image'] as String,
        appID: json['id'] as int,
        appName: json['app_name'] as String,
        androidUrl: json['android_url'] as String,
        iosUrl: json['ios_url'] as String,
      );
}
