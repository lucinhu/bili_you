import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/network/user_relations/user_realtion.dart';
import 'package:bili_you/common/utils/http_utils.dart';

class FollowingApi {
  static Future<FollowingResponse> _requestFollowingList(
      int? vmid, String? order_type, int? pn, int? ps) async {
    var response = await HttpUtils().get(
      ApiConstants.followingUsers,
      queryParameters: {
        "vmid": vmid,
        "order_type": order_type,
        "pn": pn,
        "ps": ps
      },
    );
    return FollowingResponse.fromJson(response.data);
  }

  static Future<List<UserRelation>> getFollowingList(
      {required int? vmid,
      String? order_type,
      required int pn,
      required int ps}) async {
    var response = await _requestFollowingList(vmid, order_type, pn, ps);
    if (response.code != 0) {
      throw "getFollowingList: code:${response.code}, message:${response.message}";
    }
    List<UserRelation> relations = [];
    for (var rel in response.data["list"]) {
      relations.add(UserRelation.fromJson(rel));
    }
    return relations;
  }
}
