// To parse this JSON data, do
//
//     final teamListResponse = teamListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:scavenger_hunt/models/api/team/team/team.dart';

TeamListResponse teamListResponseFromJson(String str) =>
    TeamListResponse.fromJson(json.decode(str));

String teamListResponseToJson(TeamListResponse data) =>
    json.encode(data.toJson());

class TeamListResponse {
  final bool? success;
  final Data? data;
  final String? message;

  TeamListResponse({
    this.success,
    this.data,
    this.message,
  });

  factory TeamListResponse.fromJson(Map<String, dynamic> json) =>
      TeamListResponse(
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
  final List<Team>? teams;

  Data({
    this.teams,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        teams: json["teams"] == null
            ? []
            : List<Team>.from(json["teams"]!.map((x) => Team.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "teams": teams == null
            ? []
            : List<dynamic>.from(teams!.map((x) => x.toJson())),
      };
}