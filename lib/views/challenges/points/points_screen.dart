import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
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
                RichText(
                  textScaler: MediaQuery.textScalerOf(context),
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text: "Congratulations your team received ",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: ColorStyle.primaryTextColor),
                    children: [
                      TextSpan(
                        text: "315 points",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            color: ColorStyle.primaryColor),
                      ),
                    ],
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
                    child: ListView(
                      children: List.generate(
                        3,
                        (index) => AnimationConfiguration.staggeredList(
                          position: index,
                          child: FadeInAnimation(
                              curve: Curves.decelerate,
                              child: SlideAnimation(
                                horizontalOffset: 80,
                                curve: Curves.decelerate,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: ColorStyle.cardColor,
                                    border: Border.all(
                                      color: ColorStyle.blackColor,
                                    ),
                                  ),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "If David’s age is 27 year old in 2011. What was his age in 200?",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: ColorStyle.primaryTextColor),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Answer 2",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: ColorStyle.primaryColor),
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
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: CustomRoundedButton(
                    "Continue",
                    () => Navigator.of(context).pushNamed(finishedRoute),
                    textColor: ColorStyle.whiteColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
