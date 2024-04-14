// To parse this JSON data, do
//
//     final routeResponse = routeResponseFromJson(jsonString);

import 'dart:convert';

import 'package:scavenger_hunt/models/api/route/route/route.dart';

RouteResponse routeResponseFromJson(String str) =>
    RouteResponse.fromJson(json.decode(str));

String routeResponseToJson(RouteResponse data) => json.encode(data.toJson());

class RouteResponse {
  final bool? success;
  final Data? data;
  final String? message;

  RouteResponse({
    this.success,
    this.data,
    this.message,
  });

  factory RouteResponse.fromJson(Map<String, dynamic> json) => RouteResponse(
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
  final RouteDetails? route;

  Data({
    this.route,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        route:
            json["route"] == null ? null : RouteDetails.fromJson(json["route"]),
      );

  Map<String, dynamic> toJson() => {
        "route": route?.toJson(),
      };
}
