import 'package:bili_you/common/utils/bili_you_storage.dart';
import 'package:flutter/material.dart';

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.settingsKey,
    required this.defualtValue,
  });
  final String title;
  final String subTitle;
  final String settingsKey;
  final bool defualtValue;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle),
      trailing: StatefulBuilder(builder: (context, setState) {
        return Switch(
          value: BiliYouStorage.settings
              .get(settingsKey, defaultValue: defualtValue),
          onChanged: (value) async {
            await BiliYouStorage.settings.put(settingsKey, value);
            setState(() {});
          },
        );
      }),
    );
  }
}
