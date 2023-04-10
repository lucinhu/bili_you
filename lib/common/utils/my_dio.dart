import 'dart:developer';

import 'package:bili_you/common/api/api_constants.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

abstract class MyDio {
  static Dio dio = Dio();
  static Dio dioNoCookie = Dio();
  static late CookieManager cookieManager;

  static init() async {
    if (kIsWeb) {
      cookieManager = CookieManager(CookieJar());
    } else {
      //设置cookie存放的位置，保存cookie
      var cookiePath =
          "${(await getApplicationSupportDirectory()).path}/.cookies/";
      cookieManager =
          CookieManager(PersistCookieJar(storage: FileStorage(cookiePath)));
    }
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.interceptors.add(cookieManager);
    dio.options.headers = {'user-agent': ApiConstants.userAgent};
    dio.transformer = BackgroundTransformer();
    dio.options.contentType = Headers.jsonContentType;
    if ((await cookieManager.cookieJar
            .loadForRequest(Uri.parse(ApiConstants.bilibiliBase)))
        .isEmpty) {
      try {
        await dio.get(ApiConstants.bilibiliBase); //获取默认cookie
      } catch (e) {
        log("utils/my_dio, ${e.toString()}");
      }
    }
  }
}
