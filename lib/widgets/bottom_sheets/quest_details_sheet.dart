import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/api/base/base_response.dart';
import 'package:scavenger_hunt/models/api/challenge/challenge.dart';
import 'package:scavenger_hunt/models/api/generic/generic_response.dart';
import 'package:scavenger_hunt/models/api/route/routes_response/routes_response.dart';
import 'package:scavenger_hunt/models/arguments/question_args.dart';
import 'package:scavenger_hunt/services/challenge_service.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class QuestDetailsSheet extends StatefulWidget {
  final double currentDistance;
  final double totalDistance;
  final bool reached;
  final Challenge challenge;
  const QuestDetailsSheet(
      {super.key,
      required this.currentDistance,
      required this.totalDistance,
      required this.challenge,
      required this.reached});

  @override
  State<QuestDetailsSheet> createState() => _QuestDetailsSheetState();
}

class _QuestDetailsSheetState extends State<QuestDetailsSheet> {
  late Challenge challenge;
  final GlobalKey _sliderKey = GlobalKey();
  double _sliderValue = 0.0;
  late double _currentDistance;
  late double _totalDistance;
  bool isLoading = false;
  bool reached = false;

  @override
  void initState() {
    reached = widget.reached;
    challenge = widget.challenge;
    _currentDistance = widget.currentDistance;
    _totalDistance = widget.totalDistance;
    _sliderValue = _currentDistance;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    super.initState();
  }

  Future<bool> _informServer() async {
    BaseResponse toggleActiveApi = await ChallengeService()
        .toggleActiveStatus(PrefUtil().currentTeam!.teamCode!, null);

    if (toggleActiveApi.error == null) {
      GenericResponse response = toggleActiveApi.snapshot as GenericResponse;
      if (response.success ?? false) {
        await _saveRouteDetails();
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
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
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 35),
      decoration: BoxDecoration(
          color: ColorStyle.backgroundColor,
          borderRadius: BorderRadius.circular(18)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.name ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: ColorStyle.primaryTextColor),
                    ),
                    Row(
                      children: [
                        const Text(
                          "Current points: ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: ColorStyle.secondaryTextColor),
                        ),
                        Text(
                          "${PrefUtil().currentTeam!.score ?? 0}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: ColorStyle.primaryColor),
                        ),
                      ],
                    ),
                    _buildInfoWidget()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).popAndPushNamed(
                      challengesRoute,
                      arguments: QuestionArgs(challenge: challenge)),
                  child: Image.asset(
                    'assets/pngs/mini_map.png',
                    height: 70,
                    width: 70,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              challenge.description ?? "",
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: ColorStyle.secondaryTextColor),
            ),
          ),
          const SizedBox(height: 40),
          _buildProgressWidget(),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: CustomRoundedButton(
                "",
                () async {
                  if (_sliderValue == _totalDistance) {
                    Navigator.of(context).popAndPushNamed(challengesRoute,
                        arguments: QuestionArgs(challenge: challenge));
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    bool isServerInformed = await _informServer();
                    setState(() {
                      isLoading = false;
                    });
                    if (isServerInformed && mounted) {
                      Navigator.of(context).pop(false);
                    }
                  }
                },
                widgetButton: isLoading
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: ColorStyle.whiteColor,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        reached ? "Finish Route" : "Stop",
                        style: const TextStyle(
                            height: 1.2,
                            fontSize: 16,
                            color: ColorStyle.whiteColor,
                            fontWeight: FontWeight.w500),
                      ),
                textColor: ColorStyle.whiteColor,
                buttonBackgroundColor: _sliderValue == _totalDistance
                    ? ColorStyle.primaryColor
                    : ColorStyle.red100Color,
                borderColor: _sliderValue == _totalDistance
                    ? ColorStyle.primaryColor
                    : ColorStyle.red100Color,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  _buildProgressWidget() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "0.0 km",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: ColorStyle.black200Color),
                      ),
                      Text(
                        "${_totalDistance.toStringAsFixed(2)} km",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: ColorStyle.red100Color),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Slider(
                      key: _sliderKey,
                      min: 0,
                      max: _totalDistance,
                      value: _sliderValue,
                      thumbColor: ColorStyle.whiteColor,
                      activeColor: ColorStyle.primaryColor,
                      inactiveColor: ColorStyle.grey100Color,
                      onChanged: (value) {}),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical:
                          _sliderValue > 0.3 && _sliderValue != _totalDistance
                              ? 4
                              : 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: _sliderValue > 0.3,
                            child:
                                SvgPicture.asset("assets/svgs/ic_chevron.svg"),
                          ),
                          const Text(
                            "Start",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: ColorStyle.primaryColor),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: _sliderValue == _totalDistance,
                            child: SvgPicture.asset(
                                "assets/svgs/ic_chevron.svg",
                                color: ColorStyle.red100Color),
                          ),
                          const Text(
                            "Finish",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: ColorStyle.red100Color),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: _sliderValue > 0.3 && _sliderValue != _totalDistance,
              child: Positioned(
                left: _getThumbPosition().dx - 20 + 8, // Adjust as needed
                top: _getThumbPosition().dy - 25, // Adjust as needed
                child: Column(
                  children: [
                    Text(
                      "${_sliderValue.toStringAsFixed(2)} km",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: ColorStyle.primaryColor),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    SvgPicture.asset("assets/svgs/ic_chevron.svg"),
                    const Text(
                      "Now",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: ColorStyle.primaryColor),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Offset _getThumbPosition() {
    RenderBox? renderBox =
        _sliderKey.currentContext?.findRenderObject() as RenderBox?;
    double thumbPosition = renderBox != null
        ? renderBox.size.width * (_sliderValue / _totalDistance)
        : 0;
    double dy = renderBox != null ? renderBox.size.height / 2 : 0;
    return Offset(thumbPosition, dy);
  }

  _buildInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              "Points: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: ColorStyle.outline100Color),
            ),
            Text(
              "${challenge.totalScore ?? 0}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: ColorStyle.primaryColor),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Text(
              "Difficulty: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: ColorStyle.outline100Color),
            ),
            Text(
              challenge.difficulty ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: ColorStyle.primaryColor),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Text(
              "Challenges: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: ColorStyle.outline100Color),
            ),
            Text(
              '${challenge.questions ?? 0}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: ColorStyle.primaryColor),
            ),
          ],
        ),
      ],
    );
  }
}
