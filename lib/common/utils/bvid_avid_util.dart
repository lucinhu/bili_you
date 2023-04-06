import 'dart:math';

import 'package:flutter/material.dart';

class BvidAvidUtil {
  static const String table =
      "fZodR9XQDSUm21yCkr6zBqiveYah8bt4xsWpHnJE7jL5VG3guMTKNPAwcF";
  static const List<int> seqArray = [11, 10, 3, 8, 4, 6];
  static const int xOr = 177451812;
  static const int xAdd = 8728348608;
  static const List<String> defaultBvid = [
    'B',
    'V',
    '1',
    '',
    '',
    '4',
    '',
    '1',
    '',
    '7',
    '',
    ''
  ];

  ///avid转bvid
  static String av2Bvid(int av) {
    int newAvId = (av ^ xOr) + xAdd;
    List<String> defaultBv = [];
    defaultBv.addAll(BvidAvidUtil.defaultBvid);
    for (int i = 0; i < seqArray.length; i++) {
      defaultBv[seqArray[i]] = table.characters
          .elementAt((newAvId / pow(58, i).toInt() % 58).toInt());
    }
    return defaultBv.join();
  }

  ///bvid转avid
  static int bvid2Av(String bvid) {
    int newAvId = 0;
    for (int i = 0; i < seqArray.length; i++) {
      newAvId +=
          (table.indexOf(bvid.characters.elementAt(seqArray[i])) * pow(58, i))
              .toInt();
    }
    int av = (newAvId - xAdd) ^ xOr;
    return av;
  }

  ///判断是否是bvid
  ///只是简单的通过文本判断
  static bool isBvid(String bvid) {
    bvid = bvid.toUpperCase();
    if (bvid.length != defaultBvid.length) return false;
    for (int i = 0; i < bvid.length; i++) {
      if (defaultBvid[i] == '') continue;
      if (bvid.characters.elementAt(i) != defaultBvid[i]) return false;
    }
    return true;
  }
}
