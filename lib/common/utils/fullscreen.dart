//进入全屏显示
import 'package:flutter/services.dart';

enterFullScreen() async {
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setSystemUIChangeCallback(
      (systemOverlaysAreVisible) async => {
            if (systemOverlaysAreVisible)
              {
                //为了防止状态栏出来就回不去了
                //使状态栏在全屏时确实是暂时显示的
                await SystemChrome.setEnabledSystemUIMode(
                    SystemUiMode.immersiveSticky)
              }
          });
}

//退出全屏显示
exitFullScreen() async {
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setSystemUIChangeCallback(null);
}

//横屏
landScape() async {
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
}

//竖屏
portraitUp() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}
