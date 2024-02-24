import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/views/leaderboard/leaderboard_screen.dart';
import 'package:scavenger_hunt/views/map/map_screen.dart';
import 'package:scavenger_hunt/views/team/management/team_management_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home',
      style: optionStyle,
    ),
    Text(
      'Likes',
      style: optionStyle,
    ),
    Text(
      'Search',
      style: optionStyle,
    ),
    Text(
      'Profile',
      style: optionStyle,
    ),
  ];

  List<Widget> _buildScreens() {
    return [
      const MapScreen(),
      const TeamManagementScreen(),
      const LeaderboardScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Color(0xFFF6F6F6),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        body: IndexedStack(
          index: _currentIndex,
          children: _buildScreens(),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: ColorStyle.whiteColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: ColorStyle.blackColor.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 30,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: SalomonBottomBar(
              itemShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              selectedColorOpacity: 1,
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              items: [
                SalomonBottomBarItem(
                  icon: SvgPicture.asset('assets/svgs/ic_map.svg'),
                  activeIcon: SvgPicture.asset('assets/svgs/ic_map_active.svg'),
                  title: const Text(
                    "Map",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ColorStyle.whiteColor),
                  ),
                  selectedColor: ColorStyle.primaryColor,
                ),
                SalomonBottomBarItem(
                  icon: SvgPicture.asset('assets/svgs/ic_team.svg'),
                  activeIcon:
                      SvgPicture.asset('assets/svgs/ic_team_active.svg'),
                  title: const Text(
                    "Team",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ColorStyle.whiteColor),
                  ),
                  selectedColor: ColorStyle.primaryColor,
                ),
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
    );
  }
}
