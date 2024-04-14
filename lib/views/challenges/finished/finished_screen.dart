import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/api/base/base_response.dart';
import 'package:scavenger_hunt/models/api/route/routes_response/routes_response.dart';
import 'package:scavenger_hunt/models/api/route_completed/route_completed_response.dart';
import 'package:scavenger_hunt/models/arguments/learn_args.dart';
import 'package:scavenger_hunt/services/challenge_service.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class FinishedScreen extends StatefulWidget {
  const FinishedScreen({super.key});

  @override
  State<FinishedScreen> createState() => _FinishedScreenState();
}

class _FinishedScreenState extends State<FinishedScreen> {
  final bool _isUnFinished = false;
  bool _showChallenges = false;
  late ChallengeService challengeService;
  RouteCompletedResponse? routeCompletedResponse;
  bool isLoading = false;
  String timeTaken = '00:00';
  @override
  void initState() {
    challengeService = ChallengeService();
    _markAsCompleted();

    super.initState();
  }

  _markAsCompleted() {
    setState(() {
      isLoading = true;
    });
    challengeService
        .markRouteAsCompleted(
            PrefUtil().currentRoute!.id!, PrefUtil().currentTeam!.teamCode!)
        .then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.error == null) {
        _saveRouteDetails();
        RouteCompletedResponse apiResponse = value.snapshot;

        if (apiResponse.success ?? false) {
          routeCompletedResponse = apiResponse;
          int remainingTimeInMinutes =
              routeCompletedResponse!.data!.timeTaken!.ceil();
          int hours = remainingTimeInMinutes ~/ 60;
          int minutes = remainingTimeInMinutes % 60;

          timeTaken =
              '${'$hours'.padLeft(2, '0')}:${'$minutes'.padLeft(2, '0')}';

          Future.delayed(const Duration(milliseconds: 300))
              .then((value) => setState(() => _showChallenges = true));
        } else {}
      } else {}
    });
  }

  Future<void> _saveRouteDetails() async {
    BaseResponse directionsResponse = await ChallengeService()
        .getRouteDetails(PrefUtil().currentTeam!.teamCode!);
    if (directionsResponse.error == null) {
      RoutesResponse apiResponse =
          directionsResponse.snapshot as RoutesResponse;
      PrefUtil().currentRoute = apiResponse.data?.routes?.first;
    }
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    SvgPicture.asset(
                      "assets/svgs/ic_people.svg",
                    ),
                    const SizedBox(height: 10),
                    isLoading
                        ? Container()
                        : Column(
                            children: [
                              const Text(
                                "Congratulations you finished  your route and earned",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    color: ColorStyle.primaryTextColor),
                              ),
                              Text(
                                "${routeCompletedResponse!.data!.totalScore} points",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    color: _isUnFinished
                                        ? ColorStyle.red100Color
                                        : ColorStyle.primaryColor),
                              ),
                            ],
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
                        child: isLoading
                            ? const Center(
                                child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color: ColorStyle.primaryColor,
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : Visibility(
                                visible: _showChallenges,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        AnimationConfiguration.toStaggeredList(
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
                                            margin: const EdgeInsets.only(
                                                bottom: 15),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: ColorStyle.blackColor,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${timeTaken}h",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16,
                                                            color: ColorStyle
                                                                .primaryTextColor),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      const Text(
                                                        "Time",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16,
                                                            color: ColorStyle
                                                                .black200Color),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Expanded(
                                                //   child: Column(
                                                //     crossAxisAlignment:
                                                //         CrossAxisAlignment.end,
                                                //     children: [
                                                //       Text(
                                                //         _isUnFinished
                                                //             ? "-100"
                                                //             : "300",
                                                //         style: TextStyle(
                                                //             fontWeight:
                                                //                 FontWeight.w500,
                                                //             fontSize: 16,
                                                //             color: _isUnFinished
                                                //                 ? ColorStyle
                                                //                     .red100Color
                                                //                 : ColorStyle
                                                //                     .primaryColor),
                                                //       ),
                                                //       const SizedBox(height: 8),
                                                //       const Text(
                                                //         "Points",
                                                //         style: TextStyle(
                                                //             fontWeight:
                                                //                 FontWeight.w500,
                                                //             fontSize: 16,
                                                //             color: ColorStyle
                                                //                 .black200Color),
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            margin: const EdgeInsets.only(
                                                bottom: 15),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: ColorStyle.blackColor,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${routeCompletedResponse!.data!.completedChallenges!}/${routeCompletedResponse!.data!.totalChallenges!}",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16,
                                                            color: ColorStyle
                                                                .primaryTextColor),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      const Text(
                                                        "Challenges",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16,
                                                            color: ColorStyle
                                                                .black200Color),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Expanded(
                                                //   child: Column(
                                                //     crossAxisAlignment:
                                                //         CrossAxisAlignment.end,
                                                //     children: [
                                                //       Text(
                                                //         _isUnFinished
                                                //             ? "-300"
                                                //             : "300",
                                                //         style: TextStyle(
                                                //             fontWeight:
                                                //                 FontWeight.w500,
                                                //             fontSize: 16,
                                                //             color: _isUnFinished
                                                //                 ? ColorStyle
                                                //                     .red100Color
                                                //                 : ColorStyle
                                                //                     .primaryColor),
                                                //       ),
                                                //       const SizedBox(height: 8),
                                                //       const Text(
                                                //         "Points",
                                                //         style: TextStyle(
                                                //             fontWeight:
                                                //                 FontWeight.w500,
                                                //             fontSize: 16,
                                                //             color: ColorStyle
                                                //                 .black200Color),
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            margin: const EdgeInsets.only(
                                                bottom: 15),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: ColorStyle.blackColor,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${routeCompletedResponse!.data!.answeredQuestions}/${routeCompletedResponse!.data!.totalQuestions!}",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16,
                                                            color: ColorStyle
                                                                .primaryTextColor),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      const Text(
                                                        "Quiz questions",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                                        _isUnFinished
                                                            ? "-600"
                                                            : "${routeCompletedResponse!.data!.totalScore!}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16,
                                                            color: _isUnFinished
                                                                ? ColorStyle
                                                                    .red100Color
                                                                : ColorStyle
                                                                    .primaryColor),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      const Text(
                                                        "Points",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
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
                    ),
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: CustomRoundedButton(
                        "Continue",
                        () => Navigator.of(context).pushNamed(learnRouteRoute,
                            arguments: LearnArgs(isForFinish: true)),
                        textColor: ColorStyle.whiteColor,
                      ),
                    ),
                    const SizedBox(height: 10),
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
