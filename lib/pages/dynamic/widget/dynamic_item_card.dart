import 'package:bili_you/common/models/local/dynamic/dynamic_content.dart';
import 'package:bili_you/common/models/local/dynamic/dynamic_item.dart';
import 'package:bili_you/common/models/local/reply/reply_content.dart';
import 'package:bili_you/common/values/hero_tag_id.dart';
import 'package:bili_you/common/widget/avatar.dart';
import 'package:bili_you/common/widget/cached_network_image.dart';
import 'package:bili_you/common/widget/foldable_text.dart';
import 'package:bili_you/common/widget/icon_text_button.dart';
import 'package:bili_you/index.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/index.dart';
import 'package:bili_you/pages/dynamic/widget/dynamic_article.dart';
import 'package:bili_you/pages/dynamic/widget/dynamic_draw.dart';
import 'package:bili_you/pages/user_space/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

import 'dynamic_video_card.dart';

class DynamicItemCard extends StatefulWidget {
  const DynamicItemCard(
      {super.key, required this.dynamicItem, this.isForward = false});
  final DynamicItem dynamicItem;
  final bool isForward;

  @override
  State<DynamicItemCard> createState() => _DynamicItemCardState();
}

class _DynamicItemCardState extends State<DynamicItemCard> {
  final CacheManager videoCoverCacheManager =
      CacheUtils.dynamicVideoItemCoverCacheManager;

  @override
  void dispose() {
    videoCoverCacheManager.emptyCache();
    super.dispose();
  }

  TextSpan buildEmojiText(DynamicContent content, BuildContext context) {
    if (content.emotes.isEmpty) {
      return TextSpan(text: content.description);
    }
    List<InlineSpan> spans = [];
    content.description.splitMapJoin(RegExp(r"\[.*?\]"), onMatch: (match) {
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
                  cacheManager: CacheUtils.emoteCacheManager,
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

  void _goToUserSpacePage() {
    // Get.to(() => UserSpacePage(
    //     key:
    //         ValueKey('UserSpacePage:${dynamicItem.author.mid}'),
    //     mid: dynamicItem.author.mid));
    Navigator.of(context).push(GetPageRoute(
        page: () => UserSpacePage(
            key: ValueKey('UserSpacePage:${widget.dynamicItem.author.mid}'),
            mid: widget.dynamicItem.author.mid)));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: !widget.isForward
          ? Theme.of(context).cardColor
          : Theme.of(context).colorScheme.surfaceVariant,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              if (!widget.isForward)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: AvatarWidget(
                    radius: 45 / 2,
                    avatarUrl: widget.dynamicItem.author.avatarUrl,
                    officialVerifyType:
                        widget.dynamicItem.author.officialVerify.type,
                    onPressed: _goToUserSpacePage,
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _goToUserSpacePage,
                    child: Text(
                      //发动态的作者名字
                      widget.dynamicItem.author.name,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  //发布时间,动作
                  if (!widget.isForward)
                    Text(
                      "${widget.dynamicItem.author.pubTime} ${widget.dynamicItem.author.pubAction}",
                      style: TextStyle(
                          color: Theme.of(context).hintColor, fontSize: 12),
                    )
                ],
              )
            ]),
            Padding(
              padding: EdgeInsets.only(
                  top: (!widget.isForward) ? 14.0 : 0,
                  left: 8,
                  right: 8,
                  bottom: 8), //动态信息
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///动态文字消息
                  if (widget.dynamicItem.content.description.isNotEmpty)
                    widget.dynamicItem.content.emotes.isNotEmpty
                        ? SelectableText.rich(
                            buildEmojiText(widget.dynamicItem.content, context))
                        : SelectableRegion(
                            magnifierConfiguration:
                                const TextMagnifierConfiguration(),
                            focusNode: FocusNode(),
                            selectionControls: MaterialTextSelectionControls(),
                            child: FoldableText.rich(
                              TextSpan(
                                  text: widget.dynamicItem.content.description),
                              maxLines: 6,
                              folderTextStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                              style: const TextStyle(fontSize: 15),
                            )),
                  if (widget.dynamicItem.content.description.isNotEmpty)
                    const Padding(padding: EdgeInsets.only(top: 8)),

                  ///文章
                  if (widget.dynamicItem.content is ArticleDynamicContent)
                    DynamicArticleWidget(
                        content: widget.dynamicItem.content
                            as ArticleDynamicContent),

                  ///视频
                  if (widget.dynamicItem.content is AVDynamicContent)
                    DynamicVideoCard(
                      content: widget.dynamicItem.content as AVDynamicContent,
                      cacheManager: videoCoverCacheManager,
                      heroTagId: HeroTagId.id++,
                    ),

                  ///转发
                  if ((!widget.isForward) &&
                      widget.dynamicItem.content is ForwardDynamicContent)
                    DynamicItemCard(
                      dynamicItem:
                          (widget.dynamicItem.content as ForwardDynamicContent)
                              .forward,
                      isForward: true,
                    ),

                  ///图片
                  if (widget.dynamicItem.content is DrawDynamicContent)
                    DynamicDrawWidget(
                        content:
                            widget.dynamicItem.content as DrawDynamicContent),

                  ///分享，评论，点赞
                  if (!widget.isForward)
                    GridView.count(
                      padding: const EdgeInsets.only(top: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      childAspectRatio: 16 / 9,
                      crossAxisSpacing: 10,
                      children: [
                        IconTextButton(
                            onPressed: () {
                              Get.rawSnackbar(message: '功能暂未完成');
                            },
                            icon: const Icon(Icons.arrow_outward_outlined),
                            text: Text(StringFormatUtils.numFormat(
                                widget.dynamicItem.stat.shareCount))),
                        IconTextButton(
                            onPressed: () {
                              Navigator.of(context).push(GetPageRoute(
                                  page: () => Scaffold(
                                        appBar: AppBar(title: const Text("评论")),
                                        body: ReplyPage(
                                          replyId: widget.dynamicItem.replyId,
                                          replyType:
                                              widget.dynamicItem.replyType,
                                        ),
                                      )));
                            },
                            icon: const Icon(Icons.message_outlined),
                            text: Text(StringFormatUtils.numFormat(
                                widget.dynamicItem.stat.replyCount))),
                        IconTextButton(
                            onPressed: () {
                              Get.rawSnackbar(message: '功能暂未完成');
                            },
                            icon: const Icon(Icons.thumb_up_outlined),
                            text: Text(StringFormatUtils.numFormat(
                                widget.dynamicItem.stat.likeCount)))
                      ],
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
