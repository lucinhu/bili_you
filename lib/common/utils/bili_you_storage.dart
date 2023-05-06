import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class BiliYouStorage {
  static late final Box user;
  static late final Box networkData;
  static late final Box settings;
  static late final Box history;
  static bool _initialized = false;
  static Future<void> ensureInitialized() async {
    if (!_initialized) {
      Hive.init("${(await getApplicationSupportDirectory()).path}/hive");
      user = await Hive.openBox("user");
      networkData = await Hive.openBox("networkData");
      settings = await Hive.openBox("settings");
      history = await Hive.openBox("history");
      _initialized = true;
    }
  }
}

class UserStorageKeys {
  static const String userFace = "userFace";
  static const String hasLogin = "hasLogin";
  static const String userName = "userName";
  // static const String userLevel = "userLevel";
  // static const String userCurrentExp = "userCurrentExp";
  // static const String userNextExp = "userNextExp";
  // static const String userDynamicCount = "userDynamicCount";
  // static const String userFollowerCount = "userFollowerCount";
  // static const String userFollowingCount = "userFollowingCount";
}

class SettingsStorageKeys {
  ///主题
  static const String themeMode = "themeMode";
  static const String biliTheme = "biliTheme";

  ///自动更新
  static const String autoCheckUpdate = "autoCheckUpdate";

  ///显示搜索默认词
  static const String showSearchDefualtWord = "showSearchDefualtWord";

  ///显示搜索历史
  static const String showSearchHistory = "showSearchHistory";

  ///显示热词
  static const String showHotSearch = "showHotSearch";

  ///默认开启弹幕
  static const String defaultShowDanmaku = "defaultShowDanmaku";

  ///保持弹幕开关状态
  static const String rememberDanmakuSwitch = "rememberDanmakuSwitch";

  ///保持弹幕设置
  static const String rememberDanmakuSettings = "rememberDanmakuSettings";

  ///默认弹幕速度
  static const String defaultDanmakuSpeed = "defaultDanmakuSpeed";

  ///默认弹幕字体缩放
  static const String defaultDanmakuScale = "defaultDanmakuScale";

  ///默认弹幕字体不透明度
  static const String defaultDanmakuOpacity = "defaultDanmakuOpacity";

  ///偏好视频画质
  static const String preferVideoQuality = "preferVideoQuality";

  ///进入播放页面时自动播放
  static const String autoPlayOnInit = "autoPlayOnInit";

  ///进入播放页面时全屏
  static const String fullScreenPlayOnEnter = "fullScreenPlayOnEnter";

  ///是否硬解
  static const String isHardwareDecode = "isHardwareDecode";

  ///是否后台播放
  static const String isBackGroundPlay = "isBackGroundPlay";

  ///首页推荐列数
  static const String recommendColumnCount = 'recommendColumnCount';

  ///字体大小缩放
  static const String textScaleFactor = 'textScaleFactor';

  ///偏好视频编码（avc或hev）
  static const String preferVideoCodec = "preferVideoCodec";
  static const String preferAudioQuality = "preferAudioQuality";

  ///默认播放播放速度
  static const String defaultVideoPlaybackSpeed = "defaultVideoPlaybackSpeed";
}
