import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:scavenger_hunt/keys/endpoint_keys.dart';
import 'package:scavenger_hunt/models/api/base/base_response.dart';
import 'package:scavenger_hunt/models/api/mapbox/mapbox_directions/mapbox_directions.dart';

class DirectionService {
  String directionsMode = 'walking';
  String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;
  Future<BaseResponse> getDirections(
    LatLng source,
    LatLng dest,
  ) async {
    try {
      String url = EndpointKeys.mapboxDirections;
      url =
          '$url/$directionsMode/${source.longitude},${source.latitude};${dest.longitude},${dest.latitude}?alternatives=true&continue_straight=true&geometries=polyline&language=en&overview=full&steps=true&access_token=$accessToken';

      var response = await http.get(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        MapBoxDirection apiResponse = MapBoxDirection.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }
}
