import 'package:get/get.dart';
import 'package:easy_refresh/easy_refresh.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  final RxList<Map<String, String>> videoList = <Map<String, String>>[].obs;

  static const int _pageSize = 6;
  static const int _maxPage = 4;
  int _page = 1;

  final List<Map<String, String>> _mockPool = <Map<String, String>>[
    {'title': '2026 春季新番导视', 'up': '追番小助手', 'meta': '38.2万播放 · 1.2万点赞'},
    {'title': '手机影像旗舰横评', 'up': '极客观测站', 'meta': '112万播放 · 6.5万点赞'},
    {'title': '零基础入门 Flutter 动画', 'up': '代码研究所', 'meta': '21.7万播放 · 1.8万点赞'},
    {'title': '城市夜景航拍混剪', 'up': '航拍纪实', 'meta': '67.3万播放 · 4.1万点赞'},
    {'title': '30 分钟学会拍 Vlog', 'up': '影像手册', 'meta': '40.9万播放 · 2.3万点赞'},
    {'title': '高能燃向剪辑合集', 'up': '热血剪辑师', 'meta': '95.6万播放 · 7.0万点赞'},
    {'title': '咖啡器具全解析', 'up': '慢生活实验室', 'meta': '18.4万播放 · 9.6千点赞'},
    {'title': '2026 前端趋势观察', 'up': '前端情报局', 'meta': '26.8万播放 · 1.1万点赞'},
    {'title': '影视灯光布光实战', 'up': '片场手册', 'meta': '32.5万播放 · 1.9万点赞'},
    {'title': '地铁通勤效率指南', 'up': '效率研究院', 'meta': '15.2万播放 · 8.4千点赞'},
    {'title': '热门游戏帧率对比', 'up': '硬件实验室', 'meta': '76.4万播放 · 3.7万点赞'},
    {'title': '周末 4K 纪录短片', 'up': '山海记录者', 'meta': '29.9万播放 · 1.5万点赞'},
  ];

  @override
  void onInit() {
    super.onInit();
    videoList.assignAll(_buildPageData(page: _page));
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  Future<IndicatorResult> onRefreshVideos() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _page = 1;
    videoList.assignAll(_buildPageData(page: _page));
    return IndicatorResult.success;
  }

  Future<IndicatorResult> onLoadVideos() async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (_page >= _maxPage) {
      return IndicatorResult.noMore;
    }
    _page += 1;
    videoList.addAll(_buildPageData(page: _page));
    if (_page >= _maxPage) {
      return IndicatorResult.noMore;
    }
    return IndicatorResult.success;
  }

  List<Map<String, String>> _buildPageData({required int page}) {
    final int offset = (page - 1) * _pageSize;
    return List<Map<String, String>>.generate(_pageSize, (int index) {
      final Map<String, String> base =
          _mockPool[(offset + index) % _mockPool.length];
      return <String, String>{
        'title': base['title'] ?? '',
        'up': base['up'] ?? '',
        'meta': base['meta'] ?? '',
      };
    });
  }
}
