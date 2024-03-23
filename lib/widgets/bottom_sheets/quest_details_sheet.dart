import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class QuestDetailsSheet extends StatefulWidget {
  final double currentDistance;
  final double totalDistance;
  const QuestDetailsSheet(
      {super.key, required this.currentDistance, required this.totalDistance});

  @override
  State<QuestDetailsSheet> createState() => _QuestDetailsSheetState();
}

class _QuestDetailsSheetState extends State<QuestDetailsSheet> {
  final GlobalKey _sliderKey = GlobalKey();
  double _sliderValue = 0.0;
  late double _currentDistance;
  late double _totalDistance;

  @override
  void initState() {
    _currentDistance = widget.currentDistance;
    _totalDistance = widget.totalDistance;
    _sliderValue = _currentDistance;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    super.initState();
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                      const Text(
                        "Bigfoot",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            color: ColorStyle.primaryTextColor),
                      ),
                    ],
                  ),
                  _buildInfoWidget()
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).popAndPushNamed(challengesRoute);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.asset(
                      "assets/pngs/mini_map.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset(
              "assets/pngs/quest_road_active.png",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
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
                _sliderValue == _totalDistance ? "Finish Route" : "Stop",
                () {
                  if (_sliderValue == _totalDistance) {
                    Navigator.of(context).popAndPushNamed(challengesRoute);
                  } else {
                    Navigator.of(context).pop(false);
                  }
                },
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
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Current points: ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: ColorStyle.secondaryTextColor),
              ),
              Text(
                "300",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: ColorStyle.primaryColor),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                "Time: ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ColorStyle.outline100Color),
              ),
              Text(
                "1.30h",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ColorStyle.primaryColor),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Text(
                "Difficulty: ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ColorStyle.outline100Color),
              ),
              Text(
                "Medium",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ColorStyle.primaryColor),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Text(
                "Challenges: ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ColorStyle.outline100Color),
              ),
              Text(
                "13",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ColorStyle.primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
