///Vip信息
class Vip {
  Vip({required this.isVip, required this.type});
  static Vip get zero => Vip(isVip: false, type: VipType.none);
  bool isVip;
  VipType type;
}

///Vip类型
enum VipType { none, month, year }
