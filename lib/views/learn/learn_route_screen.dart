import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/arguments/learn_args.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';
import 'package:video_player/video_player.dart';

class LearnRouteScreen extends StatefulWidget {
  final LearnArgs args;
  const LearnRouteScreen({super.key, required this.args});

  @override
  State<LearnRouteScreen> createState() => _LearnRouteScreenState();
}

class _LearnRouteScreenState extends State<LearnRouteScreen> {
  bool isButtonLoading = false;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        ),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _popToMap() {
    Navigator.of(context).popUntil((route) => route.settings.name == baseRoute);
  }

  _showPermissionsOff() async {
    if (mounted) {
      OkCancelResult result = await showOkAlertDialog(
          context: context,
          title: 'Locations',
          okLabel: "Retry",
          message:
              "Your locations are turned off. Please turn on your location permissions from settings to take part in the Scavenger Hunt");
      if (result == OkCancelResult.ok && mounted) {
        Navigator.of(context).popAndPushNamed(processingRoute);
      }
    }
  }

  _showConfirmationDialog() async {
    if (mounted) {
      if (PrefUtil().currentRoute?.timings == null) {
        OkCancelResult result = await showOkCancelAlertDialog(
            context: context,
            okLabel: "Start",
            cancelLabel: "Cancel",
            isDestructiveAction: true,
            message:
                "You are about to start the scavenger hunt. You'll have ${PrefUtil().currentRoute!.totalTime!} minutes to complete as many challenges as you can");
        if (result == OkCancelResult.ok && mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(baseRoute, (route) => false);
        }
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(baseRoute, (route) => false);
      }
    }
  }

  _checkLocationAndGoMap() async {
    PermissionStatus? permissionGranted;
    bool? serviceEnabled;
    Location location = Location();
    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    if (permissionGranted == PermissionStatus.deniedForever) {
      _showPermissionsOff();
    }

    if (permissionGranted == PermissionStatus.granted &&
        (serviceEnabled) &&
        mounted) {
      _showConfirmationDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: SvgPicture.asset("assets/svgs/ic_location.svg"),
              ),
              const SizedBox(height: 10),
              Text(
                widget.args.isForFinish
                    ? "You finish your route!"
                    : "Learn about your route",
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: ColorStyle.primaryTextColor),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text(
                  widget.args.isForFinish
                      ? "Watch a video and learn more about summary of your route"
                      : "Watch a video and learn more about your route",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: ColorStyle.secondaryTextColor),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorStyle.outline100Color,
                    ),
                  ),
                  child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Stack(
                          children: [
                            _controller.value.isPlaying
                                ? GestureDetector(
                                    onTap: () {
                                      _controller.pause();
                                      setState(() {});
                                    },
                                    child: VideoPlayer(_controller))
                                : Container(),
                            Visibility(
                              visible: !_controller.value.isPlaying,
                              child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      _controller.play();
                                      setState(() {});
                                    },
                                    icon: SvgPicture.asset(
                                        "assets/svgs/ic_pause.svg")),
                              ),
                            )
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: CustomRoundedButton(
                  "",
                  () {
                    widget.args.isForFinish
                        ? _popToMap()
                        : _checkLocationAndGoMap();
                  },
                  textColor: ColorStyle.whiteColor,
                  widgetButton: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.args.isForFinish ? "Finish" : "Start Journey",
                        style: const TextStyle(
                            height: 1.2,
                            fontSize: 16,
                            color: ColorStyle.whiteColor,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
