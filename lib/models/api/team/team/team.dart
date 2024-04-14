class Team {
  final String? id;
  final String? name;
  final String? teamCode;
  final int? score;
  final String? activeChallenge;
  final List<dynamic>? completedChallenges;

  Team({
    this.id,
    this.name,
    this.teamCode,
    this.score,
    this.activeChallenge,
    this.completedChallenges,
  });

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json["_id"],
        name: json["name"],
        teamCode: json["team_code"],
        score: json["score"],
        activeChallenge: json["active_challenge"],
        completedChallenges: json["completed_challenges"] == null
            ? []
            : List<dynamic>.from(json["completed_challenges"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "team_code": teamCode,
        "score": score,
        "active_challenge": activeChallenge,
        "completed_challenges": completedChallenges == null
            ? []
            : List<dynamic>.from(completedChallenges!.map((x) => x)),
      };
}
