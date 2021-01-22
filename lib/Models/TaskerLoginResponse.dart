// To parse this JSON data, do
//
//     final taskerLoginModel = taskerLoginModelFromJson(jsonString);

import 'dart:convert';

TaskerLoginModel taskerLoginModelFromJson(String str) =>
    TaskerLoginModel.fromJson(json.decode(str));

String taskerLoginModelToJson(TaskerLoginModel data) =>
    json.encode(data.toJson());

class TaskerLoginModel {
  TaskerLoginModel({
    this.message,
    this.status,
    this.id,
    this.email,
    this.name,
    this.profile,
  });

  String message;
  bool status;
  String id;
  String email;
  String name;
  String profile;

  factory TaskerLoginModel.fromJson(Map<String, dynamic> json) =>
      TaskerLoginModel(
        message: json["message"],
        status: json["status"],
        id: json["id"],
        email: json["email"],
        name: json["name"],
        profile: json["profile"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "id": id,
        "email": email,
        "name": name,
        "profile": profile,
      };
}
