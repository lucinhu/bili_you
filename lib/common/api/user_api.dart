import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/user/user_info.dart';
import 'package:bili_you/common/models/user/user_stat.dart';
import 'package:bili_you/common/utils/my_dio.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';

class UserApi {
  static Future<UserInfoModel> requestUserInfo() async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.userInfo);
    return JsonMapper.deserialize<UserInfoModel>(response.data)!;
  }

  static Future<UserStatModel> requestUserStat() async {
    var dio = MyDio.dio;
    var response = await dio.get(ApiConstants.userStat);
    return JsonMapper.deserialize<UserStatModel>(response.data)!;
  }
}
