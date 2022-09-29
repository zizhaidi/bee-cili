import 'package:clipboard/clipboard.dart';
import 'package:dart_date/dart_date.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magnet_search_app/app/modules/home/controllers/detail_controller.dart';
import 'package:nb_utils/nb_utils.dart';

class DetailPage extends GetView<DetailController> {
  const DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('资源详情'),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: torrentDetail(),
      ),
    );
  }

  torrentDetail() {
    return Obx(
      () => controller.torrentRes.torrent == null
          ? SizedBox(
              height: Get.height,
              child: const Center(child: CircularProgressIndicator()),
            )
          : ListView(
              children: [
                Text(
                  controller.torrentRes.torrent!.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                    "发现日期：${DateTime.parse(controller.torrentRes.torrent!.meta!.createAt).format('y-mm-dd')}   资源大小：${filesize(controller.torrentRes.torrent!.length)}"),
                const SizedBox(
                  height: 8.0,
                ),
                const Divider(),
                const Text(
                  "磁力链接:",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text(controller.torrentRes.torrent!.magnet),
                const SizedBox(
                  height: 4.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                  onPressed: () {
                    FlutterClipboard.copy(controller.torrentRes.torrent!.magnet)
                        .then(
                      (value) =>
                          Get.snackbar('提醒', '复制成功！打开迅雷APP自动开始下载，配合迅雷云盘更好用哟！'),
                    );
                  },
                  child: const Text('点击复制'),
                ).withWidth(double.infinity),
                const Divider(),
                const Text(
                  "资源中文件(仅显示前200):",
                  style: TextStyle(fontSize: 16),
                ),
                for (var file in controller.torrentRes.torrent!.files!)
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(file.name),
                    subtitle: Text('大小：${filesize(file.length)}'),
                  )
              ],
            ).paddingAll(16),
    );
  }
}
