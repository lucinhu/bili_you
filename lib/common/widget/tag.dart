import 'package:flutter/material.dart';

class TextTag extends StatelessWidget {
  final String text; // 新增文本内容参数

  const TextTag({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      child: Text(
        '  $text  ', // 使用传入的文本内容
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
