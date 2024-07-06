import 'package:flutter/material.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
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
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
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
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: ColorStyle.whiteColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: ColorStyle.primaryColor.withOpacity(0.2),
                  ),
                ],
              ),
              child: Image.asset('assets/pngs/app_logo.png'),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50.0),
              child: Text(
                "Powered By  |  D I J I N X",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: ColorStyle.greyTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
