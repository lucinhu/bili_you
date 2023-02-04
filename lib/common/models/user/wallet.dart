import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class WalletModel {
  WalletModel({
    this.mid = 0,
    this.bcoinBalance = 0,
    this.couponBalance = 0,
    this.couponDueTime = 0,
  });
  @JsonProperty(defaultValue: 0)
  final int mid;
  @JsonProperty(name: 'bcoin_balance', defaultValue: 0)
  final int bcoinBalance;
  @JsonProperty(name: 'coupon_balance', defaultValue: 0)
  final int couponBalance;
  @JsonProperty(name: 'coupon_due_time', defaultValue: 0)
  final int couponDueTime;
}
