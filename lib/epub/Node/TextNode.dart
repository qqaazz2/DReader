import 'package:flutter/cupertino.dart';

import '../ReaderNode.dart';

class TextNode extends ReaderNode {
  TextSpan textSpan;
  TextPainter? textPainter;
  List<ReaderNode> listNode = [];

  TextNode(
      this.textSpan,
      super.styleModel,
      super.uniqueId
      );

  @override
  void paint(Canvas canvas, Offset offset) {
    if (textPainter != null) {
      textPainter!.paint(canvas, offset);
    }
  }

  @override
  List<ReaderNode> layout(double availableWidth, Offset offset,
      {isFull = true}) {
    layoutBefore();
    textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter!.layout(maxWidth: availableWidth);
    currentOffset = offset;
    double lastWidth = 0;
    if (!isFull) {
      TextPosition pos =
      textPainter!.getPositionForOffset(Offset(availableWidth, 0));
      final splitIndex = pos.offset;
      if (splitIndex != textSpan.text!.length) {
        isEnter = true;
        if (splitIndex == 0 || (splitIndex < textSpan.text!.length && !isBranch)) {
          segmentation(0,0);
          return listNode;
        }

        segmentation(splitIndex, availableWidth);
      }
    }

    List<LineMetrics> list = textPainter!.computeLineMetrics();
    if (list.isEmpty) return [];
    lastWidth = list.last.width;
    if (textPainter!.height > remainingHeight!) {
      int endOffset = 0;
      double totalHeight = 0;
      for (LineMetrics lineMetrics in list) {
        totalHeight += lineMetrics.height;
        if (totalHeight > remainingHeight!) break;

        final lineEndOffset = textPainter!.getPositionForOffset(Offset(lineMetrics.left + lineMetrics.width, lineMetrics.baseline)).offset;
        lastWidth = lineMetrics.width;
        endOffset = lineEndOffset;
      }

      isTurning = true;
      segmentation(endOffset, availableWidth);
    }

    double dx = list.last.width + currentOffset.dx;
    double dy = currentOffset.dy + textPainter!.height - list.last.height;
    currentHeight = textPainter!.height;
    currentWidth = textPainter!.width;
    nextOffset = Offset(dx, dy);
    return listNode;
  }

  void segmentation(int index, double maxWidth) {
    String remainingText = textSpan.text!.substring(index);
    TextSpan newTextSpan = TextSpan(text: remainingText, style: textSpan.style);
    TextNode newTextNode = TextNode(newTextSpan, styleModel,uniqueId);
    listNode.insert(0, newTextNode);
    String currentText = textSpan.text!.substring(0, index);
    textSpan = TextSpan(text: currentText, style: textSpan.style);
    textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter!.layout(maxWidth: maxWidth);
  }
} //这里的可以直接使用TextPainter绘制出来