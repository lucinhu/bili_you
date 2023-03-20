///Vip信息
class Vip {
  Vip({required this.isVip, required this.type});
  static Vip get zero => Vip(isVip: false, type: VipType.none);
  bool isVip;
  VipType type;
}

///Vip类型
enum VipType { none, month, year }

extension VipTypeCode on VipType {
  static VipType fromCode(int code) {
    return VipType.values[code];
  }

  int get code => [0, 1, 2][index];
}
