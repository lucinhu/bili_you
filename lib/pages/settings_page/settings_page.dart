import 'package:bili_you/pages/settings_page/appearance_settings_page.dart';
import 'package:bili_you/pages/settings_page/common_settings_page.dart';
import 'package:bili_you/pages/settings_page/others_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Color iconColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(title: const Text("设置")),
      body: ListView(children: [
        ListTile(
          leading: Icon(Icons.tune_outlined, color: iconColor),
          title: const Text("通用"),
          onTap: () => Navigator.of(context).push(GetPageRoute(
            page: () => const CommonSettingsPage(),
          )),
        ),
        ListTile(
          leading: Icon(Icons.color_lens_outlined, color: iconColor),
          title: const Text("外观"),
          onTap: () => Navigator.of(context)
              .push(GetPageRoute(page: () => const AppearanceSettingsPage())),
        ),
        ListTile(
            leading: Icon(Icons.more_horiz_outlined, color: iconColor),
            title: const Text("其他"),
            onTap: () => Navigator.of(context).push(GetPageRoute(
                  page: () => const OthersSettingsPage(),
                ))),
      ]),
    );
  }
}
