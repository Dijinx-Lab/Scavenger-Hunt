import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scavenger_hunt/models/api/team/list_response/team_list_response.dart';
import 'package:scavenger_hunt/models/api/team/team/team.dart';
import 'package:scavenger_hunt/models/events/refresh_leaderboards/refresh_leaderboards.dart';
import 'package:scavenger_hunt/services/team_service.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
import 'package:scavenger_hunt/utility/toast_utils.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class LeaderboardScreen extends StatefulWidget {
  static final eventBus = EventBus();
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final ScrollController _scrollController = ScrollController();
  late TeamService teamService;
  String myScorePosition = "";
  List<Team> teams = [];
  bool isLoading = false;

  @override
  void initState() {
    teamService = TeamService();
    _getLeaderboard();

    LeaderboardScreen.eventBus.on<RefreshLeaderboards>().listen((event) {
      if (mounted) {
        _getLeaderboard();
      }
    });
    _scrollController.addListener(() => _checkElementPosition(teams
        .indexWhere((element) => element.id == PrefUtil().currentTeam!.id)));
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

  _getLeaderboard() {
    setState(() {
      isLoading = true;
    });
    teamService.getLeaderboards().then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.error == null) {
        TeamListResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          teams = apiResponse.data?.teams ?? [];
          _checkElementPosition(teams.indexWhere(
              (element) => element.id == PrefUtil().currentTeam!.id));
        } else {
          ToastUtils.showCustomSnackbar(
            context: context,
            contentText: apiResponse.message ?? "",
            icon: const Icon(
              Icons.cancel_outlined,
              color: ColorStyle.whiteColor,
            ),
          );
        }
      } else {
        ToastUtils.showCustomSnackbar(
          context: context,
          contentText: value.error ?? "",
          icon: const Icon(
            Icons.cancel_outlined,
            color: ColorStyle.whiteColor,
          ),
        );
      }
    });
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
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Leaderboard",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              color: ColorStyle.primaryTextColor),
                        ),
                        Text(
                          "Europe Ratings",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: ColorStyle.secondaryTextColor),
                        ),
                      ],
                    ),
                  ),
                  isLoading
                      ? const Center(
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              color: ColorStyle.primaryColor,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 30,
                          child: CustomRoundedButton(
                            "Refresh",
                            () => _getLeaderboard(),
                            roundedCorners: 40,
                            textSize: 12,
                            leftPadding: 20,
                            rightPadding: 20,
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                  child: AnimationLimiter(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: teams.length,
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
    bool isMyTeam = teams[index].id == PrefUtil().currentTeam!.id;
    return Container(
      margin: EdgeInsets.only(
          top: 8, bottom: index == (teams.length - 1) ? 130 : 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isMyTeam ? ColorStyle.primaryColor : ColorStyle.cardColor,
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
                        color: isMyTeam
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
          ClipRRect(
            borderRadius: BorderRadius.circular(300),
            child: SizedBox(
              width: 40,
              height: 40,
              child: CachedNetworkImage(
                imageUrl: 'https://via.placeholder.com/400',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                teams[index].name ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: isMyTeam
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
                    color: isMyTeam
                        ? ColorStyle.whiteColor
                        : ColorStyle.greyTextColor),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '${teams[index].score ?? 0}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: isMyTeam
                    ? ColorStyle.whiteColor
                    : ColorStyle.primaryTextColor),
          ),
        ],
      ),
    );
  }
}
