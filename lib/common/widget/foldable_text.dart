import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_utils/src/extensions/export.dart';

//可展开的文本
class FoldableText extends StatefulWidget {
  const FoldableText(String this.text,
      {Key? key, this.style, this.maxLines, this.folderTextStyle})
      : textSpan = null,
        super(key: key);
  const FoldableText.rich(TextSpan this.textSpan,
      {Key? key, this.style, this.maxLines, this.folderTextStyle})
      : text = null,
        super(key: key);
  final String? text;
  final TextSpan? textSpan;
  final TextStyle? style;
  //展开/收起文字的样式
  final TextStyle? folderTextStyle;
  final int? maxLines;
  @override
  State<FoldableText> createState() => _FoldableTextState();
}

class _FoldableTextState extends State<FoldableText> {
  // 全文、收起 的状态
  bool mIsExpansion = false;
  bool isExpansion(double maxWidth, double minWidth) {
    TextPainter textPainter = TextPainter(
        maxLines: widget.maxLines,
        text:
            widget.textSpan ?? TextSpan(text: widget.text, style: widget.style),
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: maxWidth, minWidth: minWidth);

    if (textPainter.didExceedMaxLines) {
      //判断 文本是否需要截断
      return true;
    } else {
      return false;
    }
  }

  void _isShowText() {
    if (mIsExpansion) {
      //关闭
      setState(() {
        mIsExpansion = false;
      });
    } else {
      //打开
      setState(() {
        mIsExpansion = true;
      });
    }
  }

  Widget _richText(double maxWidth, double minWidth) {
    if (isExpansion(maxWidth, minWidth)) {
      //是否截断
      if (mIsExpansion) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          widget.text != null
              ? Text(
                  widget.text!,
                  style: widget.style,
                )
              : Text.rich(
                  widget.textSpan!,
                  style: widget.style,
                ),
          GestureDetector(
            child: Text(
              '收起',
              style: widget.folderTextStyle,
            ),
            onTap: () => _isShowText(),
          ),
        ]);
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.text != null
                ? Text(
                    widget.text!,
                    style: widget.style,
                    maxLines: widget.maxLines,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  )
                : Text.rich(
                    widget.textSpan!,
                    style: widget.style,
                    maxLines: widget.maxLines,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
            GestureDetector(
              onTap: () {
                _isShowText();
              },
              child: Text(
                '展开',
                style: widget.folderTextStyle,
              ),
            ),
          ],
        );
      }
    } else {
      return widget.text != null
          ? Text(
              widget.text!,
              style: widget.style,
              textAlign: TextAlign.left,
            )
          : Text.rich(
              widget.textSpan!,
              style: widget.style,
              textAlign: TextAlign.left,
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (widget.text != null && widget.text!.isNotEmpty) {
        return _richText(constraints.maxWidth, constraints.minWidth);
      } else if (widget.textSpan != null &&
          !(widget.textSpan!.isBlank ?? true)) {
        return _richText(constraints.maxWidth, constraints.minWidth);
      } else {
        return const SizedBox();
      }
    });
  }
}
