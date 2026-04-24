import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_demo/app/data/models/hot_search_model.dart';
import 'package:get_demo/app/modules/home/widgets/optimized_network_image.dart';
import 'package:get_demo/app/modules/search/controllers/search_controller.dart'
    as search;

class SearchView extends GetView<search.SearchController> {
  const SearchView({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        titleSpacing: 0,
        title: SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.searchController,
                  focusNode: controller.searchFocusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    hintText: '搜索视频、UP 主、专栏',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    hintStyle: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '搜索  ',
                style: TextStyle(color: colorScheme.primary, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        final List<HotSearchItem> hotList = controller.hotList;

        if (hotList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '热搜榜',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: controller.refreshHotList,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AnimatedRotation(
                        turns: controller.refreshTurns.value,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        child: Icon(
                          Icons.refresh,
                          size: 22,
                          color:
                              controller.isRefreshing.value
                                  ? colorScheme.primary.withValues(alpha: 0.6)
                                  : colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  itemCount: hotList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3.8,
                  ),
                  itemBuilder: (context, index) {
                    final HotSearchItem item = hotList[index];
                    final String title =
                        item.showName?.isNotEmpty == true
                            ? item.showName!
                            : (item.keyword ?? '');
                    final bool isTopThree = index < 3;

                    return GestureDetector(
                      onTap: () {
                        controller.setSelectedKeyword(item.keyword ?? '');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.35,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color:
                                    isTopThree
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (item.icon?.isNotEmpty == true) ...[
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: OptimizedNetworkImage(
                                  url: item.icon!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
