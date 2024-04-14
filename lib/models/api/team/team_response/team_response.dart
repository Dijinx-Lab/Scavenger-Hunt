// To parse this JSON data, do
//
//     final teamResponse = teamResponseFromJson(jsonString);

import 'dart:convert';

import 'package:scavenger_hunt/models/api/team/team/team.dart';

TeamResponse teamResponseFromJson(String str) =>
    TeamResponse.fromJson(json.decode(str));

String teamResponseToJson(TeamResponse data) => json.encode(data.toJson());

class TeamResponse {
  final bool? success;
  final Data? data;
  final String? message;

  TeamResponse({
    this.success,
    this.data,
    this.message,
  });

  factory TeamResponse.fromJson(Map<String, dynamic> json) => TeamResponse(
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
  final Team? team;

  Data({
    this.team,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        team: json["team"] == null ? null : Team.fromJson(json["team"]),
      );

  Map<String, dynamic> toJson() => {
        "team": team?.toJson(),
      };
}
