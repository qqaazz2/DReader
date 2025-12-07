import 'dart:typed_data';

import 'package:DReader/common/EpubParsing.dart';
import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/common/ImageModule.dart';
import 'package:DReader/entity/book/BookItem.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/main.dart';
import 'package:DReader/state/book/FilesListState.dart';
import 'package:DReader/state/book/SeriesContentState.dart';
import 'package:DReader/widgets/ListWidget.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class BookCoverChange extends ConsumerStatefulWidget {
  final FilesItem filesItem;
  final int index;

  const BookCoverChange(
      {super.key,
      required this.filesItem,
      required this.index});

  @override
  ConsumerState<BookCoverChange> createState() => BookCoverChangeState();
}

class BookCoverChangeState extends ConsumerState<BookCoverChange> {
  List<int> bytes = [];
  List<String> list = [];
  late EpubParsing epubParsing;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getImage();
  }

  void getImage() async {
    String encodedFilePath = Uri.encodeFull(
      widget.filesItem.filePath.replaceAll('\\', '/').substring(1),
    );
    bytes = await HttpApi.request(
      "/$encodedFilePath",
      responseType: ResponseType.bytes,
      () => {},
      isLoading: false,
    );
    epubParsing = EpubParsing();
    list = await epubParsing.parseEpubImageFromBytes(bytes);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth > MyApp.width
          ? constraints.maxWidth * 0.7
          : constraints.maxWidth;
      double height = constraints.maxWidth > MyApp.width
          ? constraints.maxHeight * 0.9
          : constraints.maxHeight;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: width,
        height: height,
        child: Column(children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "选择封面",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close))
              ]),
          isLoading
              ? const Expanded(child: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
                constraints: BoxConstraints(
                    minWidth: 150,
                    minHeight: 150,
                    maxWidth: 150,
                    maxHeight: 150)),
          ))
              : Expanded(
                  child: ListWidget<String>(
                      list: list,
                      count: list.length,
                      widget: (String data, index,
                          {show = false, isPc = true}) {
                        List<int>? bytes = epubParsing.getImage(data);
                        return BookCover(
                          data: data,
                          index: index,
                          image: bytes,
                          voidCallback: () => ref
                              .read(filesListStateProvider(widget.filesItem.parentId)
                              .notifier)
                              .changeCover(
                              widget.filesItem.id, bytes!, widget.index),
                        );
                      },
                      scale: 0.7,
                      getList: () => {}))
        ]),
      );
    });
  }
}

class BookCover extends ListItem<String> {
  const BookCover(
      {super.key,
      required super.data,
      required super.index,
      required this.image,
      required this.voidCallback});

  final VoidCallback voidCallback;

  final List<int>? image;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BookCoverState();
}

class BookCoverState extends ConsumerState<BookCover> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      widget.image == null
          ? Expanded(child: Image.asset("images/img.png"))
          : Expanded(
              child: GestureDetector(
              child: Image.memory(Uint8List.fromList(widget.image!)),
              onTap: () => widget.voidCallback(),
            )),
      Text(widget.data)
    ]);
  }
}
