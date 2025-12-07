import 'dart:ui';

import 'package:DReader/entity/book/FilesDetailsItem.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/routes/book/widgets/FilesItems.dart';
import 'package:DReader/state/book/FilesDetailsItemState.dart';
import 'package:DReader/state/book/FilesGlobalUpdateState.dart';
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
import 'package:DReader/state/book/SeriesContentState.dart';
import 'package:DReader/state/book/FilesListState.dart';
import 'package:DReader/widgets/ListWidget.dart';
import 'package:provider/provider.dart' hide Consumer;

import 'FilesForm.dart';

class SeriesContent extends ConsumerStatefulWidget {
  const SeriesContent({
    super.key,
    required this.filesItem,
  });


  final FilesItem filesItem;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SeriesContentState();
}

class SeriesContentState extends ConsumerState<SeriesContent> {
  bool listLoading = true;
  @override
  void initState() {
    super.initState();
    ref.read(filesListStateProvider(widget.filesItem.filesId).notifier).getList();
  }

  Map<String, String> map = {"Authorization": "Bearer ${Global.token}"};

  Map<int, String> overMap = {1: "连载中", 2: "完结", 3: "弃坑", 4: "有生之年"};
  Map<int, String> readMap = {1: "未读", 2: "已读", 3: "在读"};

  @override
  Widget build(BuildContext context) {
    AsyncValue<FilesDetailsItem?> asyncValue = ref.watch(
      filesDetailsItemStateProvider(widget.filesItem.filesId),
    );
    final state = ref.watch(filesListStateProvider(widget.filesItem.filesId));
    return asyncValue.when(
      data: (FilesDetailsItem? item) {
        return PopScope(
          onPopInvokedWithResult: (bool didPop, Object? result) {
            if(item == null) return;
            final provider = filesDetailsItemStateProvider(widget.filesItem.parentId);
            if (ref.exists(provider)) {
              ref.read(provider.notifier).updateReadStatus(item.lastReadTime);
            }
            FilesItem filesItem = FilesItem(item.id, item.love, item.cover, item.name, item.overStatus, item.status, item.filesId, item.isFolder, widget.filesItem.parentId, widget.filesItem.filePath);
            ref.read(filesGlobalUpdateStateProvider).add(filesItem);
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
                            color: Theme.of(
                              context,
                            ).shadowColor.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListWidget<FilesItem>(
                                  list: state.data,
                                  count: state.count,
                                  scale: .7,
                                  widget:
                                      (
                                      FilesItem data,
                                        index, {
                                        show = false,
                                        isPc = true,
                                      }) {
                                        return FilesItems(
                                          data: data,
                                          index: index,
                                          show: show,
                                          isPc: isPc,
                                          parentId: widget.filesItem.filesId,
                                        );
                                      },
                                  getList: () => ref.read(filesListStateProvider(widget.filesItem.filesId).notifier).getList(),
                                ),
                          ),
                        ],
                      ),
                    ),
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                          return MyApp.width < MediaQuery.of(context).size.width
                              ? getPc(item)
                              : getMobile(item);
                        },
                  ),
                ),
              ),
            ],
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        print(stackTrace);
        return Center(
          child: Text(
            '加载失败: $error',
            style: const TextStyle(color: Colors.red),
          ),
        );
      },
      loading: () {
        return const Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(strokeWidth: 6, color: Colors.blue),
                SizedBox(height: 16), // 间距
                Text(
                  '加载中…',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> getPc(FilesDetailsItem? state) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return [
      SliverAppBar(
        pinned: true,
        expandedHeight: 400,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: Stack(
            children: [
              SizedBox(
                child: ImageModule.getImage(state?.cover, fit: BoxFit.cover),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Theme.of(context).cardColor.withAlpha(180),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 250,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 3,
                        child: ImageModule.getImage(
                          state?.cover,
                          fit: BoxFit.fitHeight,
                          isMemCache: false
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state?.name ?? "",
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                          Text(
                            state?.originalName ?? "",
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: getRawChipList(
                                  state?.filesAuthors ?? [],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.numbers, size: 18),
                                const SizedBox(width: 3),
                                Text.rich(
                                  overflow: TextOverflow.ellipsis,
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "BGMID：",
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: state?.bgmId.toString() ?? "无",
                                        style: textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.history_rounded, size: 18),
                                const SizedBox(width: 3),
                                Text.rich(
                                  overflow: TextOverflow.ellipsis,
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "上次阅读：",
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: state?.lastReadTime ?? "无",
                                        style: textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.timelapse_rounded, size: 18),
                                const SizedBox(width: 3),
                                Text.rich(
                                  overflow: TextOverflow.ellipsis,
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "发行时间：",
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: state?.date ?? "无",
                                        style: textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  const Icon(Icons.tag_rounded, size: 18),
                                  const SizedBox(width: 3),
                                  Text(
                                    "标签：",
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ...getRawChipList(state?.filesTags ?? []),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.file_copy, size: 18),
                                const SizedBox(width: 3),
                                Text.rich(
                                  overflow: TextOverflow.ellipsis,
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "文件地址：",
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: state?.filePath ?? "无",
                                        style: textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            constraints: const BoxConstraints(minWidth: 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "简介：",
                                          style: textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        TextSpan(
                                          text: state?.profile ?? "无",
                                          style: textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1, // 最多显示3行
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Wrap(
                            spacing: 5,
                            runSpacing: 10,
                            children: [
                              Chip(
                                avatar: const Icon(Icons.bookmark, size: 16),
                                label: Text(readMap[state?.status] ?? "未知"),
                                visualDensity: VisualDensity.compact,
                              ),
                              Chip(
                                avatar: const Icon(
                                  Icons.check_circle,
                                  size: 16,
                                ),
                                label: Text(overMap[state?.overStatus] ?? "未知"),
                                visualDensity: VisualDensity.compact,
                              ),
                              IconButton(
                                onPressed: () {
                                  ref
                                      .read(
                                        filesDetailsItemStateProvider(
                                          widget.filesItem.filesId,
                                        ).notifier,
                                      )
                                      .setLove();
                                },
                                icon: Icon(
                                  state?.love == 1
                                      ? Icons.favorite_border
                                      : Icons.favorite,
                                ),
                                color: Colors.redAccent,
                              ),
                              IconButton(
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return FilesForm(
                                      filesId: state!.filesId,
                                    );
                                  },
                                ),
                                icon: const Icon(Icons.edit_note_sharp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          centerTitle: false,
        ),
      ),
    ];
  }

  List<Widget> getMobile(FilesDetailsItem? state) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return [
      SliverAppBar(
        pinned: true,
        expandedHeight: 400,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: ImageModule.getImage(state?.cover, fit: BoxFit.fitHeight,isMemCache: false),
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
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            width: double.infinity,
            child: Consumer(
              builder: (content, ref, child) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state?.name ?? "",
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      state?.originalName ?? "",
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7, bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.person, size: 15),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Wrap(
                              children: getRawChipList(
                                state?.filesAuthors ?? [],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.bookmark_border, size: 15),
                          const SizedBox(width: 5),
                          Text("阅读状态：${readMap[state?.status]}"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.verified, size: 15),
                          const SizedBox(width: 5),
                          Text("完结状态：${overMap[state?.overStatus]}"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.history, size: 15),
                          const SizedBox(width: 5),
                          Text("上次阅读：${state?.lastReadTime ?? "无"}"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.timelapse, size: 15),
                          const SizedBox(width: 5),
                          Text("发行时间：${state?.date ?? "无"}"),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => ref
                              .read(
                                filesDetailsItemStateProvider(
                                  widget.filesItem.filesId,
                                ).notifier,
                              )
                              .setLove(),
                          constraints: const BoxConstraints(
                            minWidth: 30,
                            maxHeight: 30,
                          ),
                          icon: Icon(
                            state?.love == 1
                                ? Icons.favorite_border
                                : Icons.favorite,
                            size: 20,
                          ),
                          color: Colors.redAccent,
                        ),
                        IconButton(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) {
                              return SizedBox();
                              // return SeriesForm(
                              //   index: widget.index,
                              //   seriesId: widget.seriesId,
                              //   seriesItem: state ?,
                              // );
                            },
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 30,
                            maxHeight: 30,
                          ),
                          icon: const Icon(Icons.edit_note_sharp, size: 20),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("标签", style: TextStyle(fontSize: 17)),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Wrap(children: getRawChipList(state?.filesTags ?? [])),
                ),
              ],
            ),
          ),
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
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("简介", style: TextStyle(fontSize: 17)),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(state?.profile ?? "无"),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> getRawChipList(List list) {
    return list
            .map(
              (item) => Container(
                margin: const EdgeInsetsGeometry.only(left: 5, bottom: 5),
                child: RawChip(
                  label: Text(item.name, style: const TextStyle(fontSize: 12)),
                ),
              ),
            )
            .toList() ??
        [];
  }
}
