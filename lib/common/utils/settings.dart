import 'dart:developer';
import 'dart:io';

import 'package:bili_you/common/api/github_api.dart';
import 'package:bili_you/common/models/local/video/audio_play_item.dart';
import 'package:bili_you/common/models/local/video/video_play_item.dart';
import 'package:bili_you/common/models/network/github/github_releases_item.dart';
import 'package:bili_you/common/utils/bili_you_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsUtil {
  static dynamic getValue(String key, {dynamic defaultValue}) {
    return BiliYouStorage.settings.get(key, defaultValue: defaultValue);
  }

  static Future<void> setValue(String key, dynamic value) async {
    await BiliYouStorage.settings.put(key, value);
  }

  static ThemeMode get currentThemeMode {
    var index = getValue(SettingsStorageKeys.themeMode,
        defaultValue: ThemeMode.system.index);
    return ThemeMode.values[index];
  }

  static changeThemeMode(ThemeMode themeMode) {
    setValue(SettingsStorageKeys.themeMode, themeMode.index);
    Get.changeThemeMode(themeMode);
  }

  static BiliTheme get currentTheme {
    var index = getValue(SettingsStorageKeys.biliTheme,
        defaultValue: BiliTheme.dynamic.index);
    return BiliTheme.values[index];
  }

  static changeTheme(BiliTheme theme) {
    setValue(SettingsStorageKeys.biliTheme, theme.index);
    //不知道为什么Get.changeTheme()暗色不能更新
    //只能强制更新
    Get.forceAppUpdate();
  }

  ///检查更新，并弹窗提示
  static void checkUpdate(BuildContext context,
      {bool showSnackBar = true}) async {
    var packageInfo = await PackageInfo.fromPlatform();
    var data = await GithubApi.requestLatestRelease();
    var latestVersionData = data.name?.replaceFirst('v', '').split('+');
    var latestVersionName = latestVersionData?.first ?? '';
    log('latestVersionName:$latestVersionName');
    var latestVersionCode = latestVersionData?[1] ?? 1;
    log('versionCode:$latestVersionCode');
    var currentVersion = packageInfo.version;
    // log(data.toRawJson());
    if (latestVersionName == currentVersion) {
      if (showSnackBar) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context);
        Get.rawSnackbar(message:'已是最新版');
      }
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              scrollable: true,
              title: Text("有新版本:$latestVersionName"),
              content: SelectableText(data.body!),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("取消")),
                TextButton(
                  child: const Text("跳转下载"),
                  onPressed: () async {
                    //自动选择合适系统/abi的版本下载
                    if (Platform.isAndroid) {
                      //安卓
                      var supportedAbis =
                          (await DeviceInfoPlugin().androidInfo).supportedAbis;
                      // for (var i in supportedAbis) {
                      //   log(i);
                      // }
                      String abi = "";
                      if (supportedAbis.contains("x86_64")) {
                        abi = "x86_64";
                      } else if (supportedAbis.contains("arm64-v8a")) {
                        abi = "arm64-v8a";
                      } else if (supportedAbis.contains("armeabi-v7a")) {
                        abi = "armeabi-v7a";
                      }
                      for (Asset? i in data.assets ?? []) {
                        if (i!.name!.contains(abi) && i.name!.contains("apk")) {
                          //跳转下载
                          launchUrlString(i.browserDownloadUrl!,
                              mode: LaunchMode.externalApplication);
                          return;
                        }
                      }
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("没有匹配到支持的abi!\n现跳转至下载页面,请自行选择合适的安装包.")));
                      launchUrlString(
                          "https://github.com/lucinhu/bili_you/releases",
                          mode: LaunchMode.externalApplication);
                    } else if (Platform.isLinux) {
                      //linux
                      launchUrlString(
                          "https://github.com/lucinhu/bili_you/releases",
                          mode: LaunchMode.externalApplication);
                    } else if (Platform.isIOS) {
                      //TODO ios
                    }
                  },
                )
              ],
            );
          });
    }
  }

  //获取偏好的视频画质
  static VideoQuality getPreferVideoQuality() {
    return VideoQualityCode.fromCode(SettingsUtil.getValue(
        SettingsStorageKeys.preferVideoQuality,
        defaultValue: VideoQuality.values.last.code));
  }

  //保存偏好视频画质
  static Future<void> putPreferVideoQuality(VideoQuality quality) async {
    await SettingsUtil.setValue(
        SettingsStorageKeys.preferVideoQuality, quality.code);
  }

  //获取偏好的视频音质
  static AudioQuality getPreferAudioQuality() {
    return AudioQualityCode.fromCode(SettingsUtil.getValue(
        SettingsStorageKeys.preferAudioQuality,
        defaultValue: AudioQuality.values.last.code));
  }

  //保存偏好视频音质
  static Future<void> putPreferAudioQuality(AudioQuality quality) async {
    await SettingsUtil.setValue(
        SettingsStorageKeys.preferAudioQuality, quality.code);
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
