import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/api/team/team_response/team_response.dart';
import 'package:scavenger_hunt/services/team_service.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class JoinTeamScreen extends StatefulWidget {
  const JoinTeamScreen({super.key});

  @override
  State<JoinTeamScreen> createState() => _JoinTeamScreenState();
}

class _JoinTeamScreenState extends State<JoinTeamScreen> {
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

  final defaultPinTheme = const PinTheme(
    width: 50,
    height: 50,
    textStyle: TextStyle(
        color: Color.fromRGBO(70, 69, 66, 1),
        fontSize: 30,
        fontWeight: FontWeight.w400),
  );

  bool isJoinButtonLoading = false;
  bool showPinError = false;
  TeamService teamService = TeamService();

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _pinController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _joinTeam() async {
    setState(() {
      isJoinButtonLoading = true;
    });
    teamService.joinTeam(_pinController.text.trim()).then((value) async {
      setState(() {
        isJoinButtonLoading = false;
      });
      if (value.error == null) {
        TeamResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          PrefUtil().currentTeam = apiResponse.data?.team;
          PrefUtil().isTeamJoined = true;
          await showOkAlertDialog(
              context: context,
              title: 'Notifications',
              message:
                  "We use notifications to alert the teams about important information regarding their hunt.");
          _saveFcmToken();
        } else {
          setState(() {
            showPinError = true;
          });
        }
      } else {
        setState(() {
          showPinError = true;
        });
      }
    });
  }

  Future<String?> _getFcmToken() async {
    await _firebaseMessaging.requestPermission();
    return await _firebaseMessaging.getToken();
  }

  _saveFcmToken() async {
    setState(() {
      isJoinButtonLoading = true;
    });
    String? token = await _getFcmToken();

    teamService
        .updateTeam(
      PrefUtil().currentTeam!.teamCode!,
      token ?? '',
    )
        .then((value) async {
      setState(() {
        isJoinButtonLoading = false;
      });

      Navigator.of(context).pushNamed(processingRoute);
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
                          "Join Team",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              color: ColorStyle.primaryTextColor),
                        ),
                        Text(
                          "Join a team",
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
                    "Join a team",
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
                const SizedBox(height: 15),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: CustomRoundedButton("", () => _joinTeam(),
                      textColor: ColorStyle.whiteColor,
                      widgetButton: isJoinButtonLoading
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: ColorStyle.whiteColor,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Join Team",
                              style: TextStyle(
                                  height: 1.2,
                                  fontSize: 16,
                                  color: ColorStyle.whiteColor,
                                  fontWeight: FontWeight.w500),
                            )),
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
