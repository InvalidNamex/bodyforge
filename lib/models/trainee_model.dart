class TraineeModel {
  final int? traineeID;
  final int coachID;
  final String traineeName;
  final String traineeGoal;
  final String traineeJoinDate;
  final String? inbody;
  final String? image;
  final String? pFood;
  final String? dFood;
  final String? phone;
  final String? dailyActivity;
  final String? email;
  final String? password;
  final String? plan;
  final String? healthIssues;
  final bool? isVerified;
  const TraineeModel(
      {required this.coachID,
      required this.traineeName,
      required this.traineeGoal,
      required this.traineeJoinDate,
      this.traineeID,
      this.isVerified = false,
      this.phone,
      this.image,
      this.password,
      this.dailyActivity,
      this.dFood,
      this.email,
      this.healthIssues,
      this.inbody,
      this.pFood,
      this.plan});
  static TraineeModel fromJson(Map<String, dynamic> json) => TraineeModel(
        traineeID: json['id'] as int?,
        coachID: json['coach'] as int,
        traineeName: json['trainee_name'] as String,
        traineeGoal: json['trainee_goal'] as String,
        traineeJoinDate: json['trainee_join_date'] as String,
        inbody: json['trainee_inbody'] as String?,
        image: json['trainee_image'] as String?,
        pFood: json['trainee_pFood'] as String?,
        dFood: json['trainee_dFood'] as String?,
        phone: json['trainee_Phone'] as String?,
        dailyActivity: json['trainee_dailyActivity'] as String?,
        healthIssues: json['trainee_healthIssues'] as String?,
        email: json['trainee_email'] as String?,
        password: json['trainee_password'] as String?,
        plan: json['trainee_plan'] as String?,
        isVerified: json['trainee_isVerified'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'coach': coachID,
        'trainee_name': traineeName,
        'trainee_goal': traineeGoal,
        'trainee_join_date': traineeJoinDate,
        'trainee_inbody': inbody,
        'trainee_image': image,
        'trainee_phone': phone,
        'trainee_email': email,
        'trainee_password': password,
        'trainee_pFood': pFood,
        'trainee_dFood': dFood,
        'trainee_dailyActivity': dailyActivity,
        'trainee_healthIssues': healthIssues,
        'trainee_plan': plan,
        'trainee_isVerified': isVerified,
      };
}
