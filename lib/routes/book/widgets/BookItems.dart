import 'package:DReader/routes/book/widgets/BookCoverChange.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:DReader/common/Global.dart';
import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/common/ImageModule.dart';
import 'package:DReader/entity/book/BookItem.dart';
import 'package:DReader/entity/book/BookItem.dart';
import 'package:DReader/entity/book/BookItem.dart';
import 'package:DReader/routes/book/SeriesForm.dart';
import 'package:DReader/state/book/SeriesContentState.dart';
import 'package:DReader/state/book/SeriesListState.dart';
import 'package:DReader/widgets/ListWidget.dart';

class BookItems extends FilesItem<BookItem> {
  const BookItems(
      {super.key,
      required super.data,
      required super.index,
      required super.show,
      required super.isPc,
      required this.seriesId});

  final int seriesId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BookItemsState();
}

class BookItemsState extends ConsumerState<BookItems> {
  Map<String, String> map = {"Authorization": "Bearer ${Global.token}"};

  final status = {
    1: Colors.redAccent,
    2: Colors.transparent,
    3: Colors.amberAccent,
  };

  void changeCover(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: BookCoverChange(
                  bookItem: widget.data, seriesId: widget.seriesId,index: index,));
        });
  }

  @override
  Widget build(BuildContext context) {
    BookItem data = widget.data;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
          child: data.isFolder == 2
              ? getBookWidget(data)
              : Column(
                  children: [
                    Image.asset("images/img.png", fit: BoxFit.fill),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        data.name!,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
          onTap: () {
            ref
                .read(seriesContentStateProvider(widget.seriesId).notifier)
                .updateLastReadTime(widget.seriesId);
            context.push("/books/read?seriesId=${widget.seriesId}",
                extra: widget.data);
          }),
    );
  }

  Widget getBookWidget(BookItem data) {
    return Column(
      children: [
        Expanded(
            child: Stack(
          children: [
            ImageModule.imageModule(data.minioCover, baseUrl: false),
            Positioned(
                right: 5,
                top: 5,
                child: Badge(
                  smallSize: 10,
                  backgroundColor: status[data.status],
                )),
            Positioned(
                bottom: 0,
                right: 0,
                child: Column(
                  children: [
                    IconButton(
                        iconSize: 20,
                        tooltip: "设为系列封面",
                        icon: const Icon(
                          Icons.image,
                        ),
                        color: Colors.grey,
                        onPressed: () {
                          ref
                              .read(seriesContentStateProvider(widget.seriesId)
                                  .notifier)
                              .setCover(widget.data);
                        }),
                    IconButton(
                        iconSize: 20,
                        tooltip: "更换书籍封面",
                        icon: const Icon(
                          Icons.image_search,
                        ),
                        color: Colors.grey,
                        onPressed: () => changeCover(widget.index))
                  ],
                )),
          ],
        )),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            textAlign: TextAlign.center,
            data.name!,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
