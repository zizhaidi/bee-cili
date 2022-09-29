import 'dart:convert';

import 'package:get/get.dart';
import 'package:magnet_search_app/app/data/model/ads.dart';
import 'package:magnet_search_app/app/data/model/status.dart';
import 'package:magnet_search_app/app/data/model/torrents.dart';
import 'package:magnet_search_app/app/data/provider/api_dio.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;

  final controller = FloatingSearchBarController();

  final _adsRes = AdsRes(success: 0, ads: []).obs;
  AdsRes get adsRes => _adsRes.value;
  set adsRes(value) => _adsRes.value = value;

  final _torrentsRes = TorrentsRes(success: 0, torrents: []).obs;
  TorrentsRes get torrentsRes => _torrentsRes.value;
  set torrentsRes(value) => _torrentsRes.value = value;

  final _statusRes = StatusRes(success: 0, count: 0).obs;
  set statusRes(value) => _statusRes.value = value;
  StatusRes get statusRes => _statusRes.value;

  final _torrents = <Torrent>[].obs;
  set torrents(value) => _torrents.value = value;
  get torrents => _torrents;

  final _loading = false.obs;
  get loading => _loading.value;
  set loading(value) => _loading.value = value;

  bool nomore = false;

  final DioClient _dio = DioClient();

  int limit = 24;
  int page = 1;

  String searchQuery = '';

  bool loadmoreLoading = false;

  @override
  void onInit() {
    getAds();
    getStatus();
    super.onInit();
  }

  search(String query) {
    loading = true;
    searchQuery = query;
    _dio.getTorrents(limit: limit, page: page, q: query).then((value) {
      torrentsRes = TorrentsRes.fromJson(value.data);
      if (torrentsRes.torrents.length < limit) {
        nomore = true;
      }
      torrents = torrentsRes.torrents;
      loading = false;
    });
  }

  loadMore() {
    page += 1;
    print(page);
    print(searchQuery);
    loadmoreLoading = true;
    _dio.getTorrents(limit: limit, page: page, q: searchQuery).then((value) {
      TorrentsRes newTorrentsRes = TorrentsRes.fromJson(value.data);
      if (newTorrentsRes.torrents.length < limit) {
        nomore = true;
      }
      if (!nomore) {
        torrents.addAll(newTorrentsRes.torrents);
      }
      loadmoreLoading = false;
    });
  }

  getAds() {
    _dio.getAds().then((value) {
      adsRes = AdsRes.fromJson(value.data);
    });
  }

  getStatus() {
    _dio.getStatus().then((value) {
      statusRes = StatusRes.fromJson(value.data);
    });
  }
}
