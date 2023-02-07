import 'package:bili_you/common/models/reply/reply_item.dart';
import 'package:bili_you/common/utils/string_format_utils.dart';
import 'package:bili_you/common/values/cache_keys.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ReplyItemWidget extends StatelessWidget {
  const ReplyItemWidget(
      {super.key,
      required this.face,
      required this.name,
      required this.content,
      required this.location,
      required this.like,
      required this.timeStamp,
      this.bottomWidget,
      this.isTop = false,
      this.isUp = false,
      this.cardLabels = const []});
  final String face;
  final String name;
  final Content content;
  final String location;
  final int like;
  final int timeStamp;
  final Widget? bottomWidget;
  final bool isTop; //是否是置顶
  final bool isUp; //是否是up主
  final List<CardLabel> cardLabels;

  static TextSpan buildReplyItemContent(Content content) {
    List<InlineSpan> spans = [];
    content.message.splitMapJoin(RegExp(r"\[.*?\]"), onMatch: (match) {
      //匹配到是[]的位置时,有可能是表情
      String matched = match[0]!;
      //判断是不是有这个表情
      if (content.emoteMap.containsKey(matched)) {
        spans.add(
          WidgetSpan(
              child: SizedBox(
                  width: 20.0 * content.emoteMap[matched]!.size,
                  height: 20.0 * content.emoteMap[matched]!.size,
                  child: CachedNetworkImage(
                    cacheKey: matched,
                    cacheManager: CacheManager(Config(CacheKeys.emoteKey)),
                    imageUrl: content.emoteMap[matched]!.url,
                  ))),
        );
      } else {
        spans.add(TextSpan(text: matched));
      }
      return matched;
    }, onNonMatch: (noMatch) {
      //匹配到不是[]的位置时,不是表情
      spans.add(TextSpan(text: noMatch));
      return noMatch;
    });

    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: CachedNetworkImage(
                    imageUrl: face,
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.none,
                    cacheManager: CacheManager(Config(CacheKeys.othersFaceKey)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Builder(
                  builder: (context) {
                    if (isTop) {
                      return Text(
                        "置顶",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                Builder(
                  builder: (context) {
                    List<Widget> list = [];
                    if (cardLabels.isNotEmpty) {
                      for (var i in cardLabels) {
                        list.add(
                          SizedBox(
                              width: 45,
                              child: Text(
                                i.textContent, //标签,如热评,up觉得很赞
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )),
                        );
                      }
                      return Column(
                        children: list,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Builder(
                                builder: (context) {
                                  if (isUp) {
                                    //显示up主
                                    return Text(
                                      ' UP主 ',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              )
                            ],
                          ),
                          Text(location,
                              style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 12))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text.rich(buildReplyItemContent(content)),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            style: const ButtonStyle(
                              elevation: MaterialStatePropertyAll(0),
                              minimumSize:
                                  MaterialStatePropertyAll(Size(10, 10)),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.thumb_up_rounded,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(StringFormatUtils.numFormat(like))
                              ],
                            )),
                        const Spacer(),
                        Text(
                          StringFormatUtils.timeStampToAgoDate(timeStamp),
                          style: TextStyle(
                              fontSize: 12, color: Theme.of(context).hintColor),
                        )
                      ],
                    ),
                    bottomWidget ?? Container()
                  ]),
            )
          ],
        ));
  }
}
