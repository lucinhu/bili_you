import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../common/api/github_api.dart';
import '../../common/models/network/github/github_releases_item.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  final String projectUrl = "https://github.com/lucinhu/bili_you";
  final String authorUrl = "https://github.com/lucinhu";

  _chechUpdate(BuildContext context) async {
    var packageInfo = await PackageInfo.fromPlatform();
    var data = await GithubApi.requestLatestRelease();
    var latestVersion = data.name?.replaceFirst(RegExp(r'v'), '');
    var currentVersion = packageInfo.version;
    // log(data.toRawJson());
    if (latestVersion == currentVersion) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("已是最新版")));
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("有新版本:$latestVersion"),
              content: SingleChildScrollView(
                child: Text(data.body!),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("取消")),
                TextButton(
                  child: const Text("跳转下载"),
                  onPressed: () async {
                    //自动选择合适系统/abi的版本下载
                    if (Platform.isAndroid) {
                      //安卓
                      var supportedAbis =
                          (await DeviceInfoPlugin().androidInfo).supportedAbis;
                      // for (var i in supportedAbis) {
                      //   log(i);
                      // }
                      String abi = "";
                      if (supportedAbis.contains("x86_64")) {
                        abi = "x86_64";
                      } else if (supportedAbis.contains("arm64-v8a")) {
                        abi = "arm64-v8a";
                      } else if (supportedAbis.contains("armeabi-v7a")) {
                        abi = "armeabi-v7a";
                      }
                      for (Asset? i in data.assets ?? []) {
                        if (i!.name!.contains(abi) && i.name!.contains("apk")) {
                          //跳转下载
                          launchUrlString(i.browserDownloadUrl!,
                              mode: LaunchMode.externalApplication);
                          return;
                        }
                      }
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("没有匹配到支持的abi!\n现跳转至下载页面,请自行选择合适的安装包.")));
                      launchUrlString(
                          "https://github.com/lucinhu/bili_you/releases",
                          mode: LaunchMode.externalApplication);
                    } else if (Platform.isLinux) {
                      //linux
                      launchUrlString(
                          "https://github.com/lucinhu/bili_you/releases",
                          mode: LaunchMode.externalApplication);
                    } else if (Platform.isIOS) {
                      //TODO ios
                    }
                  },
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("关于")),
      body: ListView(children: [
        ListTile(
          title: const Text("版本"),
          subtitle: FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(snapshot.data!.version);
              } else {
                return const Text("");
              }
            },
          ),
          trailing: TextButton(
              child: const Text("检查更新"),
              onPressed: () {
                _chechUpdate(context);
              }),
        ),
        ListTile(
          title: const Text("作者"),
          subtitle: const Text("lucinhu"),
          onTap: () {
            launchUrlString(authorUrl);
          },
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: authorUrl));
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("已复制$authorUrl到剪切板")));
          },
        ),
        ListTile(
          title: const Text("项目链接"),
          subtitle: Text(projectUrl),
          onTap: () {
            launchUrlString(projectUrl);
          },
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: projectUrl));
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("已复制$projectUrl到剪切板")));
          },
        ),
        ListTile(
          title: const Text("许可"),
          onTap: () => Navigator.push(
              context,
              GetPageRoute(
                page: () => const LicensePage(
                  applicationIcon: ImageIcon(
                    AssetImage("assets/icon/bili.png"),
                    size: 200,
                  ),
                  applicationName: "Bili You",
                ),
              )),
        )
      ]),
    );
  }
}
