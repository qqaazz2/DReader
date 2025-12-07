import 'package:DReader/entity/author/AuthorItem.dart';
import 'package:DReader/main.dart';
import 'package:DReader/routes/author/widgets/AuthorForm.dart';
import 'package:DReader/routes/author/widgets/AuthorItems.dart';
import 'package:DReader/state/author/AuthorListState.dart';
import 'package:DReader/widgets/ListWidget.dart';
import 'package:DReader/widgets/ToolBar.dart';
import 'package:DReader/widgets/TopTool.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthorPage extends ConsumerStatefulWidget {
  const AuthorPage({super.key});

  @override
  ConsumerState<AuthorPage> createState() => AuthorPageState();
}

class AuthorPageState extends ConsumerState<AuthorPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    ref.read(authorListStateProvider.notifier).getList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authorListStateProvider);
    return TopTool(
      title: "制作",
      appBarBottom: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: searchInput(
            const BoxConstraints(maxWidth: double.infinity, maxHeight: 40),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () =>
              showDialog(context: context, builder: (context) => AuthorForm()),
          icon: const Icon(Icons.edit_note),
          tooltip: "新增",
        ),
        IconButton(
          onPressed: () {
            _searchController.text = "";
            ref.read(authorListStateProvider.notifier).reload();
          },
          icon: const Icon(Icons.refresh),
          tooltip: "刷新列表",
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              if (constraints.maxWidth > MyApp.width)
                ToolBar(
                  title: "制作",
                  widgetList: [
                    searchInput(
                      const BoxConstraints(maxWidth: 250, maxHeight: 60),
                    ),
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AuthorForm(),
                      ),
                      icon: const Icon(Icons.edit_note),
                      tooltip: "新增",
                    ),
                    IconButton(
                      onPressed: () {
                        ref.read(authorListStateProvider.notifier).reload();
                      },
                      icon: const Icon(Icons.refresh),
                      tooltip: "刷新列表",
                    ),
                  ],
                ),
              Expanded(
                child: ListWidget<AuthorItem>(
                  list: state.data!,
                  count: state.count,
                  scale: 1,
                  widget:
                      (AuthorItem data, index, {show = false, isPc = true}) {
                        return AuthorItems(
                          data: data,
                          index: index,
                          show: show,
                          isPc: isPc,
                        );
                      },
                  getList: () => ref
                      .read(authorListStateProvider.notifier)
                      .getList(name: _searchController.text),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget searchInput(BoxConstraints constraints) {
    return SearchBar(
      controller: _searchController,
      trailing: [
        IconButton(
          onPressed: () => ref
              .read(authorListStateProvider.notifier)
              .searchByName(_searchController.text),
          icon: const Icon(Icons.search),
        ),
      ],
      onSubmitted: (value) =>
          ref.read(authorListStateProvider.notifier).searchByName(value),
      hintText: "搜索作者",
      constraints: constraints,
    );
  }
}
