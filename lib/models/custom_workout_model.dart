class CustomWorkoutModel {
  final int? id;
  final int? exerciseID;
  final int? coach;
  final String url;

  const CustomWorkoutModel({
    this.id,
    this.exerciseID,
    this.coach,
    required this.url,
  });
  static CustomWorkoutModel fromJson(Map<String, dynamic> json) =>
      CustomWorkoutModel(
        id: json['id'] as int?,
        exerciseID: json['exercise'] as int?,
        coach: json['coach'] as int?,
        url: json['url'] as String,
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'exercise': exerciseID,
        'coach': coach,
      };
}
