import 'package:scavenger_hunt/models/api/challenge_completed/answer/answer.dart';

class Question {
  final String? id;
  final int? score;
  final String? type;
  final String? question;
  final String? picture;
  final List<dynamic>? options;
  final int? sliderMin;
  final int? sliderMax;
  final int? jumbledWord;
  final String? challenge;
  final dynamic answer;
  Answer? submittedAnswer;

  Question(
      {this.id,
      this.score,
      this.type,
      this.question,
      this.picture,
      this.options,
      this.sliderMin,
      this.sliderMax,
      this.jumbledWord,
      this.challenge,
      this.answer,
      this.submittedAnswer});

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["_id"],
        score: json["score"],
        type: json["type"],
        question: json["question"],
        picture: json["picture"],
        options: json["options"] == null
            ? []
            : List<dynamic>.from(json["options"]!.map((x) => x)),
        sliderMin: json["slider_min"],
        sliderMax: json["slider_max"],
        jumbledWord: json["jumbled_word"],
        challenge: json["challenge"],
        answer: json["answer"],
        submittedAnswer: json["submitted_answer"] == null
            ? null
            : Answer.fromJson(json["submitted_answer"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "score": score,
        "type": type,
        "question": question,
        "picture": picture,
        "options":
            options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
        "slider_min": sliderMin,
        "slider_max": sliderMax,
        "jumbled_word": jumbledWord,
        "challenge": challenge,
        "answer": answer,
        "submitted_answer": submittedAnswer,
      };
}
