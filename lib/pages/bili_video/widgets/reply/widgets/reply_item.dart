import 'package:bili_you/common/models/local/reply/reply_content.dart';
import 'package:bili_you/common/utils/string_format_utils.dart';
import 'package:bili_you/common/values/cache_keys.dart';
import 'package:bili_you/common/widget/avatar.dart';
import 'package:bili_you/common/widget/cached_network_image.dart';
import 'package:bili_you/common/widget/foldable_text.dart';
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
      this.tags = const [],
      this.onTapUser});
  final String face;
  final String name;
  final ReplyContent content;
  final String location;
  final int like;
  final int timeStamp;
  final Widget? bottomWidget;
  final bool isTop; //是否是置顶
  final bool isUp; //是否是up主
  final List<String> tags;
  final Function(BuildContext context)? onTapUser;
  static final CacheManager emoteCacheManager =
      CacheManager(Config(CacheKeys.emoteKey));

  static TextSpan buildReplyItemContent(ReplyContent content) {
    if (content.emotes.isEmpty) {
      return TextSpan(text: content.message);
    }
    List<InlineSpan> spans = [];
    content.message.splitMapJoin(RegExp(r"\[.*?\]"), onMatch: (match) {
      //匹配到是[]的位置时,有可能是表情
      String matched = match[0]!;
      Emote? emote;
      //判断是不是有这个表情
      for (var i in content.emotes) {
        if (matched == i.text) {
          emote = i;
          break;
        }
      }
      if (emote != null) {
        //有的话就放表情进去
        spans.add(WidgetSpan(
          child: SizedBox(
              width: emote.size == EmoteSize.small ? 20 : 50,
              height: emote.size == EmoteSize.small ? 20 : 50,
              child: RepaintBoundary(
                key: ValueKey('emote:${emote.url}'),
                child: CachedNetworkImage(
                  cacheWidth: 200,
                  cacheHeight: 200,
                  semanticLabel: matched,
                  cacheManager: emoteCacheManager,
                  imageUrl: emote.url,
                ),
              )),
        ));
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
                AvatarWidget(
                  avatarUrl: face,
                  radius: 45 / 2,
                  onPressed: () => onTapUser?.call(context),
                  cacheWidthHeight: 200,
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
              ],
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      child: GestureDetector(
                        onTap: () => onTapUser?.call(context),
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child:
                          //评论内容
                          //TODO: 有表情的评论暂时无法折叠
                          content.emotes.isEmpty
                              ? SelectableRegion(
                                  magnifierConfiguration:
                                      const TextMagnifierConfiguration(),
                                  focusNode: FocusNode(),
                                  selectionControls:
                                      MaterialTextSelectionControls(),
                                  child: FoldableText.rich(
                                    buildReplyItemContent(content),
                                    maxLines: 6,
                                    folderTextStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ))
                              : SelectableText.rich(
                                  buildReplyItemContent(content)),
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
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              List<Widget> list = [];
                              if (tags.isNotEmpty) {
                                for (var i in tags) {
                                  list.add(
                                    Text(
                                      "$i ", //标签,如热评,up觉得很赞
                                      maxLines: 1,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }
                                return Row(
                                  children: list,
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
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
