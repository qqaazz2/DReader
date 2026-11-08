import 'package:DReader/entity/book/FilesDownload.dart';
import 'package:DReader/main.dart';
import 'package:DReader/state/LocalState.dart';
import 'package:DReader/state/book/FilesDownloadState.dart';
import 'package:DReader/widgets/Download/LocalItems.dart';
import 'package:DReader/widgets/ListWidget.dart';
import 'package:DReader/widgets/ToolBar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/TopTool.dart';
import 'book/widgets/FilesItems.dart';

class LocalPage extends ConsumerStatefulWidget {
  const LocalPage({super.key});

  @override
  ConsumerState<LocalPage> createState() => LocalPageState();
}

class LocalPageState extends ConsumerState<LocalPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    ref.read(localStateProvider.notifier).getList();
  }

  void syncProgress() async{
    setState(() => isLoading = true );
    await ref.read(localStateProvider.notifier).syncProgress();
    setState(() =>isLoading = false );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(child: getWidget(), canPop: isLoading);
  }

  Widget getWidget() {
    List<FilesDownload> list = ref.watch(localStateProvider);
    bool isReady = ref.read(localStateProvider.notifier).isReady;
    if (!isReady) {
      return const Center(
        child: Column(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
            Text("正在检查本地缓存文件，请稍后..."),
          ],
        ),
      );
    }

    return TopTool(
      title: '离线模式',
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
                    child: ToolBar(
                      title: "离线模式",
                      widgetList: [
                        Text("共${list.length}本书籍"),
                        IconButton(
                          onPressed: () => syncProgress(),
                          icon: const Icon(Icons.sync_alt),
                          tooltip: "同步数据",
                        ),
                        IconButton(
                          onPressed: () => context.go("/home"),
                          icon: const Icon(Icons.cloud_outlined),
                          tooltip: "在线模式",
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListWidget<FilesDownload>(
                      nodeKey: "localPage",
                      checkHandle: (List<FilesDownload> selectDataList) {
                        return [
                          ElevatedButton.icon(
                            onPressed: () {
                              ref
                                  .read(localStateProvider.notifier)
                                  .removeItem(selectDataList);
                              setState(() => isReady = true);
                            },
                            label: const Text("删除缓存书籍"),
                            icon: const Icon(Icons.delete),
                          ),
                        ];
                      },
                      list: list,
                      count: list.length,
                      scale: .7,
                      widget: (FilesDownload item, index) =>
                          LocalItems(data: item, index: index),
                      getList: () {},
                    ),
                  ),
                ],
              ),
              if (isLoading)
                Positioned(
                  left: 0,
                  top: 0,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withValues(alpha: 0.85),
                    child:  const Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(),
                            ),
                            Text("正在同步书籍阅读进度，请不要操作..."),
                          ],
                        ),
                      ),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
