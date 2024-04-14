import 'package:scavenger_hunt/models/api/challenge/challenge.dart';
import 'package:scavenger_hunt/models/api/route/timings/timings.dart';

class RouteDetails {
  final String? id;
  final String? introVideo;
  final int? totalTime;
  final double? finishLineLat;
  final double? finishLineLong;
  final Challenge? activeChallenge;
  final List<Challenge>? completedChallenges;
  final List<Challenge>? pendingChallenges;
  final Timings? timings;

  RouteDetails(
      {this.id,
      this.introVideo,
      this.totalTime,
      this.finishLineLat,
      this.finishLineLong,
      this.activeChallenge,
      this.completedChallenges,
      this.pendingChallenges,
      this.timings});

  factory RouteDetails.fromJson(Map<String, dynamic> json) => RouteDetails(
        id: json["_id"],
        introVideo: json["intro_video"],
        totalTime: json["total_time"],
        finishLineLat: json["finish_line_lat"]?.toDouble(),
        finishLineLong: json["finish_line_long"]?.toDouble(),
        activeChallenge: json["active_challenge"] == null
            ? null
            : Challenge.fromJson(json["active_challenge"]),
        completedChallenges: json["completed_challenges"] == null
            ? []
            : List<Challenge>.from(json["completed_challenges"]!
                .map((x) => Challenge.fromJson(x))),
        pendingChallenges: json["pending_challenges"] == null
            ? []
            : List<Challenge>.from(
                json["pending_challenges"]!.map((x) => Challenge.fromJson(x))),
        timings:
            json["timings"] == null ? null : Timings.fromJson(json["timings"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "intro_video": introVideo,
        "total_time": totalTime,
        "finish_line_lat": finishLineLat,
        "finish_line_long": finishLineLong,
        "active_challenge": activeChallenge?.toJson(),
        "completed_challenges": completedChallenges == null
            ? []
            : List<dynamic>.from(completedChallenges!.map((x) => x.toJson())),
        "pending_challenges": pendingChallenges == null
            ? []
            : List<dynamic>.from(pendingChallenges!.map((x) => x.toJson())),
        "timings": timings?.toJson(),
      };
}
