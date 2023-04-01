import 'package:bili_you/common/models/local/video/audio_play_item.dart';
import 'package:bili_you/common/models/local/video/video_play_item.dart';
import 'package:bili_you/common/utils/index.dart';
import 'package:bili_you/common/widget/settings_label.dart';
import 'package:bili_you/common/widget/settings_radios_tile.dart';
import 'package:bili_you/common/widget/settings_switch_tile.dart';
import 'package:flutter/material.dart';

class CommonSettingsPage extends StatelessWidget {
  const CommonSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("通用设置")),
        body: ListView(children: [
          const SettingsSwitchTile(
              title: '自动检查更新',
              subTitle: '是否在启动app时检查更新',
              settingsKey: SettingsStorageKeys.autoCheckUpdate,
              defualtValue: true),
          const SettingsLabel(text: '搜索'),
          const SettingsSwitchTile(
              title: '显示搜索默认词',
              subTitle: '是否显示搜索默认词',
              settingsKey: SettingsStorageKeys.showSearchDefualtWord,
              defualtValue: true),
          const SettingsSwitchTile(
              title: '显示热搜',
              subTitle: '是否显示热搜',
              settingsKey: SettingsStorageKeys.showHotSearch,
              defualtValue: true),
          const SettingsSwitchTile(
              title: '显示搜索历史记录',
              subTitle: '是否显示搜索历史记录',
              settingsKey: SettingsStorageKeys.showSearchHistory,
              defualtValue: true),
          const SettingsLabel(text: '弹幕'),
          const SettingsSwitchTile(
              title: '默认显示弹幕',
              subTitle: '在进入视频的时候是否默认打开弹幕',
              settingsKey: SettingsStorageKeys.defaultShowDanmaku,
              defualtValue: true),
          const SettingsLabel(text: '视频'),
          SettingsRadiosTile(
            title: '偏好画质',
            subTitle: '视频播放时默认偏向选择的画质',
            buildTrailingText: () =>
                SettingsUtil.getPreferVideoQuality().description,
            itemNameValue: {
              for (var element in VideoQuality.values)
                if (element != VideoQuality.unknown)
                  element.description: element
            },
            buildGroupValue: SettingsUtil.getPreferVideoQuality,
            applyValue: (value) async {
              await SettingsUtil.putPreferVideoQuality(value);
            },
          ),
          SettingsRadiosTile(
            title: '偏好视频编码',
            subTitle: '默认偏好选择的视频编码',
            buildTrailingText: () => BiliYouStorage.settings
                .get(SettingsStorageKeys.preferVideoCodec, defaultValue: 'hev'),
            itemNameValue: const {'hev': 'hev', 'avc': 'avc'},
            buildGroupValue: () => BiliYouStorage.settings
                .get(SettingsStorageKeys.preferVideoCodec, defaultValue: 'hev'),
            applyValue: (value) {
              BiliYouStorage.settings
                  .put(SettingsStorageKeys.preferVideoCodec, value);
            },
          ),
          SettingsRadiosTile(
            title: '偏好音质',
            subTitle: '视频播放时默认偏向选择的音质',
            buildTrailingText: () =>
                SettingsUtil.getPreferAudioQuality().description,
            itemNameValue: {
              for (var element in AudioQuality.values)
                if (element != AudioQuality.unknown)
                  element.description: element
            },
            buildGroupValue: SettingsUtil.getPreferAudioQuality,
            applyValue: (value) async {
              await SettingsUtil.putPreferAudioQuality(value);
            },
          )
        ]));
  }
}
