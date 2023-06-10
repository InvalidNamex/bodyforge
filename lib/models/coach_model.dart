class CoachModel {
  final int coachID;
  final String coachName;
  final String coachImage;
  final String coachPassword;
  final String? coachQuote;
  final bool? isFeatured;
  final bool isVisible;
  const CoachModel({
    required this.coachName,
    required this.coachPassword,
    required this.coachID,
    required this.coachImage,
    required this.isVisible,
    this.isFeatured = false,
    this.coachQuote,
  });
  static CoachModel fromJson(Map<String, dynamic> json) => CoachModel(
        coachImage: json['coach_image'] as String,
        coachID: json['id'] as int,
        coachName: json['coach_name'] as String,
        coachPassword: json['coach_password'] as String,
        coachQuote: json['coach_quote'] as String?,
        isFeatured: json['coach_isFeatured'] as bool,
        isVisible: json['coach_isVisible'] as bool,
      );
}
