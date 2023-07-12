import 'package:flutter/material.dart';

class TextHelpers {
  static RichText getHighlightedText(String text, String keyword,
      TextStyle normalStyle, TextStyle highlightStyle) {
    int index = text.toLowerCase().indexOf(keyword.toLowerCase());

    List<TextSpan> texts = <TextSpan>[];
    if (index > 0) {
      texts.add(TextSpan(
        text: text.substring(0, index),
        style: normalStyle,
      ));
    }
    texts.add(TextSpan(
      text: text.substring(index, index + keyword.length),
      style: highlightStyle,
    ));
    if (index + keyword.length < text.length) {
      texts.add(TextSpan(
        text: text.substring(index + keyword.length),
        style: normalStyle,
      ));
    }

    return RichText(
      text: TextSpan(
        children: texts,
      ),
    );
  }

  Widget simpleTextCard(String text, FontWeight weight, double size,
      Color color, int maxLines, TextOverflow overFlow) {
    return Text(
      text ?? "",
      style: TextStyle(fontWeight: weight, fontSize: size, color: color),
      maxLines: maxLines,
      overflow: overFlow,
    );
  }
}
