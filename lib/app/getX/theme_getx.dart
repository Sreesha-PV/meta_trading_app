import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // Observable theme mode
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromBox();
  }

  void _loadThemeFromBox() {
    bool isDark = _box.read(_key) ?? false;
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
      _box.write(_key, false);
    } else {
      themeMode.value = ThemeMode.dark;
      _box.write(_key, true);
    }

    Get.changeThemeMode(themeMode.value);
  }
}