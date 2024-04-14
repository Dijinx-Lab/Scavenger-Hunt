class EndpointKeys {
  static String serverBaseUrl =
      //"http://192.168.100.228:3000/api/v1";
      "http://3.129.36.202/api/v1";
  static String mapboxDirections =
      'https://api.mapbox.com/directions/v5/mapbox';
  static String joinTeam = "$serverBaseUrl/team/details-by-code";
  static String updateTeam = "$serverBaseUrl/team/update";
  static String routeDetails = "$serverBaseUrl/route/all-details";
  static String toggleActiveChallenge = "$serverBaseUrl/team/toggle";
  static String questionsByChallenge =
      "$serverBaseUrl/question/details-by-challenge";
  static String leaderboards = "$serverBaseUrl/team/leaderboard";
  static String submitAnswer = "$serverBaseUrl/answer/create";
  static String completeChallenge = "$serverBaseUrl/team/mark-complete";
  static String startRoute = "$serverBaseUrl/route/start";
  static String completeRoute = "$serverBaseUrl/route/end";
  static String uploadRoute = "$serverBaseUrl/utility/upload/s3";
}