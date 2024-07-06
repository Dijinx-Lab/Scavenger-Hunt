import 'dart:io';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:scavenger_hunt/models/api/base/base_response.dart';
import 'package:scavenger_hunt/models/api/challenge/challenge.dart';
import 'package:scavenger_hunt/models/api/mapbox/mapbox_directions/mapbox_directions.dart';
import 'package:scavenger_hunt/models/api/route/route/route.dart';
import 'package:scavenger_hunt/models/events/start_quest/start_quest.dart';
import 'package:scavenger_hunt/models/events/symbol_tapped/symbol_tapped.dart';
import 'package:scavenger_hunt/services/direction_service.dart';
import 'package:scavenger_hunt/utility/pref_utils.dart';
import 'dart:math';

import 'package:scavenger_hunt/views/map/map_screen.dart';

class MapService {
  late LatLng currPosition;
  late CameraPosition initialCameraPosition;
  MapboxMapController? controller;

  bool isPlatformIos = Platform.isIOS;
  Symbol? myLocationSymbol;
  List<Symbol> challengesSymbols = [];
  Symbol? selectedSymbol;
  Location location = Location.instance;
  bool isRouteActive = false;
  Line? routeLine;
  LatLng? startingRoutePosition;

  MapService.defaults();

  MapService(double lastLatitude, double lastLongitude) {
    currPosition = LatLng(lastLatitude, lastLongitude);
    initialCameraPosition = CameraPosition(target: currPosition, zoom: 16);
  }

  void dispose() {
    controller?.onSymbolTapped.remove(onSymbolTapped);
    controller?.dispose();
  }

  void onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    controller.onSymbolTapped.add(onSymbolTapped);
  }

  void onSymbolTapped(Symbol symbol) {
    selectedSymbol = symbol;
    MapScreen.eventBus
        .fire(SymbolTapped(symbol: symbol, routeActive: isRouteActive));
  }

  void resetCameraPosition(bool routeActive) {
    if (controller == null) return;
    if (routeActive) {
      controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currPosition, zoom: 17),
        ),
      );
    } else {
      controller!.animateCamera(
        CameraUpdate.newCameraPosition(initialCameraPosition),
      );
    }
  }

  void focusFirstLocation() {
    if (controller == null) return;
    controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(target: LatLng(32.240076, -80.683378), zoom: 17),
      ),
    );
  }

  Future<void> removeMarkersAndAddDestPuc() async {
    if (controller == null) return;
    List<Symbol> symbolsToRemove = challengesSymbols
        .where((element) => element.id != selectedSymbol!.id)
        .toList();
    await controller!.removeSymbols(symbolsToRemove);
    challengesSymbols
        .removeWhere((element) => element.id != selectedSymbol!.id);

    controller!.updateSymbol(
      selectedSymbol!,
      SymbolOptions(
          geometry: selectedSymbol!.options.geometry,
          iconImage: 'assets/pngs/map_pucs/dest_puc.png',
          zIndex: 1),
    );

    controller!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currPosition, zoom: 17)));
  }

  Future<void> addCurrentLocationMarker() async {
    if (controller == null) return;
    if (!isPlatformIos) {
      final symbolOptions = SymbolOptions(
        geometry: currPosition,
        iconImage: 'assets/pngs/map_pucs/my_location_puc.png',
        zIndex: 1,
      );

      Symbol symbol = await controller!.addSymbol(symbolOptions);
      myLocationSymbol = symbol;
    }

    await addChallengesMarkers();
  }

  Future<void> addChallengesMarkers() async {
    if (controller == null) return;
    RouteDetails routeDetails = PrefUtil().currentRoute!;
    List<Challenge> pendingChallenges = routeDetails.pendingChallenges ?? [];
    List<Challenge> completedChallenges =
        routeDetails.completedChallenges ?? [];
    Challenge? activeChallenge;
    if (routeDetails.timings?.endTime == null) {
      activeChallenge = routeDetails.activeChallenge;
    }

    for (Challenge challenge in pendingChallenges) {
      Symbol symbol = await controller!.addSymbol(
        SymbolOptions(
          geometry: LatLng(challenge.latitude!, challenge.longitude!),
          iconImage: 'assets/pngs/map_pucs/active_challenge_puc.png',
          zIndex: 1,
        ),
        {
          'challengeDetails': challenge,
        },
      );
      challengesSymbols.add(symbol);
    }
    for (Challenge challenge in completedChallenges) {
      Symbol symbol = await controller!.addSymbol(
        SymbolOptions(
          geometry: LatLng(challenge.latitude!, challenge.longitude!),
          iconImage: 'assets/pngs/map_pucs/completed_challenge_puc.png',
          zIndex: 1,
        ),
        {
          'challengeDetails': challenge,
        },
      );
      challengesSymbols.add(symbol);
    }

    // if (routeDetails.finishLineLat != null &&
    //     routeDetails.finishLineLong != null) {
    //   Symbol symbol = await controller!.addSymbol(
    //     SymbolOptions(
    //       geometry:
    //           LatLng(routeDetails.finishLineLat!, routeDetails.finishLineLong!),
    //       iconImage: 'assets/pngs/map_pucs/final_challenge_puc.png',
    //       zIndex: 1,
    //     ),
    //   );
    //   challengesSymbols.add(symbol);
    // }

    if (activeChallenge != null) {
      Symbol symbol = await controller!.addSymbol(
        SymbolOptions(
          geometry:
              LatLng(activeChallenge.latitude!, activeChallenge.longitude!),
          iconImage: 'assets/pngs/map_pucs/active_challenge_puc.png',
          zIndex: 1,
        ),
        {
          'challengeDetails': activeChallenge,
        },
      );
      challengesSymbols.add(symbol);
      selectedSymbol = symbol;
      getNavigationData();
    }
  }

  void startUpdatingLocation(Function(LatLng updatedPosition) onUpdate) async {
    location.changeSettings(
        accuracy: !isPlatformIos
            ? LocationAccuracy.high
            : LocationAccuracy.navigation,
        interval: 5000,
        distanceFilter: 5);
    location.onLocationChanged
        .distinct()
        .listen((LocationData currentLocation) async {
      if (controller == null) return;
      LatLng newLatLng =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);

      currPosition = newLatLng;

      if (!isPlatformIos) {
        final symbolOptions = SymbolOptions(
          geometry: currPosition,
          iconImage: 'assets/pngs/map_pucs/my_location_puc.png',
          zIndex: 1,
        );
        await controller!.updateSymbol(myLocationSymbol!, symbolOptions);
      }
      if (isRouteActive) {
        updateRoute();
      }
    });
  }

  void updateRoute() async {
    if (controller == null) return;
    BaseResponse directionsResponse = await DirectionService()
        .getDirections(currPosition, selectedSymbol!.options.geometry!);
    if (directionsResponse.error == null) {
      MapBoxDirection directions =
          directionsResponse.snapshot as MapBoxDirection;
      if (directions.routes!.isNotEmpty) {
        List<LatLng> routePoints =
            decodePolyline(directions.routes![0].geometry!);
        // Clear existing route and draw new one
        await controller!.removeLine(routeLine!);
        addImageFromAsset("assetImage", "assets/pngs/line_pattern.png");

        routeLine = await controller!.addLine(
          LineOptions(
            geometry: routePoints,
            lineColor: "#3F6AC9",
            lineWidth: 3,
            linePattern: "assetImage",
          ),
        );
      }
    } else {}
  }

  double calculateDistance(LatLng start, LatLng end) {
    double distanceInMeters = Geolocator.distanceBetween(
        start.latitude, start.longitude, end.latitude, end.longitude);

    return distanceInMeters / 1000;
  }

  Future<List<double>> getDistanceDetails() async {
    double totalDistance = calculateDistance(
        startingRoutePosition!, challengesSymbols.first.options.geometry!);

    double distanceFromStartingPoint =
        calculateDistance(startingRoutePosition!, currPosition);

    return [distanceFromStartingPoint, totalDistance];
  }

  Future<bool> getIsCloseToTarget() async {
    LatLng target = challengesSymbols.first.options.geometry!;
    LatLng curr = currPosition;

    double distance =
        DistanceCalculator.calculateDistance(currPosition, target);
    return distance <= 10;
  }

  Challenge getActiveChallenge() {
    return challengesSymbols.first.data!['challengeDetails'];
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    if (controller == null) return;
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller!.addImage(name, list);
  }

  Future<void> removeNavigationRoute() async {
    if (controller == null) return;
    //REMOVE ROUTE LINE

    controller!.removeLine(routeLine!);
    routeLine = null;
    //REMOVE DEST MARKER

    controller!.removeSymbol(challengesSymbols.first);
    challengesSymbols.clear();
    selectedSymbol = null;
    startingRoutePosition = null;
    //DISABLE THE ROUTE STATE
    isRouteActive = false;
    await addChallengesMarkers();
    controller!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currPosition, zoom: 16)));
  }

  Future<void> addNavigationRoute(MapBoxDirection directions) async {
    if (controller == null) return;
    isRouteActive = true;
    startingRoutePosition = currPosition;
    addImageFromAsset("assetImage", "assets/pngs/line_pattern.png");
    List<LatLng> routePoints = decodePolyline(directions.routes![0].geometry!);
    routeLine = await controller!.addLine(
      LineOptions(
        geometry: routePoints,
        lineColor: "#3F6AC9",
        lineWidth: 3,
        linePattern: "assetImage",
      ),
    );
    await removeMarkersAndAddDestPuc();
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = <LatLng>[];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  getNavigationData() async {
    BaseResponse directionsResponse = await DirectionService()
        .getDirections(currPosition, selectedSymbol!.options.geometry!);
    if (directionsResponse.error == null) {
      MapBoxDirection directions =
          directionsResponse.snapshot as MapBoxDirection;
      await addNavigationRoute(directions);
      MapScreen.eventBus.fire(StartQuest());
    }
  }
}

class DistanceCalculator {
  static const double earthRadius = 6371000; // in meters

  static double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  static double calculateDistance(LatLng point1, LatLng point2) {
    double lat1 = degreesToRadians(point1.latitude);
    double lon1 = degreesToRadians(point1.longitude);
    double lat2 = degreesToRadians(point2.latitude);
    double lon2 = degreesToRadians(point2.longitude);

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }
}

Future<bool> getIsCloseToTarget(LatLng currPosition, LatLng target) async {
  double distance = DistanceCalculator.calculateDistance(currPosition, target);
  return distance <= 20;
}
