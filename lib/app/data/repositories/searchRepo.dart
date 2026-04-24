import 'dart:convert';

import 'package:get_demo/app/core/network/api.dart';
import 'package:get_demo/app/core/network/dio_client.dart';
import 'package:get_demo/app/data/models/hot_search_model.dart';

class SearchRepo {
  WooHttpUtil _httpUtil = WooHttpUtil();

  Future<HotSearchModel> searchHotList() async {
    var res = await _httpUtil.get(Api.hotSearchList);
    Map<String, dynamic> resultMap = json.decode(res.data);
    List list = resultMap['list'];
    return HotSearchModel.fromJson(list);
  }
}
