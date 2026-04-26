import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_demo/app/modules/home/widgets/hot_video_card.dart';
import 'package:get_demo/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HotView extends GetView<HomeController> {
  const HotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
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
        onRefresh: controller.onRefreshHotVideos,
        onLoad: controller.onLoadHotVideos,
        child: ListView.separated(
          cacheExtent: 900,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
          itemCount: controller.hotVideoList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, int index) {
            final item = controller.hotVideoList[index];
            return HotVideoCard(
              item: item,
              onTap:
                  () => Get.toNamed(
                    Routes.VIDEO,
                    arguments: {
                      'bvid': item.bvid,
                      'cid': item.cid,
                      'aid': item.aid,
                      'title': item.title,
                    },
                  ),
            );
          },
        ),
      ),
    );
  }
}
