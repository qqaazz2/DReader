import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/state/ThemeState.dart';

class SettingTable extends StatefulWidget {
  const SettingTable({super.key, this.isPc = true});

  final bool isPc;

  @override
  State<SettingTable> createState() => SettingTableState();
}

class SettingTableState extends State<SettingTable> {
  Map<int, TableColumnWidth> columnWidths = const {
    0: FixedColumnWidth(200),
    1: FixedColumnWidth(80),
    2: FixedColumnWidth(80),
  };

  @override
  Widget build(BuildContext context) {
    return widget.isPc ? getPc() : getMobile();
  }

  Widget getCellBox(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: child,
    );
  }

  Widget getPc() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text("最近的文件资源",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      Consumer(builder: (context, ref, child) {
        final state = ref.watch(themeStateProvider);
        return Container(
            color:
                state.light ? const Color(0xFF1f1f1f) : const Color(0xFFf0f0f0),
            width: double.infinity,
            child: DefaultTextStyle(
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface),
                child: Table(
                  border: TableBorder.all(
                    color: state.light
                        ? const Color(0xFF444444)
                        : const Color(0xFFdddddd), // 表格边框颜色
                    width: 1, // 表格边框宽度
                  ),
                  columnWidths: columnWidths,
                  children: [
                    TableRow(children: [
                      TableCell(child: getCellBox(const Text("文件名称"))),
                      TableCell(child: getCellBox(const Text("文件类型"))),
                      TableCell(child: getCellBox(const Text("文件大小"))),
                      TableCell(child: getCellBox(const Text("文件路径"))),
                    ])
                  ],
                )));
      }),
      Expanded(child: SingleChildScrollView(
        child: Consumer(builder: (context, ref, child) {
          final state = ref.watch(themeStateProvider);
          return Container(
              color: state.light
                  ? const Color(0xFF333333)
                  : const Color(0xFFf9f9f9),
              width: double.infinity,
              child: Table(
                columnWidths: columnWidths,
                border: TableBorder.all(
                  color: state.light
                      ? const Color(0xFF444444)
                      : const Color(0xFFdddddd),
                  // 表格边框颜色
                  width: 1, // 表格边框宽度
                ),
                children: [
                  TableRow(children: [
                    TableCell(child: getCellBox(const Text("文件名称"))),
                    TableCell(child: getCellBox(const Text("文件类型"))),
                    TableCell(child: getCellBox(const Text("文件大小"))),
                    TableCell(child: getCellBox(const Text("文件路径"))),
                  ]),
                  TableRow(children: [
                    TableCell(child: getCellBox(const Text("文件名称"))),
                    TableCell(child: getCellBox(const Text("文件类型"))),
                    TableCell(child: getCellBox(const Text("文件大小"))),
                    TableCell(child: getCellBox(const Text("文件路径"))),
                  ]),
                ],
              ));
        }),
      )),
      pagination()
    ]);
  }

  Widget pagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text("当前是第1页,共有50页"),
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget getMobile() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text("最近的文件资源",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          const ListTile(
            leading: Icon(Icons.insert_drive_file,size: 30,),
            title: Text("文件名称"),
            subtitle: Text("文件路径"),
            trailing: Text("文件类型"),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.insert_drive_file,size: 30,),
            title: Text("文件名称"),
            subtitle: Text("文件路径"),
            trailing: Text("文件类型"),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.insert_drive_file,size: 30,),
            title: Text("文件名称"),
            subtitle: Text("文件路径"),
            trailing: Text("文件类型"),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.insert_drive_file,size: 30,),
            title: Text("文件名称"),
            subtitle: Text("文件路径"),
            trailing: Text("文件类型"),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.insert_drive_file,size: 30,),
            title: Text("文件名称"),
            subtitle: Text("文件路径"),
            trailing: Text("文件类型"),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.insert_drive_file,size: 30,),
            title: Text("文件名称"),
            subtitle: Text("文件路径"),
            trailing: Text("文件类型"),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.insert_drive_file,size: 30,),
            title: Text("文件名称"),
            subtitle: Text("文件路径"),
            trailing: Text("文件类型"),
          ),
          const Divider(),
          pagination()
        ],
      ),
    );
  }
}
