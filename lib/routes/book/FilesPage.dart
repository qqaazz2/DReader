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

class SeriesPage extends ConsumerStatefulWidget {
  const SeriesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SeriesPageState();
}

class SeriesPageState extends ConsumerState<SeriesPage> {
  @override
  void initState() {
    super.initState();
    ref.read(filesListStateProvider(-1).notifier).getList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filesListStateProvider(-1));
    return TopTool(
      title: "图书",
      endDrawer: const SeriesDrawer(),
      actions: [
        Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(Icons.filter_list));
        })
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            if (constraints.maxWidth > MyApp.width)
              ToolBar(title: "图书", widgetList: [
                Text("共${state.count}个系列"),
                IconButton(
                    onPressed: () {
                      ref.read(filesListStateProvider(-1).notifier).reload();
                    },
                    icon: const Icon(Icons.refresh),
                    tooltip: "刷新列表"),
                IconButton(
                    onPressed: () {
                      ref.read(filesListStateProvider(-1).notifier).scanning();
                    },
                    icon: const Icon(Icons.featured_play_list_sharp),
                    tooltip: "扫描图书"),
                IconButton(
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    icon: const Icon(Icons.filter_list))
              ]),
            Expanded(
                child: ListWidget<FilesItem>(
                    list: state.data,
                    count: state.count,
                    scale: .7,
                    widget: (FilesItem data, index,
                        {show = false, isPc = true}) {
                      return FilesItems(
                        data: data,
                        index: index,
                        show: show,
                        isPc: isPc,
                        parentId: data.parentId,
                      );
                    },
                    getList: () =>
                        ref.read(filesListStateProvider(-1).notifier).getList())),
          ],
        );
      }),
    );
  }
}
