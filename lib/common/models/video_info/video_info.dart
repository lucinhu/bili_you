import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
@Json(valueDecorators: VideoInfoModel.valueDecorators)
class VideoInfoModel {
  static Map<Type, ValueDecoratorFunction> valueDecorators() => {
        typeOf<List<VideoInfoDescV2Model>>(): (value) =>
            value.cast<VideoInfoDescV2Model>(),
        typeOf<List<VideoPartModel>>(): (value) => value.cast<VideoPartModel>(),
      };
  VideoInfoModel({
    required this.code,
    required this.message,
    required this.bvid,
    // required this.aid,
    required this.videos,
    required this.tid,
    required this.tname,
    required this.copyright,
    required this.pic,
    required this.title,
    required this.pubdate,
    required this.ctime,
    required this.desc,
    required this.descV2,
    required this.state,
    required this.duration,
    required this.rights,
    required this.owner,
    required this.stat,
    required this.dataDynamic,
    required this.cid,
    required this.dimension,
    required this.premiere,
    required this.teenageMode,
    required this.isChargeableSeason,
    required this.isStory,
    required this.noCache,
    required this.pages,
    required this.subtitle,
    required this.isSeasonDisplay,
    required this.userGarb,
    required this.honorReply,
    // required this.likeIcon,
  });

  @JsonProperty(defaultValue: -1)
  final int code;
  @JsonProperty(defaultValue: "未知错误")
  final String message;
  @JsonProperty(name: 'data/bvid', defaultValue: '')
  final String bvid;
  // @JsonProperty(name: "data/aid", defaultValue: 0)
  // final int aid;
  @JsonProperty(name: "data/videos", defaultValue: 0)
  final int videos;
  @JsonProperty(name: "data/tid", defaultValue: 0)
  final int tid;
  @JsonProperty(name: "data/tname", defaultValue: '')
  final String tname;
  @JsonProperty(name: "data/copyright", defaultValue: 0)
  final int copyright;
  @JsonProperty(name: "data/pic", defaultValue: '')
  final String pic;
  @JsonProperty(name: "data/title", defaultValue: '')
  final String title;
  @JsonProperty(name: "data/pubdate", defaultValue: 0)
  final int pubdate;
  @JsonProperty(name: "data/ctime", defaultValue: 0)
  final int ctime;
  @JsonProperty(name: "data/desc", defaultValue: '')
  final String desc;
  @JsonProperty(name: "data/desc_v2", defaultValue: [])
  final List<VideoInfoDescV2Model> descV2;
  @JsonProperty(name: "data/state", defaultValue: 0)
  final int state;
  @JsonProperty(name: "data/duration", defaultValue: 0)
  final int duration;
  @JsonProperty(name: "data/rights", defaultValue: {})
  final VideoInfoRightsModel rights;
  @JsonProperty(name: "data/owner", defaultValue: {})
  final VideoInfoOwnerModel owner;
  @JsonProperty(name: "data/stat", defaultValue: {})
  final VideoInfoStatModel stat;
  @JsonProperty(name: "data/data_dynamic", defaultValue: '')
  final String dataDynamic;
  @JsonProperty(name: "data/cid", defaultValue: 0)
  final int cid;
  @JsonProperty(name: "data/dimension", defaultValue: {})
  final VideoInfoDimensionModel dimension;
  @JsonProperty(name: "data/premiere", defaultValue: {})
  final dynamic premiere;
  @JsonProperty(name: "data/teenage_mode", defaultValue: 0)
  final int teenageMode;
  @JsonProperty(name: "data/is_chargeable_season", defaultValue: false)
  final bool isChargeableSeason;
  @JsonProperty(name: "data/is_story", defaultValue: false)
  final bool isStory;
  @JsonProperty(name: "data/no_cache", defaultValue: false)
  final bool noCache;
  @JsonProperty(name: "data/pages", defaultValue: [])
  final List<VideoPartModel> pages;
  @JsonProperty(name: "data/subtitle", defaultValue: {})
  final VideoInfoSubtitleModel subtitle;
  @JsonProperty(name: "data/is_season_display", defaultValue: false)
  final bool isSeasonDisplay;
  @JsonProperty(name: "data/user_garb", defaultValue: {})
  final VideoInfoUserGarbModel userGarb;
  @JsonProperty(name: "data/honor_reply", defaultValue: {})
  final VideoInfoHonorReplyModel honorReply;
  // @JsonProperty(name: "data/like_icon", defaultValue: '')
  // final String likeIcon;
}

@jsonSerializable
class VideoInfoRightsModel {
  @JsonProperty(defaultValue: 0)
  final int bp;
  @JsonProperty(defaultValue: 0)
  final int elec;
  @JsonProperty(defaultValue: 0)
  final int download;
  @JsonProperty(defaultValue: 0)
  final int movie;
  @JsonProperty(defaultValue: 0)
  final int pay;
  @JsonProperty(defaultValue: 0)
  final int hd5;
  @JsonProperty(name: 'no_reprint', defaultValue: 0)
  final int noReprint;
  @JsonProperty(defaultValue: 0)
  final int autoplay;
  @JsonProperty(name: 'ugc_pay', defaultValue: 0)
  final int ugcPay;
  @JsonProperty(name: 'is_cooperation', defaultValue: 0)
  final int isCooperation;
  @JsonProperty(name: 'ugc_pay_preview', defaultValue: 0)
  final int ugcPayPreview;
  @JsonProperty(name: 'no_background', defaultValue: 0)
  final int noBackground;
  @JsonProperty(name: 'clean_mode', defaultValue: 0)
  final int cleanMode;
  @JsonProperty(name: 'is_stein_gate', defaultValue: 0)
  final int isSteinGate;
  @JsonProperty(name: 'is_360', defaultValue: 0)
  final int is_360;
  @JsonProperty(name: 'no_share', defaultValue: 0)
  final int noShare;
  @JsonProperty(name: 'arc_pay', defaultValue: 0)
  final int arcPay;
  @JsonProperty(name: 'free_watch', defaultValue: 0)
  final int freeWatch;

  VideoInfoRightsModel(
      {required this.bp,
      required this.elec,
      required this.download,
      required this.movie,
      required this.pay,
      required this.hd5,
      required this.noReprint,
      required this.autoplay,
      required this.ugcPay,
      required this.isCooperation,
      required this.ugcPayPreview,
      required this.noBackground,
      required this.cleanMode,
      required this.isSteinGate,
      required this.is_360,
      required this.noShare,
      required this.arcPay,
      required this.freeWatch});
}

@jsonSerializable
class VideoInfoDescV2Model {
  VideoInfoDescV2Model({
    required this.rawText,
    required this.type,
    required this.bizId,
  });
  @JsonProperty(name: 'raw_text', defaultValue: '')
  final String rawText;
  @JsonProperty(defaultValue: 0)
  final int type;
  @JsonProperty(defaultValue: 0)
  final int bizId;
}

@jsonSerializable
class VideoInfoDimensionModel {
  VideoInfoDimensionModel({
    required this.width,
    required this.height,
    required this.rotate,
  });
  @JsonProperty(defaultValue: 0)
  final int width;
  @JsonProperty(defaultValue: 0)
  final int height;
  @JsonProperty(defaultValue: 0)
  final int rotate;
}

@jsonSerializable
@Json(valueDecorators: VideoInfoHonorReplyModel.valueDecorators)
class VideoInfoHonorReplyModel {
  static Map<Type, ValueDecoratorFunction> valueDecorators() => {
        typeOf<List<VideoInfoHonorModel>>(): (value) =>
            value.cast<VideoInfoHonorModel>(),
      };
  VideoInfoHonorReplyModel({
    required this.honor,
  });
  @JsonProperty(defaultValue: [])
  final List<VideoInfoHonorModel> honor;
}

@jsonSerializable
class VideoInfoHonorModel {
  VideoInfoHonorModel({
    required this.aid,
    required this.type,
    required this.desc,
    required this.weeklyRecommendNum,
  });
  @JsonProperty(defaultValue: 0)
  final int aid;
  @JsonProperty(defaultValue: 0)
  final int type;
  @JsonProperty(defaultValue: '')
  final String desc;
  @JsonProperty(name: 'weekly_recommend_num', defaultValue: 0)
  final int weeklyRecommendNum;
}

@jsonSerializable
class VideoInfoOwnerModel {
  VideoInfoOwnerModel({
    required this.mid,
    required this.name,
    required this.face,
  });
  @JsonProperty(defaultValue: 0)
  final int mid;
  @JsonProperty(defaultValue: '')
  final String name;
  @JsonProperty(defaultValue: '')
  final String face;
}

@jsonSerializable
class VideoPartModel {
  VideoPartModel({
    required this.cid,
    required this.page,
    // required this.from,
    required this.part,
    required this.duration,
    required this.vid,
    required this.weblink,
    required this.dimension,
  });
  @JsonProperty(defaultValue: 0)
  final int cid;
  @JsonProperty(defaultValue: 0)
  final int page;
  // @JsonProperty(defaultValue: {})
  // final VideoInfoFromModel from;
  @JsonProperty(defaultValue: '')
  final String part;
  @JsonProperty(defaultValue: 0)
  final int duration;
  @JsonProperty(defaultValue: '')
  final String vid;
  @JsonProperty(defaultValue: '')
  final String weblink;
  @JsonProperty(defaultValue: {})
  final VideoInfoDimensionModel dimension;
}

// @jsonSerializable
// enum VideoInfoFromModel { vupLoad }

@jsonSerializable
class VideoInfoStatModel {
  VideoInfoStatModel({
    required this.aid,
    required this.view,
    required this.danmaku,
    required this.reply,
    required this.favorite,
    required this.coin,
    required this.share,
    required this.nowRank,
    required this.hisRank,
    required this.like,
    required this.dislike,
    required this.evaluation,
    required this.argueMsg,
  });

  @JsonProperty(defaultValue: 0)
  final int aid;
  @JsonProperty(defaultValue: 0)
  final int view;
  @JsonProperty(defaultValue: 0)
  final int danmaku;
  @JsonProperty(defaultValue: 0)
  final int reply;
  @JsonProperty(defaultValue: 0)
  final int favorite;
  @JsonProperty(defaultValue: 0)
  final int coin;
  @JsonProperty(defaultValue: 0)
  final int share;
  @JsonProperty(name: 'now_rank', defaultValue: 0)
  final int nowRank;
  @JsonProperty(name: 'his_rank', defaultValue: 0)
  final int hisRank;
  @JsonProperty(defaultValue: 0)
  final int like;
  @JsonProperty(defaultValue: 0)
  final int dislike;
  @JsonProperty(defaultValue: '')
  final String evaluation;
  @JsonProperty(name: 'argue_msg', defaultValue: '')
  final String argueMsg;
}

@jsonSerializable
class VideoInfoSubtitleModel {
  VideoInfoSubtitleModel({
    required this.allowSubmit,
    required this.list,
  });
  @JsonProperty(name: 'allow_submit', defaultValue: false)
  final bool allowSubmit;
  @JsonProperty(defaultValue: [])
  final List<dynamic> list;
}

@jsonSerializable
class VideoInfoUserGarbModel {
  VideoInfoUserGarbModel({
    required this.urlImageAniCut,
  });
  @JsonProperty(name: 'url_image_ani_cut', defaultValue: '')
  final String urlImageAniCut;
}
