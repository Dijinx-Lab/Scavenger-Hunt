import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/arguments/learn_args.dart';
import 'package:scavenger_hunt/models/events/stop_quest/stop_quest.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
import 'package:scavenger_hunt/views/map/map_screen.dart';
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
    MapScreen.eventBus.fire(StopQuest());
    Navigator.of(context).popUntil((route) => route.settings.name == baseRoute);
  }

  void initializeLocationAndSave() async {
    setState(() {
      isButtonLoading = true;
    });
    // Ensure all permissions are collected for Locations
    Location location = Location();
    bool? serviceEnabled;
    PermissionStatus? permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    // Get capture the current user location

    LocationData locationData = await location.getLocation();

    // Store the user location in sharedPreferences
    PrefUtil().setLastLatitude = locationData.latitude!;
    PrefUtil().setLastLongitude = locationData.longitude!;

    // // Get and store the directions API response in sharedPreferences
    // for (int i = 0; i < restaurants.length; i++) {
    //   Map modifiedResponse = await getDirectionsAPIResponse(currentLatLng, i);
    //   saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
    // }
    if (mounted) {
      setState(() {
        isButtonLoading = false;
      });
      Navigator.of(context)
          .pushNamedAndRemoveUntil(baseRoute, (route) => false);
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
                  () => widget.args.isForFinish
                      ? _popToMap()
                      : initializeLocationAndSave(),
                  textColor: ColorStyle.whiteColor,
                  widgetButton: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isButtonLoading
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: ColorStyle.whiteColor,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              widget.args.isForFinish
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
