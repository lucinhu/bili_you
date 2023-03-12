import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/network/user/user_info.dart';
import 'package:bili_you/common/models/network/user/user_stat.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:dio/dio.dart';

class UserApi {
  static Future<UserInfoResponse> requestUserInfo() async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.userInfo,
        options: Options(responseType: ResponseType.plain));
    return UserInfoResponse.fromRawJson(response.data);
  }

  static Future<UserStatResponse> requestUserStat() async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.userStat);
    return UserStatResponse.fromJson(response.data);
  }
}
