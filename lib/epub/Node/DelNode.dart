import 'package:flutter/material.dart';
import 'package:DReader/epub/CssToTextstyle.dart';
import 'package:DReader/epub/ReaderNode.dart';

class DelNode extends InlineNode {
  DelNode(super.tag, super.styleModel, super.uniqueId) {
    styleModel = styleModel.merge(ModelStyle(textStyle: const TextStyle(decoration: TextDecoration.lineThrough)));
  }
}
