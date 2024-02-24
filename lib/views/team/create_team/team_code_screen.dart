import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/toast_utils.dart';
import 'package:scavenger_hunt/widgets/custom_rounded_button.dart';
import 'package:scavenger_hunt/widgets/custom_text_field.dart';

class TeamCodeScreen extends StatefulWidget {
  const TeamCodeScreen({super.key});

  @override
  State<TeamCodeScreen> createState() => _TeamCodeScreenState();
}

class _TeamCodeScreenState extends State<TeamCodeScreen> {
  final TextEditingController _teamCodeController = TextEditingController();

  @override
  void initState() {
    _teamCodeController.text = "5124123";
    super.initState();
  }

  _copyTextToClipboard() {
    FlutterClipboard.copy(_teamCodeController.text).then((value) =>
        ToastUtils.showSnackBar(
            context, "Code copied to clipboard", "success"));
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
                          "Create Team",
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
                  "Team successfully created!",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: ColorStyle.primaryTextColor),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Text(
                    "Your team successfully created here is code for your team to jin",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: ColorStyle.secondaryTextColor),
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Team code",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: ColorStyle.primaryTextColor),
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _teamCodeController,
                  readOnly: true,
                  trailing: GestureDetector(
                    onTap: () => _copyTextToClipboard(),
                    child: SizedBox(
                        width: 90,
                        child: Row(children: [
                          const Text(
                            "Copy",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: ColorStyle.primaryColor),
                          ),
                          IconButton(
                            onPressed: () => _copyTextToClipboard(),
                            icon: SvgPicture.asset(
                              "assets/svgs/ic_copy.svg",
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ])),
                  ),
                ),
               
                const Spacer(),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: CustomRoundedButton(
                    "Continue",
                    () {
                      Navigator.of(context).pushNamed(processingRoute);
                    },
                    textColor: ColorStyle.whiteColor,
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
}
