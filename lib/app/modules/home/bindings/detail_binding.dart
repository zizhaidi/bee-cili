import 'package:get/get.dart';
import 'package:magnet_search_app/app/modules/home/controllers/detail_controller.dart';

class DetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailController>(() => DetailController());
  }
}
