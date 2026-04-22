import 'package:get_demo/app/core/network/api.dart';
import 'package:get_demo/app/core/network/dio_client.dart';
import 'package:get_demo/app/data/models/bangumi_list_data_model.dart';
import 'package:get_demo/app/data/models/hot_video_item_model.dart';
import 'package:get_demo/app/data/models/rec_video_item_model.dart';

class HomeRepo {
  WooHttpUtil _httpUtil = WooHttpUtil();

  Future<List<RecVideoItemModel>> rcmdVideoList({
    required int ps,
    required int freshIdx,
  }) async {
    List<RecVideoItemModel> list = [];
    var res = await _httpUtil.get(
      Api.recommendListWeb,
      params: {
        'version': 1,
        'feed_version': 'V3',
        'homepage_ver': 1,
        'ps': ps,
        'fresh_idx': freshIdx,
        'brush': freshIdx,
        'fresh_type': 4,
        // '_': DateTime.now().millisecondsSinceEpoch,
      },
    );
    for (var i in res.data['data']['item']) {
      //过滤掉live与ad，以及拉黑用户
      if (i['goto'] == 'av' && (i['owner'] != null)) {
        RecVideoItemModel videoItem = RecVideoItemModel.fromJson(i);
        // if (!RecommendFilter.filter(videoItem)) {
        list.add(videoItem);
        // }
      }
    }
    return list;
  }

  Future<List<HotVideoItemModel>> hotVideoList({
    required int pn,
    required int ps,
  }) async {
    List<HotVideoItemModel> list = [];
    var res = await _httpUtil.get(Api.hotList, params: {'pn': pn, 'ps': ps});
    for (var i in res.data['data']['list']) {
      // if (!blackMidsList.contains(i['owner']['mid'])) {
      list.add(HotVideoItemModel.fromJson(i));
      // }
    }
    return list;
  }

  Future<BangumiListDataModel> bangumiList({required int page}) async {
    var res = await _httpUtil.get(Api.bangumiList, params: {'page': page});
    return BangumiListDataModel.fromJson(res.data['data']);
  }
}
