
import 'package:bili_you/common/utils/bili_you_storage.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SettingsUtil {
  static ThemeMode get currentThemeMode {
    var index = BiliYouStorage.settings.get(SettingsStorageKeys.themeMode,
        defaultValue: ThemeMode.system.index);
    return ThemeMode.values[index];
  }

  static changeThemeMode(ThemeMode themeMode) {
    BiliYouStorage.settings.put(SettingsStorageKeys.themeMode, themeMode.index);
    Get.changeThemeMode(themeMode);
  }

  static BiliTheme get currentTheme {
    var index = BiliYouStorage.settings.get(SettingsStorageKeys.biliTheme,
        defaultValue: BiliTheme.dynamic.index);
    return BiliTheme.values[index];
  }

  static changeTheme(BiliTheme theme) {
    BiliYouStorage.settings.put(SettingsStorageKeys.biliTheme, theme.index);
    //不知道为什么Get.changeTheme()暗色不能更新
    //只能强制更新
    Get.forceAppUpdate();
  }
}

extension ThemeModeString on ThemeMode {
  String get value => ['系统', '淡色', '深色'][index];
}

enum BiliTheme {
  dynamic,
  blue,
  lightBlue,
  cyan,
  teal,
  green,
  lime,
  yellow,
  amber,
  orange,
  deepOrange,
  red,
  pink,
  purple,
  deepPurple,
  indigo,
  brown,
  blueGrey,
  grey,
}

extension BiliThemeName on BiliTheme {
  String get value => [
        '动态',
        '蓝色',
        '浅蓝色',
        '天蓝色',
        '蓝绿色',
        '绿色',
        '绿黄色',
        '黄色',
        '琥珀色',
        '橙色',
        '深橙色',
        '红色',
        '粉色',
        '紫色',
        '深紫色',
        '靛蓝色',
        '棕色',
        '蓝灰色',
        '灰色',
      ][index];
  Color get seedColor => [
        Colors.blue,
        Colors.blue,
        Colors.lightBlue,
        Colors.cyan,
        Colors.teal,
        Colors.green,
        Colors.lime,
        Colors.yellow,
        Colors.amber,
        Colors.orange,
        Colors.deepOrange,
        Colors.red,
        Colors.pink,
        Colors.purple,
        Colors.deepPurple,
        Colors.indigo,
        Colors.brown,
        Colors.blueGrey,
        Colors.grey,
      ][index];
  ThemeData get themeDataLight => ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor, brightness: Brightness.light),
      useMaterial3: true);
  ThemeData get themeDataDark => ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor, brightness: Brightness.dark),
      useMaterial3: true);
}
