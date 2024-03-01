import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  String _selectedAnswer = "";
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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "History of science",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: ColorStyle.primaryTextColor),
                          ),
                          Text(
                            "Answer a question and move to next one",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: ColorStyle.secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        "1/10",
                        style: TextStyle(
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 300,
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: ColorStyle.blackColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "If David’s age is 27 year old in 2011. What was his age in 200?",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: ColorStyle.primaryTextColor),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedAnswer = "1";
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    decoration: BoxDecoration(
                                      color: _selectedAnswer == "1"
                                          ? ColorStyle.primaryColor
                                          : ColorStyle.cardColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ColorStyle.blackColor,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Answer 1",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: _selectedAnswer == '1'
                                                ? ColorStyle.whiteColor
                                                : ColorStyle.primaryTextColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedAnswer = "2";
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    decoration: BoxDecoration(
                                      color: _selectedAnswer == "2"
                                          ? ColorStyle.primaryColor
                                          : ColorStyle.cardColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ColorStyle.blackColor,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Answer 1",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: _selectedAnswer == '2'
                                                ? ColorStyle.whiteColor
                                                : ColorStyle.primaryTextColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedAnswer = "3";
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    decoration: BoxDecoration(
                                      color: _selectedAnswer == "3"
                                          ? ColorStyle.primaryColor
                                          : ColorStyle.cardColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ColorStyle.blackColor,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Answer 1",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: _selectedAnswer == '3'
                                                ? ColorStyle.whiteColor
                                                : ColorStyle.primaryTextColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedAnswer = "4";
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    decoration: BoxDecoration(
                                      color: _selectedAnswer == "4"
                                          ? ColorStyle.primaryColor
                                          : ColorStyle.cardColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ColorStyle.blackColor,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Answer 1",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: _selectedAnswer == '4'
                                                ? ColorStyle.whiteColor
                                                : ColorStyle.primaryTextColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: CustomRoundedButton(
                    "Continue",
                    () => Navigator.of(context).pushNamed(pointsRoute),
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
