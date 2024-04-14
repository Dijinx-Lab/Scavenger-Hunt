// To parse this JSON data, do
//
//     final questionsResponse = questionsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:scavenger_hunt/models/api/question/question/question.dart';

QuestionsResponse questionsResponseFromJson(String str) =>
    QuestionsResponse.fromJson(json.decode(str));

String questionsResponseToJson(QuestionsResponse data) =>
    json.encode(data.toJson());

class QuestionsResponse {
  final bool? success;
  final Data? data;
  final String? message;

  QuestionsResponse({
    this.success,
    this.data,
    this.message,
  });

  factory QuestionsResponse.fromJson(Map<String, dynamic> json) =>
      QuestionsResponse(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  final List<Question>? questions;

  Data({
    this.questions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        questions: json["questions"] == null
            ? []
            : List<Question>.from(
                json["questions"]!.map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "questions": questions == null
            ? []
            : List<dynamic>.from(questions!.map((x) => x.toJson())),
      };
}
