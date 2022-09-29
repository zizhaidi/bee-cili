import 'package:get/get.dart';
import 'package:magnet_search_app/app/modules/home/bindings/detail_binding.dart';
import 'package:magnet_search_app/app/modules/home/views/detail_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL,
      page: () => DetailPage(),
      binding: DetailBinding(),
    )
  ];
}
