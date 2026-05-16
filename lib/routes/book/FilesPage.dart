import 'package:DReader/widgets/CheckHandleItem.dart';
import 'package:DReader/status/BookStatus.dart';
import 'package:DReader/widgets/ScanningIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/main.dart';
import 'package:DReader/routes/book/widgets/SeriesDrawer.dart';
import 'package:DReader/routes/book/widgets/FilesItems.dart';
import 'package:DReader/state/book/FilesListState.dart';
import 'package:DReader/widgets/ListWidget.dart';
import 'package:DReader/widgets/ToolBar.dart';
import 'package:DReader/widgets/TopTool.dart';
import 'package:popover/popover.dart';

class SeriesPage extends ConsumerStatefulWidget {
  const SeriesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SeriesPageState();
}

class SeriesPageState extends ConsumerState<SeriesPage> {
  @override
  void initState() {
    super.initState();
    ref.read(filesListStateProvider("-1").notifier).getList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filesListStateProvider("-1"));
    return TopTool(
      title: "图书",
      endDrawer: const SeriesDrawer(),
      actions: [
        Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(Icons.filter_list),
            );
          },
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              if (constraints.maxWidth > MyApp.width)
                ToolBar(
                  title: "图书",
                  widgetList: [
                    Text("共${state.count}个系列"),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(filesListStateProvider("-1").notifier)
                            .reload();
                      },
                      icon: const Icon(Icons.refresh),
                      tooltip: "刷新列表",
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(filesListStateProvider("-1").notifier)
                            .scanning();
                      },
                      icon: const Icon(Icons.featured_play_list_sharp),
                      tooltip: "扫描图书",
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(filesListStateProvider("-1").notifier)
                            .coverScanning();
                      },
                      icon: const Icon(Icons.image_search),
                      tooltip: "扫描封面",
                    ),
                    IconButton(
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      icon: const Icon(Icons.filter_list),
                    ),
                  ],
                ),
              Expanded(
                child: ListWidget<FilesItem>(
                  nodeKey: "${ref.read(filesListStateProvider("-1").notifier).patentId}${ref.read(filesListStateProvider("-1").notifier).seriesParam.hashCode}",
                  list: state.data,
                  count: state.count,
                  scale: .7,
                  widget: (FilesItem data, index) {
                    return FilesItems(
                      data: data,
                      index: index,
                      parentId: data.parentId,
                    );
                  },
                  checkHandle: (List<FilesItem> selectDataList) {
                    return [
                      CheckHandleItem(
                        map: BookStatus.readStatus,
                        text: "更新阅读状态",
                        onTap: (Object key) => ref
                            .read(filesListStateProvider("-1").notifier)
                            .updateStatus(selectDataList, key as int, "status"),
                        iconData: Icons.edit,
                      ),
                      CheckHandleItem(
                        map: BookStatus.overStatus,
                        text: "更新连载状态",
                        onTap: (Object key) => ref
                            .read(filesListStateProvider("-1").notifier)
                            .updateStatus(
                              selectDataList,
                              key as int,
                              "overStatus",
                            ),
                        iconData: Icons.edit,
                        height: 200,
                      ),
                      CheckHandleItem(
                        map: BookStatus.loveStatus,
                        text: "更新收藏状态",
                        onTap: (Object key) => ref
                            .read(filesListStateProvider("-1").notifier)
                            .updateStatus(
                              selectDataList,
                              key as int,
                              "love",
                            ),
                        iconData: Icons.favorite,
                      ),
                    ];
                  },
                  getList: () =>
                      ref.read(filesListStateProvider("-1").notifier).getList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
