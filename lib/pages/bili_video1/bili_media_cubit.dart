import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/utils/index.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'bili_media_content.dart';

class BiliMedia {
  String bvid;
  int cid;
  int? ssid;
  int? epid;
  bool isBangumi;
  int? progress;
  String? cover;

  BiliMedia(
      {required this.bvid,
      required this.cid,
      this.ssid,
      this.epid,
      this.isBangumi = false,
      this.progress,
      this.cover});
}

class BiliMediaCubit extends Cubit<BiliMedia> {
  BiliMediaCubit(super.initialState);
  Future<BiliMediaContent> getVideoPlayInfo() async {
    var videoPlayInfo =
        await VideoPlayApi.getVideoPlay(bvid: state.bvid, cid: state.cid);
    //找出最符合设置的清晰度/解码格式
    var seletedVideoQuality = SettingsUtil.getPreferVideoQuality();
    var seletedAudioQuality = SettingsUtil.getPreferAudioQuality();
    var seletedVideoCodec = SettingsUtil.getPreferVideoCodec();
    for (var i in videoPlayInfo.videos) {}
    return videoPlayInfo as BiliMediaContent;
  }
}
