import 'package:bili_you/common/api/api_constants.dart';

import 'level_info.dart';
import 'official.dart';
import 'official_verify.dart';
import 'pendant.dart';
import 'vip_label.dart';
import 'wallet.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class UserInfoModel {
  UserInfoModel({
    required this.code,
    required this.message,
    required this.isLogin,
    required this.emailVerified,
    required this.face,
    required this.levelInfo,
    required this.mid,
    required this.mobileVerified,
    required this.money,
    required this.moral,
    required this.official,
    required this.officialVerify,
    required this.pendant,
    required this.scores,
    required this.userName,
    required this.vipDueDate,
    required this.vipStatus,
    required this.vipType,
    required this.vipPayType,
    required this.vipThemeType,
    required this.vipLabel,
    required this.vipAvatarSubscript,
    required this.vipNicknameColor,
    required this.wallet,
    required this.hasShop,
    required this.shopUrl,
    required this.allowanceCount,
    required this.answerStatus,
  });
  @JsonProperty(defaultValue: -1)
  final int code;
  @JsonProperty(defaultValue: "未知错误")
  final String message;
  @JsonProperty(name: 'data/isLogin', defaultValue: false)
  final bool isLogin;
  @JsonProperty(name: 'data/email_verified', defaultValue: 0)
  final int emailVerified;
  @JsonProperty(name: 'data/face', defaultValue: ApiConstants.noface)
  final String face;
  @JsonProperty(name: 'data/level_info', defaultValue: {})
  final LevelInfoModel levelInfo;
  @JsonProperty(name: 'data/mid', defaultValue: 0)
  final int mid;
  @JsonProperty(name: 'data/mobile_verified', defaultValue: 0)
  final int mobileVerified;
  @JsonProperty(name: 'data/money', defaultValue: 0.0)
  final num money;
  @JsonProperty(name: 'data/moral', defaultValue: 0)
  final int moral;
  @JsonProperty(name: 'data/official', defaultValue: {})
  final OfficialModel official;
  @JsonProperty(name: 'data/officialVerify', defaultValue: {})
  final OfficialVerifyModel officialVerify;
  @JsonProperty(name: 'data/pendant', defaultValue: {})
  final PendantModel pendant;
  @JsonProperty(name: 'data/scores', defaultValue: 0)
  final int scores;
  @JsonProperty(name: 'data/uname', defaultValue: '游客')
  final String userName;
  @JsonProperty(name: 'data/vipDueDate', defaultValue: 0)
  final int vipDueDate;
  @JsonProperty(name: 'data/vipStatus', defaultValue: 0)
  final int vipStatus;
  @JsonProperty(name: 'data/vipType', defaultValue: 0)
  final int vipType;
  @JsonProperty(name: 'data/vip_pay_type', defaultValue: 0)
  final int vipPayType;
  @JsonProperty(name: 'data/vip_theme_type', defaultValue: 0)
  final int vipThemeType;
  @JsonProperty(name: 'data/vip_label', defaultValue: {})
  final VipLabelModel vipLabel;
  @JsonProperty(name: 'data/vip_avatar_subscript', defaultValue: 0)
  final int vipAvatarSubscript;
  @JsonProperty(name: 'data/vip_nickname_color', defaultValue: '')
  final String vipNicknameColor;
  @JsonProperty(name: 'data/wallet', defaultValue: {})
  final WalletModel wallet;
  @JsonProperty(name: 'data/has_shop', defaultValue: false)
  final bool hasShop;
  @JsonProperty(name: 'data/shop_url', defaultValue: '')
  final String shopUrl;
  @JsonProperty(name: 'data/allowance_count', defaultValue: 0)
  final int allowanceCount;
  @JsonProperty(name: 'data/answer_status', defaultValue: 0)
  final int answerStatus;
}
