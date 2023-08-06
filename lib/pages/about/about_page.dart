import 'package:bili_you/common/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  final String projectUrl = "https://github.com/lucinhu/bili_you";
  final String authorUrl = "https://github.com/lucinhu";

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
                SettingsUtil.checkUpdate(context);
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
            ScaffoldMessenger.of(context);
            Get.rawSnackbar(message: '已复制$authorUrl到剪切板');
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
            ScaffoldMessenger.of(context);
            Get.rawSnackbar(message: '已复制$projectUrl到剪切板');
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
