import 'package:bili_you/common/models/local/reply/official_verify.dart';
import 'package:bili_you/common/models/local/reply/vip.dart';

import 'level_info.dart';

///TODO 修改支持Hive
class LoginUserInfo {
  LoginUserInfo(
      {required this.mid,
      required this.name,
      required this.avatarUrl,
      required this.levelInfo,
      required this.officialVerify,
      required this.vip,
      required this.isLogin});
  static LoginUserInfo get zero => LoginUserInfo(
      mid: 0,
      name: "",
      avatarUrl: "",
      levelInfo: LevelInfo.zero,
      officialVerify: OfficialVerify.zero,
      vip: Vip.zero,
      isLogin: false);
  int mid;
  String name;
  String avatarUrl;
  LevelInfo levelInfo;
  OfficialVerify officialVerify;
  Vip vip;
  bool isLogin;
}
