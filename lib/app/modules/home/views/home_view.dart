import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:magnet_search_app/core/utils/helper.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:simple_html_css/simple_html_css.dart';

import '../controllers/home_controller.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF1F2F4),
      body: buildSearchBar(context, controller),
    );
  }

  Widget buildSearchBar(BuildContext context, HomeController homeController) {
    final actions = [
      FloatingSearchBarAction(
        showIfOpened: false,
        child: CircularButton(
          icon: const Icon(Icons.movie),
          onPressed: () {},
        ),
      ),
      FloatingSearchBarAction.searchToClear(
        showIfClosed: false,
      ),
    ];
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      automaticallyImplyBackButton: false,
      controller: homeController.controller,
      clearQueryOnClose: true,
      hint: '搜索磁力链接..',
      iconColor: Colors.grey,
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOutCubic,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      actions: actions,
      // progress: ,
      debounceDelay: const Duration(milliseconds: 500),
      onSubmitted: (query) {
        controller.search(query);
        homeController.controller.query = "";
        homeController.controller.close();
      },
      scrollPadding: EdgeInsets.zero,
      transition: CircularFloatingSearchBarTransition(spacing: 16),
      builder: (context, _) => buildExpandableBody(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(
          child: scrollContent(),
        ),
      ],
    );
  }

  Widget buildExpandableBody() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: Container()),
    );
  }

  Widget searchResult() {
    return LazyLoadScrollView(
      onEndOfPage: () {
        if (!controller.loadmoreLoading) {
          controller.loadMore();
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 60),
        itemCount: controller.torrents.length,
        itemBuilder: (context, index) {
          // if (kDebugMode) {
          //   print(index);
          // }
          // if (index > controller.torrents.length * 0.8 &&
          //     !controller.loadmoreLoading &&
          //     !controller.nomore) {
          //   controller.loadMore();
          // }
          return Slidable(
            // The end action pane is the one at the right or the bottom side.
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  onPressed: (context) {
                    FlutterClipboard.copy(controller.torrents[index].magnet!)
                        .then(
                      (value) =>
                          Get.snackbar('提醒', '复制成功！打开迅雷APP自动开始下载，配合迅雷云盘更好用哟！'),
                    );
                  },
                  icon: Icons.copy,
                  label: '复制磁力',
                ),
                SlidableAction(
                  // An action can be bigger than the others.
                  onPressed: (context) {
                    Get.toNamed(
                        '/detail?id=${controller.torrents[index].id}&title=${controller.torrents[index].name}');
                  },
                  icon: Icons.description,
                  label: '详情',
                ),
              ],
            ),

            // The child of the Slidable is what the user sees when the
            // component is not dragged.
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: RichText(
                text: HTML.toTextSpan(context, controller.torrents[index].name),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle:
                  Text('资源大小：${filesize(controller.torrents[index].length)}'),
            ),
          );
        },
      ).paddingOnly(left: 16, right: 16),
    );
  }

  Widget scrollContent() {
    return SafeArea(
      child: FloatingSearchBarScrollNotifier(
        child: Obx(
          () => controller.loading
              ? SizedBox(
                  height: Get.height - 80,
                  child: const Center(child: CircularProgressIndicator()),
                )
              : controller.torrents.isNotEmpty
                  ? searchResult()
                  : ListView(
                      padding: const EdgeInsets.only(top: 80),
                      children: [
                        const Text(
                          '推广内容',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        for (var item in controller.adsRes.ads)
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              item.title,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                            subtitle: Text(item.content),
                            trailing: OutlinedButton(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              onPressed: () {
                                launchURL(item.link);
                              },
                              child: const Text('前往下载',
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold)),
                            ).withWidth(100),
                          ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                            '目前拥有资源数：${controller.statusRes.count.toString()}'),
                      ],
                    ).paddingAll(16),
        ),
      ),
    );
  }
}
