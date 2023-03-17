///官方认证信息
class OfficialVerify {
  OfficialVerify({required this.type, required this.description});
  static OfficialVerify get zero =>
      OfficialVerify(type: OfficialVerifyType.none, description: "");
  OfficialVerifyType type;
  String description;
}

///官方认证类型
enum OfficialVerifyType {
  none,

  person,

  organization
}

extension OfficialVerifyTypeCode on OfficialVerifyType {
  static OfficialVerifyType fromCode(int code) {
    switch (code) {
      case -1:
        return OfficialVerifyType.none;
      case 0:
        return OfficialVerifyType.person;
      case 1:
        return OfficialVerifyType.organization;
      default:
        return OfficialVerifyType.none;
    }
  }

  get code => [-1, 0, 1][index];
}
