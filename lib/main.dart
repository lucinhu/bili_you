import 'package:bili_you/common/utils/bili_you_storage.dart';
import 'package:bili_you/common/utils/http_utils.dart';
import 'package:bili_you/common/utils/settings.dart';
import 'package:bili_you/pages/bili_video/index.dart';
import 'package:bili_you/pages/main/index.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BiliYouStorage.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const MyApp());
  //状态栏、导航栏沉浸
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: ((lightDynamic, darkDynamic) {
      return GetMaterialApp(
          onInit: () async {
            await HttpUtils().init();
          },
          navigatorObservers: [BiliVideoPage.routeObserver],
          useInheritedMediaQuery: true,
          themeMode: SettingsUtil.currentThemeMode,
          theme: ThemeData(
              colorScheme: SettingsUtil.currentTheme == BiliTheme.dynamic
                  ? lightDynamic ?? BiliTheme.dynamic.themeDataLight.colorScheme
                  : SettingsUtil.currentTheme.themeDataLight.colorScheme,
              useMaterial3: true),
          darkTheme: ThemeData(
              colorScheme: SettingsUtil.currentTheme == BiliTheme.dynamic
                  ? darkDynamic ?? BiliTheme.dynamic.themeDataDark.colorScheme
                  : SettingsUtil.currentTheme.themeDataDark.colorScheme,
              useMaterial3: true),
          home: const MainPage(),
          builder: (context, child) => child == null
              ? const SizedBox()
              : MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor *
                          SettingsUtil.getValue(
                              SettingsStorageKeys.textScaleFactor,
                              defaultValue: 1.0)),
                  child: child));
    }));
  }
}
