import 'package:bili_you/common/models/local/bangumi/episode_info.dart';

class BangumiInfo {
  BangumiInfo(
      {required this.title, required this.ssid, required this.episodes});
  static BangumiInfo get zero => BangumiInfo(title: "", ssid: 0, episodes: []);
  String title;
  int ssid;
  List<EpisodeInfo> episodes;
}
