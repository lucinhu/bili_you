import 'package:bili_you/common/models/video_info/video_info.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
@Json(valueDecorators: RelatedVideoModel.valueDecorators)
class RelatedVideoModel {
  static Map<Type, ValueDecoratorFunction> valueDecorators() => {
        typeOf<List<Datum>>(): (value) => value.cast<Datum>(),
      };
  RelatedVideoModel({
    required this.code,
    required this.data,
    required this.message,
  });

  @JsonProperty(defaultValue: -1)
  final int code;
  @JsonProperty(defaultValue: [])
  final List<Datum> data;
  @JsonProperty(defaultValue: '')
  final String message;
}

@jsonSerializable
class Datum {
  Datum({
    required this.aid,
    required this.videos,
    required this.tid,
    required this.tname,
    required this.copyright,
    required this.pic,
    required this.title,
    required this.pubdate,
    required this.ctime,
    required this.desc,
    required this.state,
    required this.duration,
    required this.missionId,
    // required this.rights,
    required this.owner,
    required this.stat,
    required this.datumDynamic,
    required this.cid,
    required this.dimension,
    required this.seasonId,
    required this.shortLink,
    required this.shortLinkV2,
    required this.bvid,
    required this.seasonType,
    required this.isOgv,
    required this.ogvInfo,
    required this.rcmdReason,
    required this.firstFrame,
    required this.pubLocation,
    required this.upFromV2,
  });

  @JsonProperty(defaultValue: 0)
  final int aid;
  @JsonProperty(defaultValue: 0)
  final int videos;
  @JsonProperty(defaultValue: 0)
  final int tid;
  @JsonProperty(defaultValue: '')
  final String tname;
  @JsonProperty(defaultValue: 0)
  final int copyright;
  @JsonProperty(defaultValue: '')
  final String pic;
  @JsonProperty(defaultValue: '')
  final String title;
  @JsonProperty(defaultValue: 0)
  final int pubdate;
  @JsonProperty(defaultValue: 0)
  final int ctime;
  @JsonProperty(defaultValue: '')
  final String desc;
  @JsonProperty(defaultValue: 0)
  final int state;
  @JsonProperty(defaultValue: 0)
  final int duration;
  @JsonProperty(defaultValue: 0, name: 'mission_id')
  final int missionId;
  // @JsonProperty(defaultValue: {})
  // final Map<String, int> rights;
  @JsonProperty(defaultValue: {})
  final Owner owner;
  @JsonProperty(defaultValue: {})
  final VideoInfoStatModel stat;
  @JsonProperty(defaultValue: '', name: 'datum_dynamic')
  final String datumDynamic;
  @JsonProperty(defaultValue: 0)
  final int cid;
  @JsonProperty(defaultValue: {})
  final Dimension dimension;
  @JsonProperty(defaultValue: 0, name: 'season_id')
  final int seasonId;
  @JsonProperty(defaultValue: '', name: 'short_link')
  final String shortLink;
  @JsonProperty(defaultValue: '', name: 'short_link_v2')
  final String shortLinkV2;
  @JsonProperty(defaultValue: '')
  final String bvid;
  @JsonProperty(defaultValue: 0, name: 'season_type')
  final int seasonType;
  @JsonProperty(defaultValue: false, name: 'is_ogv')
  final bool isOgv;
  @JsonProperty(defaultValue: {}, name: 'ogv_info')
  final dynamic ogvInfo;
  @JsonProperty(defaultValue: '', name: 'rcmd_reason')
  final String rcmdReason;
  @JsonProperty(defaultValue: '', name: 'first_frame')
  final String firstFrame;
  @JsonProperty(defaultValue: '', name: 'pub_location')
  final String pubLocation;
  @JsonProperty(defaultValue: 0, name: 'up_from_v2')
  final int upFromV2;
}

@jsonSerializable
class Dimension {
  Dimension({
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
class Owner {
  Owner({
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
