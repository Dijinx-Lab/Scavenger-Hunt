import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:scavenger_hunt/styles/color_style.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
import 'package:scavenger_hunt/widgets/bottom_sheets/map_point_sheet.dart';
import 'package:scavenger_hunt/widgets/bottom_sheets/quest_details_sheet.dart';
import 'package:scavenger_hunt/widgets/buttons/custom_rounded_button.dart';
import 'dart:math' show cos, sin, sqrt, pow;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool isQuestActive = false;
  bool showMap = false;
  // Mapbox related
  late LatLng latLng;
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;
  List<Map> carouselData = [];
  Symbol? myLocationSymbol;

  @override
  void initState() {
    super.initState();

    latLng = LatLng(PrefUtil().lastLatitude, PrefUtil().lastLongitude);
    print('LATLNG: $latLng');
    _initialCameraPosition = CameraPosition(target: latLng, zoom: 16);
    Future.delayed(const Duration(milliseconds: 400))
        .then((value) => setState(() {
              showMap = true;
            }));
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    controller.onSymbolTapped.add(_onSymbolTapped);
  }

  void _onSymbolTapped(Symbol symbol) {
    // Handle symbol tap here
    _openBottomSheet(context, const MapPointSheet());
    // You can perform any action you want when a symbol is tapped
  }

  void _addCurrentLocationMarker() {
    final symbolOptions = SymbolOptions(
      geometry: latLng,
      iconImage: 'assets/pngs/map_pucs/my_location_puc.png',
      zIndex: 1,
    );
    controller.addSymbol(symbolOptions).then((symbol) {
      setState(() {
        myLocationSymbol = symbol;
      });
    });
    _addMarkersAroundCurrentLocation();
  }

  void _addMarkersAroundCurrentLocation() {
    const double radius = 200.0; // 200 meters
    const double degree = 80; // angle between markers
    const double radiusInDegree = radius / 111000; // 1 degree = 111 km

    for (int i = 0; i < 4; i++) {
      final double angle = degree * i;
      final double dx = radiusInDegree * cos(angle);
      final double dy = radiusInDegree * sin(angle);
      final double newLat = latLng.latitude + dy;
      final double newLng = latLng.longitude + dx;
      if (i == 3) {
        controller.addSymbol(SymbolOptions(
            geometry: LatLng(newLat, newLng),
            iconImage: 'assets/pngs/map_pucs/completed_challenge_puc.png',
            zIndex: 1));
      } else if (i == 2) {
        controller.addSymbol(SymbolOptions(
            geometry: LatLng(newLat, newLng),
            iconImage: 'assets/pngs/map_pucs/final_challenge_puc.png',
            zIndex: 1));
      } else if (i == 1) {
        controller.addSymbol(SymbolOptions(
            geometry: LatLng(newLat, newLng),
            iconImage: 'assets/pngs/map_pucs/active_challenge_puc.png',
            zIndex: 1));
      } else {
        controller.addSymbol(SymbolOptions(
            geometry: LatLng(newLat, newLng),
            iconImage: 'assets/pngs/map_pucs/challenge_puc.png',
            zIndex: 1));
      }
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
                : AnimatedOpacity(
                    opacity: !showMap ? 0 : 1,
                    duration: Durations.long4,
                    child: SizedBox(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      child: MapboxMap(
                        accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
                        initialCameraPosition: _initialCameraPosition,
                        onMapCreated: _onMapCreated,
                        onStyleLoadedCallback: _addCurrentLocationMarker,
                        myLocationTrackingMode:
                            MyLocationTrackingMode.TrackingGPS,
                        minMaxZoomPreference:
                            const MinMaxZoomPreference(14, 17),
                        onUserLocationUpdated: (location) {
                          PrefUtil().setLastLatitude =
                              location.position.latitude;
                          PrefUtil().setLastLongitude =
                              location.position.longitude;
                          if (myLocationSymbol != null) {
                            final changes = SymbolOptions(geometry: latLng);
                            controller.updateSymbol(myLocationSymbol!, changes);
                            controller.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(target: location.position),
                              ),
                            );
                          }
                        },
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
              bottom: 130,
              right: 15,
              child: GestureDetector(
                onTap: () {
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(_initialCameraPosition),
                  );
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
                        () => _openBottomSheet(
                            context, const QuestDetailsSheet()),
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

  void _openBottomSheet(BuildContext context, Widget sheet) async {
    await showModalBottomSheet(
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
  }
}
