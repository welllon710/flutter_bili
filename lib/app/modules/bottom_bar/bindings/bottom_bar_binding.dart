import 'package:get/get.dart';
import 'package:get_demo/app/modules/feed/controllers/feed_controller.dart';
import 'package:get_demo/app/modules/home/controllers/home_controller.dart';
import 'package:get_demo/app/modules/me/controllers/me_controller.dart';
import 'package:get_demo/app/modules/rank/controllers/rank_controller.dart';

import '../controllers/bottom_bar_controller.dart';

class BottomBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomBarController>(() => BottomBarController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<RankController>(() => RankController());
    Get.lazyPut<FeedController>(() => FeedController());
    Get.lazyPut<MeController>(() => MeController());
  }
}
