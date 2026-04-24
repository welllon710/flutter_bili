import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_demo/app/core/theme/theme_controller.dart';
import 'package:get_demo/app/modules/home/views/bangumi.dart';
import 'package:get_demo/app/modules/home/views/hot.dart';
import 'package:get_demo/app/modules/home/views/recommend.dart';
import 'package:get_demo/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const List<String> _tabs = <String>[
    '推荐',
    '热门',
    '番剧',
    // '番剧',
    // '国创',
    // '音乐',
    // '科技',
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.explore_rounded, size: 35),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap:
                      () => Get.toNamed(
                        Routes.SEARCH,
                        arguments: {
                          'defaultKeyword': controller.searchDefault.value,
                        },
                      ),
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: theme.dividerColor.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Obx(
                      () => Row(
                        children: [
                          const SizedBox(width: 16),
                          Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            controller.searchDefault.value.isNotEmpty
                                ? controller.searchDefault.value
                                : '搜索',
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                      color: theme.textTheme.bodySmall?.color?.withValues(
                        alpha: 0.85,
                      ),
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
              child: TabBar(
                isScrollable: true,
                dividerColor: Colors.transparent,
                dividerHeight: 0,
                tabAlignment: TabAlignment.start,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(32),
                ),
                labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                labelColor: colorScheme.primary,
                unselectedLabelColor: theme.textTheme.bodyMedium?.color,
                tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                children: const [RecommendView(), HotView(), Bangumi()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
