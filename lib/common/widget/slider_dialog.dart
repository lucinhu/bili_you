import 'package:flutter/material.dart';

class SliderDialog extends StatefulWidget {
  const SliderDialog(
      {super.key,
      required this.title,
      required this.initValue,
      required this.min,
      required this.max,
      required this.divisions,
      this.onYes,
      this.onCancel,
      this.onChanged,
      this.buildLabel});
  final String title;
  final double initValue;
  final double min;
  final double max;
  final int divisions;

  final void Function(double selectingValue)? onCancel;
  final void Function(double selectingValue)? onYes;
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
        child: Slider(
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
      ),
      actions: [
        TextButton(
            onPressed: () {
              isCancel = true;
              Navigator.pop(context);
            },
            child: Text(
              "取消",
              style: TextStyle(color: Theme.of(context).hintColor),
            )),
        TextButton(
            onPressed: () {
              isCancel = false;
              widget.onYes?.call(_selectingValue);
              Navigator.pop(context);
            },
            child: const Text("确定")),
      ],
    );
  }
}
