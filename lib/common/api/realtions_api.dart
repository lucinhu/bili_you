import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/models/network/user_relations/user_realtion.dart';
import 'package:bili_you/common/utils/http_utils.dart';

class RelationApi {
  static Future<List<UserRelation>> getFollowingList(
      {required int? vmid,
      String? order_type,
      required int pn,
      required int ps}) async {
    return await _request(apiurl: ApiConstants.followings, vmid: vmid, pn: pn, ps: ps);
  }

  static Future<List<UserRelation>> getFollowersList(
      {required int? vmid,
      String? order_type,
      required int pn,
      required int ps}) async {
    return await _request(apiurl: ApiConstants.followers,order_type: order_type, vmid: vmid, pn: pn, ps: ps);
  }

  static Future<List<UserRelation>> _request(
      {required String apiurl,
      required int? vmid,
      String? order_type,
      required int pn,
      required int ps}) async {
    var _response = await HttpUtils().get(
      apiurl,
      queryParameters: {
        "vmid": vmid,
        "order_type": order_type,
        "pn": pn,
        "ps": ps
      },
    );
    var response = _response.data;

    if (response["code"] != 0) {
      throw "getRelationList: code:${response["code"]}, message:${response["message"]}";
    }

    List<UserRelation> relations = [];
    for (var rel in response["data"]["list"]) {
      relations.add(UserRelation.fromJson(rel));
    }
    return relations;
  }
}
