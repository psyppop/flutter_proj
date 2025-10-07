class MatchModel {
  final String id;
  final String userId;
  final String roommateId;
  final DateTime matchedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  MatchModel({
    required this.id,
    required this.userId,
    required this.roommateId,
    required this.matchedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'roommateId': roommateId,
    'matchedAt': matchedAt.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory MatchModel.fromJson(Map<String, dynamic> json) => MatchModel(
    id: json['id'] as String,
    userId: json['userId'] as String,
    roommateId: json['roommateId'] as String,
    matchedAt: DateTime.parse(json['matchedAt'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  MatchModel copyWith({
    String? id,
    String? userId,
    String? roommateId,
    DateTime? matchedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MatchModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    roommateId: roommateId ?? this.roommateId,
    matchedAt: matchedAt ?? this.matchedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
