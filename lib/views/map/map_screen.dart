import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:scavenger_hunt/keys/route_keys.dart';
import 'package:scavenger_hunt/models/api/base/base_response.dart';
import 'package:scavenger_hunt/models/api/challenge/challenge.dart';
import 'package:scavenger_hunt/models/api/mapbox/mapbox_directions/mapbox_directions.dart';
import 'package:scavenger_hunt/models/api/route/route_response/route_response.dart';
import 'package:scavenger_hunt/models/arguments/learn_args.dart';
import 'package:scavenger_hunt/models/arguments/question_args.dart';
import 'package:scavenger_hunt/models/arguments/term_args.dart';
import 'package:scavenger_hunt/models/events/route_completed/route_completed.dart';
import 'package:scavenger_hunt/models/events/start_quest/start_quest.dart';
import 'package:scavenger_hunt/models/events/stop_quest/stop_quest.dart';
import 'package:scavenger_hunt/models/events/symbol_tapped/symbol_tapped.dart';
import 'package:scavenger_hunt/services/challenge_service.dart';
import 'package:scavenger_hunt/services/map_service.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
import 'package:scavenger_hunt/utility/timer_utils.dart';
import 'package:scavenger_hunt/widgets/bottom_sheets/map_point_sheet.dart';
import 'package:scavenger_hunt/widgets/bottom_sheets/quest_details_sheet.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';

class MapScreen extends StatefulWidget {
  static final eventBus = EventBus();
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late ChallengeService challengeService;
  bool isPlatformIos = Platform.isIOS;
  bool isQuestActive = false;
  LatLng? liveLocation;
  // Mapbox related
  late MapService mapService;

  String _timerValue = '--:--';
  bool showMap = false;

  @override
  void initState() {
    PrefUtil().isMapShown = true;
    _timerValue = TimerUtils().initialValue();
    TimerUtils().onUpdate((value) {
      setState(() {
        _timerValue = value;
      });
    });

    challengeService = ChallengeService();
    mapService = MapService(PrefUtil().lastLatitude, PrefUtil().lastLongitude);
    mapService.startUpdatingLocation((newPosition) {
      liveLocation = newPosition;
    });
    Future.delayed(const Duration(milliseconds: 100))
        .then((value) => setState(() {
              showMap = true;
            }));
    _informServer();
    super.initState();

    MapScreen.eventBus
        .on<SymbolTapped>()
        .listen((event) => _handleSymbolTap(event.symbol));
    MapScreen.eventBus
        .on<RouteCompleted>()
        .listen((event) => _handleRouteCompleted());
    MapScreen.eventBus.on<StopQuest>().listen((event) => _handleQuestStop());
    MapScreen.eventBus.on<StartQuest>().listen((event) => _handleQuestStart());
  }

  @override
  dispose() {
    mapService.dispose();
    super.dispose();
  }

  _handleRouteCompleted() {
    if (isQuestActive) {
      _handleQuestStop();
    }
    Navigator.of(context).pushNamed(finishedRoute);
  }

  _informServer() async {
    BaseResponse directionsResponse = await challengeService.startRoute(
      PrefUtil().currentRoute!.id!,
      PrefUtil().currentTeam!.teamCode!,
    );
    if (directionsResponse.error == null) {
      RouteResponse apiResponse = directionsResponse.snapshot as RouteResponse;
      if (apiResponse.success ?? false) {
        PrefUtil().currentRoute = apiResponse.data?.route!;

        if (PrefUtil().currentRoute!.timings != null) {
          TimerUtils()
              .startCountdown(PrefUtil().currentRoute!.timings!.timeLeft!);
        }
      }
    }
  }

  _handleQuestStop() async {
    await mapService.removeNavigationRoute();
    setState(() {
      isQuestActive = false;
    });
  }

  _handleQuestStart() {
    setState(() {
      isQuestActive = true;
    });
  }

  _handleNavigationDataToPolylines(MapBoxDirection directions) async {
    await mapService.addNavigationRoute(directions);
    setState(() {
      isQuestActive = true;
    });
  }

  _handleSymbolTap(Symbol symbol) {
    if (symbol.data?['challengeDetails'] == null) {
      return;
    }

    if (!isQuestActive) {
      _openBottomSheet(
          context,
          MapPointSheet(
            source: mapService.currPosition,
            dest: mapService.selectedSymbol!.options.geometry!,
            challenge: symbol.data!['challengeDetails'],
          ), (MapBoxDirection? directions) async {
        if (directions != null) {
          _handleNavigationDataToPolylines(directions);
        }
      });
    } else {
      _openQuestSheet();
    }
  }

  _openQuestSheet() async {
    List<double> distances = await mapService.getDistanceDetails();
    bool hasReached = await mapService.getIsCloseToTarget();
    Challenge challenge = mapService.getActiveChallenge();
    if (mounted) {
      _openBottomSheet(
          context,
          QuestDetailsSheet(
              currentDistance: distances[0],
              totalDistance: distances[1],
              reached: hasReached,
              challenge: challenge), (bool? continueNavigation) async {
        if (continueNavigation != null && !continueNavigation) {
          _handleQuestStop();
        }
      });
    }
  }

  _openQuestionsList() {
    Challenge challenge = mapService.getActiveChallenge();
    if (challenge.introUrl != null) {
      Navigator.of(context).pushNamed(learnRouteRoute,
          arguments: LearnArgs(isForFinish: false, challenge: challenge));
    } else {
      Navigator.of(context).pushNamed(challengesRoute,
          arguments: QuestionArgs(challenge: challenge));
    }
  }

  _addCurrentLocationMarker() async {
    await mapService.addCurrentLocationMarker();
    setState(() {});
  }

  _showActionsDialog() async {
    if (mounted) {
      var result = await showModalActionSheet(
        context: context,
        cancelLabel: "Cancel",
        title: "Select an option",
        actions: [
          const SheetAction(
              key: "terms",
              label: "Terms and Conditions",
              textStyle: TextStyle(color: ColorStyle.primaryColor)),
          const SheetAction(
              key: "privacy",
              label: "Privacy Policy",
              textStyle: TextStyle(color: ColorStyle.primaryColor)),
          const SheetAction(
              key: "signout",
              label: "Sign Out",
              textStyle: TextStyle(color: ColorStyle.red100Color)),
        ],
      );
      if (result == "signout") {
        PrefUtil().currentRoute = null;
        PrefUtil().currentTeam = null;
        PrefUtil().isTeamJoined = false;
        PrefUtil().isMapShown = false;

        await Future.delayed(Durations.extralong1);
        if (mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(splashRoute, (e) => false);
        }
      } else if (result == "privacy" && mounted) {
        Navigator.of(context).pushNamed(
          termsRoute,
          arguments: TermsArgs(forTerms: false, fromMap: true),
        );
      } else if (result == "terms" && mounted) {
        Navigator.of(context).pushNamed(
          termsRoute,
          arguments: TermsArgs(forTerms: true, fromMap: true),
        );
      }
    }
  }

  Widget _showRouteAlreadyCompleted() {
    return (PrefUtil().currentRoute?.timings?.endTime == null)
        ? Container()
        : GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(finishedRoute),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 130),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorStyle.backgroundColor,
                border: Border.all(color: ColorStyle.blackColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Already Completed',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: ColorStyle.primaryTextColor),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Your team has already participated and completed this route",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: ColorStyle.secondaryTextColor),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 30,
                    child: CustomRoundedButton(
                      "View Summary",
                      () => Navigator.of(context).pushNamed(finishedRoute),
                      roundedCorners: 40,
                      textSize: 12,
                      leftPadding: 20,
                      rightPadding: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _showQuestDetailsWidget() {
    return !isQuestActive
        ? Container()
        : Visibility(
            visible: isQuestActive,
            maintainAnimation: true,
            maintainState: true,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear,
              opacity: isQuestActive ? 1 : 0,
              child: GestureDetector(
                onTap: () => _openQuestSheet(),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 130),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ColorStyle.backgroundColor,
                    border: Border.all(color: ColorStyle.blackColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mapService.getActiveChallenge().name ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: ColorStyle.primaryTextColor),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Text(
                                "Current points: ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: ColorStyle.secondaryTextColor),
                              ),
                              Text(
                                "${PrefUtil().currentTeam!.score ?? 0}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: ColorStyle.primaryColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              // SizedBox(
                              //   height: 30,
                              //   child: CustomRoundedButton(
                              //     "View",
                              //     () => _openQuestSheet(),
                              //     roundedCorners: 40,
                              //     textSize: 12,
                              //     leftPadding: 20,
                              //     rightPadding: 20,
                              //   ),
                              // ),
                              // SizedBox(
                              //   width: 5,
                              // ),
                              SizedBox(
                                height: 30,
                                child: CustomRoundedButton(
                                  "Start",
                                  () => _openQuestionsList(),
                                  roundedCorners: 40,
                                  textSize: 12,
                                  leftPadding: 20,
                                  rightPadding: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            "assets/pngs/mini_map.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  void _openBottomSheet(
      BuildContext context, Widget sheet, Function onReturn) async {
    dynamic sheetResponse = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18.0),
        ),
      ),
      barrierColor: Colors.transparent,
      backgroundColor: ColorStyle.backgroundColor,
      isScrollControlled: true,
      builder: (BuildContext context) => sheet,
    );

    if (sheetResponse != null) {
      onReturn(sheetResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            !showMap
                ? Container()
                : isPlatformIos
                    ? AnimatedOpacity(
                        opacity: !showMap ? 0 : 1,
                        duration: Durations.long4,
                        child: SizedBox(
                          width: double.maxFinite,
                          height: double.maxFinite,
                          child: MapboxMap(
                            accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
                            initialCameraPosition:
                                mapService.initialCameraPosition,
                            onMapCreated: mapService.onMapCreated,
                            onStyleLoadedCallback: _addCurrentLocationMarker,
                            styleString: "assets/jsons/style.json",
                            myLocationEnabled: true,
                            myLocationRenderMode: MyLocationRenderMode.COMPASS,
                            myLocationTrackingMode:
                                MyLocationTrackingMode.Tracking,
                            minMaxZoomPreference:
                                const MinMaxZoomPreference(14, 17),
                            onUserLocationUpdated: (location) {},
                          ),
                        ),
                      )
                    : AnimatedOpacity(
                        opacity: !showMap ? 0 : 1,
                        duration: Durations.long4,
                        child: SizedBox(
                          width: double.maxFinite,
                          height: double.maxFinite,
                          child: MapboxMap(
                            accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
                            initialCameraPosition:
                                mapService.initialCameraPosition,
                            onMapCreated: mapService.onMapCreated,
                            onStyleLoadedCallback: _addCurrentLocationMarker,
                            styleString: "assets/jsons/style.json",
                            minMaxZoomPreference:
                                const MinMaxZoomPreference(14, 17),
                            onUserLocationUpdated: (location) {},
                          ),
                        ),
                      ),
            Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    ColorStyle.whiteColor.withOpacity(0),
                    ColorStyle.whiteColor,
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 25, right: 25, top: MediaQuery.of(context).padding.top),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${_timerValue}h",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            color: ColorStyle.primaryTextColor),
                      ),
                      IconButton(
                        onPressed: () => _showActionsDialog(),
                        icon: Image.asset(
                          "assets/pngs/helmet_logo.png",
                          width: 25,
                          fit: BoxFit.fitWidth,
                        ),
                      )
                    ],
                  ),
                  const Text(
                    "Time Left",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: ColorStyle.secondaryTextColor),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: isQuestActive ? 300 : 130,
              right: 15,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: ColorStyle.whiteColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        mapService.focusFirstLocation();
                      },
                      visualDensity: VisualDensity.compact,
                      icon: SvgPicture.asset(
                        'assets/svgs/ic_location_point.svg',
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        mapService.resetCameraPosition(isQuestActive);
                      },
                      visualDensity: VisualDensity.compact,
                      icon: SvgPicture.asset('assets/svgs/ic_target.svg'),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _showRouteAlreadyCompleted(),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: _showQuestDetailsWidget())
          ],
        ),
      ),
    );
  }
}
