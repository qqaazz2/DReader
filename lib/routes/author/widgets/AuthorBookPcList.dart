import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/common/ImageModule.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/author/AuthorDetail.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/main.dart';
import 'package:DReader/routes/author/widgets/AuthorDetailPcCard.dart';
import 'package:DReader/routes/book/widgets/FilesItems.dart';
import 'package:DReader/state/book/FilesListState.dart';
import 'package:DReader/widgets/ListWidget.dart';
import 'package:DReader/widgets/ToolBar.dart';
import 'package:DReader/widgets/TopTool.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthorBookPcList extends ConsumerStatefulWidget {
  const AuthorBookPcList({super.key, required this.id});
  final int id;

  @override
  ConsumerState<AuthorBookPcList> createState() => AuthorBookPcListState();
}

class AuthorBookPcListState extends ConsumerState<AuthorBookPcList> {
  @override
  void initState() {
    super.initState();
    ref.read(filesListStateProvider(widget.id).notifier).getListByAuthor();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filesListStateProvider(widget.id));
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListWidget<FilesItem>(
          list: state.data,
          count: state.count,
          scale: .7,
          widget: (FilesItem data, index, {show = false, isPc = true}) {
            return FilesItems(
              data: data,
              index: index,
              show: show,
              isPc: isPc,
              parentId: widget.id,
            );
          },
          getList: () => ref
              .read(filesListStateProvider(widget.id).notifier)
              .getListByAuthor(),
        ),
      ),
    );
  }
}
