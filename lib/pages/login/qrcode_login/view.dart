import 'package:bili_you/pages/login/qrcode_login/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrcodeLogin extends StatefulWidget {
  const QrcodeLogin({super.key});

  @override
  State<QrcodeLogin> createState() => _QrcodeLoginState();
}

class _QrcodeLoginState extends State<QrcodeLogin> {
  late final QRcodeLoginController controller;
  @override
  void initState() {
    controller = Get.put(QRcodeLoginController());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('二维码登录'),
        actions: [
          TextButton(
              onPressed: () async {
                await controller.checkQRcodeLoginStat();
              },
              child: const Text("手动检查登录状态")),
        ],
      ),
      body: FutureBuilder(
        future: controller.getQRcodeInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              child: QrImageView(
                data: controller.info.url,
                backgroundColor: Colors.white,
              ),
              onTap: () {
                setState(() {});
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
