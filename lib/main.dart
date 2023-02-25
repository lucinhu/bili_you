import 'package:bili_you/common/utils/bili_you_storage.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'common/style/color_schemes.g.dart';
import 'main.reflectable.dart';
import 'pages/splash/view.dart';

void main() async {
  initializeReflectable();
  WidgetsFlutterBinding.ensureInitialized();
  await MyDio.init();
  await BiliYouStorage.ensureInitialized();
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
        theme: ThemeData(
            colorScheme: lightDynamic ?? lightColorScheme, useMaterial3: true),
        darkTheme: ThemeData(
            colorScheme: darkDynamic ?? darkColorScheme, useMaterial3: true),
        home: const SplashPage(),
      );
    }));
  }
}
