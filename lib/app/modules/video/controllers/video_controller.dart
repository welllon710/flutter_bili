import 'dart:async';

import 'package:get/get.dart';
import 'package:get_demo/app/core/network/constants.dart';
import 'package:get_demo/app/data/models/Ppay_url_model.dart';
import 'package:get_demo/app/data/models/video_detail_response.dart';
import 'package:get_demo/app/data/models/video_online_count.dart';
import 'package:get_demo/app/data/repositories/videoRepo.dart';
import 'package:get_demo/app/utils/polling_runner.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' as media_kit_video;

class VideoCustomController extends GetxController {
  final VideoRepo _videoRepo = Get.find<VideoRepo>();
  final RxBool isLoading = true.obs;
  final RxString errorText = ''.obs;
  final RxString title = ''.obs;
  final RxString playUrl = ''.obs;
  final RxInt duration = 0.obs; // millisecond
  final RxBool showPlayerControls = true.obs;
  final RxBool isPlaying = false.obs;
  final RxInt currentPosition = 0.obs; // millisecond
  final RxBool isSeeking = false.obs;
  final RxInt dragSeekPosition = 0.obs; // millisecond
  final RxBool isIntroLoading = true.obs;
  final RxString introError = ''.obs;
  final Rxn<VideoDetailData> introData = Rxn<VideoDetailData>();
  final RxString onlineTotal = ''.obs;

  late final Player player;
  late final media_kit_video.VideoController playerController;
  Timer? _controlsHideTimer;
  StreamSubscription<bool>? _playingSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration>? _durationSub;
  PollingRunner? _onlineCountPolling;
  int _onlineAid = 0;
  int _onlineCid = 0;

  @override
  void onInit() {
    super.onInit();
    player = Player();
    playerController = media_kit_video.VideoController(player);
    _bindPlayerStreams();
    _initVideo();
  }

  @override
  void onClose() {
    _controlsHideTimer?.cancel();
    _playingSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _onlineCountPolling?.dispose();
    player.dispose();
    super.onClose();
  }

  Future<void> _initVideo() async {
    final dynamic args = Get.arguments;
    final Map<dynamic, dynamic> map = args is Map ? args : <dynamic, dynamic>{};

    final String bvid = (map['bvid'] ?? '').toString();
    final int cid = _toInt(map['cid']);
    final int avid = _toInt(map['aid'] ?? map['avid']);
    title.value = (map['title'] ?? map['name'] ?? '视频播放').toString();
    _loadVideoIntro(
      bvid: bvid.isNotEmpty ? bvid : null,
      avid: avid > 0 ? avid : null,
    );
    if (avid > 0 && cid > 0) {
      _startOnlineCountPolling(aid: avid, cid: cid);
    }

    if (cid <= 0 || (bvid.isEmpty && avid <= 0)) {
      errorText.value = '缺少播放参数';
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      errorText.value = '';

      final PlayUrlModel result = await _videoRepo.getVideoPlayUrl(
        bvid: bvid.isNotEmpty ? bvid : null,
        avid: avid > 0 ? avid : null,
        cid: cid,
      );

      final String? url = _pickPlayableUrl(result);
      if (url == null || url.isEmpty) {
        throw Exception('未获取到可播放地址');
      }

      playUrl.value = url;
      duration.value = result.timeLength ?? 0;

      await player.open(
        Media(
          url,
          httpHeaders: <String, String>{
            'Referer': HttpString.baseUrl,
            'User-Agent': 'Mozilla/5.0',
          },
        ),
      );
      showControls();
    } catch (_) {
      errorText.value = '视频播放加载失败';
    } finally {
      isLoading.value = false;
    }
  }

  void _bindPlayerStreams() {
    _playingSub = player.stream.playing.listen((bool val) {
      isPlaying.value = val;
    });
    _positionSub = player.stream.position.listen((Duration val) {
      if (!isSeeking.value) {
        currentPosition.value = val.inMilliseconds;
      }
    });
    _durationSub = player.stream.duration.listen((Duration val) {
      duration.value = val.inMilliseconds;
    });
  }

  void toggleControls() {
    if (showPlayerControls.value) {
      hideControls();
    } else {
      showControls();
    }
  }

  void showControls() {
    showPlayerControls.value = true;
    _controlsHideTimer?.cancel();
    _controlsHideTimer = Timer(const Duration(seconds: 2), () {
      showPlayerControls.value = false;
    });
  }

  void hideControls() {
    _controlsHideTimer?.cancel();
    showPlayerControls.value = false;
  }

  Future<void> togglePlayPause() async {
    if (isPlaying.value) {
      await player.pause();
    } else {
      await player.play();
    }
    showControls();
  }

  void onSeekStart(double value) {
    isSeeking.value = true;
    dragSeekPosition.value = value.toInt();
    showControls();
  }

  void onSeekChanged(double value) {
    dragSeekPosition.value = value.toInt();
    showControls();
  }

  Future<void> onSeekEnd(double value) async {
    final int target = value.toInt();
    isSeeking.value = false;
    currentPosition.value = target;
    await player.seek(Duration(milliseconds: target));
    showControls();
  }

  String formatDuration(int ms) {
    final int totalSeconds = (ms ~/ 1000).clamp(0, 24 * 60 * 60);
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String? _pickPlayableUrl(PlayUrlModel model) {
    if (model.durl != null && model.durl!.isNotEmpty) {
      return model.durl!.first.url;
    }

    if (model.dash?.video != null && model.dash!.video!.isNotEmpty) {
      return model.dash!.video!.first.baseUrl;
    }

    return null;
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  Future<void> _loadVideoIntro({String? bvid, int? avid}) async {
    if ((bvid == null || bvid.isEmpty) && (avid == null || avid <= 0)) {
      isIntroLoading.value = false;
      return;
    }

    isIntroLoading.value = true;
    introError.value = '';

    try {
      final VideoDetailResponse response = await _videoRepo.getVideoIntro(
        bvid: bvid,
        avid: avid,
      );
      if (response.code == 0 && response.data != null) {
        introData.value = response.data;
        final String introTitle = response.data?.title ?? '';
        if (introTitle.isNotEmpty) {
          title.value = introTitle;
        }
        final int aid = response.data?.aid ?? 0;
        final int cid = response.data?.cid ?? 0;
        if (aid > 0 && cid > 0) {
          _startOnlineCountPolling(aid: aid, cid: cid);
        }
      } else {
        introError.value = response.message ?? '简介加载失败';
      }
    } catch (_) {
      introError.value = '简介加载失败';
    } finally {
      isIntroLoading.value = false;
    }
  }

  Future<void> _loadOnlineCount({required int aid, required int cid}) async {
    try {
      final VideoOnlineCount response = await _videoRepo.getOnlineCount(
        aid: aid,
        cid: cid,
      );
      onlineTotal.value = response.data?.total ?? '';
    } catch (_) {}
  }

  void _startOnlineCountPolling({required int aid, required int cid}) {
    if (aid <= 0 || cid <= 0) return;

    final bool isSameTarget = _onlineAid == aid && _onlineCid == cid;
    if (isSameTarget && (_onlineCountPolling?.isRunning ?? false)) return;

    _onlineAid = aid;
    _onlineCid = cid;

    _onlineCountPolling?.dispose();
    _onlineCountPolling = PollingRunner(
      callback: () => _loadOnlineCount(aid: _onlineAid, cid: _onlineCid),
      interval: const Duration(minutes: 1),
    );
    _onlineCountPolling?.start();
  }
}
