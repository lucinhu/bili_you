import 'dart:developer';

import 'package:bili_you/common/api/reply_operation_api.dart';
import 'package:bili_you/common/models/local/reply/official_verify.dart';
import 'package:bili_you/common/models/local/reply/reply_content.dart';
import 'package:bili_you/common/models/local/reply/reply_item.dart';
import 'package:bili_you/common/utils/show_dialog.dart';
import 'package:bili_you/common/utils/string_format_utils.dart';
import 'package:bili_you/common/utils/cache_util.dart';
import 'package:bili_you/common/widget/avatar.dart';
import 'package:bili_you/common/widget/cached_network_image.dart';
import 'package:bili_you/common/widget/foldable_text.dart';
import 'package:bili_you/common/widget/icon_text_button.dart';
import 'package:bili_you/common/widget/tag.dart';
import 'package:bili_you/pages/bili_video/widgets/reply/add_reply_util.dart';
import 'package:bili_you/pages/search_result/view.dart';
import 'package:bili_you/pages/user_space/view.dart';
import 'package:bili_you/pages/webview/browser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

import 'reply_reply_page.dart';

class ReplyItemWidget extends StatefulWidget {
  const ReplyItemWidget(
      {super.key,
      required this.reply,
      this.isTop = false,
      this.isUp = false,
      this.showPreReply = true,
      this.officialVerifyType});
  final ReplyItem reply;
  final bool isTop; //是否是置顶
  final bool isUp; //是否是up主
  final bool showPreReply; //是否显示评论的外显示评论
  final OfficialVerifyType? officialVerifyType;

  static final CacheManager emoteCacheManager = CacheUtils.emoteCacheManager;

  @override
  State<ReplyItemWidget> createState() => _ReplyItemWidgetState();
}

class _ReplyItemWidgetState extends State<ReplyItemWidget> {
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
                  cacheManager: ReplyItemWidget.emoteCacheManager,
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
            //若不是链接,去搜索
            Navigator.of(context).push(
                GetPageRoute(page: () => SearchResultPage(keyWord: i.url)));
          } else {
            //若是链接跳转到webview
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
          ShowDialog.showImageViewer(
              context: context,
              urls: content.pictures.map<String>((e) => e.url).toList(),
              initIndex: content.pictures.indexOf(i));
        },
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Hero(
            tag: i.url,
            child: CachedNetworkImage(
              placeholder: () => Container(
                color: Get.theme.colorScheme.primary,
              ),
              imageUrl: i.url,
              fit: BoxFit.cover,
              width: Get.size.width / 3,
              height: Get.size.width / 3,
              cacheWidth: ((Get.size.width / 3) * Get.pixelRatio).toInt(),
              cacheManager: CacheUtils.bigImageCacheManager,
            ),
          ),
        ),
      )));
    }

    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    AvatarWidget(
                      avatarUrl: widget.reply.member.avatarUrl,
                      officialVerifyType: widget.officialVerifyType,
                      radius: 45 / 2,
                      onPressed: () {
                        // Get.to(() => UserSpacePage(
                        //     key: ValueKey("UserSpacePage:${reply.member.mid}"),
                        //     mid: reply.member.mid));
                        Navigator.of(context).push(GetPageRoute(
                            page: () => UserSpacePage(
                                key: ValueKey(
                                    "UserSpacePage:${widget.reply.member.mid}"),
                                mid: widget.reply.member.mid)));
                      },
                      cacheWidthHeight: 200,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox()
                  ],
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // Get.to(() => UserSpacePage(
                              //     key:
                              //         ValueKey("UserSpacePage:${reply.member.mid}"),
                              //     mid: reply.member.mid));
                              Navigator.of(context).push(GetPageRoute(
                                  page: () => UserSpacePage(
                                      key: ValueKey(
                                          "UserSpacePage:${widget.reply.member.mid}"),
                                      mid: widget.reply.member.mid)));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.reply.member.name,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    if (widget.isUp)
                                      const Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: TextTag(
                                            text: "UP主",
                                          )),
                                    if (widget.isTop)
                                      const Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: TextTag(
                                            text: "置顶",
                                          )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                          StringFormatUtils.timeStampToAgoDate(
                                              widget.reply.replyTime),
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).hintColor,
                                              fontSize: 12)),
                                    ),
                                    Text(widget.reply.location,
                                        style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontSize: 12))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, right: 10, left: 10),
                          child:
                              //评论内容
                              //TODO: 有表情的评论暂时无法折叠
                              (widget.reply.content.emotes.isNotEmpty ||
                                      widget
                                          .reply.content.pictures.isNotEmpty ||
                                      widget.reply.content.jumpUrls.isNotEmpty)
                                  ? SelectableText.rich(buildReplyItemContent(
                                      widget.reply.content, context))
                                  : SelectableRegion(
                                      magnifierConfiguration:
                                          const TextMagnifierConfiguration(),
                                      focusNode: FocusNode(),
                                      selectionControls:
                                          MaterialTextSelectionControls(),
                                      child: FoldableText.rich(
                                        buildReplyItemContent(
                                            widget.reply.content, context),
                                        maxLines: 6,
                                        folderTextStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      )),
                        ),
                        Padding(
                          padding:const EdgeInsets.only(top:0, bottom: 0,left: 5),
                          child: Row(
                            children: [
                              StatefulBuilder(builder: (context, setState) {
                                return ThumUpButton(
                                  likeNum: widget.reply.likeCount,
                                  selected: widget.reply.hasLike,
                                  onPressed: () async {
                                    try {
                                      var result =
                                          await ReplyOperationApi.addLike(
                                              type: widget.reply.type,
                                              oid: widget.reply.oid,
                                              rpid: widget.reply.rpid,
                                              likeOrUnlike:
                                                  !widget.reply.hasLike);
                                      if (result.isSuccess) {
                                        widget.reply.hasLike =
                                            !widget.reply.hasLike;
                                        if (widget.reply.hasLike) {
                                          widget.reply.likeCount++;
                                        } else {
                                          widget.reply.likeCount--;
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
                                );
                              }),
                              AddReplyButton(
                                replyItem: widget.reply,
                                updateWidget: () {
                                  widget.reply.replyCount++;
                                  setState(() => ());
                                },
                              ),
                              Expanded(
                                child: widget.reply.tags.isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Row(children: [
                                          for (var i in widget.reply.tags)
                                            Text("$i ", //标签,如热评,up觉得很赞
                                                maxLines: 1,
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize: 14,
                                                ))
                                        ]),
                                      )
                                    : const SizedBox(),
                              )
                            ],
                          ),
                        ),
                        if (widget.reply.replyCount != 0 &&
                            widget.showPreReply == true)
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant),
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 8),
                              child: GestureDetector(
                                child: ListView(
                                  addAutomaticKeepAlives: false,
                                  addRepaintBoundaries: false,
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    for (var j in widget.reply.preReplies)
                                      //添加预显示在外楼中楼评论条目
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "${j.member.name}: ",
                                                ),
                                                buildReplyItemContent(
                                                    j.content, context)
                                              ],
                                            ),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    if (widget.reply.replyCount > 3)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          '共 ${StringFormatUtils.numFormat(widget.reply.replyCount)} 条回复 >',
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                  ],
                                ),
                                onTap: () {
                                  //楼中楼点击后弹出详细楼中楼
                                  Get.bottomSheet(
                                      ReplyReplyPage(
                                        replyId: widget.reply.oid.toString(),
                                        replyType: widget.reply.type,
                                        rootId: widget.reply.rpid,
                                      ),
                                      backgroundColor:
                                          Theme.of(context).cardColor,
                                      clipBehavior: Clip.antiAlias);
                                },
                              )),
                      ]),
                )
              ],
            )),
      ],
    );
  }
}

class ThumUpButton extends StatelessWidget {
  const ThumUpButton(
      {super.key,
      required this.onPressed,
      required this.likeNum,
      this.selected = false});
  final Function()? onPressed;
  final bool selected;
  final int likeNum;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          visualDensity: VisualDensity.comfortable,
          padding: const MaterialStatePropertyAll(
              EdgeInsets.all(5)),
          foregroundColor: selected == true
              ? MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.onPrimary)
              : null,
          backgroundColor: selected == true
              ? MaterialStatePropertyAll(Theme.of(context).colorScheme.primary)
              : null,
          elevation: const MaterialStatePropertyAll(0),
          minimumSize: const MaterialStatePropertyAll(Size(10, 5)),
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
            Text(StringFormatUtils.numFormat(likeNum))
          ],
        ));
  }
}

///回复评论按钮
class AddReplyButton extends StatelessWidget {
  const AddReplyButton(
      {super.key, required this.replyItem, required this.updateWidget});
  final ReplyItem replyItem;
  final Function() updateWidget;

  @override
  Widget build(BuildContext context) {
    return IconTextButton(
      onPressed: () {
        AddReplyUtil.showAddReplySheet(
            replyType: replyItem.type,
            oid: replyItem.oid.toString(),
            root: replyItem.rootRpid,
            parent: replyItem.rpid,
            newReplyItems: replyItem.preReplies,
            updateWidget: updateWidget,
            scrollController: null);
      },
      icon: const Padding(
        padding: EdgeInsets.all(2.0),
        child: Icon(
          Icons.reply,
          size: 15,
        ),
      ),
      text: null,
    );
  }
}
