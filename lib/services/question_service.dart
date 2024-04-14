import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scavenger_hunt/keys/endpoint_keys.dart';
import 'package:scavenger_hunt/models/api/base/base_response.dart';
import 'package:scavenger_hunt/models/api/question/question_response/question_response.dart';

class QuestionService {
  Future<BaseResponse> getQuestions(String challengeId, String teamCode) async {
    try {
      String url = EndpointKeys.questionsByChallenge;
      url = '$url?id=$challengeId&code=$teamCode';

      var response = await http.get(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
        },
      );


      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        QuestionsResponse apiResponse =
            QuestionsResponse.fromJson(responseBody);
        return BaseResponse(apiResponse, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }
}
