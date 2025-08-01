import 'dart:ui';

import 'package:DReader/epub/ReaderNode.dart';

class PageNodes {
  List<List<ReaderNode>> list = [];
  int pageCount = 0;
  int readRecodesIndex;
  double pageHeight;
  double pageWidth;
  bool isColumn;
  int columnNum;
  List<List<ReaderNode>> unallocated;
  int readPage = 0;

  void _paginateChapter(List<ReaderNode> chapterRootNodes) {
    NodeStatus.pageHeight = pageHeight;
    NodeStatus.pageWidth = pageWidth;

    List<ReaderNode> nodesToLayout = List.from(chapterRootNodes);
    while (nodesToLayout.isNotEmpty) {
      final List<ReaderNode> currentPageNodes = [];
      List<ReaderNode> nodesForNextPage = [];
      Offset currentOffset = Offset.zero;

      for (int i = 0; i < nodesToLayout.length; i++) {
        final node = nodesToLayout[i];
        List<ReaderNode> spillover = node.layout(pageWidth, currentOffset);
        currentPageNodes.add(node);
        if (node.hasIndexList.contains(readRecodesIndex))readPage = list.length + currentPageNodes.length;
        if (spillover.isNotEmpty) {
          nodesForNextPage.addAll(spillover);
          if (i + 1 < nodesToLayout.length) {
            nodesForNextPage.addAll(nodesToLayout.sublist(i + 1));
          }
          break;
        }
        currentOffset = node.nextOffset ?? const Offset(0, 0);
      }

      if (currentPageNodes.isNotEmpty) {
        list.add(currentPageNodes);
      } else if (nodesToLayout.isNotEmpty && nodesForNextPage.isEmpty) {
        nodesForNextPage = List.from(nodesToLayout);
      }
      nodesToLayout = nodesForNextPage;
    }
  }

  void _start() {
    for (var item in unallocated) {
      _paginateChapter(item);
    }
    pageCount = isColumn ? (list.length / columnNum).ceil() : list.length;
    readPage = isColumn ? (readPage / columnNum).ceil() : readPage;
  }

  PageNodes(this.unallocated, this.pageWidth, this.pageHeight,
      {this.isColumn = false, this.columnNum = 2, this.readRecodesIndex = 0}) {
    _start();
  }
}
