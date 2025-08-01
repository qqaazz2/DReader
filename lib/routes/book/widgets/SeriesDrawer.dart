import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/book/SeriesItem.dart';
import 'package:DReader/state/book/SeriesContentState.dart';
import 'package:DReader/state/book/SeriesListState.dart';

class SeriesDrawer extends ConsumerStatefulWidget {
  const SeriesDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SeriesDrawerState();
}

class SeriesDrawerState extends ConsumerState<SeriesDrawer> {
  Map<int, String> map = {1: "连载中", 2: "完结", 3: "弃坑"};
  Map<int, String> readMap = {1: "未读", 2: "已读", 3: "在读"};
  Map<int, String> loveMap = {1: "未收藏", 2: "已收藏"};
  late SeriesParam seriesParam;
  final TextEditingController searchController = TextEditingController();
  int? over;
  int? status;
  int? love;


  List<DropdownMenuEntry<int?>> _buildMenuList(Map<int, String> map) {
    List<DropdownMenuEntry<int?>> list = [];
    list.add(const DropdownMenuEntry<int?>(value: null, label: "全部"));
    map.forEach((v, k) {
      list.add(DropdownMenuEntry<int?>(value: v, label: k));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    seriesParam = ref.read(seriesListStateProvider.notifier).seriesParam;
    searchController.text = seriesParam.name ?? "";
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SearchBar(
                  hintText: '搜索系列',
                  controller: searchController,
                  onChanged: (value) => seriesParam.name =value,
                  onSubmitted: (value) => search(),
                  leading: const Icon(Icons.search),
                ),
                ListTile(
                  leading: const Icon(Icons.shuffle),
                  title: const Text("随机系列"),
                  onTap: () => randomData(),
                ),
                ListTile(
                  leading: const Icon(Icons.adf_scanner),
                  title: const Text("扫描系列"),
                  onTap: () => ref.read(seriesListStateProvider.notifier).scanning(),
                ),
                const Divider(),
                const Text(
                  "条件筛选",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                ListTile(
                  titleAlignment: ListTileTitleAlignment.titleHeight,
                  leading: const Icon(Icons.check_circle),
                  title: const Text("完结状态"),
                  subtitle: DropdownMenu<int?>(
                    initialSelection: seriesParam.overStatus,
                    onSelected: (value) => setState(() => seriesParam.overStatus = value),
                    width: 220,
                    dropdownMenuEntries: _buildMenuList(map),
                  ),
                ),
                ListTile(
                  titleAlignment: ListTileTitleAlignment.titleHeight,
                  leading: const Icon(Icons.menu_book),
                  title: const Text("阅读状态"),
                  subtitle: DropdownMenu<int?>(
                    initialSelection: seriesParam.status,
                    onSelected: (value) => setState(() => seriesParam.status = value),
                    width: 220,
                    dropdownMenuEntries: _buildMenuList(readMap),
                  ),
                ),
                ListTile(
                  titleAlignment: ListTileTitleAlignment.titleHeight,
                  leading: const Icon(Icons.star),
                  title: const Text("收藏状态"),
                  subtitle: DropdownMenu<int?>(
                    initialSelection: seriesParam.love,
                    onSelected: (value) => setState(() => seriesParam.love = value),
                    width: 220,
                    dropdownMenuEntries: _buildMenuList(loveMap),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => reset(),
                        label: const Text("重置"),
                        icon: const Icon(Icons.restart_alt),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => search(),
                        label: const Text("搜索"),
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void reset() {
    setState(() {
      seriesParam = SeriesParam();
      searchController.clear();
      search();
    });
  }

  void search() {
    ref.read(seriesListStateProvider.notifier).seriesParam = seriesParam;
    ref.read(seriesListStateProvider.notifier).clear();
    ref.read(seriesListStateProvider.notifier).getList();
  }

  void randomData()async{
    SeriesItem? seriesItem = await ref.read(seriesListStateProvider.notifier).randomData();
    if(seriesItem != null) context.push("/books/content?seriesId=${seriesItem.id}&filesId=${seriesItem.filesId}&index=1");
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}