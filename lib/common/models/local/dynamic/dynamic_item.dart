import 'package:bili_you/common/models/local/reply/reply_item.dart';

import 'dynamic_author.dart';
import 'dynamic_content.dart';
import 'dynamic_stat.dart';

class DynamicItem {
  DynamicItem(
      {required this.replyId,
      required this.replyType,
      required this.author,
      required this.type,
      required this.content,
      required this.stat});
  static DynamicItem get zero => DynamicItem(
      replyId: '',
      replyType: ReplyType.unkown,
      author: DynamicAuthor.zero,
      type: DynamicItemType.unkown,
      content: WordDynamicContent.zero,
      stat: DynamicStat.zero);

  ///评论区id
  String replyId;
  ReplyType replyType;
  DynamicAuthor author;
  DynamicItemType type;
  DynamicContent content;
  DynamicStat stat;
}

enum DynamicItemType {
  //未知
  unkown,

  ///消息
  //DYNAMIC_TYPE_WORD
  word,

  ///文章
  //DYNAMIC_TYPE_ARTICLE
  article,

  ///视频投稿
  //DYNAMIC_TYPE_AV
  av,

  ///抽签or互动?
  //DYNAMIC_TYPE_DRAW
  draw,

  ///直播推荐
  //DYNAMIC_TYPE_LIVE_RCMD
  liveRecommend,

  ///转发动态
  //DYNAMIC_TYPE_FORWARD
  forward,
}

extension DynamicItemTypeCode on DynamicItemType {
  static const List<String> _codeList = [
    "UNKOWN",
    "DYNAMIC_TYPE_WORD",
    "DYNAMIC_TYPE_ARTICLE",
    "DYNAMIC_TYPE_AV",
    "DYNAMIC_TYPE_DRAW",
    "DYNAMIC_TYPE_LIVE_RCMD",
    "DYNAMIC_TYPE_FORWARD",
  ];
  static DynamicItemType fromCode(String code) {
    int index = _codeList.indexOf(code);
    if (index == -1) {
      return DynamicItemType.unkown;
    }
    return DynamicItemType.values[index];
  }

  String get code => _codeList[index];
}
