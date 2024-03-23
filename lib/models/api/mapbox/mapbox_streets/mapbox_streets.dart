class MapboxStreetsV8 {
  final String? mapboxStreetsV8Class;

  MapboxStreetsV8({
    this.mapboxStreetsV8Class,
  });

  factory MapboxStreetsV8.fromJson(Map<String, dynamic> json) =>
      MapboxStreetsV8(
        mapboxStreetsV8Class: json["class"],
      );

  Map<String, dynamic> toJson() => {
        "class": mapboxStreetsV8Class,
      };
}
