import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scavenger_hunt/keys/endpoint_keys.dart';
import 'package:scavenger_hunt/models/api/base/base_response.dart';
import 'package:scavenger_hunt/models/api/team/list_response/team_list_response.dart';
import 'package:scavenger_hunt/models/api/team/team_response/team_response.dart';

class TeamService {
  Future<BaseResponse> joinTeam(String teamCode) async {
    try {
      String url = EndpointKeys.joinTeam;
      url = '$url?code=$teamCode';

      var response = await http.get(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        TeamResponse apiResponse = TeamResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> updateTeam(String teamCode, String fcmToken) async {
    try {
      String url = EndpointKeys.updateTeam;
      url = '$url?code=$teamCode';

      var params = HashMap();
      params["fcm_token"] = fcmToken;

      var response = await http.post(
        Uri.parse(url),
        body: json.encode(params),
        headers: {
          "content-type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        TeamResponse apiResponse = TeamResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> getLeaderboards() async {
    try {
      String url = EndpointKeys.leaderboards;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        TeamListResponse apiResponse = TeamListResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> getTerms(bool forTerms) async {
    try {
      String url = forTerms ? EndpointKeys.terms : EndpointKeys.privacy;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // var responseBody = json.decode(response.body);
        // TeamListResponse apiResponse = TeamListResponse.fromJson(responseBody);
        return BaseResponse(response.body, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }
}
