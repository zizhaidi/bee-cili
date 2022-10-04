import 'dart:convert';

import 'package:flutter/foundation.dart';
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

  final _nomore = false.obs;
  get nomore => _nomore.value;
  set nomore(value) => _nomore.value = value;

  final _loadmoreLoading = false.obs;
  get loadmoreLoading => _loadmoreLoading.value;
  set loadmoreLoading(value) => _loadmoreLoading.value = value;

  final DioClient _dio = DioClient();

  int limit = 24;
  int page = 1;

  String searchQuery = '';

  @override
  void onInit() {
    getAds();
    getStatus();
    super.onInit();
  }

  search(String query) {
    page = 1;
    loading = true;
    searchQuery = query;
    nomore = false;
    if (kDebugMode) {
      print(query);
    }
    _dio.getTorrents(limit: limit, page: page, q: query).then((value) {
      torrentsRes = TorrentsRes.fromJson(value.data);
      torrents = torrentsRes.torrents;
      if (torrents.length == 0) {
        Get.snackbar('提醒', '未找到任何内容，爬虫根据关键词爬取中！');
      }
      loading = false;
    });
  }

  refreshing() {
    page = 1;
    loading = true;
    _dio.getTorrents(limit: limit, page: page, q: searchQuery).then((value) {
      torrentsRes = TorrentsRes.fromJson(value.data);
      torrents = torrentsRes.torrents;
      loading = false;
    });
  }

  loadMore() {
    page += 1;
    if (kDebugMode) {
      print(page);
    }
    loadmoreLoading = true;
    _dio.getTorrents(limit: limit, page: page, q: searchQuery).then((value) {
      TorrentsRes newTorrentsRes = TorrentsRes.fromJson(value.data);
      if (newTorrentsRes.torrents.isEmpty) {
        nomore = true;
      } else {
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
