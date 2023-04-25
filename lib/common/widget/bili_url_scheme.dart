import 'dart:developer';

import 'package:appscheme/appscheme.dart';
import 'package:bili_you/common/api/index.dart';
import 'package:bili_you/common/utils/bvid_avid_util.dart';
import 'package:bili_you/pages/bili_video/index.dart';
import 'package:bili_you/pages/user_space/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BiliUrlScheme {
  static AppScheme appScheme = AppSchemeImpl.getInstance() as AppScheme;
  static void init(context) async {
    await appScheme.getInitScheme().then((event) => _goto(context, event));
    appScheme.registerSchemeListener().listen((event) => _goto(context, event));
  }

  static void _goto(context, SchemeEntity? event) {
    if (event != null) {
      if (event.scheme == 'bilibili') {
        //打开主页面
        //bilibili://root
        if (event.host == 'root') {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        //打开用户空间
        //bilibili://space/${mid}
        else if (event.host == 'space') {
          _navigatorPushToPage(
            context,
            UserSpacePage(
                mid: int.tryParse(event.path
                            ?.replaceFirstMapped('/', (match) => '')
                            .split('/')[0] ??
                        '0') ??
                    0),
          );
        }
        //打开视频
        //bilibili://video/${aid}
        else if (event.host == 'video') {
          String bvid = BvidAvidUtil.av2Bvid(int.tryParse(event.path
                      ?.replaceFirstMapped('/', (match) => '')
                      .split('/')[0] ??
                  '0') ??
              0);
          _navigatorPushToPage(
              context,
              FutureBuilder(
                future: Future(
                    () async => await VideoInfoApi.getFirstCid(bvid: bvid)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return BiliVideoPage(bvid: bvid, cid: snapshot.data ?? 0);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ));
        }
        //打开番剧
        //bilibili://bangumi/season/${ssid}
        else if (event.host == 'bangumi') {
          if (event.path?.startsWith('/season') ?? false) {
            //通过epid打开
            _gotoVideoPlayById(context,
                epid: int.tryParse(event.path
                            ?.replaceFirstMapped('/', (match) => '')
                            .split('/')[1] ??
                        '0') ??
                    0,
                isBangumi: true);
          }
        }
      } else if (event.scheme == 'http' || event.scheme == 'https') {
        if (event.host != null &&
            (event.host!.startsWith('www.bilibili.') ||
                event.host!.startsWith('m.bilibili.') ||
                event.host!.startsWith('b23.tv') ||
                event.host!.startsWith('bilibili.'))) {
          String idStr = event.host!.split('/').last;
          if (idStr.startsWith('av')) {
            _gotoVideoPlayById(context,
                bvid: BvidAvidUtil.av2Bvid(
                    int.parse(idStr.replaceFirstMapped('av', (match) => ''))));
          } else if (idStr.startsWith('BV')) {
            _gotoVideoPlayById(context, bvid: idStr);
          } else if (idStr.startsWith('ep')) {
            _gotoVideoPlayById(context,
                isBangumi: true,
                epid: int.parse(idStr.replaceFirstMapped('ep', (match) => '')));
          } else if (idStr.startsWith('ss')) {
            _gotoVideoPlayById(context,
                isBangumi: true,
                ssid: int.parse(idStr.replaceAllMapped('ss', (match) => '')));
          } else if (event.host!.contains('space')) {
            _navigatorPushToPage(context, UserSpacePage(mid: int.parse(idStr)));
          }
        }
      }
      log('path:${event.path}');
      log('path:${event.query}');
      log('dataString:${event.dataString}');
      log('source:${event.source}');
    }
  }

  //通过id打开视频界面
  //填视频bvid和cid(或只填bvid默认取第一p的cid)
  //番剧的话，isBangumi=true，然后填ssid或epid
  static Future<void> _gotoVideoPlayById(context,
      {String? bvid,
      int? cid,
      int? ssid,
      int? epid,
      bool isBangumi = false}) async {
    if (!isBangumi) {
      if (cid == null && bvid != null) {
        cid = await VideoInfoApi.getFirstCid(bvid: bvid);
      } else if (cid == null && bvid == null) {
        return;
      }
    } else {
      if (ssid != null || epid != null) {
        var response = await BangumiApi.getBangumiInfo(ssid: ssid, epid: epid);
        bvid = response.episodes.first.bvid;
        cid = response.episodes.first.cid;
      } else {
        return;
      }
    }
    _navigatorPushToPage(
        context,
        BiliVideoPage(
          bvid: bvid!,
          cid: cid!,
          ssid: ssid,
          isBangumi: isBangumi,
        ));
  }

  //跳转到某页面
  static Future _navigatorPushToPage(context, Widget page) {
    return Navigator.of(context).push(GetPageRoute(
      page: () => page,
    ));
  }
}
