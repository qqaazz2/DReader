import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/entity/book/SeriesItem.dart';
import 'package:DReader/main.dart';
import 'package:DReader/state/book/SeriesContentState.dart';
import 'package:DReader/state/book/SeriesListState.dart';
import 'package:DReader/widgets/ListTitleWidget.dart';

class SeriesForm extends ConsumerStatefulWidget {
  const SeriesForm(
      {super.key,
      required this.seriesItem,
      required this.index,
      this.seriesId = -1});

  final SeriesItem seriesItem;
  final int index;
  final int seriesId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SeriesFormState();
}

class SeriesFormState extends ConsumerState<SeriesForm> {
  Map<int, String> overMap = {1: "连载中", 2: "完结", 3: "弃坑"};
  Map<int, String> readMap = {1: "未读", 2: "已读", 3: "在读"};

  List<DropdownMenuEntry<int>> _buildMenuList(map) {
    List<DropdownMenuEntry<int>> list = [];
    map.forEach((v, k) {
      list.add(DropdownMenuEntry(value: v, label: k));
    });
    return list;
  }

  Future<void> editData(
      BuildContext context, SeriesItem seriesItem, int index) async {
    bool status = Form.of(context).validate();
    if (status) {
      try {
        Form.of(context).save();
        if (widget.seriesId == -1) {
          await ref
              .read(seriesListStateProvider.notifier)
              .updateData(seriesItem, index);
        } else {
          await ref
              .read(seriesContentStateProvider(widget.seriesId).notifier)
              .updateData(seriesItem);
        }
        Navigator.of(context).pop();
      } catch (error) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.seriesId == -1) {
      final state = ref.watch(seriesListStateProvider);
    } else {
      final state = ref.watch(seriesContentStateProvider(widget.seriesId));
    }
    // SeriesItem seriesItem =
    return MediaQuery.of(context).size.width > MyApp.width
        ? SimpleDialog(
            backgroundColor: Theme.of(context).cardColor,
            children: [getForm()],
          )
        : getForm();
  }

  Widget getForm() {
    double size =
        MediaQuery.of(context).size.width > MyApp.width ? 600 : double.infinity;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      constraints: BoxConstraints(
          minWidth: size, minHeight: size, maxWidth: size, maxHeight: size),
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
      child: Form(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              width: size,
              margin: const EdgeInsets.only(top: 5, bottom: 10),
              child: const Text(
                "修改详情",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 25),
              )),
          // 使用 Wrap 来替代 Row
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            alignment: WrapAlignment.end,
            children: [
              RawChip(
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (widget.seriesId == -1) {
                    ref
                        .read(seriesListStateProvider.notifier)
                        .setLove(widget.index);
                  } else {
                    ref
                        .read(seriesContentStateProvider(widget.seriesId)
                            .notifier)
                        .setLove();
                  }
                },
                avatar: Icon(
                  widget.seriesItem.love == 1
                      ? Icons.favorite_border
                      : Icons.favorite,
                  color: Colors.redAccent,
                ),
                label: const Text("收藏"),
              ),
              RawChip(
                padding: EdgeInsets.zero,
                label: Text("${widget.seriesItem.num}"),
                avatar: const Icon(Icons.book),
              ),
              RawChip(
                padding: EdgeInsets.zero,
                label: Text(widget.seriesItem.lastReadTime ?? "无"),
                // 在Wrap中，可以不用强制单行截断
                avatar: const Icon(Icons.history),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                FormInput(
                  label: '系列名称',
                  initialValue: widget.seriesItem.name,
                  iconData: Icons.drive_file_rename_outline_sharp,
                  onSaved: (String? value) => widget.seriesItem.name = value!,
                  validator: (value) {
                    if (value!.trim().isEmpty) return "请输入系列名称";
                    return null;
                  },
                ),
                FormInput(
                  label: '系列作者',
                  initialValue: widget.seriesItem.author,
                  iconData: Icons.person,
                  onSaved: (String? value) => widget.seriesItem.author = value!,
                ),
                FormInput(
                  label: '系列简介',
                  initialValue: widget.seriesItem.profile,
                  iconData: Icons.content_paste_rounded,
                  onSaved: (String? value) =>
                      widget.seriesItem.profile = value!,
                  maxLines: 5,
                ),
                ListTitleWidget(
                    icon: const Icon(Icons.update),
                    title: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text("连载状态",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface)),
                    ),
                    content: DropdownMenu(
                      inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                      width: 200,
                      dropdownMenuEntries: _buildMenuList(overMap),
                      initialSelection: widget.seriesItem.overStatus,
                      onSelected: (value) =>
                          widget.seriesItem.overStatus = value!,
                    )),
                ListTitleWidget(
                    icon: const Icon(Icons.menu_book),
                    title: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text("阅读状态",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          )),
                    ),
                    content: DropdownMenu(
                      inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                      width: 200,
                      dropdownMenuEntries: _buildMenuList(readMap),
                      initialSelection: widget.seriesItem.status,
                      onSelected: (value) => widget.seriesItem.status = value!,
                    )),
              ],
            ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("取消")),
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Builder(builder: (context) {
                    return ElevatedButton(
                        onPressed: () =>
                            editData(context, widget.seriesItem, widget.index),
                        child: const Text("确认"));
                  }))
            ],
          )
        ],
      )),
    );
  }
}

class FormInput extends StatelessWidget {
  const FormInput({
    super.key,
    this.initialValue,
    required this.onSaved,
    required this.label,
    required this.iconData,
    this.validator,
    this.maxLines = 1,
  });

  final String? initialValue;
  final String label;
  final IconData iconData;
  final int maxLines;

  // ✅ 修改为接收输入值的函数
  final void Function(String? value) onSaved;
  final String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        initialValue: initialValue,
        maxLines: maxLines,
        minLines: 1,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          labelText: label,
          hintText: "请输入$label",
          prefixIcon: Icon(
            iconData,
            size: 18,
          ),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
