import 'dart:developer';
import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/utils/http_utils.dart';
import 'package:bili_you/pages/login/controller.dart';
import 'package:bili_you/pages/login/qrcode_login/view.dart';
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
    ..setUserAgent(
        'Mozilla/5.0 (iPhone13,3; U; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/15E148 Safari/602.1')
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(
        Uri.parse('${ApiConstants.passportBase}/h5-app/passport/login'));

  //从webview获取登录cookies
  Future<void> getCookies() async {
    try {
      var cookies =
          await WebviewCookieManager().getCookies(ApiConstants.bilibiliBase);
      for (var i in cookies) {
        log('name:${i.name}, value:${i.value}, dominate:${i.domain}');
      }
      await HttpUtils.cookieManager.cookieJar
          .saveFromResponse(Uri.parse(ApiConstants.bilibiliBase), cookies);
      cookies = await WebviewCookieManager().getCookies(ApiConstants.apiBase);
      for (var i in cookies) {
        log('name:${i.name}, value:${i.value}, dominate:${i.domain}');
      }
      await HttpUtils.cookieManager.cookieJar
          .saveFromResponse(Uri.parse(ApiConstants.apiBase), cookies);
      // MyDio.dio.interceptors.add(MyDio.cookieManager);
    } catch (e) {
      log('网页登录获取cookie错误:$e');
      Get.rawSnackbar(message: '网页登录获取cookie错误:$e');
    }
  }

  //根据保存的cookies检查是否成功登录,若成功就跳转到主页面
  Future<void> checkIfLoginSuccess() async {
    try {
      if ((await LoginApi.getLoginUserInfo()).isLogin) {
        await onLoginSuccess(await LoginApi.getLoginUserInfo(),
            await LoginApi.getLoginUserStat());
        isSuccess = true;
        Navigator.of(Get.context!).popUntil((route) => route.isFirst);
        Get.rawSnackbar(title: '网页登录成功!', message: '现自动跳转到主页');
      } else {
        isSuccess = false;
        Navigator.of(Get.context!).popUntil((route) => route.isFirst);
        Get.rawSnackbar(title: '网页登录', message: '失败!');
      }
    } catch (e) {
      log('未登录:$e');
      Get.rawSnackbar(title: '网页登录', message: '未登录:$e');
    }
  }

  @override
  void initState() {
    WebViewCookieManager().clearCookies();
    webViewController.setNavigationDelegate(NavigationDelegate(
      onUrlChange: (urlChange) async {
        var url = urlChange.url ?? "";
        if (!isSuccess &&
            (url.startsWith(
                    'https://passport.bilibili.com/web/sso/exchange_cookie') ||
                url.startsWith('https://m.bilibili.com/'))) {
          await getCookies();
          await checkIfLoginSuccess();
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
          title: const Text("网页登录"),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.of(context).push(GetPageRoute(
                    page: () => const QrcodeLogin(),
                  ));
                },
                child: const Text("二维码登录")),
            TextButton(
                onPressed: () async {
                  await getCookies();
                  await checkIfLoginSuccess();
                },
                child: const Text("手动检查登录状态"))
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
