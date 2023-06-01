class WorkoutModel {
  final int? workoutID;
  final int coach;
  final int exerciseOrder;
  final int trainee;
  final int day;
  final String title;
  final String desc;
  final String url;
  const WorkoutModel({
    this.workoutID,
    required this.coach,
    required this.trainee,
    required this.day,
    required this.exerciseOrder,
    required this.title,
    required this.desc,
    required this.url,
  });
  static WorkoutModel fromJson(Map<String, dynamic> json) => WorkoutModel(
        workoutID: json['id'] as int?,
        coach: json['coach-id'] as int,
        trainee: json['trainee'] as int,
        day: json['day'] as int,
        exerciseOrder: json['exerciseOrder'] as int,
        title: json['title'] as String,
        desc: json['desc'] as String,
        url: json['url'] as String,
      );

  Map<String, dynamic> toJson() => {
        'coach-id': coach,
        'trainee': trainee,
        'exerciseOrder': exerciseOrder,
        'day': day,
        'title': title,
        'desc': desc,
        'url': url,
      };
}
