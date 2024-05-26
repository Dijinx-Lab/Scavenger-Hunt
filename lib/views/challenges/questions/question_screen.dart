import 'dart:convert';
import 'dart:io';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as Img;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/api/answer/answer_response.dart';
import 'package:scavenger_hunt/models/api/challenge/challenge.dart';
import 'package:scavenger_hunt/models/api/question/question/question.dart';
import 'package:scavenger_hunt/models/api/team/team_response/team_response.dart';
import 'package:scavenger_hunt/models/arguments/question_args.dart';
import 'package:scavenger_hunt/models/events/answer_submitted/answer_submitted.dart';
import 'package:scavenger_hunt/services/challenge_service.dart';
import 'package:scavenger_hunt/services/team_service.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
import 'package:scavenger_hunt/utility/toast_utils.dart';
import 'package:scavenger_hunt/views/challenges/questions/binary/binary_widget.dart';
import 'package:scavenger_hunt/views/challenges/questions/mcq/mcq_widget.dart';
import 'package:scavenger_hunt/views/challenges/questions/picture/picture_widget.dart';
import 'package:scavenger_hunt/views/challenges/questions/slider/slider_widget.dart';
import 'package:scavenger_hunt/views/challenges/questions/word_jumble/word_jumble_widget.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class QuestionScreen extends StatefulWidget {
  final QuestionArgs arguments;
  const QuestionScreen({super.key, required this.arguments});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late Challenge challenge;
  List<Question> questions = [];
  late ChallengeService challengeService;
  int stepperIndex = 0;
  bool isValidToProceed = false;
  bool isSubmitted = false;
  List<Widget> steps = [];
  dynamic currentAnswer;
  bool isLoading = false;
  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    challengeService = ChallengeService();
    challenge = widget.arguments.challenge;
    questions = widget.arguments.questions ?? [];
    stepperIndex = widget.arguments.selectedIndex;
    steps = _getStepsList();
    super.initState();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  _moveToNextPage() {
    stepperIndex = nextQuestionIndexWithNullAnswer(stepperIndex);
    isSubmitted = false;
    isValidToProceed = false;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (controller.hasClients) {
        controller.jumpToPage(
          stepperIndex,
        );
        setState(() {});
      }
    });
  }

  _getStepsList() {
    List<Widget> widgets = [];
    for (Question question in questions) {
      switch (question.type) {
        case "mcq":
          {
            widgets.add(McqWidget(
                question: question,
                onDataFilled: (answer, validation) =>
                    _childDataFilled(answer, validation)));
            break;
          }
        case "picture":
          {
            widgets.add(PictureWidget(
                question: question,
                onDataFilled: (answer, validation) =>
                    _childDataFilled(answer, validation)));
            break;
          }
        case "binary":
          {
            widgets.add(BinaryWidget(
                question: question,
                onDataFilled: (answer, validation) =>
                    _childDataFilled(answer, validation)));
            break;
          }
        case "slider":
          {
            widgets.add(SliderWidget(
                question: question,
                onDataFilled: (answer, validation) =>
                    _childDataFilled(answer, validation)));
            break;
          }
        case "wordjumble":
          {
            widgets.add(WordJumbleWidget(
                question: question,
                onDataFilled: (answer, validation) =>
                    _childDataFilled(answer, validation)));
            break;
          }
      }
    }
    return widgets;
  }

  _getCurrentTitle() {
    switch (questions[stepperIndex].type) {
      case "mcq":
        {
          return "Choose an answer";
        }
      case "picture":
        {
          return "Taking pictures";
        }
      case "binary":
        {
          return "True Or False";
        }
      case "slider":
        {
          return "Pick an answer";
        }
      case "wordjumble":
        {
          return "Form the answer";
        }
    }
  }

  _getCurrentSubText() {
    switch (questions[stepperIndex].type) {
      case "mcq":
        {
          return "Answer a question and move to next one";
        }
      case "picture":
        {
          return "Take a picture and move to next one";
        }
      case "binary":
        {
          return "Choose true or false and move to next one";
        }
      case "slider":
        {
          return "Pick the answer by dragging the slider";
        }
      case "wordjumble":
        {
          return "Spell out the answer by tapping the letters";
        }
    }
  }

  _childDataFilled(dynamic answer, bool validation) {
    setState(() {
      if (validation) {
        currentAnswer = answer;
      }
      isValidToProceed = validation;
    });
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: SvgPicture.asset(
                        "assets/svgs/ic_back.svg",
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getCurrentTitle(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: ColorStyle.primaryTextColor),
                          ),
                          Text(
                            _getCurrentSubText(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: ColorStyle.secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        "${stepperIndex + 1}/${steps.length}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            color: ColorStyle.primaryTextColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, index) {
                        return steps[stepperIndex];
                      },
                      itemCount: steps.length,
                      controller: controller,
                    ),
                  ),
                ),
                questions[stepperIndex].type != "wordjumble"
                    ? Container()
                    : const Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: ColorStyle.primaryColor,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "If you would like to change a letter placed in the box, touch to remove it",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: ColorStyle.secondaryTextColor),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: CustomRoundedButton(
                    "",
                    () => _saveAnswer(),
                    widgetButton: isLoading
                        ? const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              color: ColorStyle.whiteColor,
                              strokeWidth: 2,
                            ),
                          )
                        : isSubmitted
                            ? Text(
                                "Continue",
                                style: TextStyle(
                                    height: 1.2,
                                    fontSize: 16,
                                    color: isValidToProceed
                                        ? ColorStyle.whiteColor
                                        : ColorStyle.primaryColor,
                                    fontWeight: FontWeight.w500),
                              )
                            : Text(
                                "Submit",
                                style: TextStyle(
                                    height: 1.2,
                                    fontSize: 16,
                                    color: isValidToProceed
                                        ? ColorStyle.whiteColor
                                        : ColorStyle.primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                    buttonBackgroundColor: isValidToProceed
                        ? ColorStyle.primaryColor
                        : ColorStyle.whiteColor,
                    borderColor: isValidToProceed
                        ? ColorStyle.whiteColor
                        : ColorStyle.primaryColor,
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

  String? base64Image(String imagePath) {
    List<int> imageBytes = File(imagePath).readAsBytesSync();

    Img.Image? image = Img.decodeImage(Uint8List.fromList(imageBytes));

    if (image != null) {
      String base64Image =
          base64Encode(Uint8List.fromList(Img.encodeJpg(image)));

      String extension = imagePath.split('.').last;

      String base64ImageWithExtension =
          'data:image/$extension;base64,$base64Image';

      return base64ImageWithExtension;
    }
    return null;
  }

  _saveAnswer() async {
    FocusManager.instance.primaryFocus?.unfocus();

    // else {
    setState(() {
      isLoading = true;
    });
    if (questions[stepperIndex].type == "picture") {
      currentAnswer =
          await challengeService.getUploadUrl(currentAnswer, 'answers');
    }
    challengeService
        .submitAnswer(currentAnswer, questions[stepperIndex].id!,
            PrefUtil().currentTeam!.teamCode!)
        .then((value) async {
      setState(() {
        isLoading = false;
      });
      if (value.error == null) {
        AnswerResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          if (isValidToProceed) {
            _showSubmissionDetailDialog(
                apiResponse.data!.answer!.isCorrect!,
                apiResponse.data!.answer!.score!,
                PrefUtil().currentTeam!.score!);

            questions[stepperIndex].submittedAnswer = apiResponse.data?.answer;
            _refreshTeamData();
            _notifyChild();

            setState(() {
              isSubmitted = true;
            });
          }
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
    // }
  }

  int nextQuestionIndexWithNullAnswer(int currentIndex) {
    int nextIndex = (currentIndex + 1) % questions.length;

    if (questions[currentIndex].submittedAnswer == null && nextIndex == 0) {
      return currentIndex;
    }

    while (questions[nextIndex].submittedAnswer != null) {
      nextIndex = (nextIndex + 1) % questions.length;

      if (nextIndex == currentIndex) {
        return -1;
      }
    }

    return nextIndex;
  }

  bool areAllAnswersNonNull() {
    for (var question in questions) {
      if (question.submittedAnswer == null) {
        return false;
      }
    }

    return true;
  }

  _notifyChild() {
    switch (questions[stepperIndex].type) {
      case "mcq":
        {
          McqWidget.eventBus.fire(AnswerSubmitted());
          break;
        }
      case "picture":
        {
          PictureWidget.eventBus.fire(AnswerSubmitted());
          break;
        }
      case "binary":
        {
          BinaryWidget.eventBus.fire(AnswerSubmitted());
          break;
        }
      case "slider":
        {
          SliderWidget.eventBus.fire(AnswerSubmitted());
          break;
        }
      case "wordjumble":
        {
          WordJumbleWidget.eventBus.fire(AnswerSubmitted());
          break;
        }
    }
  }

  _refreshTeamData() async {
    TeamService().joinTeam(PrefUtil().currentTeam!.teamCode!).then((value) {
      if (value.error == null) {
        TeamResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          PrefUtil().currentTeam = apiResponse.data?.team;
        } else {}
      } else {}
    });
  }

  _showSubmissionDetailDialog(
    bool isCorrect,
    int points,
    int teamScore,
  ) async {
    int originalTeamScore = teamScore;

    if (isCorrect) {
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 200));
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 200));
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.vibrate();
    }

    Dialog dialog = Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Center(
                  child: Text(
                    "Answer Submitted",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorStyle.primaryTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  isCorrect
                      ? "Congratulations 🥳\nYou've recieved +$points points for this question, and your total score is"
                      : "Oops 😔\nYou've not recieved any points for this question, and your total score is still",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: ColorStyle.secondaryTextColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                StatefulBuilder(builder: (context, setState) {
                  Future.delayed(const Duration(milliseconds: 300))
                      .then((value) {
                    if (teamScore == originalTeamScore && isCorrect) {
                      setState(() {
                        teamScore += points;
                      });
                    }
                  });
                  return AnimatedFlipCounter(
                    duration: const Duration(milliseconds: 1000),
                    prefix: isCorrect ? "+ " : "",
                    suffix: isCorrect ? " ✅" : " ❌",
                    value: teamScore,
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: isCorrect
                            ? ColorStyle.green100Color
                            : ColorStyle.red100Color),
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: SizedBox(
                      height: 50,
                      width: double.maxFinite,
                      child: CustomRoundedButton(
                        "Continue",
                        () {
                          if (isSubmitted) {
                            Navigator.of(context).pop();
                            if (!areAllAnswersNonNull()) {
                              _moveToNextPage();
                            } else {
                              Navigator.of(context).pushNamed(pointsRoute,
                                  arguments:
                                      QuestionArgs(challenge: challenge));
                            }
                          }
                        },
                        textSize: 14,
                        roundedCorners: 4,
                        textWeight: FontWeight.w600,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) => dialog,
        barrierColor: const Color(0x59000000));
  }
}
