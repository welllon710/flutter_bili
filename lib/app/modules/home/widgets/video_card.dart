import 'package:flutter/material.dart';
import 'package:get_demo/app/data/models/rec_video_item_model.dart';
import 'package:get_demo/app/modules/home/widgets/optimized_network_image.dart';
import 'package:get_demo/app/utils/utils.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({required this.item, super.key});

  final RecVideoItemModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 内容区 视频卡片 一行2个
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: SizedBox(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: OptimizedNetworkImage(
                      url: item.pic ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Positioned(
                  //   right: 8,
                  //   top: 8,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 6,
                  //       vertical: 2,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       color: Colors.black.withValues(alpha: 0.45),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: Text(
                  //       Utils.timeFormat(item.duration),
                  //       style: const TextStyle(
                  //         fontSize: 10,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ClipRect(
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.0, 0.32, 0.68, 1.0],
                            colors: [
                              Colors.black.withValues(alpha: 0.02),
                              Colors.black.withValues(alpha: 0.2),
                              Colors.black.withValues(alpha: 0.45),
                              Colors.black.withValues(alpha: 0.9),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 6),
                                _MetaInfo(
                                  icon: Icons.play_arrow_rounded,
                                  text: Utils.numFormat(item.stat?.view ?? 0),
                                ),
                                const SizedBox(width: 8),
                                _MetaInfo(
                                  icon: Icons.mode_comment_outlined,
                                  text: Utils.numFormat(item.stat?.danmu ?? 0),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                Utils.timeFormat(item.duration ?? 0),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${item.title}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
            child: Text(
              '${item.owner?.name}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8),
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaInfo extends StatelessWidget {
  const _MetaInfo({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white),
        const SizedBox(width: 2),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
