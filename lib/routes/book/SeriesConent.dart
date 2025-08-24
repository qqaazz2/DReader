import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/common/Global.dart';
import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/common/ImageModule.dart';
import 'package:DReader/entity/book/BookItem.dart';
import 'package:DReader/main.dart';
import 'package:DReader/routes/book/widgets/BookItems.dart';
import 'package:DReader/routes/book/widgets/SeriesChangeCover.dart';
import 'package:DReader/routes/book/widgets/SeriesDetails.dart';
import 'package:DReader/state/book/SeriesContentState.dart';
import 'package:DReader/state/book/SeriesListState.dart';
import 'package:DReader/widgets/ListWidget.dart';

import 'SeriesForm.dart';

class SeriesContent extends ConsumerStatefulWidget {
  const SeriesContent(
      {super.key,
      required this.filesId,
      required this.seriesId,
      required this.index});

  final int seriesId;
  final int filesId;
  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SeriesContentState();
}

class SeriesContentState extends ConsumerState<SeriesContent> {
  @override
  void initState() {
    super.initState();
    ref
        .read(seriesContentStateProvider(widget.seriesId).notifier)
        .getData(widget.filesId);
  }

  Map<String, String> map = {"Authorization": "Bearer ${Global.token}"};

  Map<int, String> overMap = {1: "连载中", 2: "完结", 3: "弃坑", 4: "有生之年"};
  Map<int, String> readMap = {1: "未读", 2: "已读", 3: "在读"};

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seriesContentStateProvider(widget.seriesId));
    if (state.seriesItem == null) {
      return const Center(
        child: SizedBox(
          width: 150,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 6,
                color: Colors.blue,
              ),
              SizedBox(height: 16), // 间距
              Text(
                '加载中…',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    return PopScope(
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (widget.index == 1) {
            ref
                .read(seriesListStateProvider.notifier)
                .setData(state.seriesItem!);
          }
        },
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: SafeArea(
                  child: NestedScrollView(
                body: Container(
                    constraints: const BoxConstraints(minWidth: 200),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4))
                        ]),
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: ListWidget<BookItem>(
                                  list: state.bookItem!,
                                  count: state.bookItem!.length,
                                  scale: .7,
                                  widget: (BookItem data, index,
                                      {show = false, isPc = true}) {
                                    return BookItems(
                                      data: data,
                                      index: index,
                                      show: show,
                                      isPc: isPc,
                                      seriesId: widget.seriesId,
                                    );
                                  },
                                  getList: () => {}))
                        ])),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return MyApp.width < MediaQuery.of(context).size.width
                      ? getPc(state)
                      : getMobile(state);
                },
              )),
              // child: Row(
              //   children: [
              //     SizedBox(
              //         width: 100,
              //         child: AspectRatio(
              //             aspectRatio: 9 / 13,
              //             child: imageModule(splicingPath(seriesItem.filePath)))),
              //     SingleChildScrollView(
              //       child: Column(
              //         mainAxisSize: MainAxisSize.max,
              //         children: [
              //           Padding(
              //               padding: const EdgeInsets.only(bottom: 10),
              //               child: Text(
              //                 seriesItem.name,
              //                 style: const TextStyle(fontSize: 20),
              //                 maxLines: 2,
              //               )),
              //           // Padding(padding: EdgeInsets)
              //         ],
              //       ),
              //     )
              //   ],
              // ),
            )
          ],
        ));
  }

  List<Widget> getPc(state) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return [
      SliverAppBar(
        pinned: true,
        expandedHeight: 400,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: Stack(children: [
            SizedBox(
                child: ImageModule.imageModule(state.seriesItem!.minioCover,
                    baseUrl: false, fit: BoxFit.cover)),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Theme.of(context).cardColor.withAlpha(180),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  SizedBox(
                      width: 250,
                      child: Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 3,
                          child: ImageModule.imageModule(
                              state.seriesItem!.minioCover,
                              baseUrl: false,
                              fit: BoxFit.fitHeight))),
                  const SizedBox(width: 20),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.seriesItem!.name,
                          style: textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "${state.seriesItem!.author}",
                          style: textTheme.titleMedium?.copyWith(fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.history, size: 18),
                            const SizedBox(width: 3),
                            Text.rich(
                                overflow: TextOverflow.ellipsis,
                                TextSpan(children: [
                                  TextSpan(
                                      text: "上次阅读：",
                                      style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                    text: state.seriesItem!.lastReadTime ?? "无",
                                    style: textTheme.bodyLarge,
                                  ),
                                ])),
                          ],
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          constraints:
                              const BoxConstraints(minWidth: 0, maxWidth: 500),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: "简介：",
                                      style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: state.seriesItem!.profile ?? "无",
                                      style: textTheme.bodyLarge,
                                    ),
                                  ]),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3, // 最多显示3行
                                ),
                              ),
                            ],
                          )),
                      const Spacer(),
                      Wrap(
                        spacing: 5,
                        runSpacing: 10,
                        children: [
                          Chip(
                            avatar: const Icon(
                              Icons.bookmark,
                              size: 16,
                            ),
                            label:
                                Text(readMap[state.seriesItem!.status] ?? "未知"),
                            visualDensity: VisualDensity.compact,
                          ),
                          Chip(
                            avatar: const Icon(
                              Icons.check_circle,
                              size: 16,
                            ),
                            label: Text(
                                overMap[state.seriesItem!.overStatus] ?? "未知"),
                            visualDensity: VisualDensity.compact,
                          ),
                          IconButton(
                            onPressed: () {
                              ref
                                  .read(seriesContentStateProvider(
                                          widget.seriesId)
                                      .notifier)
                                  .setLove();
                            },
                            icon: Icon(state.seriesItem!.love == 1
                                ? Icons.favorite_border
                                : Icons.favorite),
                            color: Colors.redAccent,
                          ),
                          IconButton(
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SeriesForm(
                                      index: widget.index,
                                      seriesId: widget.seriesId,
                                      seriesItem: state.seriesItem!,
                                    );
                                  }),
                              icon: const Icon(Icons.edit_note_sharp))
                        ],
                      )
                    ],
                  )),
                ],
              ),
            )
          ]),
          centerTitle: false,
        ),
      ),
    ];
  }

  List<Widget> getMobile(state) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return [
      SliverAppBar(
        pinned: true,
        expandedHeight: 400,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: ImageModule.imageModule(state.seriesItem!.minioCover,
              baseUrl: false, fit: BoxFit.fitHeight),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        sliver: SliverToBoxAdapter(
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ]),
              width: double.infinity,
              child: Consumer(builder: (content, ref, child) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.seriesItem!.name,
                        style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Padding(
                      padding: const EdgeInsets.only(top: 7, bottom: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 15,
                          ),
                          const SizedBox(width: 5),
                          Text("${state.seriesItem!.author}")
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.bookmark_border,
                            size: 15,
                          ),
                          const SizedBox(width: 5),
                          Text("阅读状态：${readMap[state.seriesItem!.status]}")
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified,
                            size: 15,
                          ),
                          const SizedBox(width: 5),
                          Text("完结状态：${overMap[state.seriesItem!.overStatus]}")
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.history,
                              size: 15,
                            ),
                            const SizedBox(width: 5),
                            Text(
                                "上次阅读：${state.seriesItem!.lastReadTime ?? "无"}"),
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            ref
                                .read(
                                    seriesContentStateProvider(widget.seriesId)
                                        .notifier)
                                .setLove();
                          },
                          constraints:
                              const BoxConstraints(minWidth: 30, maxHeight: 30),
                          icon: Icon(
                              state.seriesItem!.love == 1
                                  ? Icons.favorite_border
                                  : Icons.favorite,
                              size: 20),
                          color: Colors.redAccent,
                        ),
                        IconButton(
                            onPressed: () => showDialog(
                                context: context,
                                builder: (context) {
                                  return SeriesForm(
                                    index: widget.index,
                                    seriesId: widget.seriesId,
                                    seriesItem: state.seriesItem!,
                                  );
                                }),
                            constraints: const BoxConstraints(
                                minWidth: 30, maxHeight: 30),
                            icon: const Icon(
                              Icons.edit_note_sharp,
                              size: 20,
                            ))
                      ],
                    )
                  ],
                );
              })),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        sliver: SliverToBoxAdapter(
          child: Container(
              constraints: const BoxConstraints(minHeight: 100),
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ]),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "简介",
                    style: TextStyle(fontSize: 17),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(state.seriesItem!.profile ?? "无"),
                  )
                ],
              )),
        ),
      ),
    ];
  }
}
