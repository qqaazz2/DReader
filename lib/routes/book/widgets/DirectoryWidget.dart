import 'package:DReader/epub/PageNodes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../main.dart';

class DirectoryWidget extends StatefulWidget {
  final PageNodes pageNodes;
  final int currentPage;
  final void Function(int) clickFunc;

  const DirectoryWidget({
    super.key,
    required this.pageNodes,
    required this.clickFunc,
    required this.currentPage,
  });

  @override
  State<DirectoryWidget> createState() => _DirectoryWidgetState();
}

class _DirectoryWidgetState extends State<DirectoryWidget> {
  bool hideNofFound = true;
  int? currentPage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    final entries = widget.pageNodes.directory.entries
        .where((item) => !hideNofFound || !item.key.contains("未定义"))
        .toList();
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final pageIndex = entry.value;
      final title = entry.key;
      final isCurrent =
          pageIndex <= (currentPage ?? widget.currentPage) &&
              (i + 1 >= entries.length ||
                  entries[i + 1].value > (currentPage ?? widget.currentPage));
      list.add(
          Container(color: isCurrent ? Theme.of(context).colorScheme.secondaryContainer : Colors.transparent,child: ListTile(
            title: Text(title),
            selected: isCurrent,
            trailing: Text("$pageIndex"),
            onTap: () {
              widget.clickFunc.call(pageIndex);
              setState(() => currentPage = pageIndex);
            },
          ))
      );
    }
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Container(
        color: Theme
            .of(context)
            .cardColor,
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "目录",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Expanded(child: SizedBox()),
                const Text("隐藏未定义："),
                Switch(
                  value: hideNofFound,
                  onChanged: (value) => setState(() => hideNofFound = value),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: list.isNotEmpty ? SingleChildScrollView(child: Column(children: list)) : const Center(child: Text("文件目录数据为空"),),
            ),
          ],
        ),
      ),
    );
  }
}
