import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/widgets/custom_rounded_button.dart';
import 'package:scavenger_hunt/widgets/custom_text_field.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final TextEditingController _teamNameController = TextEditingController();
  Color _fieldBorderColor = ColorStyle.outline100Color;
  String? errorText;

  @override
  void initState() {
    _teamNameController.addListener(() => _teamControllerListener());
    super.initState();
  }

  _teamControllerListener() {
    setState(() {
      if (_teamNameController.text.isNotEmpty) {
        _fieldBorderColor = ColorStyle.blackColor;
      } else {
        _fieldBorderColor = ColorStyle.outline100Color;
      }
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
                  "Enter name to create a team",
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
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Team name",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: ColorStyle.primaryTextColor),
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _teamNameController,
                  hint: "Enter team name",
                  borderColor: _fieldBorderColor,
                  errorText: errorText,
                  onTap: () {
                    setState(() {
                      errorText = null;
                    });
                  },
                ),
                const Spacer(),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: CustomRoundedButton(
                    "Create Team",
                    () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (_teamNameController.text.toLowerCase() ==
                          "wild cats") {
                        setState(() {
                          errorText = "Name already used";
                        });
                      } else {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(teamCodeRoute);
                      }
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
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(joinTeamRoute);
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
}
