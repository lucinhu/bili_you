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
}
