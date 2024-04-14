// To parse this JSON data, do
//
//     final routesResponse = routesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:scavenger_hunt/models/api/route/route/route.dart';

RoutesResponse routesResponseFromJson(String str) =>
    RoutesResponse.fromJson(json.decode(str));

String routesResponseToJson(RoutesResponse data) => json.encode(data.toJson());

class RoutesResponse {
  final bool? success;
  final Data? data;
  final String? message;

  RoutesResponse({
    this.success,
    this.data,
    this.message,
  });

  factory RoutesResponse.fromJson(Map<String, dynamic> json) => RoutesResponse(
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
  final List<RouteDetails>? routes;

  Data({
    this.routes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        routes: json["routes"] == null
            ? []
            : List<RouteDetails>.from(json["routes"]!.map((x) => RouteDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "routes": routes == null
            ? []
            : List<dynamic>.from(routes!.map((x) => x.toJson())),
      };
}
