import 'dart:developer';

import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/utils/http_utils.dart';
import 'package:bili_you/common/widget/video_audio_player.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';

class BiliLivePageController extends GetxController {
  BiliLivePageController({required this.roomId});
  final int roomId;
  Future<void> init() async {
    await PlayersSingleton().dispose();
    await PlayersSingleton().init();
    PlayersSingleton().count++;
    await onRefresh();
  }

  Future<void> onRefresh() async {
    var response =
        await HttpUtils().get(ApiConstants.livePlayUrl, queryParameters: {
      'room_id': roomId,
      'protocol': '0, 1',
      'format': '0, 1, 2',
      'codec': '0, 1',
      'qn': 250,
      'platform': 'web',
      'ptype': 8,
      'dolby': 5,
      'panorama': 1
    });
    log(response.data['code'].toString());
    log(response.data['message']);
    String baseUrl = response.data['data']['playurl_info']['playurl']['stream']
        [0]['format'][0]['codec'][0]['base_url'];
    String host = response.data['data']['playurl_info']['playurl']['stream'][0]
        ['format'][0]['codec'][0]['url_info'][0]['host'];
    String extra = response.data['data']['playurl_info']['playurl']['stream'][0]
        ['format'][0]['codec'][0]['url_info'][0]['extra'];

    await PlayersSingleton().player!.open(
          Media(host + baseUrl + extra,
              httpHeaders: {'referer': 'https://live.bilibili.com'}),
        );
    await PlayersSingleton().player!.play();
  }

  @override
  void onClose() {
    PlayersSingleton().dispose();
    super.onClose();
  }
}
