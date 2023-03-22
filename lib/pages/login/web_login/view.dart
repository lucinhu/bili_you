import 'dart:developer';

import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/utils/index.dart';
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
  final WebViewController webViewController = WebViewController()
    // ..setUserAgent(ApiConstants.mobileUserAgent)
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(
        Uri.parse('${ApiConstants.passportBase}/h5-app/passport/login'));
  @override
  void initState() {
    WebViewCookieManager().clearCookies();
    webViewController.setNavigationDelegate(NavigationDelegate(
      onPageFinished: (url) async {
        log('sdas');
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
            MyDio.cookieManager.cookieJar.saveFromResponse(
                Uri.parse(ApiConstants.bilibiliBase), cookies);
            cookies =
                await WebviewCookieManager().getCookies(ApiConstants.apiBase);
            for (var i in cookies) {
              log('name:${i.name}, value:${i.value}, dominate:${i.domain}');
            }
            MyDio.cookieManager.cookieJar
                .saveFromResponse(Uri.parse(ApiConstants.apiBase), cookies);
            MyDio.dio.interceptors.add(MyDio.cookieManager);
          } catch (e) {
            log('网页登陆获取cookie错误:$e');
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
          }
        }
      },
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: WebViewWidget(controller: webViewController));
  }
}
