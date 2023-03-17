import 'official_verify.dart';
import 'vip.dart';

class ReplyMember {
  ReplyMember(
      {required this.mid,
      required this.name,
      required this.gender,
      required this.avatarUrl,
      required this.level,
      required this.officialVerify,
      required this.vip});
  static ReplyMember get zero => ReplyMember(
      mid: 0,
      name: "",
      gender: Gender.secret,
      avatarUrl: "",
      level: 0,
      officialVerify: OfficialVerify.zero,
      vip: Vip.zero);
  int mid;
  String name;
  String avatarUrl;
  int level;
  OfficialVerify officialVerify;
  Vip vip;

  ///性别
  Gender gender;
}

enum Gender { man, woman, secret }

extension GenderText on Gender {
  static Gender fromText(String text) {
    switch (text) {
      case '男':
        return Gender.man;
      case '女':
        return Gender.woman;
      case '保密':
        return Gender.secret;
      default:
        return Gender.secret;
    }
  }

  get text => ['男', '女', '保密'][index];
}
