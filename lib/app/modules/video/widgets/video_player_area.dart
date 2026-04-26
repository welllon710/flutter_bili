import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_demo/app/modules/video/controllers/video_controller.dart';
import 'package:get_demo/app/modules/video/widgets/video_controls_overlay.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayerArea extends StatelessWidget {
  const VideoPlayerArea({
    required this.controller,
    required this.theme,
    super.key,
  });

  final VideoCustomController controller;
  final ThemeData theme;

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

      final int total = controller.duration.value > 0 ? controller.duration.value : 1;
      final int activePos =
          controller.isSeeking.value
              ? controller.dragSeekPosition.value
              : controller.currentPosition.value;

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
                sliderValue: activePos.clamp(0, total).toDouble(),
                sliderMax: total.toDouble(),
                progressText:
                    '${controller.formatDuration(activePos)} / ${controller.formatDuration(total)}',
                onBack: Get.back,
                onPlayPause: controller.togglePlayPause,
                onSeekStart: controller.onSeekStart,
                onSeekChanged: controller.onSeekChanged,
                onSeekEnd: controller.onSeekEnd,
                onPortraitTap: controller.showControls,
              ),
            ],
          ),
        ),
      );
    });
  }
}
