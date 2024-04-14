import 'dart:async';

class TimerUtils {
  static final TimerUtils _instance = TimerUtils._internal();
  Timer? _timer;
  late Duration _duration;
  late Function(String) _onUpdateCallback;

  factory TimerUtils() {
    return _instance;
  }

  TimerUtils._internal();

  void startCountdown(int durationInMinutes) {
    if (durationInMinutes > 0) {
      _duration = Duration(minutes: durationInMinutes);
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(minutes: 1), _updateTimer);
    }
  }

  void _updateTimer(Timer timer) {
    _duration -= const Duration(seconds: 1);
    if (_duration.isNegative) {
      _timer?.cancel();
      _onUpdateCallback("00:00");
    } else {
      String twoDigits(int n) {
        if (n >= 10) return "$n";
        return "0$n";
      }

      final hours = twoDigits(_duration.inHours);
      final minutes = twoDigits(_duration.inMinutes.remainder(60));

      _onUpdateCallback("$hours:$minutes");
    }
  }

  String initialValue() {
    if (_timer == null) {
      return '--:--';
    }
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    final hours = twoDigits(_duration.inHours);
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    return "$hours:$minutes";
  }

  void onUpdate(Function(String) callback) {
    _onUpdateCallback = callback;
  }
}
