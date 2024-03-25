import 'dart:io';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:scavenger_hunt/models/api/base/base_response.dart';
import 'package:scavenger_hunt/models/api/mapbox/mapbox_directions/mapbox_directions.dart';
import 'package:scavenger_hunt/models/events/symbol_tapped/symbol_tapped.dart';
import 'package:scavenger_hunt/services/direction_service.dart';
import 'dart:math' show cos, sin, sqrt, pow;

import 'package:scavenger_hunt/views/map/map_screen.dart';

class MapService {
  late LatLng currPosition;
  late CameraPosition initialCameraPosition;
  late MapboxMapController controller;

  Symbol? myLocationSymbol;
  List<Symbol> challengesSymbols = [];
  Symbol? selectedSymbol;
  Location location = Location();
  bool isRouteActive = false;
  Line? routeLine;
  LatLng? startingRoutePosition;
  bool isPlatformIos = Platform.isIOS;

  MapService(double lastLatitude, double lastLongitude) {
    currPosition = LatLng(lastLatitude, lastLongitude);
    initialCameraPosition = CameraPosition(target: currPosition, zoom: 16);
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
    if (routeActive) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currPosition, zoom: 17),
        ),
      );
    } else {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(initialCameraPosition),
      );
    }
  }

  Future<void> removeMarkersAndAddDestPuc() async {
    List<Symbol> symbolsToRemove = challengesSymbols
        .where((element) => element.id != selectedSymbol!.id)
        .toList();
    await controller.removeSymbols(symbolsToRemove);

    challengesSymbols
        .removeWhere((element) => element.id != selectedSymbol!.id);
    controller.updateSymbol(
      selectedSymbol!,
      SymbolOptions(
          geometry: selectedSymbol!.options.geometry,
          iconImage: 'assets/pngs/map_pucs/dest_puc.png',
          zIndex: 1),
    );

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currPosition, zoom: 17)));
  }

  Future<void> addCurrentLocationMarker() async {
    if (!isPlatformIos) {
      final symbolOptions = SymbolOptions(
        geometry: currPosition,
        iconImage: 'assets/pngs/map_pucs/my_location_puc.png',
        zIndex: 1,
      );

      Symbol symbol = await controller.addSymbol(symbolOptions);
      myLocationSymbol = symbol;
    }

    await addMarkersAroundCurrentLocation();
  }

  Future<void> addMarkersAroundCurrentLocation() async {
    const double radius = 200.0; // 200 meters
    const double degree = 80; // angle between markers
    const double radiusInDegree = radius / 111000; // 1 degree = 111 km

    for (int i = 0; i < 4; i++) {
      final double angle = degree * i;
      final double dx = radiusInDegree * cos(angle);
      final double dy = radiusInDegree * sin(angle);
      final double newLat = currPosition.latitude + dy;
      final double newLng = currPosition.longitude + dx;
      Symbol symbol;
      if (i == 3) {
        symbol = await controller.addSymbol(SymbolOptions(
            geometry: LatLng(newLat, newLng),
            iconImage: 'assets/pngs/map_pucs/completed_challenge_puc.png',
            zIndex: 1));
      } else if (i == 2) {
        symbol = await controller.addSymbol(SymbolOptions(
            geometry: LatLng(newLat, newLng),
            iconImage: 'assets/pngs/map_pucs/final_challenge_puc.png',
            zIndex: 1));
      } else if (i == 1) {
        symbol = await controller.addSymbol(SymbolOptions(
            geometry: LatLng(newLat, newLng),
            iconImage: 'assets/pngs/map_pucs/active_challenge_puc.png',
            zIndex: 1));
      } else {
        symbol = await controller.addSymbol(SymbolOptions(
            geometry: LatLng(newLat, newLng),
            iconImage: 'assets/pngs/map_pucs/challenge_puc.png',
            zIndex: 1));
      }
      challengesSymbols.add(symbol);
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
      LatLng newLatLng =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);

      currPosition = newLatLng;

      if (!isPlatformIos) {
        final symbolOptions = SymbolOptions(
          geometry: currPosition,
          iconImage: 'assets/pngs/map_pucs/my_location_puc.png',
          zIndex: 1,
        );
        await controller.updateSymbol(myLocationSymbol!, symbolOptions);
      }
      if (isRouteActive) {
        updateRoute();
      }
    });
  }

  void updateRoute() async {
    BaseResponse directionsResponse = await DirectionService()
        .getDirections(currPosition, selectedSymbol!.options.geometry!);
    if (directionsResponse.error == null) {
      MapBoxDirection directions =
          directionsResponse.snapshot as MapBoxDirection;
      if (directions.routes!.isNotEmpty) {
        List<LatLng> routePoints =
            decodePolyline(directions.routes![0].geometry!);
        // Clear existing route and draw new one
        await controller.removeLine(routeLine!);
        addImageFromAsset("assetImage", "assets/pngs/line_pattern.png");

        routeLine = await controller.addLine(
          LineOptions(
            geometry: routePoints,
            lineColor: "#3F6AC9",
            lineWidth: 3,
            linePattern: "assetImage",
          ),
        );
      }
    } else {
      // ToastUtils.showSnackBar(
      //     context, "Could not get navigations at this moment", "fail");
    }
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

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.addImage(name, list);
  }

  Future<void> removeNavigationRoute() async {
    //REMOVE ROUTE LINE
    print(routeLine);
    controller.removeLine(routeLine!);
    routeLine = null;
    //REMOVE DEST MARKER
    print(challengesSymbols.first);
    controller.removeSymbol(challengesSymbols.first);
    challengesSymbols.clear();
    selectedSymbol = null;
    startingRoutePosition = null;
    //DISABLE THE ROUTE STATE
    isRouteActive = false;
    await addMarkersAroundCurrentLocation();
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currPosition, zoom: 16)));
  }

  Future<void> addNavigationRoute(MapBoxDirection directions) async {
    isRouteActive = true;
    startingRoutePosition = currPosition;
    addImageFromAsset("assetImage", "assets/pngs/line_pattern.png");
    List<LatLng> routePoints = decodePolyline(directions.routes![0].geometry!);
    routeLine = await controller.addLine(
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
}
