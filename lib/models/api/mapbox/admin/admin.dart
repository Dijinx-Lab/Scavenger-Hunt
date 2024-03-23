class Admin {
  final String? iso31661Alpha3;
  final String? iso31661;

  Admin({
    this.iso31661Alpha3,
    this.iso31661,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        iso31661Alpha3: json["iso_3166_1_alpha3"],
        iso31661: json["iso_3166_1"],
      );

  Map<String, dynamic> toJson() => {
        "iso_3166_1_alpha3": iso31661Alpha3,
        "iso_3166_1": iso31661,
      };
}
