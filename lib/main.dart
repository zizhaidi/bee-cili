import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "beecili",
      theme: ThemeData.light().copyWith(
        iconTheme: const IconThemeData(
          color: Color(0xFF4d4d4d),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 4,
        ),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
