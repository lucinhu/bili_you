import 'dart:io';

import 'package:bili_you/common/utils/string_format_utils.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CacheManagementPage extends StatefulWidget {
  const CacheManagementPage({super.key});

  @override
  State<CacheManagementPage> createState() => _CacheManagementPageState();
}

class _CacheManagementPageState extends State<CacheManagementPage> {
  List<Widget> items = [];

  Future<double> getTotalSizeOfFilesInDir(FileSystemEntity file) async {
    if (file is File && await file.exists()) {
      int length = await file.length();
      return length.toDouble();
    }
    if (file is Directory && await file.exists()) {
      List children = file.listSync();
      double total = 0;
      if (children.isNotEmpty) {
        for (FileSystemEntity child in children) {
          total += await getTotalSizeOfFilesInDir(child);
        }
      }
      return total;
    }
    return 0;
  }

  Future<void> buildItems() async {
    items.clear();
    var dir = await getTemporaryDirectory();
    for (var element in dir.listSync()) {
      if (element is Directory && await element.exists()) {
        //我们只取保存在文件夹的缓存
        //如果是文件夹的话，就计算它的大小
        double size = await getTotalSizeOfFilesInDir(element);
        items.add(ListTile(
          title: Text(element.path.split('/').last),
          subtitle: Text(StringFormatUtils.byteNumToFileSize(size)),
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("是否删除该缓存？"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("否")),
                  TextButton(
                      onPressed: () {
                        element.deleteSync(recursive: true);
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                      child: const Text("是")),
                ],
              ),
            );
          },
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("缓存管理"),
      ),
      body: FutureBuilder(
        future: buildItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(children: items);
          } else {
            return const LinearProgressIndicator();
          }
        },
      ),
    );
  }
}
