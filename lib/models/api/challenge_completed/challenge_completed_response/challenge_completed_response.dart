// To parse this JSON data, do
//
//     final challengeCompletedResponse = challengeCompletedResponseFromJson(jsonString);

import 'dart:convert';

import 'package:scavenger_hunt/models/api/challenge/challenge.dart';
import 'package:scavenger_hunt/models/api/challenge_completed/answer/answer.dart';

ChallengeCompletedResponse challengeCompletedResponseFromJson(String str) =>
    ChallengeCompletedResponse.fromJson(json.decode(str));

String challengeCompletedResponseToJson(ChallengeCompletedResponse data) =>
    json.encode(data.toJson());

class ChallengeCompletedResponse {
  final bool? success;
  final Data? data;
  final String? message;

  ChallengeCompletedResponse({
    this.success,
    this.data,
    this.message,
  });

  factory ChallengeCompletedResponse.fromJson(Map<String, dynamic> json) =>
      ChallengeCompletedResponse(
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
  final Challenge? challenge;
  final List<Answer>? answers;

  Data({
    this.challenge,
    this.answers,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        challenge: json["challenge"] == null
            ? null
            : Challenge.fromJson(json["challenge"]),
        answers: json["answers"] == null
            ? []
            : List<Answer>.from(
                json["answers"]!.map((x) => Answer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "challenge": challenge?.toJson(),
        "answers": answers == null
            ? []
            : List<dynamic>.from(answers!.map((x) => x.toJson())),
      };
}
