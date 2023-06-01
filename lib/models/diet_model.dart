class DietModel {
  final int? dietID;
  final int coach;
  final int mealOrder;
  final int trainee;
  final int day;
  final String title;
  final String desc;
  const DietModel({
    this.dietID,
    required this.coach,
    required this.trainee,
    required this.day,
    required this.mealOrder,
    required this.title,
    required this.desc,
  });
  static DietModel fromJson(Map<String, dynamic> json) => DietModel(
        dietID: json['id'] as int?,
        coach: json['coach-id'] as int,
        trainee: json['trainee'] as int,
        day: json['day'] as int,
        mealOrder: json['mealOrder'] as int,
        title: json['title'] as String,
        desc: json['desc'] as String,
      );

  Map<String, dynamic> toJson() => {
        'coach-id': coach,
        'trainee': trainee,
        'mealOrder': mealOrder,
        'day': day,
        'title': title,
        'desc': desc,
      };
}
