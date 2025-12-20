import 'package:get/get.dart';
import 'package:get_demo/app/data/repositories/homeRepo.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepo>(() => HomeRepo());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
