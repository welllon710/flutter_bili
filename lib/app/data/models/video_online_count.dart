class VideoOnlineCount {
  int code;
  String message;
  int ttl;
  Data data;

  VideoOnlineCount({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });

  factory VideoOnlineCount.fromJson(Map<String, dynamic> json) =>
      VideoOnlineCount(
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
  String total;
  String count;
  ShowSwitch showSwitch;
  Abtest abtest;

  Data({
    required this.total,
    required this.count,
    required this.showSwitch,
    required this.abtest,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    total: json["total"],
    count: json["count"],
    showSwitch: ShowSwitch.fromJson(json["show_switch"]),
    abtest: Abtest.fromJson(json["abtest"]),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "count": count,
    "show_switch": showSwitch.toJson(),
    "abtest": abtest.toJson(),
  };
}

class Abtest {
  String group;

  Abtest({required this.group});

  factory Abtest.fromJson(Map<String, dynamic> json) =>
      Abtest(group: json["group"]);

  Map<String, dynamic> toJson() => {"group": group};
}

class ShowSwitch {
  bool total;
  bool count;

  ShowSwitch({required this.total, required this.count});

  factory ShowSwitch.fromJson(Map<String, dynamic> json) =>
      ShowSwitch(total: json["total"], count: json["count"]);

  Map<String, dynamic> toJson() => {"total": total, "count": count};
}
