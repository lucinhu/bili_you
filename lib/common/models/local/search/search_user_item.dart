import 'package:bili_you/common/models/local/reply/official_verify.dart';
import 'package:bili_you/common/models/local/reply/reply_member.dart';

class SearchUserItem {
  SearchUserItem(
      {required this.mid,
      required this.name,
      required this.face,
      required this.sign,
      required this.fansCount,
      required this.videoCount,
      required this.level,
      required this.gender,
      required this.isUpper,
      required this.isLive,
      required this.roomId,
      required this.officialVerify});
  static SearchUserItem get zero => SearchUserItem(
      mid: 0,
      name: '',
      face: '',
      sign: '',
      fansCount: 0,
      videoCount: 0,
      level: 0,
      gender: Gender.secret,
      isUpper: false,
      isLive: false,
      roomId: 0,
      officialVerify: OfficialVerify.zero);
  int mid;
  String name;
  String face;
  String sign;
  int fansCount;
  int videoCount;
  int level;
  Gender gender;
  bool isUpper;
  bool isLive;
  int roomId;
  OfficialVerify officialVerify;
}
