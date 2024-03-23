import 'package:scavenger_hunt/models/api/mapbox/admin/admin.dart';
import 'package:scavenger_hunt/models/api/mapbox/step/step.dart';

class Leg {
  final List<dynamic>? viaWaypoints;
  final List<Admin>? admins;
  final double? weight;
  final double? duration;
  final List<Step>? steps;
  final double? distance;
  final String? summary;

  Leg({
    this.viaWaypoints,
    this.admins,
    this.weight,
    this.duration,
    this.steps,
    this.distance,
    this.summary,
  });

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
        viaWaypoints: json["via_waypoints"] == null
            ? []
            : List<dynamic>.from(json["via_waypoints"]!.map((x) => x)),
        admins: json["admins"] == null
            ? []
            : List<Admin>.from(json["admins"]!.map((x) => Admin.fromJson(x))),
        weight: json["weight"]?.toDouble(),
        duration: json["duration"]?.toDouble(),
        steps: json["steps"] == null
            ? []
            : List<Step>.from(json["steps"]!.map((x) => Step.fromJson(x))),
        distance: json["distance"]?.toDouble(),
        summary: json["summary"],
      );

  Map<String, dynamic> toJson() => {
        "via_waypoints": viaWaypoints == null
            ? []
            : List<dynamic>.from(viaWaypoints!.map((x) => x)),
        "admins": admins == null
            ? []
            : List<dynamic>.from(admins!.map((x) => x.toJson())),
        "weight": weight,
        "duration": duration,
        "steps": steps == null
            ? []
            : List<dynamic>.from(steps!.map((x) => x.toJson())),
        "distance": distance,
        "summary": summary,
      };
}
