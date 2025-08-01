import 'dart:math';

import 'package:flutter/material.dart';

import 'package:DReader/epub/CssToTextstyle.dart';
import 'package:DReader/epub/ReaderNode.dart';

import 'TextNode.dart';

class RubyNode extends InlineNode {
  RubyNode(super.tag, super.styleModel, super.uniqueId);

  TextNode? cloneTextNode;
  RtNode? cloneRtNode;

  @override
  List<ReaderNode> layout(double availableWidth, Offset offset, {isFull}) {
    currentOffset = offset;
    layoutBefore();
    // remainingHeight = ReaderNode.pageHeight - currentOffset.dy;
    RtNode? rtNode;
    TextNode? textNode;
    double baseInterval = 0;
    for (ReaderNode child in children) {
      if (child is RtNode) {
        rtNode = child;
        cloneRtNode = child.clone();
        cloneRtNode?.children = child.children;
      } else if (child is TextNode) {
        textNode = child;
        cloneTextNode =
            TextNode(child.textSpan, child.styleModel, child.uniqueId);
      }
    }

    if (rtNode == null || textNode == null) {
      nextOffset = offset;
      return [];
    }

    rtNode.remainingHeight = remainingHeight;
    rtNode.isBranch = false;
    rtNode.layout(availableWidth, offset);
    if (rtNode.isTurning || rtNode.isEnter || availableWidth <= 0) {
      if (rtNode.isTurning) isTurning = true;
      if (rtNode.isEnter) isEnter = true;
      return [clone()];
    }

    textNode.remainingHeight = remainingHeight! - rtNode.currentHeight;
    textNode.isBranch = false;
    Offset textOffset =
        Offset(offset.dx, offset.dy + rtNode.currentHeight + baseInterval);
    textNode.layout(availableWidth, textOffset, isFull: isFull);
    if (textNode.isTurning || textNode.isEnter || availableWidth <= 0) {
      if (textNode.isTurning) {
        isTurning = true;
      }
      if (textNode.isEnter) isEnter = true;
      return [clone()];
    }

    if (rtNode.currentWidth > textNode.currentWidth) {
      final dx = rtNode.currentOffset.dx +
          (rtNode.currentWidth - textNode.currentWidth) / 2;
      textNode.currentOffset = Offset(dx, textNode.currentOffset.dy);
    } else {
      final dx = textNode.currentOffset.dx +
          (textNode.currentWidth - rtNode.currentWidth) / 2;
      rtNode.currentWidth = 0;
      rtNode.currentLineWidth = 0;
      rtNode.currentLineHeight = 0;
      rtNode.currentHeight = 0;
      rtNode.layout(availableWidth, Offset(dx, rtNode.currentOffset.dy));
    }
    currentWidth = max(rtNode.currentWidth, textNode.currentWidth);
    currentHeight =
        rtNode.currentHeight + textNode.currentHeight + baseInterval;
    nextOffset = Offset(offset.dx + currentWidth, offset.dy);
    return [];
  }

  @override
  RubyNode clone() {
    RubyNode rubyNode = RubyNode(tag, styleModel, uniqueId);
    rubyNode.children = [cloneTextNode!, cloneRtNode!];
    return rubyNode;
  }
}

class RtNode extends InlineNode {
  RtNode(super.tag, super.styleModel, super.uniqueId) {
    ModelStyle modelStyle = ModelStyle(
        textStyle:
            const TextStyle(fontSize: CssToTextstyle.baseFontSize / 1.5));
    styleModel = styleModel.merge(modelStyle);
  }

  @override
  RtNode clone() {
    currentWidth = 0;
    currentLineHeight = 0;
    currentHeight = 0;
    return RtNode(tag, styleModel, uniqueId);
  }
}
