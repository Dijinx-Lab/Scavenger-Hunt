import 'package:flutter/material.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _moveToNextScreen();
    super.initState();
  }

  _moveToNextScreen() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if (PrefUtil().currentTeam != null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(processingRoute, (route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(welcomeRoute, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
