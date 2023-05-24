import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/utils/http_utils.dart';
import 'package:bili_you/common/utils/index.dart';
import 'package:crypto/crypto.dart';

///get请求参数拼接w_rid和wts字段
///
///用在”用户投稿视频“、”用户投稿专栏“、”首页推送“、”推广信息“、”热搜“、”视频信息“、”视频取流“、”搜索“等接口
class WbiSign {
  static const _mixinKeyEncTab = [
    46,
    47,
    18,
    2,
    53,
    8,
    23,
    32,
    15,
    50,
    10,
    31,
    58,
    3,
    45,
    35,
    27,
    43,
    5,
    49,
    33,
    9,
    42,
    19,
    29,
    28,
    14,
    39,
    12,
    38,
    41,
    13,
    37,
    48,
    7,
    16,
    24,
    55,
    40,
    61,
    26,
    17,
    0,
    1,
    60,
    51,
    30,
    4,
    22,
    25,
    54,
    21,
    56,
    59,
    6,
    63,
    57,
    62,
    11,
    36,
    20,
    34,
    44,
    52
  ];

  //获取最新的wbikeys(即img_key和sub_key的拼接)
  static Future<String> _getWbiKeys() async {
    var response = await HttpUtils().get(ApiConstants.userInfo);
    String imgUrl = response.data['data']['wbi_img']['img_url'];
    String subUrl = response.data['data']['wbi_img']['sub_url'];
    String imgKey = imgUrl
        .substring(imgUrl.lastIndexOf('/') + 1, imgUrl.length)
        .split('.')[0];
    String subKey = subUrl
        .substring(subUrl.lastIndexOf('/') + 1, subUrl.length)
        .split('.')[0];
    return imgKey + subKey;
  }

  ///为请求参数进行wbi签名
  static Future<Map<String, dynamic>> encodeParams(
      Map<String, dynamic> params) async {
    String wbiKeys;
    var nowDate = DateTime.now();
    //获取最新的wbikeys
    {
      var localWbiKeys =
          BiliYouStorage.user.get('wbiKeys', defaultValue: []) as List;
      if (localWbiKeys.isNotEmpty &&
          DateTime.fromMillisecondsSinceEpoch(localWbiKeys[1] as int).day ==
              nowDate.day) {
        //如果存在本地的wbikeys且没有过期就使用本地的wbiKeys
        wbiKeys = localWbiKeys[0] as String;
      } else {
        //否则获取最新的wbikeys
        wbiKeys = await _getWbiKeys();
        await BiliYouStorage.user
            .put('wbiKeys', [wbiKeys, nowDate.millisecondsSinceEpoch]);
      }
    }
    //打乱重排
    String mixinKeys = "";
    for (var element in _mixinKeyEncTab) {
      mixinKeys += wbiKeys[element];
    }
    //取前32个字符
    mixinKeys = mixinKeys.substring(0, 32);
    //将params拼接后转为字符串
    String query = StringFormatUtils.mapToQueryStringSorted(params);
    //wts为当前时间戳
    int wts = nowDate.millisecondsSinceEpoch;
    query += '&wts=$wts$mixinKeys';
    String wRid = md5.convert(query.codeUnits).toString();
    return params..addAll({'wts': wts.toString(), 'w_rid': wRid});
  }
}
