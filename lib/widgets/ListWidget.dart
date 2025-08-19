import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/main.dart';

class ListWidget<T> extends StatefulWidget {
  const ListWidget(
      {super.key,
      required this.list,
      required this.count,
      required this.widget,
      required this.scale,
      required this.getList});

  final List<T> list;
  final int count;
  final VoidCallback getList;
  final FilesItem<T> Function(T data, int index, {bool show, bool isPc}) widget;
  final double scale;

  @override
  State<StatefulWidget> createState() => ListWidgetState<T>();
}

class ListWidgetState<T> extends State<ListWidget<T>> {

  @override
  Widget build(BuildContext context) {
    int listNum = widget.list.length;
    bool isLoading = true;
    return LayoutBuilder(builder: (builder, constraints) {
      int num = getNum(constraints);
      return NotificationListener<ScrollNotification>(
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
                childAspectRatio: widget.scale),
            itemBuilder: (context, index) {
              return Container(
                  margin:
                      const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  child: constraints.maxWidth > MyApp.width
                      ? PCItem<T>(
                          data: widget.list[index],
                          index: index,
                          widget: widget.widget,
                        )
                      : MobileItem<T>(
                          data: widget.list[index],
                          index: index,
                          widget: widget.widget,
                        ));
            }),
      );
    });
  }

  int getNum(constraints) {
    int num = 10;
    print('constraints.maxWidth${constraints.maxWidth}');
    if (1300 > constraints.maxWidth && constraints.maxWidth > 700) {
      num = 4;
    } else if (2160 > constraints.maxWidth && constraints.maxWidth > 1300) {
      num = 6;
    } else if (constraints.maxWidth < 700) {
      num = 2;
    }
    return num;
  }
}

class MobileItem<T> extends StatelessWidget {
  const MobileItem(
      {super.key,
      required this.data,
      required this.index,
      required this.widget});

  final T data;
  final int index;
  final FilesItem<T> Function(T data, int index, {bool show, bool isPc}) widget;

  @override
  Widget build(BuildContext context) {
    return widget(data, index, show: false, isPc: false);
  }
}

class PCItem<T> extends StatelessWidget {
  PCItem(
      {super.key,
      required this.data,
      required this.index,
      required this.widget});

  final T data;
  final int index;
  final ValueNotifier<bool> show = ValueNotifier<bool>(false);
  final FilesItem<T> Function(T data, int index, {bool show, bool isPc}) widget;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      builder: (BuildContext context, bool value, Widget? child) {
        return widget(data, index, show: value, isPc: true);
      },
      valueListenable: show,
    );
  }
}

abstract class FilesItem<T> extends ConsumerStatefulWidget {
  const FilesItem(
      {super.key,
      required this.data,
      this.show = false,
      this.isPc = true,
      required this.index});

  final T data;
  final bool show;
  final bool isPc;
  final int index;
}
