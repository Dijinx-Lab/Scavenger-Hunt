import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scavenger_hunt/models/leaderboard_entry.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/avatar_utils.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final ScrollController _scrollController = ScrollController();
  String myScorePosition = "";

  @override
  void initState() {
    _scrollController.addListener(() => _checkElementPosition(12));
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    _scrollController.animateTo(
      index * 80,
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
    );
  }

  _checkElementPosition(int index) {
    double viewportHeight = _scrollController.position.viewportDimension;
    double itemExtent = 80;

    double desiredOffset = index * itemExtent;
    double currentOffset = _scrollController.offset;

    if (desiredOffset < currentOffset) {
      myScorePosition = 'up';
    } else if (desiredOffset > currentOffset + viewportHeight) {
      myScorePosition = 'down';
    } else {
      myScorePosition = 'in view';
    }
    setState(() {});
  }

  List<LeaderboardEntry> _getLeaderboardEntries() {
    return [
      LeaderboardEntry("Wild Cats", "100", "U+1F482", "#E1DDD8"),
      LeaderboardEntry("Common Thiefs", "97", "U+1F3CB", "#E1DDD8"),
      LeaderboardEntry("Running Shoes", "96", "U+1F38F", "#E1DDD8"),
      LeaderboardEntry("Triple team", "92", "U+1F4CD", "#E1DDD8"),
      LeaderboardEntry("Solos", "87", "U+1F4CD", "#E1DDD8"),
      LeaderboardEntry("Duos", "85", "U+1F4CD", "#E1DDD8"),
      LeaderboardEntry("Flex", "80", "U+1F4CD", "#E1DDD8"),
      LeaderboardEntry("Running Shoes", "78", "U+1F4CD", "#E1DDD8"),
      LeaderboardEntry("Triple team", "74", "U+1F4CD", "#E1DDD8"),
      LeaderboardEntry("Solos", "70", "U+1F4CD", "#E1DDD8"),
      LeaderboardEntry("Duos", "85", "U+1F4CD", "#E1DDD8"),
      LeaderboardEntry("Flex", "80", "U+1F4CD", "#E1DDD8"),
      LeaderboardEntry("Running Shoes", "78", "U+1F4CD", "#E1DDD8"),
      LeaderboardEntry("Triple team", "74", "U+1F4CD", "#E1DDD8"),
      LeaderboardEntry("Solos", "70", "U+1F4CD", "#E1DDD8"),
      LeaderboardEntry("Duos", "85", "U+1F4CD", "#E1DDD8"),
      LeaderboardEntry("Flex", "80", "U+1F4CD", "#E1DDD8"),
      LeaderboardEntry("Running Shoes", "78", "U+1F4CD", "#E1DDD8"),
      LeaderboardEntry("Triple team", "74", "U+1F4CD", "#E1DDD8"),
      LeaderboardEntry("Solos", "70", "U+1F4CD", "#E1DDD8"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButton: _buildTakeToScoreButton(),
        body: Padding(
          padding: EdgeInsets.only(
              left: 25, right: 25, top: MediaQuery.of(context).padding.top),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Leaderboard",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: ColorStyle.primaryTextColor),
              ),
              const Text(
                "Europe Ratings",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: ColorStyle.secondaryTextColor),
              ),
              const SizedBox(height: 15),
              Expanded(
                  child: AnimationLimiter(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: _getLeaderboardEntries().length,
                  itemBuilder: (context, index) =>
                      AnimationConfiguration.staggeredList(
                    position: index,
                    child: ScaleAnimation(
                      scale: 0.5,
                      curve: Curves.decelerate,
                      child: FadeInAnimation(
                        curve: Curves.decelerate,
                        child: SlideAnimation(
                            horizontalOffset: 80,
                            curve: Curves.decelerate,
                            child: _buildLeaderboardTeamWidget(index)),
                      ),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTakeToScoreButton() {
    return Visibility(
      visible: myScorePosition != "in view",
      maintainAnimation: true,
      maintainState: true,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
        opacity: myScorePosition != "in view" ? 1 : 0,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 130),
            child: SizedBox(
              height: 60,
              width: 160,
              child: CustomRoundedButton(
                "View Location",
                () {
                  _scrollToIndex(12);
                },
                widgetButton:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                      myScorePosition == "up"
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 22,
                      color: ColorStyle.whiteColor),
                  const SizedBox(width: 10),
                  const Text(
                    "My score",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: ColorStyle.whiteColor),
                  )
                ]),
                roundedCorners: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardTeamWidget(int index) {
    return Container(
      margin: EdgeInsets.only(
          top: 8,
          bottom: index == (_getLeaderboardEntries().length - 1) ? 130 : 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: index == 11 ? ColorStyle.primaryColor : ColorStyle.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorStyle.blackColor, width: 1),
      ),
      child: Row(
        children: [
          index > 2
              ? SizedBox(
                  width: 25,
                  child: Text(
                    (index + 1).toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: index == 11
                            ? ColorStyle.whiteColor
                            : ColorStyle.primaryTextColor),
                  ),
                )
              : Image.asset(
                  index == 0
                      ? "assets/pngs/medal_1.png"
                      : index == 1
                          ? "assets/pngs/medal_2.png"
                          : "assets/pngs/medal_3.png",
                  width: 25,
                  height: 25,
                ),
          const SizedBox(width: 15),
          CircleAvatar(
            radius: 22,
            backgroundColor: index == 11
                ? const Color(0xFF4F7DE2)
                : AvatarUtils.hexToColor(
                    _getLeaderboardEntries()[index].bgColor),
            child: Text(
              AvatarUtils.getEmoji(_getLeaderboardEntries()[index].emoji),
              style: const TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getLeaderboardEntries()[index].name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: index == 11
                        ? ColorStyle.whiteColor
                        : ColorStyle.primaryTextColor),
              ),
              const SizedBox(height: 4),
              Text(
                "View team details",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: index == 11
                        ? ColorStyle.whiteColor
                        : ColorStyle.greyTextColor),
              ),
            ],
          ),
          const Spacer(),
          Text(
            _getLeaderboardEntries()[index].score,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: index == 11
                    ? ColorStyle.whiteColor
                    : ColorStyle.primaryTextColor),
          ),
        ],
      ),
    );
  }
}
