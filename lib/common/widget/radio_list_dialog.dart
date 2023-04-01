import 'package:flutter/material.dart';

class RadioListDialog<T> extends StatefulWidget {
  const RadioListDialog(
      {super.key,
      required this.title,
      required this.itemNameValueMap,
      required this.groupValue,
      this.onChanged});
  final String title;
  final Map<String, T> itemNameValueMap;
  final T groupValue;
  final Function(T? value)? onChanged;

  @override
  State<RadioListDialog<T>> createState() => _RadioListDialogState<T>();
}

class _RadioListDialogState<T> extends State<RadioListDialog<T>> {
  late List<Widget> items;
  @override
  void initState() {
    items = <Widget>[];
    widget.itemNameValueMap.forEach((title, value) {
      items.add(RadioListTile(
        value: value,
        groupValue: widget.groupValue,
        title: Text(title),
        onChanged: (value) {
          widget.onChanged?.call(value);
          setState(() {});
        },
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(widget.title),
      content: Column(children: items),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'))
      ],
    );
  }
}
