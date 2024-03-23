// To parse this JSON data, do
//
//     final mapBoxDirection = mapBoxDirectionFromJson(jsonString);

import 'dart:convert';

import 'package:scavenger_hunt/models/api/mapbox/route/route.dart';
import 'package:scavenger_hunt/models/api/mapbox/waypoint/waypoint.dart';

MapBoxDirection mapBoxDirectionFromJson(String str) =>
    MapBoxDirection.fromJson(json.decode(str));

String mapBoxDirectionToJson(MapBoxDirection data) =>
    json.encode(data.toJson());

class MapBoxDirection {
  final List<Route>? routes;
  final List<Waypoint>? waypoints;
  final String? code;
  final String? uuid;

  MapBoxDirection({
    this.routes,
    this.waypoints,
    this.code,
    this.uuid,
  });

  factory MapBoxDirection.fromJson(Map<String, dynamic> json) =>
      MapBoxDirection(
        routes: json["routes"] == null
            ? []
            : List<Route>.from(json["routes"]!.map((x) => Route.fromJson(x))),
        waypoints: json["waypoints"] == null
            ? []
            : List<Waypoint>.from(
                json["waypoints"]!.map((x) => Waypoint.fromJson(x))),
        code: json["code"],
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "routes": routes == null
            ? []
            : List<dynamic>.from(routes!.map((x) => x.toJson())),
        "waypoints": waypoints == null
            ? []
            : List<dynamic>.from(waypoints!.map((x) => x.toJson())),
        "code": code,
        "uuid": uuid,
      };
}
