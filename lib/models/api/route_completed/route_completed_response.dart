// To parse this JSON data, do
//
//     final routeCompletedResponse = routeCompletedResponseFromJson(jsonString);

import 'dart:convert';

RouteCompletedResponse routeCompletedResponseFromJson(String str) =>
    RouteCompletedResponse.fromJson(json.decode(str));

String routeCompletedResponseToJson(RouteCompletedResponse data) =>
    json.encode(data.toJson());

class RouteCompletedResponse {
  final bool? success;
  final Data? data;
  final String? message;

  RouteCompletedResponse({
    this.success,
    this.data,
    this.message,
  });

  factory RouteCompletedResponse.fromJson(Map<String, dynamic> json) =>
      RouteCompletedResponse(
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
  final String? id;
  final String? introVideo;
  final int? totalTime;
  final double? finishLineLat;
  final double? finishLineLong;
  final double? timeTaken;
  final int? completedChallenges;
  final int? totalChallenges;
  final int? totalQuestions;
  final int? answeredQuestions;
  final int? totalScore;

  Data({
    this.id,
    this.introVideo,
    this.totalTime,
    this.finishLineLat,
    this.finishLineLong,
    this.timeTaken,
    this.completedChallenges,
    this.totalChallenges,
    this.totalQuestions,
    this.answeredQuestions,
    this.totalScore,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        introVideo: json["intro_video"],
        totalTime: json["total_time"],
        finishLineLat: json["finish_line_lat"]?.toDouble(),
        finishLineLong: json["finish_line_long"]?.toDouble(),
        timeTaken: json["time_taken"]?.toDouble(),
        completedChallenges: json["completed_challenges"],
        totalChallenges: json["total_challenges"],
        totalQuestions: json["total_questions"],
        answeredQuestions: json["answered_questions"],
        totalScore: json["total_score"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "intro_video": introVideo,
        "total_time": totalTime,
        "finish_line_lat": finishLineLat,
        "finish_line_long": finishLineLong,
        "time_taken": timeTaken,
        "completed_challenges": completedChallenges,
        "total_challenges": totalChallenges,
        "total_questions": totalQuestions,
        "answered_questions": answeredQuestions,
        "total_score": totalScore,
      };
}
