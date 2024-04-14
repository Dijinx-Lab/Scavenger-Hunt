import 'dart:convert';

import 'package:scavenger_hunt/models/api/challenge_completed/answer/answer.dart';

AnswerResponse answerResponseFromJson(String str) =>
    AnswerResponse.fromJson(json.decode(str));

String answerResponseToJson(AnswerResponse data) => json.encode(data.toJson());

class AnswerResponse {
  final bool? success;
  final Data? data;
  final String? message;

  AnswerResponse({
    this.success,
    this.data,
    this.message,
  });

  factory AnswerResponse.fromJson(Map<String, dynamic> json) => AnswerResponse(
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
  final Answer? answer;

  Data({
    this.answer,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        answer: json["answer"] == null ? null : Answer.fromJson(json["answer"]),
      );

  Map<String, dynamic> toJson() => {
        "answer": answer?.toJson(),
      };
}
