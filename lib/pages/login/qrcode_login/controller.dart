import 'dart:async';
import 'dart:developer';

import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/models/local/login/login_qrcode_info.dart';
import 'package:bili_you/common/models/local/login/login_qrcode_stat.dart';
import 'package:bili_you/pages/login/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QRcodeLoginController extends GetxController {
  late LoginQrcodeStat stat;
  late LoginQRcodeInfo info;
  Timer? timer;

  Future<void> getQRcodeInfo() async {
    timer?.cancel();
    timer = null;
    info = await LoginApi.getQRcode();

    ///每秒钟检查是否扫码登录成功
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      log('a');
      stat = await LoginApi.checkQRcodeLogin(qrcodeKey: info.qrcodeKey);
      if (stat == LoginQrcodeStat.loginSuccess) {
        //成功时
        await onLoginSuccess(await LoginApi.getLoginUserInfo(),
            await LoginApi.getLoginUserStat());
        Navigator.of(Get.context!).popUntil((route) => route.isFirst);
        await Get.rawSnackbar(message: "登录成功！").show();
      } else if (stat == LoginQrcodeStat.qrcodeInvalid) {
        //二维码失效时,弹出提示
        await Get.rawSnackbar(message: "二维码失效!请点击二维码进行刷新!").show();
      }
    });
  }

  ///手动检查登录状态
  Future<void> checkQRcodeLoginStat() async {
    stat = await LoginApi.checkQRcodeLogin(qrcodeKey: info.qrcodeKey);
    if (stat == LoginQrcodeStat.loginSuccess) {
      await onLoginSuccess(
          await LoginApi.getLoginUserInfo(), await LoginApi.getLoginUserStat());
      Navigator.of(Get.context!).popUntil((route) => route.isFirst);
      await Get.rawSnackbar(message: "登录成功！").show();
    } else {
      await Get.rawSnackbar(message: stat.message).show();
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    timer = null;
  }
}
