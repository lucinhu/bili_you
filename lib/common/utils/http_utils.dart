import 'dart:developer';

import 'package:bili_you/common/api/index.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:path_provider/path_provider.dart';

class HttpUtils {
  static final HttpUtils _instance = HttpUtils._internal();
  factory HttpUtils() => _instance;
  static late final Dio dio;
  static late final CookieManager cookieManager;
  CancelToken _cancelToken = CancelToken();

  ///初始化构造
  HttpUtils._internal() {
    BaseOptions options = BaseOptions(
      headers: {
        'keep-alive': true,
        'user-agent': ApiConstants.userAgent,
        'Accept-Encoding': 'gzip'
      },
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      contentType: Headers.jsonContentType,
      persistentConnection: true,
    );
    dio = Dio(options);
    dio.transformer = BackgroundTransformer();

    // 添加error拦截器
    dio.interceptors.add(ErrorInterceptor());
  }

  ///初始化设置
  Future<void> init() async {
    if (kIsWeb) {
      cookieManager = CookieManager(CookieJar());
    } else {
      //设置cookie存放的位置，保存cookie
      var cookiePath =
          "${(await getApplicationSupportDirectory()).path}/.cookies/";
      cookieManager =
          CookieManager(PersistCookieJar(storage: FileStorage(cookiePath)));
    }
    dio.interceptors.add(cookieManager);
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

  // 关闭dio
  void cancelRequests({required CancelToken token}) {
    _cancelToken.cancel("cancelled");
    _cancelToken = token;
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response;
  }

  Future post(
    String path, {
    Map<String, dynamic>? queryParameters,
    data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
    );
    return response;
  }
}

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  // 是否有网
  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    switch (err.type) {
      // case DioErrorType.badCertificate:
      //   Get.rawSnackbar(message: 'bad certificate');
      //   break;
      // case DioErrorType.badResponse:
      //   Get.rawSnackbar(message: 'bad response');
      //   break;
      // case DioErrorType.cancel:
      //   Get.rawSnackbar(message: 'canceled');
      //   break;
      // case DioErrorType.connectionError:
      //   Get.rawSnackbar(message: 'connection error');
      //   break;
      // case DioErrorType.connectionTimeout:
      //   Get.rawSnackbar(message: 'connection timeout');
      //   break;
      // case DioErrorType.receiveTimeout:
      //   Get.rawSnackbar(message: 'receive timeout');
      //   break;
      // case DioErrorType.sendTimeout:
      //   Get.rawSnackbar(message: 'send timeout');
      //   break;
      case DioExceptionType.unknown:
        if (!await isConnected()) {
          //网络未连接
          Get.rawSnackbar(title: '网络未连接 ', message: '请检查网络状态');
          handler.reject(err);
        }
        // else {
        //   Get.rawSnackbar(message: '未知网络错误');
        // }
        break;
      default:
    }

    return super.onError(err, handler);
  }
}
