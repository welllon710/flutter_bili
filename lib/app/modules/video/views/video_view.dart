import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_demo/app/modules/video/controllers/video_controller.dart';
import 'package:get_demo/app/modules/video/widgets/video_comment_tab.dart';
import 'package:get_demo/app/modules/video/widgets/video_intro_tab.dart';
import 'package:get_demo/app/modules/video/widgets/video_player_area.dart';
import 'package:get_demo/app/utils/utils.dart';

class VideoView extends GetView<VideoCustomController> {
  const VideoView({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: colorScheme.surface,
                  surfaceTintColor: Colors.transparent,
                  toolbarHeight: 220,
                  expandedHeight: 220,
                  flexibleSpace: LayoutBuilder(
                    builder: (
                      BuildContext context,
                      BoxConstraints boxConstraints,
                    ) {
                      return VideoPlayerArea(
                        controller: controller,
                        theme: theme,
                      );
                    },
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Container(
                      color: colorScheme.surface,
                      // padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Obx(() {
                              final int replyCount =
                                  controller.introData.value?.stat?.reply ?? 0;
                              final String replyText = Utils.numFormat(
                                replyCount,
                              );

                              return TabBar(
                                // padding: const EdgeInsets.symmetric(
                                //   horizontal: 10,
                                // ),
                                isScrollable: true,
                                dividerColor: Colors.transparent,
                                indicatorSize: TabBarIndicatorSize.label,
                                tabAlignment: TabAlignment.start,
                                // labelPadding: const EdgeInsets.only(left: 30),
                                labelColor: colorScheme.primary,
                                unselectedLabelColor:
                                    colorScheme.onSurfaceVariant,
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                                unselectedLabelStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                tabs: [
                                  const Tab(text: '简介'),
                                  Tab(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('评论'),
                                        const SizedBox(width: 4),
                                        Text(
                                          replyText,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 38,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        '点我输入弹幕',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                      ),
                                    ),
                                  ),
                                  FilledButton(
                                    onPressed: () {},
                                    style: FilledButton.styleFrom(
                                      minimumSize: const Size(58, 30),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text('发送'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                VideoIntroTab(controller: controller),
                VideoCommentTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
