import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/api/base/base_response.dart';
import 'package:scavenger_hunt/models/api/route/routes_response/routes_response.dart';
import 'package:scavenger_hunt/models/arguments/learn_args.dart';
import 'package:scavenger_hunt/services/challenge_service.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
import 'package:scavenger_hunt/utility/timer_utils.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _startApiCalls();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startApiCalls() async {
    await _animateToProgress(0.3);
    if (mounted) {
      if (!PrefUtil().isLocationImportanceShown) {
        await showOkAlertDialog(
            context: context,
            title: 'Locations',
            message:
                "Your location permissions are required to place you accuratly on the Scavenger Hunt map");
        PrefUtil().isLocationImportanceShown = true;
      }
    }
    await initializeLocationAndSave();
    await _animateToProgress(0.9);
    await _saveRouteDetails();
    await _animateToProgress(1);

    if (mounted) {
      if (PrefUtil().isMapShown) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(baseRoute, (route) => false);
      } else {
        Navigator.of(context).pushNamed(learnRouteRoute,
            arguments: LearnArgs(isForFinish: false));
      }
    }
  }

  Future<void> initializeLocationAndSave() async {
    try {
      bool? serviceEnabled;
      PermissionStatus? permissionGranted;
      Location location = Location();

      // Set accuracy to balanced

      // Check if the service is enabled
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          print("Location service is not enabled.");
          return;
        }
      }

      // Check for location permissions
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          print("Location permission not granted.");
          return;
        }
      } else if (permissionGranted == PermissionStatus.deniedForever) {
        print("Location permission permanently denied.");
        return;
      }

      // Get the location data
      if (permissionGranted == PermissionStatus.granted) {
        location.changeSettings(accuracy: LocationAccuracy.balanced);
        LocationData locationData = await location.getLocation();

        // Save the location data
        PrefUtil().lastLatitude = locationData.latitude!;
        PrefUtil().lastLongitude = locationData.longitude!;
        print(
            "Location saved: (${locationData.latitude}, ${locationData.longitude})");
      }
    } catch (e) {
      print("Error while getting location: $e");
    }
  }

  Future<void> _animateToProgress(double progress) async {
    await _animationController.animateTo(
      progress,
      curve: Curves.linear,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _saveRouteDetails() async {
    BaseResponse directionsResponse = await ChallengeService()
        .getRouteDetails(PrefUtil().currentTeam!.teamCode!);

    if (directionsResponse.error == null) {
      RoutesResponse apiResponse =
          directionsResponse.snapshot as RoutesResponse;
      if (apiResponse.success ?? false) {
        PrefUtil().currentRoute = apiResponse.data?.routes?.first;
        if (PrefUtil().currentRoute!.timings != null) {
          TimerUtils()
              .startCountdown(PrefUtil().currentRoute!.timings!.timeLeft!);
        }
      } else {
        await showOkAlertDialog(
            context: context,
            title: 'Alert',
            message:
                "Your session has expired please enter your team code again");
        Navigator.of(context)
            .pushNamedAndRemoveUntil(welcomeRoute, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Visibility(
                visible: Navigator.of(context).canPop(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: SvgPicture.asset(
                        "assets/svgs/ic_back.svg",
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Join Team",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              color: ColorStyle.primaryTextColor),
                        ),
                        Text(
                          "Join a team",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: ColorStyle.secondaryTextColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: SvgPicture.asset("assets/svgs/ic_people.svg"),
              ),
              const SizedBox(height: 10),
              const Text(
                "Code accepted",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: ColorStyle.primaryTextColor),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text(
                  "Processing to app...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: ColorStyle.secondaryTextColor),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 50,
                height: 50,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) => CircularProgressIndicator(
                    value: _animationController.value,
                    strokeWidth: 2.5,
                    backgroundColor: ColorStyle.grey100Color,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
