import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/events/notification_recieved/notification_recieved.dart';
import 'package:scavenger_hunt/models/events/refresh_leaderboards/refresh_leaderboards.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
import 'package:scavenger_hunt/views/leaderboard/leaderboard_screen.dart';
import 'package:scavenger_hunt/views/map/map_screen.dart';

class BaseScreen extends StatefulWidget {
  static final eventBus = EventBus();
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  initState() {
    super.initState();

    _openRouteSummary();
    BaseScreen.eventBus
        .on<NotificationRecieved>()
        .listen((event) => _handleNotification(event));
  }

  _handleNotification(NotificationRecieved notification) {
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      if (notification.action == "open_route_summary") {
        Navigator.of(context).pushNamed(finishedRoute);
      }
    });
  }

  _openRouteSummary() {
    if (PrefUtil().currentRoute!.timings?.endTime != null) {
      Future.delayed(const Duration(milliseconds: 800))
          .then((value) => Navigator.of(context).pushNamed(finishedRoute));
    }
  }

  // _handleInitialNotification() {
  //   "initialNotif: ${PrefUtil().lastNotificationAction}");
  //   if (PrefUtil().lastNotificationAction != null) {
  //     NotificationAction notifAction = PrefUtil().lastNotificationAction!;
  //     PrefUtil().lastNotificationAction = null;
  //     notifAction);
  //     Future.delayed(const Duration(milliseconds: 500)).then((value) {
  //       if (notifAction.action == "open_route_summary") {
  //         Navigator.of(context).pushNamed(finishedRoute);
  //       }
  //     });
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      const MapScreen(),
      //const TeamManagementScreen(),
      const LeaderboardScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      body: LazyLoadIndexedStack(
        index: _currentIndex,
        children: _buildScreens(),
      ),
      bottomNavigationBar: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 150,
              width: double.maxFinite,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    ColorStyle.whiteColor,
                    ColorStyle.whiteColor.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: ColorStyle.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: ColorStyle.blackColor.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 30,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: SalomonBottomBar(
                  itemShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  selectedColorOpacity: 1,
                  currentIndex: _currentIndex,
                  onTap: (i) {
                    if (i == 1) {
                      LeaderboardScreen.eventBus.fire(RefreshLeaderboards());
                    }
                    setState(() => _currentIndex = i);
                  },
                  items: [
                    SalomonBottomBarItem(
                      icon: SvgPicture.asset('assets/svgs/ic_map.svg'),
                      activeIcon:
                          SvgPicture.asset('assets/svgs/ic_map_active.svg'),
                      title: const Text(
                        "Map",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ColorStyle.whiteColor),
                      ),
                      selectedColor: ColorStyle.primaryColor,
                    ),
                    // SalomonBottomBarItem(
                    //   icon: SvgPicture.asset('assets/svgs/ic_team.svg'),
                    //   activeIcon:
                    //       SvgPicture.asset('assets/svgs/ic_team_active.svg'),
                    //   title: const Text(
                    //     "Team",
                    //     style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w500,
                    //         color: ColorStyle.whiteColor),
                    //   ),
                    //   selectedColor: ColorStyle.primaryColor,
                    // ),
                    SalomonBottomBarItem(
                      icon: SvgPicture.asset('assets/svgs/ic_trophy.svg'),
                      activeIcon:
                          SvgPicture.asset('assets/svgs/ic_trophy_active.svg'),
                      title: const Text(
                        "Leaderboard",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ColorStyle.whiteColor),
                      ),
                      selectedColor: ColorStyle.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
