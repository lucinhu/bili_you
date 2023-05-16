enum LoginQrcodeStat {
  ///登录成功
  loginSuccess,

  ///未扫码
  hasNotScan,

  ///扫码了但没确认
  hasNotAccept,

  ///二维码失效
  qrcodeInvalid,

  ///其他状态
  other,
}

extension LoginQrcodeStatExtension on LoginQrcodeStat {
  static const map = {
    0: '登录成功',
    86101: '未扫码',
    86090: '已扫码但未确认',
    86038: "二维码已失效",
    -1: "登录失败"
  };
  int get code => map.keys.toList()[index];
  String get message => map.values.toList()[index];
  static LoginQrcodeStat fromCode(int code) {
    var index = map.keys.toList().indexOf(code);
    if (index == -1) {
      //找不到对应的就返回 其他状态
      return LoginQrcodeStat.other;
    } else {
      return LoginQrcodeStat.values[index];
    }
  }
}
