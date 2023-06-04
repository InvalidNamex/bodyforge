class TransformationModel {
  final int transformationID;
  final int coachID;
  final String before;
  final String? name;
  final String after;
  const TransformationModel({
    required this.transformationID,
    required this.coachID,
    required this.before,
    this.name,
    required this.after,
  });
  static TransformationModel fromJson(Map<String, dynamic> json) =>
      TransformationModel(
        transformationID: json['id'] as int,
        coachID: json['coach-id'] as int,
        before: json['before'] as String,
        name: json['name'] as String?,
        after: json['after'] as String,
      );
}
