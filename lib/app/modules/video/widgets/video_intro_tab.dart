import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_demo/app/modules/home/widgets/optimized_network_image.dart';
import 'package:get_demo/app/modules/video/controllers/video_controller.dart';
import 'package:get_demo/app/utils/utils.dart';
import 'package:like_button/like_button.dart';

class VideoIntroTab extends StatelessWidget {
  final VideoCustomController controller;
  const VideoIntroTab({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Obx(() {
      if (controller.isIntroLoading.value &&
          controller.introData.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.introError.value.isNotEmpty &&
          controller.introData.value == null) {
        return Center(
          child: Text(
            controller.introError.value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        );
      }

      final data = controller.introData.value;
      if (data == null) {
        return Center(
          child: Text(
            '暂无简介',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        );
      }

      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          Text(
            data.title ?? controller.title.value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipOval(
                child: SizedBox(
                  width: 34,
                  height: 34,
                  child: OptimizedNetworkImage(
                    url: data.owner?.face ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  data.owner?.name ?? 'UP主',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () {},
                label: Text('关注'),
                icon: const Icon(Icons.add),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(58, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (controller.onlineTotal.value.isNotEmpty)
                _MetaChip(
                  icon: Icons.remove_red_eye_outlined,
                  text: '${controller.onlineTotal.value}在线',
                ),
              _MetaChip(
                icon: Icons.play_arrow_rounded,
                text: Utils.numFormat(data.stat?.view ?? 0),
              ),
              _MetaChip(
                icon: Icons.mode_comment_outlined,
                text: Utils.numFormat(data.stat?.reply ?? 0),
              ),
              _MetaChip(
                icon: Icons.thumb_up_alt_outlined,
                text: Utils.numFormat(data.stat?.like ?? 0),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _LikeActionItem(count: data.stat?.like ?? 0)),
              Expanded(
                child: _ActionItem(
                  icon: Icons.thumb_down_alt_outlined,
                  count: data.stat?.dislike ?? 0,
                ),
              ),
              Expanded(
                child: _ActionItem(
                  icon: Icons.bookmark_outline_rounded,
                  count: data.stat?.favorite ?? 0,
                ),
              ),
              Expanded(
                child: _ActionItem(
                  icon: Icons.reply_outlined,
                  count: data.stat?.share ?? 0,
                ),
              ),
              Expanded(
                child: _ActionItem(
                  icon: Icons.monetization_on_outlined,
                  count: data.stat?.coin ?? 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ExpandableNotifier(
            child: ExpandablePanel(
              theme: ExpandableThemeData(
                tapBodyToCollapse: true,
                tapBodyToExpand: true,
                iconColor: colorScheme.onSurfaceVariant,
                iconPadding: const EdgeInsets.only(left: 10),
                iconSize: 18,
                animationDuration: const Duration(milliseconds: 180),
              ),
              collapsed: Text(
                data.desc?.isNotEmpty == true ? data.desc! : '暂无简介内容',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.92),
                  height: 1.6,
                ),
              ),
              expanded: Text(
                data.desc?.isNotEmpty == true ? data.desc! : '暂无简介内容',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.92),
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({required this.icon, required this.count});

  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {},
      // borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 21, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 4),
            Text(
              '${Utils.numFormat(count)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LikeActionItem extends StatefulWidget {
  const _LikeActionItem({required this.count});

  final int count;

  @override
  State<_LikeActionItem> createState() => _LikeActionItemState();
}

class _LikeActionItemState extends State<_LikeActionItem>
    with SingleTickerProviderStateMixin {
  late int _likeCount;
  bool _isLiked = false;
  String _deltaText = '+1';
  late final AnimationController _plusOneController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );
  late final Animation<double> _plusOneOpacity = TweenSequence<double>([
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 0,
        end: 1,
      ).chain(CurveTween(curve: Curves.easeOut)),
      weight: 35,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(
        begin: 1,
        end: 0,
      ).chain(CurveTween(curve: Curves.easeIn)),
      weight: 65,
    ),
  ]).animate(_plusOneController);
  late final Animation<Offset> _plusOneOffset = Tween<Offset>(
    begin: const Offset(0, 0.2),
    end: const Offset(0, -0.9),
  ).animate(
    CurvedAnimation(parent: _plusOneController, curve: Curves.easeOutCubic),
  );

  @override
  void initState() {
    super.initState();
    _likeCount = widget.count;
  }

  @override
  void didUpdateWidget(covariant _LikeActionItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count && !_isLiked) {
      _likeCount = widget.count;
    }
  }

  @override
  void dispose() {
    _plusOneController.dispose();
    super.dispose();
  }

  Future<bool> _onLikeTap(bool isLiked) async {
    final bool nextLiked = !isLiked;
    setState(() {
      _isLiked = nextLiked;
      _deltaText = nextLiked ? '+1' : '-1';
      if (isLiked) {
        _likeCount = _likeCount > 0 ? _likeCount - 1 : 0;
      } else {
        _likeCount += 1;
      }
    });
    _plusOneController.forward(from: 0);
    return nextLiked;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 34,
            height: 26,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                LikeButton(
                  size: 21,
                  isLiked: _isLiked,
                  onTap: _onLikeTap,
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      isLiked
                          ? Icons.thumb_up_alt_rounded
                          : Icons.thumb_up_alt_outlined,
                      size: 21,
                      color:
                          isLiked
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                    );
                  },
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: colorScheme.primary,
                    dotSecondaryColor: colorScheme.primary.withValues(
                      alpha: 0.75,
                    ),
                    dotThirdColor: colorScheme.primary.withValues(alpha: 0.6),
                    dotLastColor: colorScheme.primary.withValues(alpha: 0.45),
                  ),
                  circleColor: CircleColor(
                    start: colorScheme.primary.withValues(alpha: 0.28),
                    end: colorScheme.primary.withValues(alpha: 0.06),
                  ),
                  likeCount: null,
                  countBuilder:
                      (int? count, bool isLiked, String text) =>
                          const SizedBox.shrink(),
                ),
                Positioned(
                  right: -8,
                  top: -8,
                  child: IgnorePointer(
                    child: FadeTransition(
                      opacity: _plusOneOpacity,
                      child: SlideTransition(
                        position: _plusOneOffset,
                        child: Text(
                          _deltaText,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            Utils.numFormat(_likeCount),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color:
                  _isLiked ? colorScheme.primary : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
