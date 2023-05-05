import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class BiliYouStorage {
  static late final Box user;
  static late final Box networkData;
  static late final Box settings;
  static late final Box history;
  static late final Box video;
  static bool _initialized = false;
  static Future<void> ensureInitialized() async {
    if (!_initialized) {
      Hive.init("${(await getApplicationSupportDirectory()).path}/hive");
      user = await Hive.openBox("user");
      networkData = await Hive.openBox("networkData");
      settings = await Hive.openBox("settings");
      history = await Hive.openBox("history");
      video = await Hive.openBox("video");
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
  static const String themeMode = "themeMode";
  static const String biliTheme = "biliTheme";
  static const String autoCheckUpdate = "autoCheckUpdate";
  static const String showSearchDefualtWord = "showSearchDefualtWord";
  static const String showSearchHistory = "showSearchHistory";
  static const String showHotSearch = "showHotSearch";
  static const String defaultShowDanmaku = "defaultShowDanmaku";
  static const String preferVideoQuality = "preferVideoQuality";
  static const String autoPlayOnInit = "autoPlayOnInit";
  static const String fullScreenPlayOnEnter = "fullScreenPlayOnEnter";
  static const String isHardwareDecode = "isHardwareDecode";

  ///首页推荐列数
  static const String recommendColumnCount = 'recommendColumnCount';

  ///字体大小缩放
  static const String textScaleFactor = 'textScaleFactor';

  ///偏好视频编码（avc或hev）
  static const String preferVideoCodec = "preferVideoCodec";
  static const String preferAudioQuality = "preferAudioQuality";
}

class VideoStorageKeys {
  static const String speed = "speed";
}
