class Category {
  final int id;
  final int type;
  final String name;
  final int sort;
  final int status;
  final String createTime;
  final String updateTime;
  final int createUser;
  final int updateUser;

  Category({
    required this.id,
    required this.type,
    required this.name,
    required this.sort,
    required this.status,
    required this.createTime,
    required this.updateTime,
    required this.createUser,
    required this.updateUser,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      sort: json['sort'],
      status: json['status'],
      createTime: json['createTime'],
      updateTime: json['updateTime'],
      createUser: json['createUser'],
      updateUser: json['updateUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'sort': sort,
      'status': status,
      'createTime': createTime,
      'updateTime': updateTime,
      'createUser': createUser,
      'updateUser': updateUser,
    };
  }
}
