class ExerciseModel {
  final int? exerciseID;
  final String category;
  final String exercise;
  final String url;

  const ExerciseModel({
    this.exerciseID,
    required this.category,
    required this.exercise,
    required this.url,
  });
  static ExerciseModel fromJson(Map<String, dynamic> json) => ExerciseModel(
        exerciseID: json['id'] as int?,
        category: json['category'] as String,
        exercise: json['exercise'] as String,
        url: json['url'] as String,
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'url': url,
        'exercise': exercise,
      };
}
