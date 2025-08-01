import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:DReader/common/Global.dart';
import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/common/ImageModule.dart';
import 'package:DReader/entity/book/SeriesItem.dart';
import 'package:DReader/entity/book/SeriesItem.dart';
import 'package:DReader/entity/book/SeriesItem.dart';
import 'package:DReader/routes/book/SeriesForm.dart';
import 'package:DReader/state/book/SeriesListState.dart';
import 'package:DReader/widgets/ListWidget.dart';

class SeriesItems extends FilesItem<SeriesItem> {
  const SeriesItems(
      {super.key,
      required super.data,
      required super.index,
      required super.show,
      required super.isPc});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SeriesItemsState();
}

class SeriesItemsState extends ConsumerState<SeriesItems> {
  Map<String, String> map = {"Authorization": "Bearer ${Global.token}"};

  final over = [
    "连载中",
    "完结",
    "弃坑",
  ];

  final status = [
    Colors.redAccent,
    Colors.transparent,
    Colors.amberAccent,
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seriesListStateProvider);
    SeriesItem data = widget.data;
    return GestureDetector(
        child: Card(
          color: Theme.of(context).cardColor.withAlpha(255),
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.zero,
          child: Column(
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
                        backgroundColor: status[data.status - 1],
                      )),
                  Positioned(
                      left: 5,
                      bottom: 5,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(150),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          over[data.overStatus - 1],
                          style: const TextStyle(color: Colors.white),
                        ),
                      )),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Column(
                        children: [
                          IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 23,
                              constraints: const BoxConstraints(minWidth: 30,minHeight: 30),
                              onPressed: () => ref
                                  .read(seriesListStateProvider.notifier)
                                  .setLove(widget.index),
                              icon: Icon(
                                data.love == 1
                                    ? Icons.favorite_border
                                    : Icons.favorite,
                                color: Colors.redAccent,
                              )),
                          IconButton(
                            iconSize: 23,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 30,minHeight: 30),
                            icon: const Icon(
                              Icons.edit_note_sharp,
                            ),
                            color: Colors.grey.shade300,
                            onPressed: () => showDialog(
                                context: context,
                                builder: (context) {
                                  return SeriesForm(
                                    index: widget.index,
                                    seriesItem: data,
                                  );
                                }),
                          )
                        ],
                      )),
                ],
              )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  data.name,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          context.push(
              "/books/content?seriesId=${data.id}&filesId=${data.filesId}&index=1");
        });
  }
}
