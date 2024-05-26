import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/arguments/learn_args.dart';
import 'package:scavenger_hunt/models/arguments/question_args.dart';
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
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    String url = widget.args.challenge != null
        ? widget.args.challenge!.introUrl!
        : 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.initialize().then((value) {});

    _chewieController = ChewieController(
      videoPlayerController: _controller,
    );
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      setState(() {
        _controller.play();
      });
    });

    // _chewieController.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
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
    Location location = Location.instance;
    print("loc $location");
    serviceEnabled = await location.serviceEnabled();

    print("service $serviceEnabled");

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();

    print("perm $permissionGranted");

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
                widget.args.challenge != null
                    ? "Learn about your location"
                    : widget.args.isForFinish
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
                  widget.args.challenge != null
                      ? "Watch a video and learn more about summary of your location"
                      : widget.args.isForFinish
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
              // _chewieController.isPlaying
              //     ?
              Expanded(
                child: Column(
                  children: [
                    const Spacer(),
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Chewie(
                        controller: _chewieController,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              // : Expanded(
              //     child: Container(
              //       width: double.maxFinite,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(8),
              //         border: _chewieController.isPlaying
              //             ? null
              //             : Border.all(
              //                 color: ColorStyle.outline100Color,
              //               ),
              //       ),
              //       child: Stack(
              //         children: [
              //           // _chewieController.isPlaying
              //           //     ? GestureDetector(
              //           //         onTap: () {
              //           //           _controller.pause();
              //           //           setState(() {});
              //           //         },
              //           //         child: Center(
              //           //           child: SizedBox(
              //           //             width: double.maxFinite,
              //           //             height: 220,
              //           //             child: Chewie(
              //           //               controller: _chewieController,
              //           //             ),
              //           //           ),
              //           //         ))
              //           //     : Container(),
              //           Center(
              //             child: IconButton(
              //                 onPressed: () {
              //                   _controller.play();
              //                   setState(() {});
              //                 },
              //                 icon: SvgPicture.asset(
              //                     "assets/svgs/ic_pause.svg")),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              const SizedBox(height: 30),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: CustomRoundedButton(
                  "",
                  () {
                    if (widget.args.challenge != null) {
                      _chewieController.pause();
                      Navigator.of(context).popAndPushNamed(challengesRoute,
                          arguments:
                              QuestionArgs(challenge: widget.args.challenge!));
                    } else if (widget.args.isForFinish) {
                      _popToMap();
                    } else {
                      _checkLocationAndGoMap();
                    }
                  },
                  textColor: ColorStyle.whiteColor,
                  widgetButton: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.args.challenge != null
                            ? "Continue"
                            : widget.args.isForFinish
                                ? "Finish"
                                : "Start Journey",
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
