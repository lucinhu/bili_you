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
          Navigator.of(context).push(GetPageRoute(
            page: () => UserSpacePage(
                mid: int.tryParse(event.path
                            ?.replaceFirstMapped('/', (match) => '')
                            .split('/')[0] ??
                        '0') ??
                    0),
          ));
        }
        //打开视频
        //bilibili://video/${aid}
        else if (event.host == 'video') {
          Navigator.of(context).push(GetPageRoute(page: () {
            String bvid = BvidAvidUtil.av2Bvid(int.tryParse(event.path
                        ?.replaceFirstMapped('/', (match) => '')
                        .split('/')[0] ??
                    '0') ??
                0);
            return FutureBuilder(
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
            );
          }));
        }
        //打开番剧
        //bilibili://bangumi/season/${ssid}
        else if (event.host == 'bangumi') {
          if (event.path?.startsWith('/season') ?? false) {
            Navigator.of(context).push(GetPageRoute(page: () {
              String bvid = '';
              int ssid = int.tryParse(event.path
                          ?.replaceFirstMapped('/', (match) => '')
                          .split('/')[1] ??
                      '0') ??
                  0;
              int cid = 0;
              return FutureBuilder(
                future: Future(() async {
                  var response = (await BangumiApi.getBangumiInfo(ssid: ssid));
                  bvid = response.episodes.first.bvid;
                  cid = response.episodes.first.cid;
                }),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return BiliVideoPage(
                      bvid: bvid,
                      cid: cid,
                      ssid: ssid,
                      isBangumi: true,
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            }));
          }
        }
      }

      log('path:${event.path}');
      log('path:${event.query}');
      log('dataString:${event.dataString}');
      log('source:${event.source}');
    }
  }
}
