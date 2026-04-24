import 'dart:async';

import 'package:get/get.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:get_demo/app/data/models/b_search_model.dart';
import 'package:get_demo/app/data/models/bangumi_list_data_model.dart';
import 'package:get_demo/app/data/models/hot_video_item_model.dart';
import 'package:get_demo/app/data/models/rec_video_item_model.dart';
import 'package:get_demo/app/data/repositories/homeRepo.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  final RxList<RecVideoItemModel> videoList = <RecVideoItemModel>[].obs;
  final RxList<HotVideoItemModel> hotVideoList = <HotVideoItemModel>[].obs;
  final RxList<BangumiListItemModel> bangumiList = <BangumiListItemModel>[].obs;
  final RxString searchDefault = ''.obs;
  Timer? _searchDefaultTimer;
  bool _isLoadingSearchDefault = false;

  HomeRepo homeRepo = Get.put(HomeRepo());

  // 单页返回的记录条数
  final int ps = 12;
  final int hotPs = 20;
  final int bangumiPs = 15;

  // 当前翻页号，对应接口 fresh_idx
  int freshIdx = 0;
  bool _hasMore = true;
  int hotPn = 1;
  bool _hotHasMore = true;
  int bangumiPage = 1;
  bool _bangumiHasMore = true;

  @override
  void onInit() {
    super.onInit();
    _startSearchDefaultTimer();
    _loadInitialData();
  }

  @override
  void onClose() {
    _searchDefaultTimer?.cancel();
    super.onClose();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  Future<void> _loadInitialData() async {
    await _loadFirstPage();
    await _loadHotFirstPage();
    await _loadBangumiFirstPage();
    await _loadSearchDefault();
  }

  Future<IndicatorResult> onRefreshVideos() async {
    try {
      freshIdx = 0;
      final List<RecVideoItemModel> result = await homeRepo.rcmdVideoList(
        ps: ps,
        freshIdx: freshIdx,
      );
      videoList.assignAll(result);
      _hasMore = result.length >= ps;
      return IndicatorResult.success;
    } catch (_) {
      return IndicatorResult.fail;
    }
  }

  Future<IndicatorResult> onLoadVideos() async {
    if (!_hasMore) {
      return IndicatorResult.noMore;
    }

    try {
      final int nextFreshIdx = freshIdx + 1;
      final List<RecVideoItemModel> result = await homeRepo.rcmdVideoList(
        ps: ps,
        freshIdx: nextFreshIdx,
      );

      if (result.isEmpty) {
        _hasMore = false;
        return IndicatorResult.noMore;
      }

      freshIdx = nextFreshIdx;
      videoList.addAll(result);
      _hasMore = result.length >= ps;
      return _hasMore ? IndicatorResult.success : IndicatorResult.noMore;
    } catch (_) {
      return IndicatorResult.fail;
    }
  }

  Future<IndicatorResult> onRefreshHotVideos() async {
    if (!_hotHasMore) {
      return IndicatorResult.noMore;
    }

    try {
      final int nextPn = hotPn + 1;
      final List<HotVideoItemModel> result = await homeRepo.hotVideoList(
        pn: nextPn,
        ps: hotPs,
      );
      if (result.isEmpty) {
        _hotHasMore = false;
        return IndicatorResult.noMore;
      }

      hotPn = nextPn;
      hotVideoList.insertAll(0, result);
      _hotHasMore = result.length >= hotPs;
      return _hotHasMore ? IndicatorResult.success : IndicatorResult.noMore;
    } catch (_) {
      return IndicatorResult.fail;
    }
  }

  Future<IndicatorResult> onLoadHotVideos() async {
    if (!_hotHasMore) {
      return IndicatorResult.noMore;
    }

    try {
      final int nextPn = hotPn + 1;
      final List<HotVideoItemModel> result = await homeRepo.hotVideoList(
        pn: nextPn,
        ps: hotPs,
      );
      if (result.isEmpty) {
        _hotHasMore = false;
        return IndicatorResult.noMore;
      }
      hotPn = nextPn;
      hotVideoList.addAll(result);
      _hotHasMore = result.length >= hotPs;
      return _hotHasMore ? IndicatorResult.success : IndicatorResult.noMore;
    } catch (_) {
      return IndicatorResult.fail;
    }
  }

  Future<IndicatorResult> onRefreshBangumi() async {
    try {
      bangumiPage = 1;
      final BangumiListDataModel result = await homeRepo.bangumiList(
        page: bangumiPage,
      );
      final List<BangumiListItemModel> list =
          (result.list ?? <BangumiListItemModel>[])
              .cast<BangumiListItemModel>();
      bangumiList.assignAll(list);
      _bangumiHasMore = (result.hasNext ?? 0) == 1 && list.length >= bangumiPs;
      return IndicatorResult.success;
    } catch (_) {
      return IndicatorResult.fail;
    }
  }

  Future<IndicatorResult> onLoadBangumi() async {
    if (!_bangumiHasMore) {
      return IndicatorResult.noMore;
    }

    try {
      final int nextPage = bangumiPage + 1;
      final BangumiListDataModel result = await homeRepo.bangumiList(
        page: nextPage,
      );
      final List<BangumiListItemModel> list =
          (result.list ?? <BangumiListItemModel>[])
              .cast<BangumiListItemModel>();
      if (list.isEmpty) {
        _bangumiHasMore = false;
        return IndicatorResult.noMore;
      }
      bangumiPage = nextPage;
      bangumiList.addAll(list);
      _bangumiHasMore = (result.hasNext ?? 0) == 1 && list.length >= bangumiPs;
      return _bangumiHasMore ? IndicatorResult.success : IndicatorResult.noMore;
    } catch (_) {
      return IndicatorResult.fail;
    }
  }

  Future<void> _loadFirstPage() async {
    try {
      freshIdx = 0;
      final List<RecVideoItemModel> result = await homeRepo.rcmdVideoList(
        ps: ps,
        freshIdx: freshIdx,
      );
      videoList.assignAll(result);
      _hasMore = result.length >= ps;
    } catch (_) {
      videoList.clear();
      _hasMore = true;
    }
  }

  Future<void> _loadHotFirstPage() async {
    try {
      hotPn = 1;
      final List<HotVideoItemModel> result = await homeRepo.hotVideoList(
        pn: hotPn,
        ps: hotPs,
      );
      hotVideoList.assignAll(result);
      _hotHasMore = result.length >= hotPs;
    } catch (_) {
      hotVideoList.clear();
      _hotHasMore = true;
    }
  }

  Future<void> _loadBangumiFirstPage() async {
    try {
      bangumiPage = 1;
      final BangumiListDataModel result = await homeRepo.bangumiList(
        page: bangumiPage,
      );
      final List<BangumiListItemModel> list =
          (result.list ?? <BangumiListItemModel>[])
              .cast<BangumiListItemModel>();
      bangumiList.assignAll(list);
      _bangumiHasMore = (result.hasNext ?? 0) == 1 && list.length >= bangumiPs;
    } catch (_) {
      bangumiList.clear();
      _bangumiHasMore = true;
    }
  }

  Future<void> _loadSearchDefault() async {
    if (_isLoadingSearchDefault) return;

    _isLoadingSearchDefault = true;

    try {
      final BiliSearchModel result = await homeRepo.getSearchDefault();
      searchDefault.value = result.showName ?? '';
    } catch (_) {
    } finally {
      _isLoadingSearchDefault = false;
    }
  }

  void _startSearchDefaultTimer() {
    _searchDefaultTimer?.cancel();
    _searchDefaultTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _loadSearchDefault();
    });
  }
}
