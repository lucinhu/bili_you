import 'package:bili_you/common/models/local/reply/reply_content.dart';
import 'package:bili_you/common/models/local/reply/reply_member.dart';

class ReplyItem {
  ReplyItem(
      {required this.rpid,
      required this.oid,
      required this.type,
      required this.member,
      required this.rootRpid,
      required this.parentRpid,
      required this.dialogRpid,
      required this.replyCount,
      required this.replyTime,
      required this.preReplies,
      required this.likeCount,
      required this.hasLike,
      required this.location,
      required this.content,
      required this.tags});

  static ReplyItem get zero => ReplyItem(
      rpid: 0,
      oid: 0,
      type: ReplyType.unkown,
      member: ReplyMember.zero,
      rootRpid: 0,
      parentRpid: 0,
      dialogRpid: 0,
      replyCount: 0,
      replyTime: 0,
      preReplies: [],
      likeCount: 0,
      hasLike: false,
      location: "",
      content: ReplyContent.zero,
      tags: []);

  ///评论id
  int rpid;

  ///评论区对象id，具体含义看评论区类型代码
  int oid;

  ///评论区类型代码
  ReplyType type;

  ///发送者
  ReplyMember member;

  ///根评论 rpid
  ///
  ///若为一级评论则为 0
  /// 大于一级评论则为根评论 id
  int rootRpid;

  ///回复父评论 rpid
  ///
  ///若为一级评论则为0
  /// 若为二级评论则为根评论rpid
  /// 大于二级评论为上一级评论rpid
  int parentRpid;

  ///回复对方 rpid
  ///
  ///若为一级评论则为0
  ///若为二级评论则为该评论rpid
  ///大于二级评论为上一级评论rpid
  int dialogRpid;

  ///回复条数
  int replyCount;

  ///评论发送时间(时间戳)
  int replyTime;

  ///赞数
  int likeCount;

  ///是否已点赞
  bool hasLike;

  ///评论内容
  ReplyContent content;

  ///显示在外的评论回复
  List<ReplyItem> preReplies;

  ///标签文本如up主觉得很赞
  List<String> tags;

  ///ip属地
  String location;
}

enum ReplyType {
  unkown,

  ///视频稿件,oid代表avid
  video,

  ///话题,oid代表话题id
  topic,

  ///活动,oid代表活动id
  activity,

  ///小视频,oid代表小视频id
  littleVideo,

  ///小黑屋封禁信息,oid代表封禁公示id
  blackHouseInfo,

  ///公告信息,oid代表公告id
  announcement,

  ///直播活动,oid代表直播间id
  liveActivity,

  ///活动稿件,oid代表
  activityManuscript,

  ///直播公告,oid代表
  liveAnnoucement,

  ///相簿（图片动态）,oid代表相簿id
  gallery,

  ///专栏,oid代表专栏cvid
  column,

  ///票务,oid代表
  ticket,

  ///音频,oid代表音频auid
  audio,

  ///风纪委员会,oid代表众裁项目id
  disciplineCommission,

  ///点评,oid代表
  comment,

  ///动态（纯文字动态&分享）,oid代表动态id
  trend,

  ///播单,oid代表
  playList,

  ///音乐播单,oid代表
  musicPlayList,

  ///漫画1,oid代表
  comic1,

  ///漫画2,oid代表
  comic2,

  ///漫画3,oid代表漫画mcid
  comic3,

  ///课程,oid代表课程epid
  lesson
}

extension ReplyTypeCode on ReplyType {
  static final List<int> _codeList = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    33
  ];

  static ReplyType fromCode(int code) {
    var index = _codeList.indexOf(code);
    if (code == -1) {
      return ReplyType.unkown;
    }
    return ReplyType.values[index];
  }

  get code => _codeList[index];
}
