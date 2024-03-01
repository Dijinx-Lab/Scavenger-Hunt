import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class JoinTeamScreen extends StatefulWidget {
  const JoinTeamScreen({super.key});

  @override
  State<JoinTeamScreen> createState() => _JoinTeamScreenState();
}

class _JoinTeamScreenState extends State<JoinTeamScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _pinController = TextEditingController();
  bool showPinError = false;
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
                          "Join Team",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              color: ColorStyle.primaryTextColor),
                        ),
                        Text(
                          "Create a team or join",
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
                const Spacer(),
                Center(
                  child: SvgPicture.asset("assets/svgs/ic_people.svg"),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter code to join a team",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: ColorStyle.primaryTextColor),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Text(
                    "Create a team or join",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: ColorStyle.secondaryTextColor),
                  ),
                ),
                const SizedBox(height: 10),
                Pinput(
                  length: 6,
                  controller: _pinController,
                  focusNode: _focusNode,
                  autofocus: false,
                  errorText: "Wrong code",
                  forceErrorState: showPinError,
                  preFilledWidget: Container(
                    width: 7,
                    height: 1.5,
                    color: ColorStyle.outline100Color,
                  ),
                  defaultPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                    color: ColorStyle.backgroundColor,
                    border: Border.all(color: ColorStyle.outline100Color),
                    borderRadius: BorderRadius.circular(6),
                  )),
                  androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsRetrieverApi,
                  focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: ColorStyle.backgroundColor,
                        border: Border.all(color: ColorStyle.blackColor),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      textStyle: const TextStyle(
                          color: ColorStyle.primaryTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: ColorStyle.backgroundColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: ColorStyle.blackColor),
                      ),
                      textStyle: const TextStyle(
                          color: ColorStyle.primaryTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  errorPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: ColorStyle.backgroundColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: ColorStyle.red100Color),
                      ),
                      textStyle: const TextStyle(
                          color: ColorStyle.red100Color,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  onChanged: (value) {},
                  onTap: () {
                    setState(() {
                      showPinError = false;
                    });
                  },
                  onCompleted: (value) {
                    if (_pinController.text == "111111") {
                      setState(() {
                        showPinError = true;
                      });
                    }
                  },
                  showCursor: true,
                  cursor: cursor,
                ),
                const Spacer(),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: CustomRoundedButton(
                    "Create Team",
                    () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(createTeamRoute);
                    },
                    textColor: ColorStyle.whiteColor,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: CustomRoundedButton(
                    "Join Team",
                    () {
                      if (!showPinError) {
                        Navigator.of(context).pushNamed(processingRoute);
                      }
                    },
                    textColor: ColorStyle.primaryColor,
                    buttonBackgroundColor: ColorStyle.whiteColor,
                    waterColor: ColorStyle.primaryColor.withOpacity(0.1),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final defaultPinTheme = const PinTheme(
    width: 50,
    height: 50,
    textStyle: TextStyle(
        color: Color.fromRGBO(70, 69, 66, 1),
        fontSize: 30,
        fontWeight: FontWeight.w400),
  );

  final cursor = Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: 21,
      height: 1,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(137, 146, 160, 1),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
