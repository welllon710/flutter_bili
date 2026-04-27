import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class VideoControlsOverlay extends StatelessWidget {
  const VideoControlsOverlay({
    required this.visible,
    required this.title,
    required this.isPlaying,
    required this.progress,
    required this.total,
    required this.progressText,
    required this.onBack,
    required this.onPlayPause,
    required this.onSeekStart,
    required this.onSeekChanged,
    required this.onSeekEnd,
    required this.onPortraitTap,
    super.key,
  });

  final bool visible;
  final String title;
  final bool isPlaying;
  final Duration progress;
  final Duration total;
  final String progressText;
  final VoidCallback onBack;
  final VoidCallback onPlayPause;
  final ValueChanged<Duration> onSeekStart;
  final ValueChanged<Duration> onSeekChanged;
  final ValueChanged<Duration> onSeekEnd;
  final VoidCallback onPortraitTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 180),
      child: IgnorePointer(
        ignoring: !visible,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.48),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 6,
              left: 6,
              right: 6,
              child: Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Row(
                children: [
                  IconButton(
                    onPressed: onPlayPause,
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: ProgressBar(
                      progress: progress,
                      total: total,
                      barHeight: 2.5,
                      thumbRadius: 5,
                      timeLabelLocation: TimeLabelLocation.none,
                      baseBarColor: Colors.white.withValues(alpha: 0.28),
                      bufferedBarColor: Colors.white.withValues(alpha: 0.42),
                      progressBarColor: Colors.white,
                      thumbColor: Colors.white,
                      onDragStart: (ThumbDragDetails details) {
                        onSeekStart(details.timeStamp);
                      },
                      onDragUpdate: (ThumbDragDetails details) {
                        onSeekChanged(details.timeStamp);
                      },
                      onSeek: onSeekEnd,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    progressText,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  IconButton(
                    onPressed: onPortraitTap,
                    icon: const Icon(
                      Icons.stay_current_portrait_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
