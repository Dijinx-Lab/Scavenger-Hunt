import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class ChallengesDetailScreen extends StatefulWidget {
  const ChallengesDetailScreen({super.key});

  @override
  State<ChallengesDetailScreen> createState() => _ChallengesDetailScreenState();
}

class _ChallengesDetailScreenState extends State<ChallengesDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildActiveChallengeWidget(),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildActiveChallengeWidget(),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildActiveChallengeWidget(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        childAnimationBuilder: (widget) => FadeInAnimation(
                          curve: Curves.decelerate,
                          child: SlideAnimation(
                              horizontalOffset: 120,
                              curve: Curves.decelerate,
                              child: widget),
                        ),
                        children: [
                          _buildQuestChallengeWidget(),
                          _buildQuestChallengeWidget()
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: CustomRoundedButton(
                    "Skip",
                    () => (),
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

  _buildQuestChallengeWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Quest 17",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: ColorStyle.primaryTextColor.withOpacity(0.5)),
              ),
              const Text(
                "History of science",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: ColorStyle.primaryTextColor),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 30,
            child: CustomRoundedButton(
              "View",
              () => Navigator.of(context).pushNamed(questionsRoute),
              roundedCorners: 40,
              textSize: 12,
              leftPadding: 20,
              rightPadding: 20,
            ),
          ),
        ],
      ),
    );
  }

  _buildActiveChallengeWidget() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorStyle.primaryColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Available",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: ColorStyle.whiteColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: ColorStyle.whiteColor, shape: BoxShape.circle),
            child: const Text(
              "3",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: ColorStyle.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
