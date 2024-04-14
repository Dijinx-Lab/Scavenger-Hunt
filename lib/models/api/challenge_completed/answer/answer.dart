class Answer {
   final String? id;
  final dynamic answer;
  final String? teamCode;
  final int? score;
  final bool? isCorrect;
  final String? question;
  final DateTime? createdOn;
  final dynamic deletedOn;
  final String? challengeId;

  Answer({
    this.id,
    this.answer,
    this.teamCode,
    this.score,
    this.isCorrect,
    this.question,
    this.createdOn,
    this.deletedOn,
    this.challengeId,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json["_id"],
        answer: json["answer"],
        teamCode: json["team_code"],
        score: json["score"],
        isCorrect: json["is_correct"],
        question: json["question"],
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        deletedOn: json["deleted_on"],
        challengeId: json["challengeId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "answer": answer,
        "team_code": teamCode,
        "score": score,
        "is_correct": isCorrect,
        "question": question,
        "created_on": createdOn?.toIso8601String(),
        "deleted_on": deletedOn,
        "challengeId": challengeId,
      };
}
