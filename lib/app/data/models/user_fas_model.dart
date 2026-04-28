class UserFasModel {
  int code;
  String message;
  int ttl;
  Data data;

  UserFasModel({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });

  factory UserFasModel.fromJson(Map<String, dynamic> json) => UserFasModel(
    code: json["code"],
    message: json["message"],
    ttl: json["ttl"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "ttl": ttl,
    "data": data.toJson(),
  };
}

class Data {
  int mid;
  int following;
  int whisper;
  int black;
  int follower;
  dynamic fansMedalToast;
  dynamic fansEffect;

  Data({
    required this.mid,
    required this.following,
    required this.whisper,
    required this.black,
    required this.follower,
    required this.fansMedalToast,
    required this.fansEffect,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    mid: json["mid"],
    following: json["following"],
    whisper: json["whisper"],
    black: json["black"],
    follower: json["follower"],
    fansMedalToast: json["fans_medal_toast"],
    fansEffect: json["fans_effect"],
  );

  Map<String, dynamic> toJson() => {
    "mid": mid,
    "following": following,
    "whisper": whisper,
    "black": black,
    "follower": follower,
    "fans_medal_toast": fansMedalToast,
    "fans_effect": fansEffect,
  };
}
