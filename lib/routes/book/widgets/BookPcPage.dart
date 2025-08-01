import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DReader/epub/ReaderNode.dart';
import 'package:DReader/epub/ReaderNode.dart';
import 'package:DReader/epub/ReaderPainter.dart';
import 'package:DReader/routes/book/BookRead.dart';

class BookPcPage extends StatefulWidget {
  const BookPcPage({super.key, required this.list, required this.list2});

  final List<ReaderNode> list;
  final List<ReaderNode> list2;

  @override
  State<BookPcPage> createState() => BookPcPageState();
}

class BookPcPageState extends State<BookPcPage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        item(widget.list),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(color: Colors.grey),
          width: 1,
        ),
        item(widget.list2)
      ],
    );
  }

  Widget item(List<ReaderNode> list) {
    return Expanded(
        child:CustomPaint(
          painter: ReaderPainter(list),
        )
    );
  }
}
