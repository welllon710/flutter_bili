import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_demo/app/data/models/video_detail_response.dart';
import 'package:get_demo/app/modules/home/widgets/hot_video_card.dart';
import 'package:get_demo/app/modules/home/widgets/optimized_network_image.dart';
import 'package:get_demo/app/modules/video/controllers/video_controller.dart';
import 'package:get_demo/app/routes/app_pages.dart';
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.owner?.name ?? 'UP主',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      controller.followerTotal.value.isNotEmpty
                          ? '${Utils.numFormat(int.tryParse(controller.followerTotal.value) ?? controller.followerTotal.value)}粉丝'
                          : '粉丝获取中',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
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
          if ((data.ugcSeason?.sections ?? []).any(
            (SectionItem section) => (section.episodes ?? []).isNotEmpty,
          )) ...[
            const SizedBox(height: 18),
            _UgcSeasonSection(
              ugcSeason: data.ugcSeason!,
              currentBvid: data.bvid ?? '',
            ),
          ],
          const SizedBox(height: 18),
          Text(
            '相关推荐',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          if (controller.isRelatedLoading.value &&
              controller.relatedVideoList.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (controller.relatedError.value.isNotEmpty &&
              controller.relatedVideoList.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                controller.relatedError.value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else if (controller.relatedVideoList.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '暂无相关推荐',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            ...controller.relatedVideoList.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: HotVideoCard(
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
                ),
              );
            }),
        ],
      );
    });
  }
}

class _UgcSeasonSection extends StatelessWidget {
  const _UgcSeasonSection({required this.ugcSeason, required this.currentBvid});

  static const String _seasonDialogTag = 'ugc_season_dialog';

  final UgcSeason ugcSeason;
  final String currentBvid;

  void _showSeasonEpisodesSheet(
    BuildContext context,
    List<EpisodeItem> episodes,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    SmartDialog.show<void>(
      tag: _seasonDialogTag,
      keepSingle: true,
      clickMaskDismiss: true,
      alignment: Alignment.bottomCenter,
      animationType: SmartAnimationType.centerFade_otherSlide,
      maskColor: Colors.black.withValues(alpha: 0.45),
      builder: (BuildContext dialogContext) {
        return Material(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          clipBehavior: Clip.antiAlias,
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: MediaQuery.of(dialogContext).size.width,
              height: MediaQuery.of(dialogContext).size.height * 0.72,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 12, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            ugcSeason.title?.isNotEmpty == true
                                ? ugcSeason.title!
                                : '合集',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '${ugcSeason.epCount ?? episodes.length}个视频',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        IconButton(
                          onPressed:
                              () => SmartDialog.dismiss(
                                status: SmartStatus.custom,
                                tag: _seasonDialogTag,
                              ),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
                      itemCount: episodes.length,
                      itemBuilder: (_, int index) {
                        final EpisodeItem episode = episodes[index];
                        final bool isCurrent =
                            currentBvid.isNotEmpty &&
                            episode.bvid == currentBvid;
                        final bool canOpen =
                            episode.bvid?.isNotEmpty == true &&
                            (episode.cid ?? 0) > 0;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _UgcEpisodeCard(
                            episode: episode,
                            isCurrent: isCurrent,
                            onTap:
                                canOpen
                                    ? () {
                                      SmartDialog.dismiss(
                                        status: SmartStatus.custom,
                                        tag: _seasonDialogTag,
                                      );
                                      Get.toNamed(
                                        Routes.VIDEO,
                                        arguments: {
                                          'bvid': episode.bvid,
                                          'cid': episode.cid,
                                          'aid': episode.aid,
                                          'title': episode.title,
                                        },
                                      );
                                    }
                                    : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final List<EpisodeItem> episodes =
        ugcSeason.sections
            ?.expand(
              (SectionItem section) => section.episodes ?? <EpisodeItem>[],
            )
            .toList() ??
        <EpisodeItem>[];

    if (episodes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                ugcSeason.title?.isNotEmpty == true ? ugcSeason.title! : '合集',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '${ugcSeason.epCount ?? episodes.length}个视频',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        if (ugcSeason.intro?.isNotEmpty == true) ...[
          const SizedBox(height: 6),
          Text(
            ugcSeason.intro!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
        const SizedBox(height: 10),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _showSeasonEpisodesSheet(context, episodes),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.35,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.video_library_outlined,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '查看合集视频',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '共${episodes.length}个视频，点击展开',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _UgcEpisodeCard extends StatelessWidget {
  const _UgcEpisodeCard({
    required this.episode,
    required this.isCurrent,
    this.onTap,
  });

  final EpisodeItem episode;
  final bool isCurrent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
              isCurrent
                  ? colorScheme.primary.withValues(alpha: 0.08)
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(14),
          border:
              isCurrent
                  ? Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.35),
                  )
                  : null,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 120,
                height: 72,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    OptimizedNetworkImage(
                      url: episode.cover ?? '',
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.02),
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              Utils.timeFormat(episode.page?.duration ?? 0),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
                  Row(
                    children: [
                      if (isCurrent) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '播放中',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: Text(
                          episode.title?.isNotEmpty == true
                              ? episode.title!
                              : episode.page?.pagePart ?? '合集视频',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    episode.page?.pagePart?.isNotEmpty == true
                        ? episode.page!.pagePart!
                        : '第${episode.page?.page ?? 0}P',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.35,
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
