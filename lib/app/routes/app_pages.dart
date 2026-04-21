import 'package:get/get.dart';

import '../modules/bottom_bar/bindings/bottom_bar_binding.dart';
import '../modules/bottom_bar/views/bottom_bar_view.dart';
import '../modules/feed/bindings/feed_binding.dart';
import '../modules/feed/views/feed_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/me/bindings/me_binding.dart';
import '../modules/me/views/me_view.dart';
import '../modules/rank/bindings/rank_binding.dart';
import '../modules/rank/views/rank_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.BOTTOM_BAR;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.RANK,
      page: () => const RankView(),
      binding: RankBinding(),
    ),
    GetPage(
      name: _Paths.FEED,
      page: () => const FeedView(),
      binding: FeedBinding(),
    ),
    GetPage(name: _Paths.ME, page: () => const MeView(), binding: MeBinding()),
    GetPage(
      name: _Paths.BOTTOM_BAR,
      page: () => const BottomBarView(),
      binding: BottomBarBinding(),
    ),
  ];
}
