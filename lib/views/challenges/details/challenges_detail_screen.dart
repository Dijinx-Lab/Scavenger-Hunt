import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/api/challenge/challenge.dart';
import 'package:scavenger_hunt/models/api/question/question/question.dart';
import 'package:scavenger_hunt/models/api/question/question_response/question_response.dart';
import 'package:scavenger_hunt/models/arguments/question_args.dart';
import 'package:scavenger_hunt/services/question_service.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
import 'package:scavenger_hunt/utility/toast_utils.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class ChallengesDetailScreen extends StatefulWidget {
  static final eventBus = EventBus();
  final QuestionArgs arguments;
  const ChallengesDetailScreen({super.key, required this.arguments});

  @override
  State<ChallengesDetailScreen> createState() => _ChallengesDetailScreenState();
}

class _ChallengesDetailScreenState extends State<ChallengesDetailScreen> {
  bool _showChallenges = false;
  bool isLoading = false;
  late QuestionService questionService;
  late Challenge challenge;
  List<Question> questions = [];
  @override
  void initState() {
    questionService = QuestionService();
    challenge = widget.arguments.challenge;
    _getQuestions();
    // ChallengesDetailScreen.eventBus
    //     .on<SubmitQuestion>()
    //     .listen((event) => _handleSubmitQuestion(event.questionId));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _handleSubmitQuestion(String id) {
    // if (mounted) {
    //   int index = questions.indexWhere((element) => element.id == id);
    //   if (index == -1) {
    //     questions[index].answered = true;
    //   }
    //   Future.delayed(Duration(milliseconds: 500))
    //       .then((value) => setState(() {}));
    // }
  }

  _goToQuestion(index) async {
    if (questions[index].submittedAnswer == null) {
      await Navigator.of(context).pushNamed(questionsRoute,
          arguments: QuestionArgs(
              challenge: challenge,
              questions: questions,
              selectedIndex: index));
      _getQuestions();
    }
  }

  _getQuestions() {
    setState(() {
      isLoading = true;
    });
    questionService
        .getQuestions(challenge.id!, PrefUtil().currentTeam!.teamCode!)
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.error == null) {
        QuestionsResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          questions = apiResponse.data?.questions ?? [];
          Future.delayed(const Duration(milliseconds: 300))
              .then((value) => setState(() => _showChallenges = true));
        } else {
          ToastUtils.showCustomSnackbar(
            context: context,
            contentText: apiResponse.message ?? "",
            icon: const Icon(
              Icons.cancel_outlined,
              color: ColorStyle.whiteColor,
            ),
          );
        }
      } else {
        ToastUtils.showCustomSnackbar(
          context: context,
          contentText: value.error ?? "",
          icon: const Icon(
            Icons.cancel_outlined,
            color: ColorStyle.whiteColor,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("res ${areAllAnswersNonNull()}");
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
                Row(
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
                          "Challenges",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              color: ColorStyle.primaryTextColor),
                        ),
                        Text(
                          "Review your challenges",
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
                            child: AnimationLimiter(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: questions.length,
                                itemBuilder: (context, index) =>
                                    AnimationConfiguration.staggeredList(
                                  position: index,
                                  child: FadeInAnimation(
                                    curve: Curves.decelerate,
                                    child: SlideAnimation(
                                        horizontalOffset: 120,
                                        curve: Curves.decelerate,
                                        child:
                                            _buildQuestChallengeWidget(index)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                Visibility(
                  visible: !isLoading && areAllAnswersNonNull(),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: CustomRoundedButton(
                          "",
                          () {
                            Navigator.of(context).pushNamed(pointsRoute,
                                arguments: QuestionArgs(challenge: challenge));
                          },
                          widgetButton: const Text(
                            "Continue",
                            style: TextStyle(
                                height: 1.2,
                                fontSize: 16,
                                color: ColorStyle.whiteColor,
                                fontWeight: FontWeight.w500),
                          ),
                          buttonBackgroundColor: ColorStyle.primaryColor,
                          borderColor: ColorStyle.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildQuestChallengeWidget(int index) {
    print(questions[index].submittedAnswer?.isCorrect);
    return GestureDetector(
      onTap: () => _goToQuestion(index),
      child: Container(
        padding:
            const EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 20),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: ColorStyle.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorStyle.blackColor,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 25,
              height: 25,
              child: SvgPicture.asset('assets/svgs/ic_map.svg'),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quest ${index + 1}",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: ColorStyle.primaryTextColor.withOpacity(0.5)),
                  ),
                  Text(
                    questions[index].question ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: ColorStyle.primaryTextColor),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            SizedBox(
              height: 30,
              child: CustomRoundedButton(
                "View",
                () => _goToQuestion(index),
                roundedCorners: 40,
                textSize: 12,
                leftPadding: 20,
                rightPadding: 20,
              ),
            ),
            Checkbox(
                value: (questions[index].submittedAnswer != null),
                fillColor: questions[index].submittedAnswer == null
                    ? null
                    : MaterialStatePropertyAll(
                        (questions[index].submittedAnswer!.isCorrect ?? false)
                            ? ColorStyle.green100Color
                            : ColorStyle.red100Color),
                visualDensity: VisualDensity.compact,
                onChanged: (val) {})
          ],
        ),
      ),
    );
  }

  bool areAllAnswersNonNull() {
    for (var question in questions) {
      if (question.submittedAnswer == null) {
        return false;
      }
    }

    return true;
  }

  // _buildActiveChallengeWidget() {
  //   return Container(
  //     padding: const EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       color: ColorStyle.primaryColor,
  //       borderRadius: BorderRadius.circular(6),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "Available",
  //           style: TextStyle(
  //             fontWeight: FontWeight.w500,
  //             fontSize: 14,
  //             color: ColorStyle.whiteColor.withOpacity(0.6),
  //           ),
  //         ),
  //         const SizedBox(height: 6),
  //         Container(
  //           padding: const EdgeInsets.all(8),
  //           decoration: const BoxDecoration(
  //               color: ColorStyle.whiteColor, shape: BoxShape.circle),
  //           child: const Text(
  //             "3",
  //             style: TextStyle(
  //               fontWeight: FontWeight.w500,
  //               fontSize: 14,
  //               color: ColorStyle.primaryColor,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
