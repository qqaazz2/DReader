import 'package:flutter/material.dart';
import 'package:DReader/epub/CssToTextstyle.dart';
import 'package:DReader/epub/ReaderNode.dart';

class BNode extends InlineNode {
  BNode(super.tag, super.styleModel,super.uniqueId) {
    styleModel = styleModel.merge(ModelStyle(
        textStyle: const TextStyle(fontWeight: FontWeight.bold)));
  }
}
