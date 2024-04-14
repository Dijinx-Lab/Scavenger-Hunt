// To parse this JSON data, do
//
//     final notificationAction = notificationActionFromJson(jsonString);

import 'dart:convert';

NotificationAction notificationActionFromJson(String str) =>
    NotificationAction.fromJson(json.decode(str));

String notificationActionToJson(NotificationAction data) =>
    json.encode(data.toJson());

class NotificationAction {
  final String? action;
  final String? id;

  NotificationAction({
    this.action,
    this.id,
  });

  factory NotificationAction.fromJson(Map<String, dynamic> json) =>
      NotificationAction(
        action: json["action"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "action": action,
        "id": id,
      };
}
