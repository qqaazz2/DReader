import 'dart:ui';

import 'package:DReader/epub/ReaderNode.dart';

class BrNode extends BlockNode {
  BrNode(super.tag, super.styleModel, super.uniqueId);

  @override
  List<ReaderNode> layout(double availableWidth, Offset offset, {isFull}) {
    layoutBefore();
    currentOffset = offset;
    double dy = currentOffset.dy + 18;
    if(remainingHeight! < 18){
      isTurning = true;
      return [clone()];
    }
    currentHeight = 18;
    nextOffset = Offset(defaultDx, dy);
    return [];
  }

  @override
  BrNode clone() {
    return BrNode(tag, styleModel,uniqueId);
  }
}
