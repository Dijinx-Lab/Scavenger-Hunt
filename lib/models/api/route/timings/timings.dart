class Timings {
  final DateTime? startTime;
  final DateTime? endTime;
  final int? timeLeft;

  Timings({
    this.startTime,
    this.endTime,
    this.timeLeft,
  });

  factory Timings.fromJson(Map<String, dynamic> json) => Timings(
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"]),
        endTime:
            json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
        timeLeft: json["time_left"],
      );

  Map<String, dynamic> toJson() => {
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "time_left": timeLeft,
      };
}
