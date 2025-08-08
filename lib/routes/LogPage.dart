import 'package:DReader/entity/ListData.dart';
import 'package:DReader/entity/LogData.dart';
import 'package:DReader/main.dart';
import 'package:DReader/state/LogState.dart';
import 'package:DReader/widgets/ToolBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/TopTool.dart';

enum LogLevel { info, warning, error }

class LogPage extends ConsumerStatefulWidget {
  const LogPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LogePageState();
}

class LogePageState extends ConsumerState<LogPage> {
  bool isLoading = true;
  late LogParam logParam;

  @override
  void initState() {
    super.initState();
    ref.read(logStateProvider.notifier).getList();
  }

  @override
  Widget build(BuildContext context) {
    ListData<LogData> listData = ref.watch(logStateProvider);
    logParam = ref.read(logStateProvider.notifier).logParam;
    List<LogData> list = listData.data ?? [];
    List<Widget> actions = getActions();
    return TopTool(
        title: "操作日志",
        actions: actions,
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(children: [
            if (constraints.maxWidth > MyApp.width)
              ToolBar(title: "操作日志", widgetList: actions),
            list.isEmpty
                ? const Expanded(
                    child: Align(
                    child: Center(
                      child: Text("暂无数据"),
                    ),
                  ))
                : Expanded(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (list.length < listData.count &&
                              notification.metrics.atEdge &&
                              notification.metrics.pixels ==
                                  notification.metrics.maxScrollExtent &&
                              isLoading) {
                            bool isLoading = false;
                            ref.read(logStateProvider.notifier).getList();
                          }
                          return false;
                        },
                        child: ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return LogItem(logData: list[index]);
                            })),
                  )),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("共${listData.count}条日志"),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ))
          ]);
        }));
  }

  List<Widget> getActions() {
    return [
      IconButton(
        onPressed: () {
          ref.read(logStateProvider.notifier).reload();
        },
        icon: const Icon(Icons.refresh),
        tooltip: "刷新日志",
      ),
      PopupMenuButton(
          tooltip: "筛选日志等级",
          onSelected: (value) {
            logParam.levels ??= [];
            if (logParam.levels!.contains(value.name.toUpperCase())) {
              logParam.levels?.remove(value.name.toUpperCase());
            } else {
              logParam.levels?.add(value.name.toUpperCase());
            }
            ref.read(logStateProvider.notifier).reload();
          },
          itemBuilder: (context) => LogLevel.values
              .map((item) => CheckedPopupMenuItem(
                    value: item,
                    checked:
                        logParam.levels?.contains(item.name.toUpperCase()) ??
                            false,
                    child: Text(item.name),
                  ))
              .toList(),
          child: IgnorePointer(
            child: IconButton(
                onPressed: () {}, icon: const Icon(Icons.filter_list)),
          ))
    ];
  }
}

class LogItem extends StatelessWidget {
  final LogData logData;
  final Map<String, Icon> map = {
    "info": const Icon(Icons.info),
    "error": const Icon(
      Icons.error,
      color: Colors.redAccent,
    )
  };

  LogItem({super.key, required this.logData});

  Widget _getTextWidget(BuildContext context, String label, String value) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("$label:",
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          Expanded(
            child: SelectableText(
              value,
              style: textTheme.bodyMedium
                  ?.copyWith(color: Theme.of(context).hintColor),
            ),
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 7),
        elevation: 0.5,
        child: ExpansionTile(
          leading: map[logData.level.toLowerCase()],
          title: Text(
            logData.message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(logData.time, style: const TextStyle(fontSize: 12)),
          expandedAlignment: Alignment.topLeft,
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)
                  .copyWith(top: 0),
          children: [
            const Divider(),
            const SizedBox(
              height: 5,
            ),
            _getTextWidget(context, "详细信息", logData.message),
            _getTextWidget(context, "记录时间", logData.time),
            _getTextWidget(context, "日志等级", logData.level),
            _getTextWidget(context, "调用来源", logData.callerClass),
          ],
          // trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.copy)),
        ));
  }
}
