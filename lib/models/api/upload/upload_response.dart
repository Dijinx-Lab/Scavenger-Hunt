// To parse this JSON data, do
//
//     final uploadResponse = uploadResponseFromJson(jsonString);

import 'dart:convert';

UploadResponse uploadResponseFromJson(String str) =>
    UploadResponse.fromJson(json.decode(str));

String uploadResponseToJson(UploadResponse data) => json.encode(data.toJson());

class UploadResponse {
  final bool? success;
  final Data? data;
  final String? message;

  UploadResponse({
    this.success,
    this.data,
    this.message,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) => UploadResponse(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  final String? url;

  Data({
    this.url,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}
