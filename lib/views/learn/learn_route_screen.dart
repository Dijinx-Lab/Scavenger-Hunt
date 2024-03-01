import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/arguments/learn_args.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';
import 'package:video_player/video_player.dart';

class LearnRouteScreen extends StatefulWidget {
  final LearnArgs args;
  const LearnRouteScreen({super.key, required this.args});

  @override
  State<LearnRouteScreen> createState() => _LearnRouteScreenState();
}

class _LearnRouteScreenState extends State<LearnRouteScreen> {
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
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                  widget.args.isForFinish ? "Finish" : "Start Journey",
                  () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(baseRoute, (route) => false),
                  textColor: ColorStyle.whiteColor,
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
