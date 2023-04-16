import 'dart:developer';
import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/utils/http_utils.dart';
import 'package:bili_you/pages/login/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebLoginPage extends StatefulWidget {
  const WebLoginPage({super.key});

  @override
  State<WebLoginPage> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends State<WebLoginPage> {
  bool isSuccess = false;
  GlobalKey progressBarKey = GlobalKey();
  double progressBarValue = 0;
  final WebViewController webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(
        Uri.parse('${ApiConstants.passportBase}/h5-app/passport/login'));
  @override
  void initState() {
    WebViewCookieManager().clearCookies();
    webViewController.setNavigationDelegate(NavigationDelegate(
      onPageFinished: (url) async {
        if (!isSuccess &&
            (url.startsWith(
                    'https://passport.bilibili.com/web/sso/exchange_cookie') ||
                url.startsWith('https://m.bilibili.com/'))) {
          try {
            var cookies = await WebviewCookieManager()
                .getCookies(ApiConstants.bilibiliBase);
            for (var i in cookies) {
              log('name:${i.name}, value:${i.value}, dominate:${i.domain}');
            }
            await HttpUtils.cookieManager.cookieJar.saveFromResponse(
                Uri.parse(ApiConstants.bilibiliBase), cookies);
            cookies =
                await WebviewCookieManager().getCookies(ApiConstants.apiBase);
            for (var i in cookies) {
              log('name:${i.name}, value:${i.value}, dominate:${i.domain}');
            }
            await HttpUtils.cookieManager.cookieJar
                .saveFromResponse(Uri.parse(ApiConstants.apiBase), cookies);
            // MyDio.dio.interceptors.add(MyDio.cookieManager);
          } catch (e) {
            log('网页登陆获取cookie错误:$e');
            Get.rawSnackbar(message: '网页登陆获取cookie错误:$e');
          }
          try {
            if ((await LoginApi.getLoginUserInfo()).isLogin) {
              await onLoginSuccess(await LoginApi.getLoginUserInfo(),
                  await LoginApi.getLoginUserStat());
              isSuccess = true;
              Navigator.of(Get.context!).popUntil((route) => route.isFirst);
              Get.rawSnackbar(title: '网页登陆成功!', message: '现自动跳转到主页');
            } else {
              isSuccess = false;
              Navigator.of(Get.context!).popUntil((route) => route.isFirst);
              Get.rawSnackbar(title: '网页登陆', message: '失败!');
            }
          } catch (e) {
            log('未登陆:$e');
            Get.rawSnackbar(title: '网页登陆', message: '未登陆:$e');
          }
        }
      },
      onProgress: (progress) {
        progressBarKey.currentState?.setState(() {
          progressBarValue = progress / 100.toDouble();
        });
      },
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("网页登陆"),
          actions: [
            TextButton(
                onPressed: () async {
                  try {
                    if ((await LoginApi.getLoginUserInfo()).isLogin) {
                      Get.rawSnackbar(title: '网页登陆', message: '已登陆');
                      await onLoginSuccess(await LoginApi.getLoginUserInfo(),
                          await LoginApi.getLoginUserStat());
                    } else {
                      Get.rawSnackbar(title: '网页登陆', message: '未登陆');
                    }
                  } catch (e) {
                    Get.rawSnackbar(message: '错误:$e');
                    Get.dialog(AlertDialog(
                      title: const Text('错误信息'),
                      content: Text('$e'),
                      scrollable: true,
                    ));
                  }
                },
                child: const Text("手动检查登陆状态"))
          ],
        ),
        body: Column(children: [
          StatefulBuilder(
              key: progressBarKey,
              builder: (context, setState) {
                return Visibility(
                  visible: progressBarValue < 1,
                  child: LinearProgressIndicator(
                    key: ValueKey(progressBarValue),
                    value: progressBarValue,
                  ),
                );
              }),
          Expanded(
            child: WebViewWidget(controller: webViewController),
          )
        ]));
  }
}
