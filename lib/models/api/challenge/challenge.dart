class Challenge {
  final String? id;
  final String? name;
  final String? difficulty;
  final double? longitude;
  final double? latitude;
  final int? questions;
  final int? totalScore;
  final String? route;
  final String? description;

  Challenge({
    this.id,
    this.name,
    this.difficulty,
    this.longitude,
    this.latitude,
    this.questions,
    this.totalScore,
    this.route,
    this.description,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        id: json["_id"],
        name: json["name"],
        difficulty: json["difficulty"],
        longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
        questions: json["questions"],
        totalScore: json["total_score"],
        route: json["route"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "difficulty": difficulty,
        "longitude": longitude,
        "latitude": latitude,
        "questions": questions,
        "total_score": totalScore,
        "route": route,
        "description": description,
      };
}
