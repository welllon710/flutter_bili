import 'package:get_demo/app/core/network/api.dart';
import 'package:get_demo/app/core/network/dio_client.dart';
import 'package:get_demo/app/data/models/Ppay_url_model.dart';
import 'package:get_demo/app/data/models/video_detail_response.dart';
import 'package:get_demo/app/data/models/video_online_count.dart';

class VideoRepo {
  final WooHttpUtil _httpUtil = WooHttpUtil();

  Future<PlayUrlModel> getVideoPlayUrl({
    String? bvid,
    int? avid,
    required int cid,
    int qn = 64,
    int fnval = 1,
    int fourk = 1,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'cid': cid,
      'qn': qn,
      'fnval': fnval,
      'fourk': fourk,
    };

    if (bvid != null && bvid.isNotEmpty) {
      params['bvid'] = bvid;
    } else if (avid != null) {
      params['avid'] = avid;
    }

    final res = await _httpUtil.get(Api.videoUrl, params: params);
    return PlayUrlModel.fromJson(res.data['data']);
  }

  Future<VideoDetailResponse> getVideoIntro({String? bvid, int? avid}) async {
    final Map<String, dynamic> params = <String, dynamic>{};
    if (bvid != null && bvid.isNotEmpty) {
      params['bvid'] = bvid;
    } else if (avid != null && avid > 0) {
      params['aid'] = avid;
    }

    final res = await _httpUtil.get(Api.videoIntro, params: params);

    return VideoDetailResponse.fromJson(res.data);
  }

  Future<VideoOnlineCount> getOnlineCount({
    required int aid,
    required int cid,
  }) async {
    final res = await _httpUtil.get(
      Api.onlineTotal,
      params: {'aid': aid, 'cid': cid},
    );
    return VideoOnlineCount.fromJson(res.data);
  }
}
