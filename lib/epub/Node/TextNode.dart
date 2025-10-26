import 'package:flutter/material.dart';

import '../ReaderNode.dart';

class TextNode extends ReaderNode {
  TextSpan textSpan;
  TextPainter? textPainter;
  List<ReaderNode> listNode = [];

  TextNode(this.textSpan, super.styleModel, super.uniqueId);

  @override
  void paint(Canvas canvas, Offset offset) {
    if (textPainter != null) {
      textPainter!.paint(canvas, offset);
    }
  }

  @override
  List<ReaderNode> layout(
    double availableWidth,
    Offset offset, {
    isFull = true,
  }) {
    double extraLineSpacing = styleModel.extraLineSpacing ?? 0;
    layoutBefore();
    textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter!.layout(maxWidth: availableWidth);
    currentOffset = offset;
    double lastWidth = 0;

    if (!isFull) {
      TextPosition pos = textPainter!.getPositionForOffset(
        Offset(availableWidth, 0),
      );
      final splitIndex = pos.offset;
      if (splitIndex != textSpan.text!.length) {
        isEnter = true;

        //这里是当一行中剩余宽度不够了 直接将Node放到下一行
        if (splitIndex == 0 ||
            (splitIndex < textSpan.text!.length && !isBranch)) {
          segmentation(0, 0);
          return listNode;
        }

        //这里是还有splitIndex的值位置，将裁断splitIndex这么多的文本出来，其余放到下一行
        segmentation(splitIndex, availableWidth);
      }
    }

    List<LineMetrics> list = textPainter!.computeLineMetrics();
    if (list.isEmpty) return [];
    lastWidth = list.last.width;

    if (extraLineSpacing > 0 && list.length > 1) {
      int firstLineOffset = textPainter!
          .getPositionForOffset(
            Offset(list[0].left + list[0].width, list[0].baseline),
          )
          .offset;
      isEnter = true;
      currentHeight = extraLineSpacing;
      segmentation(firstLineOffset, availableWidth);
    }

    //这里是对如果文本的总高度超过了页面剩余的实际高度
    if (textPainter!.height > remainingHeight!) {
      int endOffset = 0;
      double totalHeight = 0;
      int listIndex = 0;
      for (LineMetrics lineMetrics in list) {
        totalHeight += lineMetrics.height;
        //这里判断如果截取的所有行的下一行加上来大于实际高度就可以裁掉在这一行加上去前的所有文本作为一段了
        if (totalHeight > remainingHeight!) break;

        final lineEndOffset = textPainter!
            .getPositionForOffset(
              Offset(
                lineMetrics.left + lineMetrics.width,
                lineMetrics.baseline,
              ),
            )
            .offset;
        lastWidth = lineMetrics.width;
        endOffset = lineEndOffset;
        listIndex++;
      }

      isTurning = true;
      segmentation(endOffset, availableWidth);
    }

    double dx = list.last.width + currentOffset.dx;
    double dy = currentOffset.dy + textPainter!.height - list.last.height;
    currentHeight += textPainter!.height;
    currentWidth = textPainter!.width;
    nextOffset = Offset(dx, dy);
    return listNode;
  }

  void segmentation(int index, double maxWidth) {
    String remainingText = textSpan.text!.substring(index);
    TextSpan newTextSpan = TextSpan(text: remainingText, style: textSpan.style);
    TextNode newTextNode = TextNode(newTextSpan, styleModel, uniqueId);
    listNode.insert(0, newTextNode);
    String currentText = textSpan.text!.substring(0, index);
    textSpan = TextSpan(text: currentText, style: textSpan.style);
    textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter!.layout(maxWidth: maxWidth);
  }
} //这里的可以直接使用TextPainter绘制出来
