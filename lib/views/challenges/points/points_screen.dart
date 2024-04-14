import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/api/base/base_response.dart';
import 'package:scavenger_hunt/models/api/challenge/challenge.dart';
import 'package:scavenger_hunt/models/api/challenge_completed/answer/answer.dart';
import 'package:scavenger_hunt/models/api/challenge_completed/challenge_completed_response/challenge_completed_response.dart';
import 'package:scavenger_hunt/models/api/route/routes_response/routes_response.dart';
import 'package:scavenger_hunt/models/arguments/question_args.dart';
import 'package:scavenger_hunt/models/events/stop_quest/stop_quest.dart';
import 'package:scavenger_hunt/services/challenge_service.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
import 'package:scavenger_hunt/views/map/map_screen.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class PointsScreen extends StatefulWidget {
  final QuestionArgs arguments;
  const PointsScreen({super.key, required this.arguments});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  late ChallengeService challengeService;
  late Challenge challenge;
  bool _showChallenges = false;
  bool isLoading = false;

  int score = 0;
  List<Answer> answers = [];

  @override
  void initState() {
    challengeService = ChallengeService();
    challenge = widget.arguments.challenge;
    _markAsCompleted();
    super.initState();
  }

  _markAsCompleted() {
    setState(() {
      isLoading = true;
    });
    challengeService
        .markChallengeAsCompleted(PrefUtil().currentTeam!.teamCode!)
        .then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.error == null) {
        ChallengeCompletedResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          await _saveRouteDetails();
          MapScreen.eventBus.fire(StopQuest());

          answers = apiResponse.data?.answers ?? [];
          Future.delayed(const Duration(milliseconds: 300))
              .then((value) => setState(() => _showChallenges = true));
          for (Answer answer in answers) {
            score += answer.score ?? 0;
          }
          setState(() {});
        } else {}
      } else {
        print(value.error);
      }
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 30),
                SvgPicture.asset(
                  "assets/svgs/ic_people.svg",
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: !isLoading,
                  child: RichText(
                    textScaler: MediaQuery.textScalerOf(context),
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Congratulations your team received ",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: ColorStyle.primaryTextColor),
                      children: [
                        TextSpan(
                          text: "$score points",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              color: ColorStyle.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Review your answers",
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
                            child: ListView(
                              children: List.generate(
                                answers.length,
                                (index) => AnimationConfiguration.staggeredList(
                                  position: index,
                                  child: FadeInAnimation(
                                      curve: Curves.decelerate,
                                      child: SlideAnimation(
                                        horizontalOffset: 80,
                                        curve: Curves.decelerate,
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          margin:
                                              const EdgeInsets.only(bottom: 15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: ColorStyle.cardColor,
                                            border: Border.all(
                                              color: ColorStyle.blackColor,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                answers[index].question ?? '',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: ColorStyle
                                                        .primaryTextColor),
                                              ),
                                              const SizedBox(height: 8),
                                              answers[index]
                                                      .answer
                                                      .toString()
                                                      .startsWith('http')
                                                  ? Container()
                                                  : Text(
                                                      answers[index]
                                                          .answer
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                          color: (answers[index]
                                                                      .isCorrect ??
                                                                  false)
                                                              ? ColorStyle
                                                                  .primaryColor
                                                              : ColorStyle
                                                                  .red100Color),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      )),
                                ),
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
                    () {
                      if (PrefUtil().currentRoute!.activeChallenge == null &&
                          PrefUtil().currentRoute!.pendingChallenges!.isEmpty) {
                        Navigator.of(context).popUntil(
                            (route) => route.settings.name == baseRoute);
                        Navigator.of(context).pushNamed(finishedRoute);
                      } else {
                        Navigator.of(context).popUntil(
                            (route) => route.settings.name == baseRoute);
                      }
                    },
                    textColor: ColorStyle.whiteColor,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
