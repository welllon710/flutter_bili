import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart'
    hide BottomBarController;
import 'package:get/get.dart';
import 'package:get_demo/app/core/theme/theme_controller.dart';
import 'package:get_demo/app/modules/feed/views/feed_view.dart';
import 'package:get_demo/app/modules/home/views/home_view.dart';
import 'package:get_demo/app/modules/me/views/me_view.dart';
import 'package:get_demo/app/modules/rank/views/rank_view.dart';

import '../controllers/bottom_bar_controller.dart';

class _NavItem {
  const _NavItem({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

class BottomBarView extends GetView<BottomBarController> {
  const BottomBarView({super.key});

  static const List<_NavItem> _navItems = <_NavItem>[
    _NavItem(title: '首页', icon: Icons.home_rounded),
    _NavItem(title: '排行', icon: Icons.leaderboard_rounded),
    _NavItem(title: '动态', icon: Icons.dynamic_feed_rounded),
    _NavItem(title: '我的', icon: Icons.person_rounded),
  ];

  static const List<Map<String, String>> _homeFeed = <Map<String, String>>[
    <String, String>{'title': '今日推荐', 'desc': '按你的偏好更新了 12 条内容'},
    <String, String>{'title': '热门视频', 'desc': '本周热度持续上升的精选合集'},
    <String, String>{'title': '关注更新', 'desc': '你关注的 UP 主有新作品发布'},
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Obx(() {
      final int currentIndex = controller.currentIndex;
      final _NavItem currentTab = _navItems[currentIndex];
      return Scaffold(
        body: BottomBar(
          fit: StackFit.expand,
          borderRadius: BorderRadius.circular(50),
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          showIcon: false,
          width: MediaQuery.of(context).size.width - 50,
          barColor: colorScheme.surface.withValues(alpha: 0.96),
          offset: 12,
          barAlignment: Alignment.bottomCenter,
          hideOnScroll: true,
          body:
              (context, scrollController) => _buildTabBody(
                currentIndex,
                scrollController,
                theme,
                colorScheme,
              ),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
            child: Row(
              children: List<Widget>.generate(
                _navItems.length,
                (int index) => _buildNavItem(
                  index: index,
                  currentIndex: currentIndex,
                  colorScheme: colorScheme,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTabBody(
    int tabIndex,
    ScrollController scrollController,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    if (tabIndex == 0) {
      return const HomeView();
    }
    if (tabIndex == 1) {
      return const RankView();
    }
    if (tabIndex == 2) {
      return const FeedView();
    }
    if (tabIndex == 3) {
      return const MeView();
    }
    return const SizedBox();
  }

  Widget _buildNavItem({
    required int index,
    required int currentIndex,
    required ColorScheme colorScheme,
  }) {
    final bool selected = index == currentIndex;
    final _NavItem item = _navItems[index];

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => controller.changeTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color:
                selected
                    ? colorScheme.primary.withValues(alpha: 0.16)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                size: 20,
                color:
                    selected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.65),
              ),
              const SizedBox(height: 3),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color:
                      selected
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
