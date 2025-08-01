import 'package:flutter/material.dart';

import 'ReaderNode.dart';

class ReaderPainter extends CustomPainter {
  final List<ReaderNode> nodeList;

  ReaderPainter(this.nodeList);

  @override
  void paint(Canvas canvas, Size size) {
    for (ReaderNode node in nodeList) {
      node.paint(canvas, node.currentOffset); // 再绘制
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
