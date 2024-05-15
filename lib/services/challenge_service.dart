import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:scavenger_hunt/keys/endpoint_keys.dart';
import 'package:scavenger_hunt/models/api/answer/answer_response.dart';
import 'package:scavenger_hunt/models/api/base/base_response.dart';
import 'package:scavenger_hunt/models/api/challenge_completed/challenge_completed_response/challenge_completed_response.dart';
import 'package:scavenger_hunt/models/api/generic/generic_response.dart';
import 'package:scavenger_hunt/models/api/route/route_response/route_response.dart';
import 'package:scavenger_hunt/models/api/route/routes_response/routes_response.dart';
import 'package:scavenger_hunt/models/api/route_completed/route_completed_response.dart';
import 'package:scavenger_hunt/models/api/upload/upload_response.dart';

class ChallengeService {
  Future<BaseResponse> getRouteDetails(String teamCode) async {
    try {
      String url = EndpointKeys.routeDetails;
      url = '$url?code=$teamCode';

      var response = await http.get(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );

      print(url);
      print(response.body);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        RoutesResponse apiResponse = RoutesResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> toggleActiveStatus(
      String teamCode, String? challengeId) async {
    try {
      String url = EndpointKeys.toggleActiveChallenge;
      if (challengeId != null) {
        url = '$url?code=$teamCode&id=$challengeId';
      } else {
        url = '$url?code=$teamCode';
      }

      var response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );
      print(url);
      print(response.body);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse apiResponse = GenericResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<String> getUploadUrl(String uploadPath, String folder) async {
    try {
      Uri url = Uri.parse(EndpointKeys.uploadRoute);
      var request = http.MultipartRequest("POST", url);
      request.fields['folder'] = folder;

      File uploadFile = File(uploadPath);

      http.MultipartFile file =
          await http.MultipartFile.fromPath('file', uploadFile.path);
      request.files.add(file);

      var value = await request.send();

      if (value.statusCode == 200) {
        final response = await http.Response.fromStream(value);
        var responseBody = json.decode(response.body);
        UploadResponse apiResponse = UploadResponse.fromJson(responseBody);
        return apiResponse.data?.url ?? '';
      } else {
        return "";
      }
    } catch (e) {
      return '';
    }
  }

  Future<BaseResponse> submitAnswer(
      dynamic answer, String questionId, String teamCode) async {
    try {
      String url = EndpointKeys.submitAnswer;
      var params = HashMap();
      params["answer"] = answer;
      params["team_code"] = teamCode;
      params["question"] = questionId;
      var response = await http.post(
        Uri.parse(url),
        body: json.encode(params),
        headers: {
          "content-type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        AnswerResponse apiResponse = AnswerResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> markChallengeAsCompleted(String teamCode) async {
    try {
      String url = EndpointKeys.completeChallenge;
      url = '$url?code=$teamCode';
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );
      print(url);
      print(response.body);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        ChallengeCompletedResponse apiResponse =
            ChallengeCompletedResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> startRoute(String routeId, String teamCode) async {
    try {
      String url = EndpointKeys.startRoute;
      url = '$url?code=$teamCode&id=$routeId';
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        RouteResponse apiResponse = RouteResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> markRouteAsCompleted(
      String routeId, String teamCode) async {
    try {
      String url = EndpointKeys.completeRoute;
      url = '$url?code=$teamCode&id=$routeId';
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        RouteCompletedResponse apiResponse =
            RouteCompletedResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }
}
