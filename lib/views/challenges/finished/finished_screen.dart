import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/arguments/learn_args.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class FinishedScreen extends StatefulWidget {
  const FinishedScreen({super.key});

  @override
  State<FinishedScreen> createState() => _FinishedScreenState();
}

class _FinishedScreenState extends State<FinishedScreen> {
  bool _isUnFinished = false;
  bool _showChallenges = false;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 300))
        .then((value) => setState(() => _showChallenges = true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isUnFinished = !_isUnFinished;
                      });
                    },
                    child: const Text("Mock unfinished tasks")),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    SvgPicture.asset(
                      "assets/svgs/ic_people.svg",
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Congratulations you finished  your route and earned",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: ColorStyle.primaryTextColor),
                    ),
                    Text(
                      _isUnFinished ? "0 points" : "3150 points",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: _isUnFinished
                              ? ColorStyle.red100Color
                              : ColorStyle.primaryColor),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Your team successfully finished route,\nreview summary",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: ColorStyle.black200Color),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Visibility(
                          visible: _showChallenges,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: AnimationConfiguration.toStaggeredList(
                                childAnimationBuilder: (widget) =>
                                    FadeInAnimation(
                                      curve: Curves.decelerate,
                                      child: SlideAnimation(
                                          horizontalOffset: 150,
                                          curve: Curves.decelerate,
                                          child: widget),
                                    ),
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    margin: const EdgeInsets.only(bottom: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ColorStyle.blackColor,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "01:35h",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: ColorStyle
                                                        .primaryTextColor),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Time",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: ColorStyle
                                                        .black200Color),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                _isUnFinished ? "-100" : "300",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: _isUnFinished
                                                        ? ColorStyle.red100Color
                                                        : ColorStyle
                                                            .primaryColor),
                                              ),
                                              const SizedBox(height: 8),
                                              const Text(
                                                "Points",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: ColorStyle
                                                        .black200Color),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    margin: const EdgeInsets.only(bottom: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ColorStyle.blackColor,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "4/4",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: ColorStyle
                                                        .primaryTextColor),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Challenges",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: ColorStyle
                                                        .black200Color),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                _isUnFinished ? "-300" : "300",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: _isUnFinished
                                                        ? ColorStyle.red100Color
                                                        : ColorStyle
                                                            .primaryColor),
                                              ),
                                              const SizedBox(height: 8),
                                              const Text(
                                                "Points",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: ColorStyle
                                                        .black200Color),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    margin: const EdgeInsets.only(bottom: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ColorStyle.blackColor,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "36/40",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: ColorStyle
                                                        .primaryTextColor),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Quiz questions",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: ColorStyle
                                                        .black200Color),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                _isUnFinished ? "-600" : "300",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: _isUnFinished
                                                        ? ColorStyle.red100Color
                                                        : ColorStyle
                                                            .primaryColor),
                                              ),
                                              const SizedBox(height: 8),
                                              const Text(
                                                "Points",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: ColorStyle
                                                        .black200Color),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: CustomRoundedButton(
                        "Continue",
                        () => Navigator.of(context).pushNamed(learnRouteRoute,
                            arguments: LearnArgs(isForFinish: true)),
                        // Navigator.of(context)
                        //     .popUntil((route) => route.settings.name == baseRoute),
                        textColor: ColorStyle.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
