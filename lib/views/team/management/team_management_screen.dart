import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scavenger_hunt/models/active_user.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/avatar_utils.dart';
import 'package:scavenger_hunt/utility/clipboard_utils.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';
import 'package:scavenger_hunt/widgets/inputs/custom_text_field.dart';

class TeamManagementScreen extends StatefulWidget {
  const TeamManagementScreen({super.key});

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> {
  final TextEditingController _teamCodeController = TextEditingController();
  bool isActive = false;

  @override
  void initState() {
    _teamCodeController.text = "5124123";
    super.initState();
  }

  List<ActiveUser> _getActiveUsers() {
    return [
      ActiveUser("Tom", "U+1F482", "#FFECCF"),
      ActiveUser("Alice", "U+1F3AD", "#DDEFFF"),
      ActiveUser("Jon", "U+1F5F3", "#E2FFEC"),
      ActiveUser("Agnes", "U+1F340", "#FFFDD2"),
      ActiveUser("Trey", "U+1F6F9", "#FFF4E4"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: EdgeInsets.only(
              left: 25, right: 25, top: MediaQuery.of(context).padding.top),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      "Team Management",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: ColorStyle.primaryTextColor),
                    ),
                    const Text(
                      "Review team management",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: ColorStyle.secondaryTextColor),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Team code",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: ColorStyle.primaryTextColor),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _teamCodeController,
                      readOnly: true,
                      trailing: GestureDetector(
                        onTap: () => ClipboardUtils.copyToClipboard(
                            context, _teamCodeController.text),
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
                                onPressed: () => ClipboardUtils.copyToClipboard(
                                    context, _teamCodeController.text),
                                icon: SvgPicture.asset(
                                  "assets/svgs/ic_copy.svg",
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                            ])),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Active users",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: ColorStyle.primaryColor),
                    ),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: AnimationConfiguration.toStaggeredList(
                          childAnimationBuilder: (widget) => FadeInAnimation(
                            curve: Curves.decelerate,
                            child: ScaleAnimation(
                                //horizontalOffset: 80,
                                curve: Curves.decelerate,
                                child: widget),
                          ),
                          children: List.generate(
                            _getActiveUsers().length,
                            (index) => Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: AvatarUtils.hexToColor(
                                      _getActiveUsers()[index].bgColor),
                                  child: Text(
                                    AvatarUtils.getEmoji(
                                        _getActiveUsers()[index].emoji),
                                    style: const TextStyle(fontSize: 34),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _getActiveUsers()[index].name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: ColorStyle.greyTextColor),
                                )
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 20),
                    isActive
                        ? _buildChallengeActiveWidget()
                        : _buildOverallStatsWidget(),
                    const SizedBox(height: 130),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        isActive = !isActive;
                      });
                    },
                    child: const Text("Mock Active State")),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildOverallStatsWidget() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: AnimationConfiguration.toStaggeredList(
          childAnimationBuilder: (widget) => FadeInAnimation(
            curve: Curves.decelerate,
            child: SlideAnimation(
                horizontalOffset: 80, curve: Curves.decelerate, child: widget),
          ),
          children: [
            const Text(
              "Overall Stats",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: ColorStyle.primaryTextColor),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.maxFinite,
              height: 190,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorStyle.blackColor, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: AvatarUtils.hexToColor(
                            _getActiveUsers()[0].bgColor),
                        child: Text(
                          AvatarUtils.getEmoji(_getActiveUsers()[0].emoji),
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                      // Image.asset(
                      //   _getActiveUsers()[0].image,
                      //   width: 50,
                      //   height: 50,
                      // ),
                      const SizedBox(height: 8),
                      const Text(
                        "Overview",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: ColorStyle.greyTextColor),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Wild Cats",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: ColorStyle.primaryTextColor),
                      ),
                      Row(
                        children: [
                          CustomRoundedButton(
                            "View Location",
                            () {},
                            roundedCorners: 40,
                            textSize: 12,
                            leftPadding: 20,
                            rightPadding: 20,
                          ),
                          const SizedBox(width: 4),
                          CustomRoundedButton(
                            "Manage",
                            () {},
                            roundedCorners: 40,
                            textSize: 12,
                            leftPadding: 20,
                            rightPadding: 20,
                            waterColor: ColorStyle.primaryColor.withOpacity(.1),
                            buttonBackgroundColor: ColorStyle.whiteColor,
                            textColor: ColorStyle.primaryColor,
                          )
                        ],
                      )
                    ],
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "ranking #335",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: ColorStyle.primaryColor),
                      ),
                      Spacer(),
                      Text(
                        "3150",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            color: ColorStyle.primaryColor),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Score",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: ColorStyle.greyTextColor),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

  _buildChallengeActiveWidget() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: AnimationConfiguration.toStaggeredList(
          childAnimationBuilder: (widget) => FadeInAnimation(
            curve: Curves.decelerate,
            child: SlideAnimation(
                horizontalOffset: 80, curve: Curves.decelerate, child: widget),
          ),
          children: [
            const Text(
              "Active Challenge: Bigfoot",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: ColorStyle.primaryTextColor),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.maxFinite,
              height: 190,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: ColorStyle.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorStyle.blackColor, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: AvatarUtils.hexToColor(
                                _getActiveUsers()[0].bgColor),
                            child: Text(
                              AvatarUtils.getEmoji(_getActiveUsers()[0].emoji),
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                      )),
                      // Image.asset(
                      //   _getActiveUsers()[0].image,
                      //   width: 50,
                      //   height: 50,
                      // ),
                      const SizedBox(height: 8),
                      const Text(
                        "Overview",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: ColorStyle.greyTextColor),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Wild Cats",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: ColorStyle.primaryTextColor),
                      ),
                      Row(
                        children: [
                          CustomRoundedButton(
                            "View Location",
                            () {},
                            roundedCorners: 40,
                            textSize: 12,
                            leftPadding: 20,
                            rightPadding: 20,
                          ),
                          const SizedBox(width: 4),
                          CustomRoundedButton(
                            "Manage",
                            () {},
                            roundedCorners: 40,
                            textSize: 12,
                            leftPadding: 20,
                            rightPadding: 20,
                            waterColor: ColorStyle.primaryColor.withOpacity(.1),
                            buttonBackgroundColor: ColorStyle.cardColor,
                            textColor: ColorStyle.primaryColor,
                          )
                        ],
                      )
                    ],
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Active",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: ColorStyle.primaryColor),
                      ),
                      Spacer(),
                      Text(
                        "3150",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            color: ColorStyle.primaryColor),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Score",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: ColorStyle.greyTextColor),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Active Challenge: Bigfoot",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: ColorStyle.primaryTextColor),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.maxFinite,
              height: 190,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorStyle.blackColor, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          children: List.generate(
                        1,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: AvatarUtils.hexToColor(
                                _getActiveUsers()[0].bgColor),
                            child: Text(
                              AvatarUtils.getEmoji(_getActiveUsers()[0].emoji),
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                      )),
                      // Image.asset(
                      //   _getActiveUsers()[0].image,
                      //   width: 50,
                      //   height: 50,
                      // ),
                      const SizedBox(height: 8),
                      const Text(
                        "Overview",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: ColorStyle.greyTextColor),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Wild Cats",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: ColorStyle.primaryTextColor),
                      ),
                      Row(
                        children: [
                          CustomRoundedButton(
                            "View Location",
                            () {},
                            roundedCorners: 40,
                            textSize: 12,
                            leftPadding: 20,
                            rightPadding: 20,
                          ),
                          const SizedBox(width: 4),
                          CustomRoundedButton(
                            "Manage",
                            () {},
                            roundedCorners: 40,
                            textSize: 12,
                            leftPadding: 20,
                            rightPadding: 20,
                            waterColor: ColorStyle.primaryColor.withOpacity(.1),
                            buttonBackgroundColor: ColorStyle.backgroundColor,
                            textColor: ColorStyle.primaryColor,
                          )
                        ],
                      )
                    ],
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "ranking #335",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: ColorStyle.primaryColor),
                      ),
                      Spacer(),
                      Text(
                        "3150",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            color: ColorStyle.primaryColor),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Score",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: ColorStyle.greyTextColor),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
