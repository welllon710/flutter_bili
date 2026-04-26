import 'package:get/get.dart';
import 'package:get_demo/app/data/repositories/videoRepo.dart';
import 'package:get_demo/app/modules/video/controllers/video_controller.dart';

class VideoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoRepo>(() => VideoRepo());
    Get.lazyPut<VideoCustomController>(() => VideoCustomController());
  }
}
