import 'dart:async';

typedef PollingCallback = FutureOr<void> Function();

/// 轻量轮询器：只需要传入执行函数和间隔时间。
class PollingRunner {
  PollingRunner({required this.callback, required this.interval});

  final PollingCallback callback;
  final Duration interval;

  Timer? _timer;
  bool _isExecuting = false;

  bool get isRunning => _timer?.isActive ?? false;

  /// 启动轮询。默认先立即执行一次，再按间隔轮询。
  Future<void> start({bool immediate = true}) async {
    if (isRunning) return;

    if (immediate) {
      await _runOnce();
    }

    _timer = Timer.periodic(interval, (_) {
      _runOnce();
    });
  }

  /// 停止轮询。
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// 释放资源。
  void dispose() {
    stop();
  }

  /// 手动立即执行一次，不影响轮询状态。
  Future<void> runNow() async {
    await _runOnce();
  }

  Future<void> _runOnce() async {
    // 避免上一次任务尚未完成时重复执行。
    if (_isExecuting) return;
    _isExecuting = true;
    try {
      await callback();
    } catch (_) {
      // 保持轮询持续进行，错误由业务侧自行处理。
    } finally {
      _isExecuting = false;
    }
  }
}
