class CoachModel {
  final int coachID;
  final String coachName;
  final String coachImage;
  final String? coachVideo;
  final String coachPassword;
  final String? coachQuote;
  final String? coachJoinDate;
  final String? coachPlan;
  final String? coachPhone;
  final String? coachMail;
  final bool isVerified;
  final bool? isFeatured;
  final bool isVisible;
  const CoachModel(
      {required this.coachName,
      required this.coachPassword,
      required this.coachID,
      required this.coachImage,
      required this.isVisible,
      required this.isVerified,
      this.isFeatured = false,
      this.coachQuote,
      this.coachVideo,
      this.coachJoinDate,
      this.coachMail,
      this.coachPhone,
      this.coachPlan});
  static CoachModel fromJson(Map<String, dynamic> json) => CoachModel(
        coachID: json['id'] as int,
        coachName: json['coach_name'] as String,
        coachPassword: json['coach_password'] as String,
        coachImage: json['coach_image'] as String,
        coachVideo: json['coach_video'] as String?,
        coachQuote: json['coach_quote'] as String?,
        coachJoinDate: json['coach_joinDate'] as String?,
        coachPlan: json['coach_plan'] as String?,
        coachPhone: json['coach_phone'] as String?,
        coachMail: json['coach_email'] as String?,
        isFeatured: json['coach_isFeatured'] as bool,
        isVisible: json['coach_isVisible'] as bool,
        isVerified: json['coach_isVerified'] as bool,
      );
  Map<String, dynamic> toJson() => {
        'coach_name': coachName,
        'coach_password': coachPassword,
        'coach_image': coachImage,
        'coach_video': coachVideo,
        'coach_quote': coachQuote,
        'coach_joinDate': coachJoinDate,
        'coach_plan': coachPlan,
        'coach_phone': coachPhone,
        'coach_email': coachMail,
        'coach_isFeatured': isFeatured,
        'coach_isVisible': isVisible,
        'coach_isVerified': isVerified,
      };
}
