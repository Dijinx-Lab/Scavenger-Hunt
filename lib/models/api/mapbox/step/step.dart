import 'package:scavenger_hunt/models/api/mapbox/intersection/intersection.dart';
import 'package:scavenger_hunt/models/api/mapbox/maneuver/maneuver.dart';

class Step {
  final List<Intersection>? intersections;
  final Maneuver? maneuver;
  final String? name;
  final double? duration;
  final double? distance;
  final String? drivingSide;
  final double? weight;
  final String? mode;
  final String? geometry;

  Step({
    this.intersections,
    this.maneuver,
    this.name,
    this.duration,
    this.distance,
    this.drivingSide,
    this.weight,
    this.mode,
    this.geometry,
  });

  factory Step.fromJson(Map<String, dynamic> json) => Step(
        intersections: json["intersections"] == null
            ? []
            : List<Intersection>.from(
                json["intersections"]!.map((x) => Intersection.fromJson(x))),
        maneuver: json["maneuver"] == null
            ? null
            : Maneuver.fromJson(json["maneuver"]),
        name: json["name"],
        duration: json["duration"]?.toDouble(),
        distance: json["distance"]?.toDouble(),
        drivingSide: json["driving_side"],
        weight: json["weight"]?.toDouble(),
        mode: json["mode"],
        geometry: json["geometry"],
      );

  Map<String, dynamic> toJson() => {
        "intersections": intersections == null
            ? []
            : List<dynamic>.from(intersections!.map((x) => x.toJson())),
        "maneuver": maneuver?.toJson(),
        "name": name,
        "duration": duration,
        "distance": distance,
        "driving_side": drivingSide,
        "weight": weight,
        "mode": mode,
        "geometry": geometry,
      };
}
