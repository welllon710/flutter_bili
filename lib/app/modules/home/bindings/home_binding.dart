import 'package:get/get.dart';
import 'package:get_demo/app/data/repositories/homeRepo.dart';
import 'package:get_demo/app/modules/feed/controllers/feed_controller.dart';
import 'package:get_demo/app/modules/me/controllers/me_controller.dart';
import 'package:get_demo/app/modules/rank/controllers/rank_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepo>(() => HomeRepo());
    Get.lazyPut<HomeController>(() => HomeController());
    // Get.lazyPut<RankController>(() => RankController());
    // Get.lazyPut<FeedController>(() => FeedController());
    // Get.lazyPut<MeController>(() => MeController());
  }
}
