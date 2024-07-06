import 'package:scavenger_hunt/models/api/challenge/challenge.dart';
import 'package:scavenger_hunt/models/api/route/timings/timings.dart';

class RouteDetails {
  final String? id;
  final String? introVideo;
  final String? outroVideo;
  final int? totalTime;
  final String? introMessage;
  final String? outroMessage;
  final Challenge? activeChallenge;
  final List<Challenge>? completedChallenges;
  final List<Challenge>? pendingChallenges;
  final Timings? timings;

  RouteDetails({
    this.id,
    this.introVideo,
    this.outroVideo,
    this.totalTime,
    this.introMessage,
    this.outroMessage,
    this.activeChallenge,
    this.completedChallenges,
    this.pendingChallenges,
    this.timings,
  });

  factory RouteDetails.fromJson(Map<String, dynamic> json) => RouteDetails(
        id: json["_id"],
        introVideo: json["intro_video"],
        outroVideo: json["outro_video"],
        totalTime: json["total_time"],
        introMessage: json["intro_message"],
        outroMessage: json["outro_message"],
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
        "outro_video": outroVideo,
        "total_time": totalTime,
        "intro_message": introMessage,
        "outro_message": outroMessage,
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
