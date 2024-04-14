import 'dart:convert';

import 'package:scavenger_hunt/keys/pref_keys.dart';
import 'package:scavenger_hunt/models/api/route/route/route.dart';
import 'package:scavenger_hunt/models/api/team/team/team.dart';
import 'package:scavenger_hunt/models/notification/notification_action.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtil {
  static SharedPreferences? _sharedPreferences;

  factory PrefUtil() => PrefUtil._internal();

  PrefUtil._internal();

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  double get lastLatitude =>
      _sharedPreferences!.getDouble(currentLatitude) ?? 0.0;

  set lastLatitude(double value) {
    _sharedPreferences!.setDouble(currentLatitude, value);
  }

  double get lastLongitude =>
      _sharedPreferences!.getDouble(currentLongitude) ?? 0.0;

  set lastLongitude(double value) {
    _sharedPreferences!.setDouble(currentLongitude, value);
  }

  bool get isTeamJoined => _sharedPreferences!.getBool(teamJoined) ?? false;

  set isTeamJoined(bool value) {
    _sharedPreferences!.setBool(teamJoined, value);
  }

  String get startRouteTime =>
      _sharedPreferences!.getString(routeStartTime) ?? '';

  set startRouteTime(String value) {
    _sharedPreferences!.setString(routeStartTime, value);
  }

  bool get isMapShown => _sharedPreferences!.getBool(mapShown) ?? false;

  set isMapShown(bool value) {
    _sharedPreferences!.setBool(mapShown, value);
  }

  bool get isLocationImportanceShown =>
      _sharedPreferences!.getBool(locationImportanceShown) ?? false;

  set isLocationImportanceShown(bool value) {
    _sharedPreferences!.setBool(locationImportanceShown, value);
  }

  Team? get currentTeam {
    try {
      String? teamJson = _sharedPreferences!.getString(team);
      if (teamJson == null || teamJson == '') return null;

      return Team.fromJson(json.decode(teamJson));
    } catch (e) {
      return null;
    }
  }

  set currentTeam(Team? value) {
    try {
      if (value == null) {
        _sharedPreferences!.setString(team, '');
      } else {
        final String teamJson = json.encode(value.toJson());
        _sharedPreferences!.setString(team, teamJson);
      }
    } catch (e) {
    }
  }

  RouteDetails? get currentRoute {
    try {
      String? routeJson = _sharedPreferences!.getString(route);
      if (routeJson == null || routeJson == '') return null;

      return RouteDetails.fromJson(json.decode(routeJson));
    } catch (e) {
      
      return null;
    }
  }

  set currentRoute(RouteDetails? value) {
    try {
      if (value == null) {
        _sharedPreferences!.setString(route, '');
      } else {
        final String routeJson = json.encode(value.toJson());
        _sharedPreferences!.setString(route, routeJson);
      }
    } catch (e) {
    }
  }

  NotificationAction? get lastNotificationAction {
    try {
      String? notifJson = _sharedPreferences!.getString(lastNotifAction);
      if (notifJson == null || notifJson == '') return null;

      return NotificationAction.fromJson(json.decode(notifJson));
    } catch (e) {
      
      return null;
    }
  }

  set lastNotificationAction(NotificationAction? value) {
    try {
      if (value == null) {
        _sharedPreferences!.setString(lastNotifAction, '');
      } else {
        final String notifJson = json.encode(value.toJson());
        _sharedPreferences!.setString(lastNotifAction, notifJson);
      }
    } catch (e) {
      
    }
  }
}
