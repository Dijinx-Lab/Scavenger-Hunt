import 'package:scavenger_hunt/keys/pref_keys.dart';
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

  set setLastLatitude(double value) {
    _sharedPreferences!.setDouble(currentLatitude, value);
  }

  double get lastLongitude =>
      _sharedPreferences!.getDouble(currentLongitude) ?? 0.0;

  set setLastLongitude(double value) {
    _sharedPreferences!.setDouble(currentLongitude, value);
  }
}
