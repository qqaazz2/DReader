import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:DReader/epub/Node/INode.dart';
import 'package:DReader/epub/Node/ImageNode.dart';
import 'package:DReader/epub/Node/RubyNode.dart';
import 'package:DReader/epub/Node/TextNode.dart';
import 'CssToTextstyle.dart';

class NodeStatus {
  static double pageHeight = 0;
  static double pageWidth = 0;
  static int readTagNum = 0;
}

abstract class ReaderNode {
  static int page = 0;
  static List<List<ReaderNode>> list = [];
  List<ReaderNode> children = [];
  late ModelStyle styleModel;
  bool isTurning;
  bool isEnter;
  bool isBranch = true;
  double? remainingHeight;
  Offset currentOffset = const Offset(0, 0);
  Offset? nextOffset;
  double currentHeight = 0;
  double currentWidth = 0;
  int uniqueId;
  bool isCurrent = false;
  List<int> hasIndexList = [];

  ReaderNode(this.styleModel, this.uniqueId,
      {this.isTurning = false, this.isEnter = false});

  void layoutBefore() {
    hasIndexList = [uniqueId];
    isTurning = false;
    isEnter = false;
  }

  List<ReaderNode> layout(double availableWidth, Offset offset,
      {isFull = true});

  void paint(Canvas canvas, Offset offset);

  void deepUpdateOffset(double dxDifference, double dyDifference) {
    for (var element in children) {
      element.deepUpdateOffset(dxDifference, dyDifference);
    }
    currentOffset = Offset(
        currentOffset.dx + dxDifference, dyDifference + currentOffset.dy);
    if (nextOffset != null) {
      nextOffset =
          Offset(nextOffset!.dx + dxDifference, dyDifference + nextOffset!.dy);
    }
  }

  ReaderNode clone() {
    return this;
  }
}

class ElementNode extends ReaderNode {
  String tag;

  ElementNode(
    this.tag,
    super.styleModel,
    super.uniqueId,
  );

  double defaultDx = 0;
  double defaultDy = 0;
  bool isOver = true;
  List<ReaderNode> truncatedNode = [];
  List<ReaderNode> nextPageNode = [];
  double currentLineHeight = 0;
  double currentLineWidth = 0;
  int truncatedIndex = -1;
  List<int> currentLineIndex = [];
  bool highlyInconsistent = false;

  @override
  List<ReaderNode> layout(double availableWidth, Offset offset, {isFull}) {
    layoutBefore();
    currentOffset = offset;
    remainingHeight ??= NodeStatus.pageHeight;
    defaultDx = offset.dx;
    double top = 0;
    if (this is BlockNode) {
      void applyEdgeInsets(EdgeInsets? insets) {
        if (insets == null) return;

        availableWidth -= insets.left + insets.right;
        defaultDx += insets.left;

        if (insets.top != 0 && isOver) {
          top += insets.top;
        }
      }

      applyEdgeInsets(styleModel.margin);
      applyEdgeInsets(styleModel.padding);
    }
    defaultDy = offset.dy + top;
    currentHeight += top;

    if (defaultDy >= NodeStatus.pageHeight && children.isNotEmpty) {
      isTurning = true;
    }

    if (isTurning) {
      final blockNode = clone();
      blockNode.currentOffset = Offset(defaultDx, 0);
      blockNode.children = children;
      children = [];
      return [blockNode];
    }
    Offset? nextChildOffset = Offset(defaultDx, defaultDy);
    double unchanged = availableWidth;
    if (children.isNotEmpty) {
      int childIndex = 0;
      while (childIndex != children.length) {
        ReaderNode child = children[childIndex];
        child.remainingHeight = NodeStatus.pageHeight - currentOffset.dy - currentHeight;
        bool isFull = unchanged == availableWidth;
        child.isBranch = isBranch;
        if (child is BlockNode) {
          currentHeight += currentLineHeight; // 加上上一行的最终高度
          currentLineHeight = 0;
          nextChildOffset = Offset(defaultDx, offset.dy + currentHeight); // 新行从当前高度开始
          truncatedNode = child.layout(unchanged, nextChildOffset);
          currentHeight += child.currentHeight;
          currentLineHeight = 0; // 清空行高
        } else {
          truncatedNode =
              child.layout(availableWidth, nextChildOffset!, isFull: isFull);
          currentLineWidth += child.currentWidth;
          if (child.currentHeight != currentLineHeight &&
              currentLineHeight > 0 &&
              !highlyInconsistent) {
            highlyInconsistent = true;
          }
          currentLineHeight =
              max(currentLineHeight, child.currentHeight); //这里再货比同一行内的所有Node的高度
          availableWidth = availableWidth - child.currentWidth;
          currentLineIndex.add(childIndex);
        }

        currentWidth = max(currentWidth, currentLineWidth);

        hasIndexList.addAll(child.hasIndexList);
        if (child.isEnter || child.isTurning || availableWidth <= 0) {
          currentHeight += currentLineHeight;
          rearrangement();
          currentLineWidth = 0;
          currentLineHeight = 0;
          currentLineIndex = [];
          if (child.isTurning) {
            isTurning = true;
            turning(childIndex);
            break;
          } else if (child.isEnter || availableWidth <= 0) {
            availableWidth = unchanged;
            nextChildOffset = Offset(defaultDx, defaultDy + currentHeight);
            childIndex++;
            children.insertAll(childIndex, truncatedNode);
            continue;
          }
        }
        nextChildOffset = child.nextOffset ?? Offset(defaultDx, defaultDy);
        childIndex++;
      }
      rearrangement();
    }

    if (currentLineHeight > 0) {
      currentHeight += currentLineHeight;
      currentLineHeight = 0;
    }

    if (this is BlockNode) {
      if (isOver) {
        currentHeight += (styleModel.padding?.bottom ?? 0);
        currentHeight += (styleModel.margin?.bottom ?? 0);
      }
    }
    nextOffset = nextChildOffset;
    if (children.isNotEmpty && truncatedIndex != -1) {
      children = children.sublist(0, truncatedIndex + 1);
    }
    return nextPageNode;
  }

  void turning(childIndex) {
    isOver = false;
    final elementNode = clone();
    truncatedNode.addAll(children.skip(childIndex + 1).toList());
    elementNode.children = truncatedNode;
    elementNode.currentOffset = Offset(defaultDx, 0);
    truncatedIndex = childIndex;
    nextPageNode = [elementNode];
  }

  void rearrangement() {
    if (currentLineIndex.isNotEmpty && highlyInconsistent) {
      for (int index in currentLineIndex) {
        ReaderNode child = children[index];
        if (child.currentHeight == currentLineHeight) continue;
        double difference = currentLineHeight - child.currentHeight;
        child.deepUpdateOffset(0, difference);
        children[index] = child;
      }
      currentLineIndex.clear();
      highlyInconsistent = false;
    }
  }

  @override
  void paint(Canvas canvas, Offset offset) {
    if (children.isNotEmpty) {
      for (ReaderNode child in children) {
        child.paint(canvas, child.currentOffset);
      }
    }
  }
} //需要交给不同对应的标签自己去绘制，有其他的子类实现绘制

class BlockNode extends ElementNode {
  BlockNode(super.tag, super.styleModel, super.uniqueId);

  @override
  BlockNode clone() {
    BlockNode copy = BlockNode(tag, styleModel,uniqueId);

    copy.isOver = isOver;
    copy.children = [];
    return copy;
  }
}

class InlineNode extends ElementNode {
  InlineNode(super.tag, super.styleModel, super.uniqueId);

  @override
  InlineNode clone() {
    InlineNode copy = InlineNode(tag, styleModel,uniqueId);

    copy.isOver = isOver;
    copy.children = [];
    return copy;
  }
}
