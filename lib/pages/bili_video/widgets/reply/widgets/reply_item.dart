import 'dart:developer';

import 'package:bili_you/common/api/reply_operation_api.dart';
import 'package:bili_you/common/models/local/reply/reply_content.dart';
import 'package:bili_you/common/models/local/reply/reply_item.dart';
import 'package:bili_you/common/utils/string_format_utils.dart';
import 'package:bili_you/common/values/cache_keys.dart';
import 'package:bili_you/common/widget/avatar.dart';
import 'package:bili_you/common/widget/cached_network_image.dart';
import 'package:bili_you/common/widget/foldable_text.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/widgets/view_image.dart';
import 'package:bili_you/pages/search_result/view.dart';
import 'package:bili_you/pages/user_space/view.dart';
import 'package:bili_you/pages/webview/browser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

import 'reply_reply_page.dart';

class ReplyItemWidget extends StatelessWidget {
  const ReplyItemWidget(
      {super.key,
      required this.reply,
      this.isTop = false,
      this.isUp = false,
      this.showPreReply = true,
      this.pauseVideoPlayer});
  final ReplyItem reply;
  final bool isTop; //是否是置顶
  final bool isUp; //是否是up主
  final bool showPreReply; //是否显示评论的外显示评论
  final Function()? pauseVideoPlayer;

  static final CacheManager emoteCacheManager =
      CacheManager(Config(CacheKeys.emoteKey));

  TextSpan buildReplyItemContent(ReplyContent content, BuildContext context) {
    if (content.emotes.isEmpty &&
        content.jumpUrls.isEmpty &&
        content.pictures.isEmpty) {
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
    if (content.jumpUrls.isNotEmpty) {
      spans.add(const TextSpan(text: '\n'));
    }
    //添加跳转链接
    for (var i in content.jumpUrls) {
      spans.add(WidgetSpan(
          child: GestureDetector(
        child: Text(
          i.title,
          style: TextStyle(color: Get.theme.colorScheme.primary),
        ),
        onTap: () {
          var url = Uri.tryParse(i.url);
          if (url == null || !url.hasScheme) {
            pauseVideoPlayer?.call();
            //若不是链接,去搜索
            // Get.to(() => SearchResultPage(
            //     key: ValueKey("SearchResultPage:${i.url}"), keyWord: i.url));
            Navigator.of(context).push(GetPageRoute(
                page: () => SearchResultPage(
                    key: ValueKey("SearchResultPage:${i.url}"),
                    keyWord: i.url)));
          } else {
            pauseVideoPlayer?.call();
            //若是链接跳转到webview
            // Get.to(() => BiliBrowser(
            //     key: ValueKey("BiliBrowser:${i.url}"),
            //     url: url,
            //     title: i.title));
            Navigator.of(context).push(GetPageRoute(
                page: () => BiliBrowser(
                    key: ValueKey("BiliBrowser:${i.url}"),
                    url: url,
                    title: i.title)));
          }
        },
      )));
    }
    if (content.pictures.isNotEmpty) {
      spans.add(const TextSpan(text: '\n'));
    }
    //添加图片
    for (var i in content.pictures) {
      spans.add(WidgetSpan(
          child: GestureDetector(
        onTap: () {
          pauseVideoPlayer?.call();
          // Get.to(
          //     () => ViewImage(key: ValueKey("ViewImage:${i.url}"), url: i.url));
          Navigator.of(context).push(GetPageRoute(
              page: () =>
                  ViewImage(key: ValueKey("ViewImage:${i.url}"), url: i.url)));
        },
        child: Hero(
          tag: i.url,
          transitionOnUserGestures: true,
          child: CachedNetworkImage(
            placeholder: () => Container(
              color: Get.theme.colorScheme.primary,
            ),
            imageUrl: i.url,
            width: 200,
            cacheWidth: 200 * Get.pixelRatio.toInt(),
            cacheManager: CacheManager(Config(CacheKeys.replyImageKey)),
          ),
        ),
      )));
    }

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
                  avatarUrl: reply.member.avatarUrl,
                  radius: 45 / 2,
                  onPressed: () {
                    pauseVideoPlayer?.call();
                    // Get.to(() => UserSpacePage(
                    //     key: ValueKey("UserSpacePage:${reply.member.mid}"),
                    //     mid: reply.member.mid));
                    Navigator.of(context).push(GetPageRoute(
                        page: () => UserSpacePage(
                            key: ValueKey("UserSpacePage:${reply.member.mid}"),
                            mid: reply.member.mid)));
                  },
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
                        onTap: () {
                          pauseVideoPlayer?.call();
                          // Get.to(() => UserSpacePage(
                          //     key:
                          //         ValueKey("UserSpacePage:${reply.member.mid}"),
                          //     mid: reply.member.mid));
                          Navigator.of(context).push(GetPageRoute(
                              page: () => UserSpacePage(
                                  key: ValueKey(
                                      "UserSpacePage:${reply.member.mid}"),
                                  mid: reply.member.mid)));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  reply.member.name,
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
                            Text(reply.location,
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
                          (reply.content.emotes.isNotEmpty ||
                                  reply.content.pictures.isNotEmpty ||
                                  reply.content.jumpUrls.isNotEmpty)
                              ? SelectableText.rich(
                                  buildReplyItemContent(reply.content, context))
                              : SelectableRegion(
                                  magnifierConfiguration:
                                      const TextMagnifierConfiguration(),
                                  focusNode: FocusNode(),
                                  selectionControls:
                                      MaterialTextSelectionControls(),
                                  child: FoldableText.rich(
                                    buildReplyItemContent(
                                        reply.content, context),
                                    maxLines: 6,
                                    folderTextStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  )),
                    ),
                    Row(
                      children: [
                        StatefulBuilder(builder: (context, setState) {
                          return ElevatedButton(
                              onPressed: () async {
                                try {
                                  var result = await ReplyOperationApi.addLike(
                                      type: reply.type,
                                      oid: reply.oid,
                                      rpid: reply.rpid,
                                      likeOrUnlike: !reply.hasLike);
                                  if (result.isSuccess) {
                                    reply.hasLike = !reply.hasLike;
                                    if (reply.hasLike) {
                                      reply.likeCount++;
                                    } else {
                                      reply.likeCount--;
                                    }
                                    setState(() {});
                                  } else {
                                    Get.rawSnackbar(
                                        message: '点赞失败:${result.error}');
                                  }
                                } catch (e) {
                                  log(e.toString());
                                  Get.rawSnackbar(message: '$e');
                                }
                              },
                              style: ButtonStyle(
                                foregroundColor: reply.hasLike == true
                                    ? MaterialStatePropertyAll(
                                        Theme.of(context).colorScheme.onPrimary)
                                    : null,
                                backgroundColor: reply.hasLike == true
                                    ? MaterialStatePropertyAll(
                                        Theme.of(context).colorScheme.primary)
                                    : null,
                                elevation: const MaterialStatePropertyAll(0),
                                minimumSize: const MaterialStatePropertyAll(
                                    Size(10, 10)),
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
                                  Text(StringFormatUtils.numFormat(
                                      reply.likeCount))
                                ],
                              ));
                        }),
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              List<Widget> list = [];
                              if (reply.tags.isNotEmpty) {
                                for (var i in reply.tags) {
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
                          StringFormatUtils.timeStampToAgoDate(reply.replyTime),
                          style: TextStyle(
                              fontSize: 12, color: Theme.of(context).hintColor),
                        )
                      ],
                    ),
                    Builder(
                      builder: (context) {
                        Widget? subReplies;
                        if (reply.replyCount != 0 && showPreReply == true) {
                          List<Widget> preSubReplies = []; //预显示在外的楼中楼
                          for (var j in reply.preReplies) {
                            //添加预显示在外楼中楼评论条目
                            preSubReplies.add(Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${j.member.name}: ",
                                      ),
                                      buildReplyItemContent(j.content, context)
                                    ],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )));
                          }

                          preSubReplies.add(Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '共 ${StringFormatUtils.numFormat(reply.replyCount)} 条回复 >',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ));

                          //预显示在外楼中楼控件
                          subReplies = Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant),
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 8),
                              child: GestureDetector(
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: preSubReplies,
                                ),
                                onTap: () {
                                  //楼中楼点击后弹出详细楼中楼
                                  Get.bottomSheet(
                                      ReplyReplyPage(
                                        replyId: reply.oid.toString(),
                                        replyType: reply.type,
                                        rootId: reply.rpid,
                                        pauseVideoCallback:
                                            pauseVideoPlayer ?? () {},
                                      ),
                                      backgroundColor:
                                          Theme.of(context).cardColor,
                                      clipBehavior: Clip.antiAlias);
                                },
                              ));
                        }
                        return subReplies ?? const SizedBox();
                      },
                    )
                  ]),
            )
          ],
        ));
  }
}
