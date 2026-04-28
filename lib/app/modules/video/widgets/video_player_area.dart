import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_demo/app/modules/home/widgets/optimized_network_image.dart';
import 'package:get_demo/app/modules/video/controllers/video_controller.dart';
import 'package:get_demo/app/modules/video/widgets/video_controls_overlay.dart';
import 'package:get_demo/app/utils/utils.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayerArea extends StatelessWidget {
  const VideoPlayerArea({
    required this.controller,
    required this.theme,
    super.key,
  });

  final VideoCustomController controller;
  final ThemeData theme;

  Future<void> _replayCurrentVideo() async {
    await controller.onSeekEnd(0);
    if (!controller.isPlaying.value) {
      await controller.togglePlayPause();
    } else {
      controller.showControls();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.errorText.value.isNotEmpty) {
        return Center(
          child: Text(
            controller.errorText.value,
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        );
      }

      final int total =
          controller.duration.value > 0 ? controller.duration.value : 1;
      final int activePos =
          controller.isSeeking.value
              ? controller.dragSeekPosition.value
              : controller.currentPosition.value;
      final bool showRecommendOverlay =
          total > 1000 &&
          controller.currentPosition.value >= total - 1000 &&
          !controller.isSeeking.value;

      return SizedBox(
        height: 220,
        width: double.infinity,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: controller.toggleControls,
          onDoubleTap: controller.togglePlayPause,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Video(controller: controller.playerController, controls: null),
              VideoControlsOverlay(
                visible: controller.showPlayerControls.value,
                title: controller.title.value,
                isPlaying: controller.isPlaying.value,
                progress: Duration(milliseconds: activePos.clamp(0, total)),
                total: Duration(milliseconds: total),
                progressText:
                    '${controller.formatDuration(activePos)} / ${controller.formatDuration(total)}',
                onBack: Get.back,
                onPlayPause: controller.togglePlayPause,
                onSeekStart:
                    (Duration position) => controller.onSeekStart(
                      position.inMilliseconds.toDouble(),
                    ),
                onSeekChanged:
                    (Duration position) => controller.onSeekChanged(
                      position.inMilliseconds.toDouble(),
                    ),
                onSeekEnd:
                    (Duration position) => controller.onSeekEnd(
                      position.inMilliseconds.toDouble(),
                    ),
                onPortraitTap: controller.showControls,
              ),
              if (showRecommendOverlay) ..._buildRecommendVideoOverlay(context),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _buildRecommendVideoOverlay(BuildContext context) {
    final ColorScheme colorScheme = theme.colorScheme;
    final data = controller.introData.value;
    final String cover = data?.pic ?? '';
    final String title = data?.title ?? controller.title.value;
    final String owner = data?.owner?.name ?? 'UP主';
    final String viewText = Utils.numFormat(data?.stat?.view ?? 0);
    final String replyText = Utils.numFormat(data?.stat?.reply ?? 0);
    final int durationSeconds = data?.duration ?? 0;

    return [
      DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.72),
              Colors.black.withValues(alpha: 0.9),
            ],
          ),
        ),
      ),
      Positioned(
        top: 12,
        left: 12,
        right: 12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: Get.back,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: Colors.white,
              visualDensity: VisualDensity.compact,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.26),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz_rounded),
              color: Colors.white,
              visualDensity: VisualDensity.compact,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.26),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: 48,
        left: 12,
        right: 12,
        bottom: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '推荐视频',
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 116,
                      height: 72,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          OptimizedNetworkImage(url: cover, fit: BoxFit.cover),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.55),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.55),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 19,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 6,
                            bottom: 5,
                            child: Text(
                              controller.formatDuration(durationSeconds * 1000),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                              child: Text(
                                "UP",
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                owner,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.92),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.play_arrow_rounded,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              viewText,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.mode_comment_outlined,
                              size: 13,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              replyText,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _replayCurrentVideo,
                    icon: const Icon(Icons.replay_rounded),
                    label: const Text('重播'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.45),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share_outlined),
                    label: const Text('分享'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.16),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }
}
