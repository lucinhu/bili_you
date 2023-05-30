import '../reply/official_verify.dart';
import '../reply/vip.dart';

class DynamicAuthor {
  DynamicAuthor(
      {required this.mid,
      required this.name,
      required this.avatarUrl,
      required this.officialVerify,
      required this.vip,
      required this.pubTime,
      required this.pubAction,
      this.hasUpdate = false});
  static DynamicAuthor get zero => DynamicAuthor(
      mid: 0,
      name: "",
      avatarUrl: "",
      officialVerify: OfficialVerify.zero,
      vip: Vip.zero,
      pubTime: "",
      pubAction: "");
  int mid;
  String name;
  String avatarUrl;
  OfficialVerify officialVerify;
  Vip vip;
  String pubTime;
  String pubAction;
  bool hasUpdate;
}
