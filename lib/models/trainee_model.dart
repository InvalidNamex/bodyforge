class TraineeModel {
  final int? traineeID;
  final int coachID;
  final String traineeName;
  final String traineeGoal;
  final String traineeJoinDate;
  const TraineeModel(
      {this.traineeID,
      required this.coachID,
      required this.traineeName,
      required this.traineeGoal,
      required this.traineeJoinDate});
  static TraineeModel fromJson(Map<String, dynamic> json) => TraineeModel(
      traineeID: json['id'] as int?,
      coachID: json['coach'] as int,
      traineeName: json['trainee_name'] as String,
      traineeGoal: json['trainee_goal'] as String,
      traineeJoinDate: json['trainee_join_date'] as String);

  Map<String, dynamic> toJson() => {
        'coach': coachID,
        'trainee_name': traineeName,
        'trainee_goal': traineeGoal,
        'trainee_join_date': traineeJoinDate,
      };
}
