import 'package:DReader/state/common/ListWidgetCheckState.dart';
import 'package:DReader/widgets/ListWidgetItem.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/main.dart';

class ListWidget<T> extends ConsumerStatefulWidget {
  const ListWidget({
    super.key,
    required this.list,
    required this.count,
    required this.widget,
    required this.scale,
    required this.getList,
    this.checkHandle,
    this.nodeKey
  });

  final List<T> list;
  final int count;
  final VoidCallback getList;
  final ListItem<T> Function(T data, int index) widget;
  final double scale;
  final List<Widget> Function(List<T> selectdDataList)? checkHandle;
  final String? nodeKey;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ListWidgetState<T>();
}

class ListWidgetState<T> extends ConsumerState<ListWidget<T>> {
  List<int> checkIndex = [];
  bool _showCheckBox = false;

  @override
  Widget build(BuildContext context) {
    bool isLoading = true;
    int listNum = widget.list.length;
    return LayoutBuilder(
      builder: (builder, constraints) {
        int num = getNum(constraints);
        return Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (listNum < widget.count &&
                    notification.metrics.atEdge &&
                    notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent &&
                    isLoading) {
                  isLoading = false;
                  widget.getList();
                }
                return false;
              },
              child: GridView.builder(
                itemCount: listNum,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: constraints.maxWidth / num,
                  childAspectRatio: widget.scale,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      if (_showCheckBox || widget.nodeKey == null) return;
                      setState(() => _showCheckBox = true);
                    },
                    onTap: () => clickCheckBox(index),
                    child: ListWidgetItem<T>(
                      index: index,
                      widget: widget.widget,
                      data: widget.list[index],
                      showCheckBox: _showCheckBox,
                      nodeKey: widget.nodeKey,
                    ),
                  );
                },
              ),
            ),
            if (_showCheckBox)
              Positioned(
                right: 5,
                bottom: 5,
                child: Consumer(builder: (context,ref,child){
                  Set<int> set = ref.watch(listWidgetCheckStateProvider(widget.nodeKey!));
                  List<T> list = set.map((item) => widget.list[item]).toList();
                  return Wrap(
                    spacing: 10,
                    children: [
                      ...(widget.checkHandle?.call(list) ?? []),
                      ElevatedButton.icon(
                        onPressed: () => cleanCheckStatus(),
                        label: const Text("取消"),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  );
                })
              ),
          ],
        );
      },
    );
  }

  void clickCheckBox(int index) {
    if (!_showCheckBox) return;
    ref.read(listWidgetCheckStateProvider(widget.nodeKey!).notifier).toggle(index);
  }

  void cleanCheckStatus() {
    Future.microtask(
          () => ref.read(listWidgetCheckStateProvider(widget.nodeKey!).notifier).clean(),
    );
    setState(() {
      _showCheckBox = false;
    });
  }

  int getNum(constraints) {
    int num = 10;
    if (1300 > constraints.maxWidth && constraints.maxWidth > 700) {
      num = 4;
    } else if (2160 > constraints.maxWidth && constraints.maxWidth > 1300) {
      num = 6;
    } else if (constraints.maxWidth < 700) {
      num = 2;
    }
    return num;
  }

  @override
  void didUpdateWidget(covariant ListWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.count != widget.count) && _showCheckBox) {
      _showCheckBox = false;
      Future.microtask(
        () => ref.read(listWidgetCheckStateProvider(widget.nodeKey!).notifier).clean(),
      );
    }
  }
}

abstract class ListItem<T> extends ConsumerStatefulWidget {
  const ListItem({super.key, required this.data, required this.index});

  final T data;
  final int index;
}
