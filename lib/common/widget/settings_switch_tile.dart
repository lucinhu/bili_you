import 'package:bili_you/common/utils/settings.dart';
import 'package:flutter/material.dart';

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.settingsKey,
      required this.defualtValue,
      this.apply});
  final String title;
  final String subTitle;
  final String settingsKey;
  final bool defualtValue;

  ///在开关切换且设置保存后进行调用，提供给外部进行应用该设置项
  final Function()? apply;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle),
      trailing: StatefulBuilder(builder: (context, setState) {
        return Switch(
          value: SettingsUtil.getValue(settingsKey, defaultValue: defualtValue),
          onChanged: (value) async {
            await SettingsUtil.setValue(settingsKey, value);
            setState(() {});
            apply?.call();
          },
        );
      }),
    );
  }
}
