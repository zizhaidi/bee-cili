import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:magnet_search_app/app/data/model/torrent.dart';
import 'package:magnet_search_app/app/data/provider/api_dio.dart';

class DetailController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    id = Get.parameters['id']!;
    title = Get.parameters['title']!;
    getTorrent();
    super.onInit();
  }

  String id = '';
  String title = '';

  final _torrentRes = TorrentRes(success: 0).obs;
  TorrentRes get torrentRes => _torrentRes.value;
  set torrentRes(value) => _torrentRes.value = value;

  final _dio = DioClient();

  getTorrent() {
    _dio.getTorrent(id).then((value) {
      if (kDebugMode) {
        print(value.data);
      }
      torrentRes = TorrentRes.fromJson(value.data);
    });
  }
}
