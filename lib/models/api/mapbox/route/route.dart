import 'package:scavenger_hunt/models/api/mapbox/leg/leg.dart';

class Route {
  final String? weightName;
  final double? weight;
  final double? duration;
  final double? distance;
  final List<Leg>? legs;
  final String? geometry;

  Route({
    this.weightName,
    this.weight,
    this.duration,
    this.distance,
    this.legs,
    this.geometry,
  });

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        weightName: json["weight_name"],
        weight: json["weight"]?.toDouble(),
        duration: json["duration"]?.toDouble(),
        distance: json["distance"]?.toDouble(),
        legs: json["legs"] == null
            ? []
            : List<Leg>.from(json["legs"]!.map((x) => Leg.fromJson(x))),
        geometry: json["geometry"],
      );

  Map<String, dynamic> toJson() => {
        "weight_name": weightName,
        "weight": weight,
        "duration": duration,
        "distance": distance,
        "legs": legs == null
            ? []
            : List<dynamic>.from(legs!.map((x) => x.toJson())),
        "geometry": geometry,
      };
}
