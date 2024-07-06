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
  final String? introUrl;

  Challenge(
      {this.id,
      this.name,
      this.difficulty,
      this.longitude,
      this.latitude,
      this.questions,
      this.totalScore,
      this.route,
      this.description,
      this.introUrl});

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        id: json["_id"],
        name: json["name"],
        difficulty: json["difficulty"],
        longitude:
            json["longitude"] != null ? double.parse(json["longitude"]) : null,
        latitude:
            json["latitude"] != null ? double.parse(json["latitude"]) : null,
        questions: json["questions"],
        totalScore: json["total_score"],
        route: json["route"],
        description: json["description"],
        introUrl: json["intro_url"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "difficulty": difficulty,
        "longitude": longitude?.toString(),
        "latitude": latitude?.toString(),
        "questions": questions,
        "total_score": totalScore,
        "route": route,
        "description": description,
        "intro_url": introUrl
      };
}
