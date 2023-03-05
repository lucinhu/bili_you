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
