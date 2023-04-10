import 'package:bili_you/common/models/local/dynamic/dynamic_content.dart';
import 'package:bili_you/common/models/local/dynamic/dynamic_item.dart';
import 'package:bili_you/common/models/local/reply/reply_content.dart';
import 'package:bili_you/common/values/hero_tag_id.dart';
import 'package:bili_you/common/widget/avatar.dart';
import 'package:bili_you/common/widget/cached_network_image.dart';
import 'package:bili_you/common/widget/foldable_text.dart';
import 'package:bili_you/common/widget/icon_text_button.dart';
import 'package:bili_you/index.dart';
import 'package:bili_you/pages/bili_video/index.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/index.dart';
import 'package:bili_you/pages/user_space/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class DynamicItemCard extends StatefulWidget {
  const DynamicItemCard({super.key, required this.dynamicItem});
  final DynamicItem dynamicItem;

  @override
  State<DynamicItemCard> createState() => _DynamicItemCardState();
}

class _DynamicItemCardState extends State<DynamicItemCard> {
  final CacheManager videoCoverCacheManager =
      CacheManager(Config(CacheKeys.dynamicVideoItemCoverKey));

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
                  cacheManager: CacheManager(Config(CacheKeys.emoteKey)),
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
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AvatarWidget(
                  radius: 45 / 2,
                  avatarUrl: widget.dynamicItem.author.avatarUrl,
                  officialVerifyType:
                      widget.dynamicItem.author.officialVerify.type,
                  onPressed: () {
                    // Get.to(() => UserSpacePage(
                    //     key:
                    //         ValueKey('UserSpacePage:${dynamicItem.author.mid}'),
                    //     mid: dynamicItem.author.mid));
                    Navigator.of(context).push(GetPageRoute(
                        page: () => UserSpacePage(
                            key: ValueKey(
                                'UserSpacePage:${widget.dynamicItem.author.mid}'),
                            mid: widget.dynamicItem.author.mid)));
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    //发动态的作者名字
                    widget.dynamicItem.author.name,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  //发布时间,动作
                  Text(
                    "${widget.dynamicItem.author.pubTime} ${widget.dynamicItem.author.pubAction}",
                    style: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 12),
                  )
                ],
              )
            ]),
            Padding(
              padding: const EdgeInsets.only(
                  top: 14.0, left: 8, right: 8, bottom: 8), //动态信息
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///动态文字消息
                  widget.dynamicItem.content.emotes.isNotEmpty
                      ? SelectableText.rich(
                          buildEmojiText(widget.dynamicItem.content, context))
                      : SelectableRegion(
                          magnifierConfiguration:
                              const TextMagnifierConfiguration(),
                          focusNode: FocusNode(),
                          selectionControls: MaterialTextSelectionControls(),
                          child: FoldableText.rich(
                            buildEmojiText(widget.dynamicItem.content, context),
                            maxLines: 6,
                            folderTextStyle: TextStyle(
                                color: Theme.of(context).primaryColor),
                            style: const TextStyle(fontSize: 15),
                          )),

                  ///视频
                  if (widget.dynamicItem.content is AVDynamicContent)
                    DynamicVideoCard(
                      content: widget.dynamicItem.content as AVDynamicContent,
                      cacheManager: videoCoverCacheManager,
                      heroTagId: HeroTagId.id++,
                    ),

                  ///分享，评论，点赞
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
                                        replyType: widget.dynamicItem.replyType,
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

class DynamicVideoCard extends StatelessWidget {
  const DynamicVideoCard(
      {super.key,
      required this.content,
      required this.cacheManager,
      required this.heroTagId});
  final AVDynamicContent content;
  final playInfoTextStyle = const TextStyle(
      color: Colors.white, fontSize: 12, overflow: TextOverflow.ellipsis);
  final CacheManager cacheManager;
  final int heroTagId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HeroTagId.lastId = heroTagId;
        int cid = 0;
        Navigator.of(context).push(GetPageRoute(
          page: () => FutureBuilder(future: Future(() async {
            cid = (await VideoInfoApi.getVideoParts(bvid: content.bvid))
                .first
                .cid;
          }), builder: (context, snap) {
            if (snap.connectionState == ConnectionState.done) {
              return BiliVideoPage(bvid: content.bvid, cid: cid);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: LayoutBuilder(builder: (context, boxConstraints) {
                    return Hero(
                        tag: heroTagId,
                        transitionOnUserGestures: true,
                        child: CachedNetworkImage(
                          cacheWidth: (boxConstraints.maxWidth *
                                  MediaQuery.of(context).devicePixelRatio)
                              .toInt(),
                          cacheHeight: (boxConstraints.maxHeight *
                                  MediaQuery.of(context).devicePixelRatio)
                              .toInt(),
                          cacheManager: cacheManager,
                          fit: BoxFit.cover,
                          imageUrl: content.picUrl,
                          placeholder: () => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          errorWidget: () => const Icon(Icons.error),
                          filterQuality: FilterQuality.none,
                        ));
                  }),
                ),
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black38,
                          blurRadius: 12,
                          spreadRadius: 10,
                          offset: Offset(0, 12)),
                    ],
                  ),
                  padding: const EdgeInsets.only(left: 6, right: 6, bottom: 3),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.slideshow_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        Text(
                          " ${content.playCount}  ",
                          maxLines: 1,
                          style: playInfoTextStyle,
                        ),
                        const Icon(
                          Icons.format_list_bulleted_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        Text(
                          " ${content.damakuCount}",
                          maxLines: 1,
                          style: playInfoTextStyle,
                        ),
                        const Spacer(),
                        Text(
                          content.duration,
                          maxLines: 1,
                          style: playInfoTextStyle,
                        ),
                      ]),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              content.title,
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }
}
