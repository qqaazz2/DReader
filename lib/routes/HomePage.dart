import 'package:DReader/common/Global.dart';
import 'package:DReader/common/ImageModule.dart';
import 'package:DReader/entity/book/SeriesItem.dart';
import 'package:DReader/main.dart';
import 'package:DReader/routes/book/widgets/SeriesItems.dart';
import 'package:DReader/state/home/BookRecentState.dart';
import 'package:DReader/state/home/OverviewState.dart';
import 'package:DReader/state/book/SeriesListState.dart';
import 'package:DReader/state/home/RecentlyAddsState.dart';
import 'package:DReader/widgets/TopTool.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum TimePeriod {
  lingChen('凌晨'),
  zaoShang('早上'),
  zhongWu('中午'),
  xiaWu('下午'),
  wanShang('晚上');

  const TimePeriod(this.displayName);

  final String displayName;

  static TimePeriod fromTimeOfDay(TimeOfDay time) {
    final hour = time.hour;
    if (hour >= 0 && hour < 5) {
      return TimePeriod.lingChen;
    } else if (hour >= 5 && hour < 11) {
      return TimePeriod.zaoShang;
    } else if (hour >= 11 && hour < 13) {
      return TimePeriod.zhongWu;
    } else if (hour >= 13 && hour < 18) {
      return TimePeriod.xiaWu;
    } else {
      return TimePeriod.wanShang;
    }
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  late TimePeriod currTimeText;

  Widget titleWidget(String text, {Widget? action}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (action != null) action,
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    ref.read(bookRecentStateProvider.notifier).getData();
    ref.read(overviewStateProvider.notifier).getOverview();
    currTimeText = TimePeriod.fromTimeOfDay(TimeOfDay.now());
    ref.read(recentlyAddsStateProvider.notifier).getList();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    ScrollController scrollController = ScrollController();
    return TopTool(
        title: "首页",
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${currTimeText.displayName}好，祝你今天愉快！",
                      style: themeData.textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == "scan") {
                          // 执行扫描逻辑
                          ref.read(seriesListStateProvider.notifier).scanning();
                        } else if (value == "logout") {
                          Global.logout(context);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: "scan", child: Text("扫描")),
                        const PopupMenuItem(
                            value: "logout", child: Text("退出登录")),
                      ],
                    ),
                  ],
                ),
                titleWidget("继续阅读"),
                Consumer(builder: (context, ref, child) {
                  final bookRecentState = ref.watch(bookRecentStateProvider);
                  return LayoutBuilder(builder: (context, constraints) {
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                        child: bookRecentState == null
                            ? const SizedBox(
                                height: 150,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text("暂无阅读记录")))
                            : GestureDetector(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        constraints: const BoxConstraints(
                                            minHeight: 150,
                                            minWidth: 150 * 0.7,
                                            maxHeight: 300,
                                            maxWidth: 300 * 0.7),
                                        width: constraints.maxWidth * 0.2,
                                        child: AspectRatio(
                                            aspectRatio: .7,
                                            child: ImageModule.minioImage(
                                                bookRecentState.minioCover,
                                                bookRecentState.cover)),
                                      ),
                                      Expanded(
                                          child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("${bookRecentState.name}",
                                                  maxLines: 1),
                                              Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 20),
                                                  child: SliderTheme(
                                                    data:
                                                        SliderTheme.of(context)
                                                            .copyWith(
                                                      thumbShape:
                                                          SliderComponentShape
                                                              .noThumb,
                                                      overlayShape:
                                                          SliderComponentShape
                                                              .noOverlay,
                                                      minThumbSeparation: 0,
                                                    ),
                                                    child: Slider(
                                                      value: bookRecentState
                                                          .progress,
                                                      min: 0,
                                                      max: 1,
                                                      onChanged: (value) {},
                                                    ),
                                                  )),
                                              Text(
                                                  "已读 ${(bookRecentState.progress * 100).toStringAsFixed(2)}%")
                                            ]),
                                      )),
                                      const Icon(
                                          Icons.arrow_forward_ios_rounded),
                                      const SizedBox(
                                        width: 10,
                                      )
                                    ]),
                                onTap: () => ref
                                    .read(bookRecentStateProvider.notifier)
                                    .read(context)),
                      ),
                    );
                  });
                }),
                titleWidget("书库一览",
                    action: IconButton(
                        onPressed: () => ref
                            .read(overviewStateProvider.notifier)
                            .getOverview(),
                        icon: const Icon(Icons.refresh))),
                Consumer(builder: (context, ref, child) {
                  final overviewState = ref.watch(overviewStateProvider);
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int num = constraints.maxWidth <= MyApp.width ? 2 : 4;
                      double width =
                          (constraints.maxWidth / num).clamp(0, 250) - 10;
                      final items = [
                        _StatCardData(overviewState.seriesCount, "系列总数",
                            Icons.library_books, () {}, Colors.blue),
                        _StatCardData(overviewState.bookCount, "书籍总数",
                            Icons.menu_book, () {}, Colors.green),
                        _StatCardData(overviewState.overCount, "已读书籍",
                            Icons.check_circle, () {}, Colors.teal),
                        _StatCardData(overviewState.unreadCount, "未读书籍",
                            Icons.pending_actions, () {}, Colors.orange),
                      ];
                      return Wrap(
                        alignment: WrapAlignment.center,
                        children: items.map((item) {
                          return _StatCard(
                            data: item,
                            width: width,
                          );
                        }).toList(),
                      );
                    },
                  );
                }),
                titleWidget("最近添加",
                    action: Row(
                      children: [
                        IconButton(
                            tooltip: "刷新数据",
                            onPressed: () => ref
                                .read(recentlyAddsStateProvider.notifier)
                                .getList(),
                            icon: const Icon(Icons.refresh)),
                        TextButton(
                            onPressed: () => context.go("/books"),
                            child: const Text("查看更多"))
                      ],
                    )),
                Consumer(builder: (context, ref, child) {
                  final seriesListState = ref.watch(recentlyAddsStateProvider);
                  return LayoutBuilder(builder: (context, constraints) {
                    void changeOffset(int type) {
                      double currentOffset = scrollController.offset;
                      double? offset;
                      if (type == 1) {
                        if (currentOffset == 0) return;
                        offset = currentOffset - constraints.maxWidth;
                      } else {
                        if (currentOffset >=
                            scrollController.position.maxScrollExtent) return;
                        offset = currentOffset + constraints.maxWidth;
                      }
                      scrollController.animateTo(offset,
                          curve: Curves.linear,
                          duration: const Duration(milliseconds: 500));
                    }

                    return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Stack(
                          children: [
                            Listener(
                                onPointerSignal: (pointerSignal) {
                                  if (pointerSignal is PointerScrollEvent) {
                                    final offset = scrollController.offset +
                                        pointerSignal.scrollDelta.dy;
                                    if (offset >= 0 &&
                                        offset <
                                            scrollController
                                                .position.maxScrollExtent) {
                                      scrollController.jumpTo(offset);
                                    }
                                  }
                                },
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: seriesListState.data.length,
                                    controller: scrollController,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      SeriesItem seriesItem =
                                          seriesListState.data[index];
                                      return GestureDetector(
                                          onTap: () => context.push(
                                              "/books/content?seriesId=${seriesItem.id}&filesId=${seriesItem.filesId}&index=0"),
                                          child: Card(
                                              clipBehavior: Clip.hardEdge,
                                              child: AspectRatio(
                                                  aspectRatio: 0.7,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                          child: ImageModule
                                                              .minioImage(
                                                                  seriesItem
                                                                      .minioCover,
                                                                  seriesItem
                                                                      .cover)),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 10,
                                                                  bottom: 5),
                                                          child: Text(
                                                            seriesItem.name,
                                                            maxLines: 1,
                                                          ))
                                                    ],
                                                  ))));
                                    })),
                            if (MyApp.width < constraints.maxWidth)
                              Positioned.fill(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                    IconButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(Colors
                                                    .black
                                                    .withAlpha(100))),
                                        onPressed: () => changeOffset(1),
                                        icon: const Icon(
                                            Icons.arrow_back_ios_rounded)),
                                    IconButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(Colors
                                                    .black
                                                    .withAlpha(100))),
                                        onPressed: () => changeOffset(2),
                                        icon: const Icon(
                                            Icons.arrow_forward_ios_rounded)),
                                  ]))
                          ],
                        ));
                  });
                }),
              ])),
        ));
  }
}

class _StatCardData {
  final int value;
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  _StatCardData(this.value, this.label, this.icon, this.onTap, this.iconColor);
}

class _StatCard extends StatelessWidget {
  final _StatCardData data;
  final double width;

  const _StatCard({required this.data, required this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: data.onTap,
      child: Card(
        child: SizedBox(
          width: width,
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(data.icon, color: data.iconColor, size: 35),
              SizedBox(width: width * 0.1),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${data.value}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(data.label),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
