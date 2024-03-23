import 'package:scavenger_hunt/models/api/mapbox/mapbox_streets/mapbox_streets.dart';
class Intersection {
  final List<int>? bearings;
  final List<bool>? entry;
  final MapboxStreetsV8? mapboxStreetsV8;
  final bool? isUrban;
  final int? adminIndex;
  final int? out;
  final int? geometryIndex;
  final List<double>? location;
  final int? intersectionIn;

  Intersection({
    this.bearings,
    this.entry,
    this.mapboxStreetsV8,
    this.isUrban,
    this.adminIndex,
    this.out,
    this.geometryIndex,
    this.location,
    this.intersectionIn,
  });

  factory Intersection.fromJson(Map<String, dynamic> json) => Intersection(
        bearings: json["bearings"] == null
            ? []
            : List<int>.from(json["bearings"]!.map((x) => x)),
        entry: json["entry"] == null
            ? []
            : List<bool>.from(json["entry"]!.map((x) => x)),
        mapboxStreetsV8: json["mapbox_streets_v8"] == null
            ? null
            : MapboxStreetsV8.fromJson(json["mapbox_streets_v8"]),
        isUrban: json["is_urban"],
        adminIndex: json["admin_index"],
        out: json["out"],
        geometryIndex: json["geometry_index"],
        location: json["location"] == null
            ? []
            : List<double>.from(json["location"]!.map((x) => x?.toDouble())),
        intersectionIn: json["in"],
      );

  Map<String, dynamic> toJson() => {
        "bearings":
            bearings == null ? [] : List<dynamic>.from(bearings!.map((x) => x)),
        "entry": entry == null ? [] : List<dynamic>.from(entry!.map((x) => x)),
        "mapbox_streets_v8": mapboxStreetsV8?.toJson(),
        "is_urban": isUrban,
        "admin_index": adminIndex,
        "out": out,
        "geometry_index": geometryIndex,
        "location":
            location == null ? [] : List<dynamic>.from(location!.map((x) => x)),
        "in": intersectionIn,
      };
}
