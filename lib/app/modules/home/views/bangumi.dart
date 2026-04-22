import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_demo/app/modules/home/widgets/bangumi_video_card.dart';

import '../controllers/home_controller.dart';

class Bangumi extends GetView<HomeController> {
  const Bangumi({super.key});

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
        onRefresh: controller.onRefreshBangumi,
        onLoad: controller.onLoadBangumi,
        child: GridView.builder(
          cacheExtent: 900,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
          itemCount: controller.bangumiList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 10,
            childAspectRatio: 0.52,
          ),
          itemBuilder: (_, int index) {
            final item = controller.bangumiList[index];
            return BangumiVideoCard(item: item);
          },
        ),
      ),
    );
  }
}
