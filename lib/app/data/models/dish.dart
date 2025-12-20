class DishFlavor {
  final int id;
  final int dishId;
  final String name;
  final dynamic value;

  DishFlavor({
    required this.id,
    required this.dishId,
    required this.name,
    required this.value,
  });

  factory DishFlavor.fromJson(Map<String, dynamic> json) {
    return DishFlavor(
      id: json['id'],
      dishId: json['dishId'],
      name: json['name'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'dishId': dishId, 'name': name, 'value': value};
  }
}

class Dish {
  final int id;
  final String name;
  final int categoryId;
  final double price;
  final String image;
  final String description;
  final int status;
  final String updateTime;
  final String categoryName;
  final List<DishFlavor> flavors;

  Dish({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.image,
    required this.description,
    required this.status,
    required this.updateTime,
    required this.categoryName,
    required this.flavors,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      categoryId: json['categoryId'],
      price: (json['price'] as num).toDouble(), // ⭐ 关键
      image: json['image'],
      description: json['description'],
      status: json['status'],
      updateTime: json['updateTime'],
      categoryName: json['categoryName'],
      flavors:
          (json['flavors'] as List? ?? [])
              .map((e) => DishFlavor.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'price': price,
      'image': image,
      'description': description,
      'status': status,
      'updateTime': updateTime,
      'categoryName': categoryName,
      'flavors': flavors.map((e) => e.toJson()).toList(),
    };
  }
}
