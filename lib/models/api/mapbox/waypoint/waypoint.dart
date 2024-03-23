class Waypoint {
  final double? distance;
  final String? name;
  final List<double>? location;

  Waypoint({
    this.distance,
    this.name,
    this.location,
  });

  factory Waypoint.fromJson(Map<String, dynamic> json) => Waypoint(
        distance: json["distance"]?.toDouble(),
        name: json["name"],
        location: json["location"] == null
            ? []
            : List<double>.from(json["location"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "distance": distance,
        "name": name,
        "location":
            location == null ? [] : List<dynamic>.from(location!.map((x) => x)),
      };
}
