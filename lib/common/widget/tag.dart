import 'package:flutter/material.dart';

class TextTag extends StatelessWidget {
  final String text;

  const TextTag({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      child: Text(
        '  $text  ',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
