class BiliSearchModel {
  String? seid;
  int? id;
  int? type;
  String? showName;
  String? name;
  int? gotoType;
  String? gotoValue;
  String? url;

  BiliSearchModel({
    this.seid,
    this.id,
    this.type,
    this.showName,
    this.name,
    this.gotoType,
    this.gotoValue,
    this.url,
  });

  factory BiliSearchModel.fromJson(Map<String, dynamic> json) {
    return BiliSearchModel(
      seid: json['seid'],
      id: json['id'],
      type: json['type'],
      showName: json['show_name'],
      name: json['name'],
      gotoType: json['goto_type'],
      gotoValue: json['goto_value'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seid': seid,
      'id': id,
      'type': type,
      'show_name': showName,
      'name': name,
      'goto_type': gotoType,
      'goto_value': gotoValue,
      'url': url,
    };
  }
}
