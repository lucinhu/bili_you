import 'package:bili_you/common/models/local/dynamic/dynamic_content.dart';
import 'package:bili_you/common/widget/foldable_text.dart';
import 'package:bili_you/pages/dynamic/widget/dynamic_draw.dart';
import 'package:flutter/material.dart';

class DynamicArticleWidget extends StatelessWidget {
  const DynamicArticleWidget({super.key, required this.content});
  final ArticleDynamicContent content;

  @override
  Widget build(BuildContext context) {
    ///TODO: 跳转到文章
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(content.title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        if ((content.title.isNotEmpty && content.text.isNotEmpty))
          const Padding(padding: EdgeInsets.only(top: 4)),
        SelectableRegion(
            magnifierConfiguration: const TextMagnifierConfiguration(),
            focusNode: FocusNode(),
            selectionControls: MaterialTextSelectionControls(),
            child: FoldableText.rich(
              TextSpan(text: content.text),
              maxLines: 6,
              folderTextStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary),
              style: const TextStyle(fontSize: 15),
            )),
        if ((content.title.isNotEmpty || content.text.isNotEmpty) &&
            content.draws.isNotEmpty)
          const Padding(padding: EdgeInsets.only(top: 4)),
        DynamicDrawWidget(
            content: DrawDynamicContent(
                description: content.description,
                emotes: content.emotes,
                draws: content.draws)),
      ],
    );
  }
}
