import 'package:get/get.dart';
import 'package:get_demo/app/data/repositories/searchRepo.dart';

import '../controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchRepo>(() => SearchRepo());
    Get.put<SearchController>(SearchController());
  }
}
