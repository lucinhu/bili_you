import 'package:flutter/material.dart';

class SliderDialog extends StatefulWidget {
  const SliderDialog(
      {super.key,
      required this.title,
      required this.initValue,
      required this.min,
      required this.max,
      this.divisions,
      this.onOk,
      this.onCancel,
      this.onChanged,
      this.buildLabel,
      this.showCancelButton = true});
  final String title;
  final double initValue;
  final double min;
  final double max;
  final int? divisions;
  final bool showCancelButton;

  final void Function(double selectingValue)? onCancel;
  final void Function(double selectingValue)? onOk;
  final void Function(double selectingValue)? onChanged;
  final String Function(double selectingValue)? buildLabel;

  @override
  State<SliderDialog> createState() => _SliderDialogState();
}

class _SliderDialogState extends State<SliderDialog> {
  late double _selectingValue;
  bool isCancel = true;
  @override
  void initState() {
    _selectingValue = widget.initValue;
    super.initState();
  }

  @override
  void dispose() {
    if (isCancel) {
      widget.onCancel?.call(_selectingValue);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: IntrinsicHeight(
        child: Column(
          children: [
            if (widget.buildLabel != null)
              Text(widget.buildLabel!.call(_selectingValue)),
            Slider(
              min: widget.min,
              max: widget.max,
              divisions: widget.divisions,
              label: widget.buildLabel?.call(_selectingValue),
              value: _selectingValue,
              onChanged: (value) {
                widget.onChanged?.call(value);
                setState(() {});
                _selectingValue = value;
              },
            ),
          ],
        ),
      ),
      actions: [
        if (widget.showCancelButton)
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "取消",
                style: TextStyle(color: Theme.of(context).hintColor),
              )),
        if (widget.onOk != null)
          TextButton(
              onPressed: () {
                isCancel = false;
                widget.onOk?.call(_selectingValue);
                Navigator.pop(context);
              },
              child: const Text("确定")),
      ],
    );
  }
}
