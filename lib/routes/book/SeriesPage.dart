import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/entity/book/SeriesItem.dart';
import 'package:DReader/main.dart';
import 'package:DReader/routes/book/widgets/SeriesDrawer.dart';
import 'package:DReader/routes/book/widgets/SeriesItems.dart';
import 'package:DReader/state/book/SeriesListState.dart';
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
    ref.read(seriesListStateProvider.notifier).getList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seriesListStateProvider);
    return TopTool(
      title: "图书",
      endDrawer: const SeriesDrawer(),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          child: const Icon(Icons.list),
        );
      }),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            if (constraints.maxWidth > MyApp.width) ToolBar(widgetList: [
              Text("共${state.count}本图书"),
              IconButton(onPressed: (){
                ref.read(seriesListStateProvider.notifier).reload();
              }, icon: const Icon(Icons.refresh),tooltip: "刷新列表",),
              IconButton(onPressed: (){
                ref.read(seriesListStateProvider.notifier).scanning();
              }, icon: const Icon(Icons.featured_play_list_sharp),tooltip: "扫描图书",)
            ]),
            Expanded(
                child: ListWidget<SeriesItem>(
                    list: state.data,
                    count: state.count,
                    scale: .7,
                    widget: (SeriesItem data, index,
                        {show = false, isPc = true}) {
                      return SeriesItems(
                        data: data,
                        index: index,
                        show: show,
                        isPc: isPc,
                      );
                    },
                    getList: () =>
                        ref.read(seriesListStateProvider.notifier).getList())),
          ],
        );
      }),
    );
  }
}
