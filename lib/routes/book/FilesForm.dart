import 'dart:convert';

import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/Tags.dart';
import 'package:DReader/entity/book/FilesDetailsAuthor.dart';
import 'package:DReader/entity/book/FilesDetailsItem.dart';
import 'package:DReader/entity/book/FilesDetailsTag.dart';
import 'package:DReader/routes/book/widgets/FilesAuthorBox.dart';
import 'package:DReader/state/book/FilesDetailsItemState.dart';
import 'package:DReader/widgets/FormInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/main.dart';
import 'package:DReader/state/book/SeriesContentState.dart';
import 'package:DReader/state/book/FilesListState.dart';
import 'package:DReader/widgets/ListTitleWidget.dart';

class FilesForm extends ConsumerStatefulWidget {
  const FilesForm({super.key, required this.filesId});

  final int filesId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FilesFormState();
}

class FilesFormState extends ConsumerState<FilesForm> {
  Map<int, String> overMap = {1: "连载中", 2: "完结", 3: "弃坑", 4: "有生之年"};
  Map<int, String> readMap = {1: "未读", 2: "已读", 3: "在读"};
  FilesDetailsItem? filesDetailsItem;

  List<DropdownMenuEntry<int>> _buildMenuList(map) {
    List<DropdownMenuEntry<int>> list = [];
    map.forEach((v, k) {
      list.add(DropdownMenuEntry(value: v, label: k));
    });
    return list;
  }

  Future<void> editData(BuildContext context) async {
    bool status = Form.of(context).validate();
    if (status) {
      try {
        Form.of(context).save();
        ref
            .read(filesDetailsItemStateProvider(widget.filesId).notifier)
            .updateData(filesDetailsItem!);
        Navigator.of(context).pop();
      } catch (error) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.seriesId == -1) {
    //   final state = ref.watch(filesListStateProvider);
    // } else {
    //   final state = ref.watch(seriesContentStateProvider(widget.seriesId));
    // }
    // SeriesItem filesItem =
    AsyncValue<FilesDetailsItem?> asyncValue = ref.watch(
      filesDetailsItemStateProvider(widget.filesId),
    );
    return MediaQuery.of(context).size.width > MyApp.width
        ? SimpleDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            children: [getForm(asyncValue)],
          )
        : getForm(asyncValue);
  }

  Widget getForm(AsyncValue<FilesDetailsItem?> asyncValue) {
    double width = MediaQuery.of(context).size.width > MyApp.width
        ? MediaQuery.of(context).size.width * 0.8
        : double.infinity;
    double height = MediaQuery.of(context).size.width > MyApp.width
        ? MediaQuery.of(context).size.height * 0.8
        : double.infinity;
    return asyncValue.when(
      data: (FilesDetailsItem? item) {
        if (item == null) return const Center(child: Text("查询不到对应数据"));
        filesDetailsItem ??= FilesDetailsItem.fromJson(
          jsonDecode(jsonEncode(item)),
        );
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          constraints: BoxConstraints(
            minWidth: width,
            minHeight: height,
            maxWidth: width,
            maxHeight: height,
          ),
          padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: width,
                  margin: const EdgeInsets.only(top: 5, bottom: 10),
                  child: const Text(
                    "编辑详情",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  alignment: WrapAlignment.end,
                  children: [
                    RawChip(
                      padding: EdgeInsets.zero,
                      onPressed: () => setState(() => filesDetailsItem!.love = filesDetailsItem!.love == 1 ? 2 : 1),
                      avatar: Icon(
                        filesDetailsItem!.love == 1
                            ? Icons.favorite_border
                            : Icons.favorite,
                        color: Colors.redAccent,
                      ),
                      label: const Text("收藏"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormInput(
                          label: '名称',
                          initialValue: filesDetailsItem!.name,
                          iconData: Icons.drive_file_rename_outline_sharp,
                          onSaved: (String? value) =>
                              filesDetailsItem!.name = value!,
                          validator: (value) {
                            if (value!.trim().isEmpty) return "请输入名称";
                            return null;
                          },
                        ),
                        FormInput(
                          label: '原名称',
                          initialValue: filesDetailsItem!.originalName,
                          iconData: Icons.drive_file_rename_outline_sharp,
                          onSaved: (String? value) =>
                              filesDetailsItem!.originalName = value!,
                        ),
                        FormInput(
                          label: 'BGMID',
                          initialValue: filesDetailsItem!.bgmId?.toString(),
                          iconData: Icons.numbers,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textInputType: TextInputType.number,
                          onSaved: (String? value) =>
                              filesDetailsItem!.bgmId = int.tryParse(value!),
                        ),
                        FormInput(
                          label: '系列简介',
                          initialValue: filesDetailsItem!.profile,
                          iconData: Icons.content_paste_rounded,
                          onSaved: (String? value) =>
                              filesDetailsItem!.profile = value!,
                          maxLines: 100,
                        ),
                        const Text("标签"),
                        const SizedBox(height: 5),
                        FormAutoComplete(tags: filesDetailsItem!.filesTags),
                        const SizedBox(height: 10),
                        const Text("制作团队"),
                        const SizedBox(height: 5),
                        FilesAuthorBox(author: filesDetailsItem!.filesAuthors),
                        const SizedBox(height: 10),
                        ListTitleWidget(
                          icon: const Icon(Icons.timelapse_rounded),
                          title: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              "发行时间",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          content: Text(filesDetailsItem!.date ?? "请选择发行时间"),
                          trailing: ElevatedButton(
                            onPressed: () => showDateDialog(),
                            child: const Text("选择时间"),
                          ),
                        ),
                        ListTitleWidget(
                          icon: const Icon(Icons.update),
                          title: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              "连载状态",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          content: DropdownMenu(
                            inputDecorationTheme: InputDecorationTheme(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            width: 200,
                            dropdownMenuEntries: _buildMenuList(overMap),
                            initialSelection: filesDetailsItem!.overStatus,
                            onSelected: (value) =>
                                filesDetailsItem!.overStatus = value!,
                          ),
                        ),
                        ListTitleWidget(
                          icon: const Icon(Icons.menu_book),
                          title: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              "阅读状态",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          content: DropdownMenu(
                            inputDecorationTheme: InputDecorationTheme(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            width: 200,
                            dropdownMenuEntries: _buildMenuList(readMap),
                            initialSelection: filesDetailsItem!.status,
                            onSelected: (value) =>
                                filesDetailsItem!.status = value!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("取消"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Builder(
                        builder: (context) {
                          return ElevatedButton(
                            onPressed: () => editData(context),
                            child: const Text("确认"),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return Center(
          child: Text(
            '加载失败: $error',
            style: const TextStyle(color: Colors.red),
          ),
        );
      },
      loading: () {
        return const Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(strokeWidth: 6, color: Colors.blue),
                SizedBox(height: 16), // 间距
                Text(
                  '加载中…',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDateDialog() async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
    );

    if (dateTime != null) {
      setState(
        () => filesDetailsItem!.date = dateTime.toString().split(" ")[0],
      );
    }
  }
}

class FormAutoComplete extends StatefulWidget {
  const FormAutoComplete({super.key, required this.tags});

  final List<FilesDetailsTag> tags;

  @override
  State<StatefulWidget> createState() => FormAutoCompleteState();
}

class FormAutoCompleteState extends State<FormAutoComplete> {
  Map<String, int> items = {};
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void getTagList() async {
    BaseResult<List<Tags>> baseResult = await HttpApi.request<List<Tags>>(
      "/tags/getTagsList",
      (json) {
        if (json is List) {
          return json.map((item) => Tags.fromJson(item)).toList();
        }
        return [];
      },
    );
    if (baseResult.code == "2000") {
      if (baseResult.result == null || baseResult.result!.isEmpty) return;
      for (Tags item in baseResult.result!) {
        items[item.name] = item.id;
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getTagList();
  }

  void changeTags(String name) {
    name = name.trim();
    _controller.clear();
    if (widget.tags.any((t) => t.name == name)) return;
    int? id;
    if (items.containsKey(name)) id = items[name];
    widget.tags.add(FilesDetailsTag(-1, name, id));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RawAutocomplete<String>(
            textEditingController: _controller,
            focusNode: _focusNode,
            optionsBuilder: (TextEditingValue value) {
              return items.keys
                  .where((item) => item.contains(value.text))
                  .map((item) => item);
            },
            onSelected: (String value) {
              changeTags(value);
              _focusNode.unfocus();
            },
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    onSubmitted: (value) {
                      changeTags(value);
                      onFieldSubmitted();
                    },
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                  );
                },
            optionsViewBuilder: (context, onSelected, options) {
              return Material(
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 0,
                    maxHeight: 200,
                  ),
                  child: ListView(
                    children: options.map((opt) {
                      return ListTile(
                        title: Text(opt),
                        onTap: () => onSelected(opt),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Wrap(
            children: widget.tags
                .map(
                  (item) => Container(
                    margin: const EdgeInsets.only(right: 10, bottom: 5),
                    child: RawChip(
                      label: Text(item.name),
                      onDeleted: () => setState(
                        () => widget.tags.removeWhere(
                          (value) => value.name == item.name,
                        ),
                      ),
                      deleteIcon: const Icon(Icons.delete),
                      deleteIconColor: Colors.redAccent,
                      deleteButtonTooltipMessage: "删除",
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
