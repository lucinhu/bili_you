import 'package:bili_you/common/widget/radio_list_dialog.dart';
import 'package:flutter/material.dart';

class SettingsRadiosTile<T> extends StatefulWidget {
  const SettingsRadiosTile(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.buildTrailingText,
      required this.itemNameValue,
      required this.buildGroupValue,
      required this.applyValue});
  final String title;
  final String subTitle;

  ///当前已选择项的名称
  final String Function() buildTrailingText;

  ///项的(名称--值)数据表
  final Map<String, T> itemNameValue;

  ///当前选择项的值
  final T Function() buildGroupValue;

  ///使当前选择值生效的回调函数
  final Function(T value) applyValue;

  @override
  State<SettingsRadiosTile<T>> createState() => _SettingsRadiosTileState<T>();
}

class _SettingsRadiosTileState<T> extends State<SettingsRadiosTile<T>> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: Text(widget.subTitle),
      trailing: Text(widget.buildTrailingText()),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => RadioListDialog(
            title: widget.title,
            itemNameValueMap: widget.itemNameValue,
            groupValue: widget.buildGroupValue(),
            onChanged: (value) {
              if (value != null) widget.applyValue(value);
              Navigator.of(context).pop();
              setState(
                () {},
              );
            },
          ),
        );
      },
    );
  }
}
