class Annotation {
  final List<double>? distance;
  final List<double>? duration;

  Annotation({
    this.distance,
    this.duration,
  });

  factory Annotation.fromJson(Map<String, dynamic> json) => Annotation(
        distance: json["distance"] == null
            ? []
            : List<double>.from(json["distance"]!.map((x) => x?.toDouble())),
        duration: json["duration"] == null
            ? []
            : List<double>.from(json["duration"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "distance":
            distance == null ? [] : List<dynamic>.from(distance!.map((x) => x)),
        "duration":
            duration == null ? [] : List<dynamic>.from(duration!.map((x) => x)),
      };
}
