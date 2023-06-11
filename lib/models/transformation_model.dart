class TransformationModel {
  final int? transformationID;
  final int coachID;
  final String? before;
  final String? name;
  final String? after;
  const TransformationModel({
    this.transformationID,
    required this.coachID,
    this.before,
    this.name,
    this.after,
  });
  static TransformationModel fromJson(Map<String, dynamic> json) =>
      TransformationModel(
        transformationID: json['id'] as int?,
        coachID: json['coach-id'] as int,
        before: json['before'] as String?,
        name: json['name'] as String?,
        after: json['after'] as String?,
      );
  Map<String, dynamic> toJson() => {
        'coach-id': coachID,
        'before': before,
        'name': name,
        'after': after,
      };
}
