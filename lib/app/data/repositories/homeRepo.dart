import 'package:get_demo/app/core/network/dio_client.dart';
import 'package:get_demo/app/data/models/category.dart';
import 'package:get_demo/app/data/models/dish.dart';
import 'package:get_demo/app/data/models/response.dart';

class HomeRepo {
  WooHttpUtil _httpUtil = WooHttpUtil();

  Future<List<Category>> getCategoryList() async {
    final response = await _httpUtil.get('/user/category/list');
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => Category.fromJson(json),
    );
    return apiResponse.data;
  }

  Future<List<Dish>> getProducts(int categoryId) async {
    final response = await _httpUtil.get(
      '/user/dish/list',
      params: {'categoryId': categoryId},
    );
    final apiResponse = ApiResponse.fromJson(
      response.data,
      (json) => Dish.fromJson(json),
    );
    return apiResponse.data;
  }
}
