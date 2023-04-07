import 'dart:developer';
import 'dart:io';

import 'package:bili_you/common/api/api_constants.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';
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
    if (Platform.isIOS || Platform.isMacOS || Platform.isAndroid) {
      dio.httpClientAdapter = NativeAdapter();
    }
    dio.interceptors.add(cookieManager);
    dio.options.headers = {'user-agent': ApiConstants.userAgent};
    dio.transformer = BackgroundTransformer();
    dio.options.contentType = Headers.jsonContentType;
    try {
      await dio.get(ApiConstants.bilibiliBase); //获取默认cookie
    } catch (e) {
      log("utils/my_dio, ${e.toString()}");
    }
  }
}
