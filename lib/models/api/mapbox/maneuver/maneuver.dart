class Maneuver {
  final String? type;
  final String? instruction;
  final int? bearingAfter;
  final int? bearingBefore;
  final List<double>? location;

  Maneuver({
    this.type,
    this.instruction,
    this.bearingAfter,
    this.bearingBefore,
    this.location,
  });

  factory Maneuver.fromJson(Map<String, dynamic> json) => Maneuver(
        type: json["type"],
        instruction: json["instruction"],
        bearingAfter: json["bearing_after"],
        bearingBefore: json["bearing_before"],
        location: json["location"] == null
            ? []
            : List<double>.from(json["location"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "instruction": instruction,
        "bearing_after": bearingAfter,
        "bearing_before": bearingBefore,
        "location":
            location == null ? [] : List<dynamic>.from(location!.map((x) => x)),
      };
}
