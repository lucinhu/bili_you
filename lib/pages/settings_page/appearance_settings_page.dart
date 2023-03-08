import 'package:bili_you/common/utils/settings.dart';
import 'package:flutter/material.dart';

class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({super.key});

  @override
  State<AppearanceSettingsPage> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  RadioListTile themeModeListTile(ThemeMode themeMode) {
    return RadioListTile<ThemeMode>(
      value: themeMode,
      groupValue: SettingsUtil.currentThemeMode,
      title: Text(themeMode.value),
      onChanged: (value) {
        SettingsUtil.changeThemeMode(value!);
        setState(() {});
        Navigator.pop(context);
      },
    );
  }

  List<RadioListTile> buildThemeModeList() {
    List<RadioListTile> list = [];
    for (var themeMode in ThemeMode.values) {
      list.add(themeModeListTile(themeMode));
    }
    return list;
  }

  RadioListTile themeListTile(BiliTheme theme) {
    return RadioListTile<BiliTheme>(
      value: theme,
      groupValue: SettingsUtil.currentTheme,
      title: Text(
        theme.value,
        style: TextStyle(
            color: theme == BiliTheme.dynamic ? null : theme.seedColor),
      ),
      onChanged: (value) {
        SettingsUtil.changeTheme(value!);
        setState(() {});
        Navigator.pop(context);
      },
    );
  }

  List<RadioListTile> buildThemeLists() {
    List<RadioListTile> list = [];
    for (var theme in BiliTheme.values) {
      list.add(themeListTile(theme));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("外观设置")),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              "主题",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          ListTile(
            title: const Text("主题模式"),
            subtitle: Text(SettingsUtil.currentThemeMode.value),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        scrollable: true,
                        title: const Text("主题模式"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("取消"))
                        ],
                        contentPadding: EdgeInsets.zero,
                        content: Column(children: buildThemeModeList()),
                      ));
            },
          ),
          ListTile(
            title: const Text("主题"),
            subtitle: Text(SettingsUtil.currentTheme.value),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        scrollable: true,
                        title: const Text("主题"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("取消"))
                        ],
                        contentPadding: EdgeInsets.zero,
                        content: Column(
                          children: buildThemeLists(),
                        ),
                      ));
            },
          )
        ]));
  }
}
