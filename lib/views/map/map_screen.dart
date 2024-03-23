import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:scavenger_hunt/models/api/mapbox/mapbox_directions/mapbox_directions.dart';
import 'package:scavenger_hunt/models/events/stop_quest/stop_quest.dart';
import 'package:scavenger_hunt/models/events/symbol_tapped/symbol_tapped.dart';
import 'package:scavenger_hunt/services/map_service.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
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
  bool isQuestActive = false;
  bool showMap = false;
  // Mapbox related
  late MapService mapService;
  LatLng? liveLocation;

  @override
  void initState() {
    mapService = MapService(PrefUtil().lastLatitude, PrefUtil().lastLongitude);
    mapService.startUpdatingLocation((newPosition) {
      liveLocation = newPosition;
    });
    Future.delayed(const Duration(milliseconds: 100))
        .then((value) => setState(() {
              showMap = true;
            }));
    super.initState();
    MapScreen.eventBus.on<SymbolTapped>().listen((event) => _handleSymbolTap());
    MapScreen.eventBus.on<StopQuest>().listen((event) => _handleQuestStop());
  }

  _handleQuestStop() async {
    await mapService.removeNavigationRoute();
    setState(() {
      isQuestActive = false;
    });
  }

  _handleNavigationDataToPolylines(MapBoxDirection directions) async {
    await mapService.addNavigationRoute(directions);
    setState(() {
      isQuestActive = true;
    });
  }

  _handleSymbolTap() {
    if (!isQuestActive) {
      _openBottomSheet(
          context,
          MapPointSheet(
            source: mapService.currPosition,
            dest: mapService.selectedSymbol!.options.geometry!,
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
    if (mounted) {
      _openBottomSheet(
          context,
          QuestDetailsSheet(
            currentDistance: distances[0],
            totalDistance: distances[1],
          ), (bool? continueNavigation) async {
        if (continueNavigation != null && !continueNavigation) {
          _handleQuestStop();
        }
      });
    }
  }

  _addCurrentLocationMarker() async {
    await mapService.addCurrentLocationMarker();
    setState(() {});
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
                : AnimatedOpacity(
                    opacity: !showMap ? 0 : 1,
                    duration: Durations.long4,
                    child: SizedBox(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      child: MapboxMap(
                        accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
                        initialCameraPosition: mapService.initialCameraPosition,
                        onMapCreated: mapService.onMapCreated,
                        onStyleLoadedCallback: _addCurrentLocationMarker,
                        styleString: "assets/jsons/style.json",
                        myLocationEnabled: true,
                        myLocationRenderMode: MyLocationRenderMode.COMPASS,
                        myLocationTrackingMode: MyLocationTrackingMode.Tracking,
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

            // Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       TextButton(
            //         onPressed: () {
            //           _openBottomSheet(context, const MapPointSheet());
            //         },
            //         child: const Text("Mock map point button"),
            //       ),
            //       TextButton(
            //         onPressed: () {
            //           setState(() {
            //             isQuestActive = !isQuestActive;
            //           });
            //         },
            //         child: const Text("Mock quest started state"),
            //       ),
            //     ],
            //   ),
            // ),
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
                      const Text(
                        "01:35h",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            color: ColorStyle.primaryTextColor),
                      ),
                      SvgPicture.asset("assets/svgs/ic_helmet.svg")
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
              child: GestureDetector(
                onTap: () {
                  mapService.resetCameraPosition(isQuestActive);
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorStyle.whiteColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/svgs/ic_location_light.svg'),
                      const SizedBox(height: 10),
                      SvgPicture.asset('assets/svgs/ic_target.svg'),
                    ],
                  ),
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: _showQuestDetailsWidget())
          ],
        ),
      ),
    );
  }

  Widget _showQuestDetailsWidget() {
    return Visibility(
        visible: isQuestActive,
        maintainAnimation: true,
        maintainState: true,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear,
          opacity: isQuestActive ? 1 : 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 130),
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
                    const Text(
                      "Quest 17",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: ColorStyle.primaryTextColor),
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      children: [
                        Text(
                          "Current points: ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: ColorStyle.secondaryTextColor),
                        ),
                        Text(
                          "300",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: ColorStyle.primaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 30,
                      child: CustomRoundedButton(
                        "View",
                        () => _openQuestSheet(),
                        roundedCorners: 40,
                        textSize: 12,
                        leftPadding: 20,
                        rightPadding: 20,
                      ),
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
}
