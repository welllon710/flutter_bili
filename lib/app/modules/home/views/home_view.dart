import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_demo/app/core/theme/theme_controller.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:get_demo/app/modules/home/widgets/video_card.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const List<String> _tabs = <String>[
    '推荐',
    '直播',
    '动画',
    '番剧',
    '国创',
    '音乐',
    '科技',
  ];

  static const List<Map<String, String>> _items = <Map<String, String>>[
    <String, String>{
      'title': '老番茄',
      'subtitle': '【史上最惨】这个视频我做了一年...',
      'meta': '48.5万次观看 · 2小时前',
      'time': '14:32',
    },
    <String, String>{
      'title': '极客湾 Geekerwan',
      'subtitle': '移动端CPU性能排行榜：谁是真正的王者？',
      'meta': '120万次观看 · 5小时前',
      'time': '12:10',
    },
    <String, String>{
      'title': '影视飓风 MediaStorm',
      'subtitle': '我们用这台相机拍出了电影感！',
      'meta': '85万次观看 · 1天前',
      'time': '昨日',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        // leading: const Icon(Icons.explore_rounded, size: 35),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.explore_rounded, size: 35),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: theme.textTheme.bodyMedium?.color?.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '搜索视频、UP 主、专栏',
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.6,
                        ),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          Obx(
            () => Row(
              children: [
                Text(
                  themeController.isDarkMode ? '深色' : '浅色',
                  style: TextStyle(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Switch(
                  value: themeController.isDarkMode,
                  onChanged: (_) => themeController.toggleTheme(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            height: 45,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Obx(() {
              final current = controller.currentIndex.value;
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, int index) {
                  final bool selected = index == current;
                  return GestureDetector(
                    onTap: () {
                      controller.changeTab(index);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            selected
                                ? colorScheme.primary.withOpacity(0.2)
                                : theme.cardColor,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Text(
                        _tabs[index],
                        style: TextStyle(
                          color:
                              selected
                                  ? colorScheme.primary
                                  : theme.textTheme.bodyMedium?.color,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemCount: _tabs.length,
              );
            }),
          ),
          const SizedBox(height: 8),

          // 内容区 视频卡片 一行2个
          Expanded(
            child: Obx(
              () => EasyRefresh(
                clipBehavior: Clip.none,
                header: const ClassicHeader(
                  dragText: '下拉刷新',
                  armedText: '松开刷新',
                  processingText: '刷新中...',
                  processedText: '刷新完成',
                  noMoreText: '暂无更多',
                  failedText: '刷新失败',
                  readyText: '刷新完成',
                ),
                footer: const ClassicFooter(
                  dragText: '上拉加载',
                  armedText: '松开加载',
                  processingText: '加载中...',
                  processedText: '加载完成',
                  noMoreText: '已经到底了',
                  failedText: '加载失败',
                  readyText: '加载完成',
                ),
                onRefresh: controller.onRefreshVideos,
                onLoad: controller.onLoadVideos,
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  itemCount: controller.videoList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (_, int index) {
                    final item = controller.videoList[index];
                    return VideoCard(
                      title: item['title'] ?? '',
                      up: item['up'] ?? '',
                      meta: item['meta'] ?? '',
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
