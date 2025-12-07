import 'dart:ui';

import 'package:DReader/common/Global.dart';
import 'package:DReader/common/ImageModule.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/entity/book/FilesOverview.dart';
import 'package:DReader/main.dart';
import 'package:DReader/routes/book/widgets/FilesItems.dart';
import 'package:DReader/state/UserInfoState.dart';
import 'package:DReader/state/home/BookRecentState.dart';
import 'package:DReader/state/home/OverviewState.dart';
import 'package:DReader/state/book/FilesListState.dart';
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
          Text(text, style: Theme.of(context).textTheme.titleLarge),
          if (action != null) action,
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    currTimeText = TimePeriod.fromTimeOfDay(TimeOfDay.now());
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    ScrollController scrollController = ScrollController();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return constraints.maxWidth > MyApp.width
            ? const PcHome()
            : const MobileHome();
      },
    );
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

class PcHome extends ConsumerStatefulWidget {
  const PcHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PcHomeState();
}

class PcHomeState extends ConsumerState<PcHome> {
  late TimePeriod currTimeText;

  Widget titleWidget(String text, {Widget? action}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: Theme.of(context).textTheme.titleLarge),
          if (action != null) action,
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    currTimeText = TimePeriod.fromTimeOfDay(TimeOfDay.now());
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    BoxConstraints itemConstraints = const BoxConstraints(
      minWidth: 0,
      maxWidth: 180,
    );
    return TopTool(
      title: "首页",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Container(
              constraints: itemConstraints,
              child: Column(
                children: [
                  ListTile(
                    title: const Text("扫描书籍"),
                    onTap: () => ref
                        .read(filesListStateProvider(-1).notifier)
                        .scanning(),
                  ),
                  ListTile(
                    title: const Text("退出登录"),
                    onTap: () => Global.logout(context),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: VerticalDivider(width: 5),
            ),
            Expanded(
              child: Column(
                children: [
                  // 问候语部分
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      "${currTimeText.displayName}好，祝你今天愉快！",
                      style: themeData.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // 核心展示区域
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final bookRecentState = ref.watch(
                          bookRecentStateProvider,
                        );
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              constraints: constraints,
                              color: themeData.scaffoldBackgroundColor,
                              child: bookRecentState.when(
                                data: (FilesItem? item) {
                                  if (item == null) {
                                    return const Center(child: Text("暂无阅读记录"));
                                  }
                                  return GestureDetector(
                                    onTap: () =>
                                        context.push("/read?", extra: item),
                                    behavior: HitTestBehavior.opaque,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ClipRect(
                                          child: ImageFiltered(
                                            imageFilter: ImageFilter.blur(
                                              sigmaX: 25,
                                              sigmaY: 25,
                                            ),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.black,
                                              ),
                                              child: ImageModule.getImage(
                                                item.cover,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          color: themeData
                                              .scaffoldBackgroundColor
                                              .withOpacity(0.6), // 融合主题色
                                        ),
                                        Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                constraints:
                                                    const BoxConstraints(
                                                      minHeight: 300,
                                                      maxHeight: 500,
                                                    ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      blurRadius: 20,
                                                      offset: const Offset(
                                                        0,
                                                        10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                clipBehavior: Clip.antiAlias,
                                                child: AspectRatio(
                                                  aspectRatio: 2 / 3,
                                                  child: ImageModule.getImage(
                                                    item.cover,
                                                    isMemCache: false,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                item.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 10),
                                              const Opacity(
                                                opacity: 0.7,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text("点击继续阅读"),
                                                    SizedBox(width: 5),
                                                    Icon(
                                                      Icons.arrow_forward,
                                                      size: 16,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                error: (err, stack) =>
                                    Center(child: Text('加载失败: $err')),
                                loading: () => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: VerticalDivider(width: 5),
            ),
            Container(
              constraints: itemConstraints,
              child: Column(
                children: [
                  titleWidget(
                    "书库一览",
                    action: IconButton(
                      onPressed: () => ref.invalidate(overviewStateProvider),
                      icon: const Icon(Icons.refresh),
                    ),
                  ),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final overviewState = ref.watch(overviewStateProvider);
                        return overviewState.when(
                          data: (FilesOverview item) {
                            final items = [
                              _StatCardData(
                                item.seriesCount,
                                "系列总数",
                                Icons.library_books,
                                () {},
                                Colors.blue,
                              ),
                              _StatCardData(
                                item.bookCount,
                                "书籍总数",
                                Icons.menu_book,
                                () {},
                                Colors.green,
                              ),
                              _StatCardData(
                                item.overCount,
                                "已读书籍",
                                Icons.check_circle,
                                () {},
                                Colors.teal,
                              ),
                              _StatCardData(
                                item.unreadCount,
                                "未读书籍",
                                Icons.pending_actions,
                                () {},
                                Colors.orange,
                              ),
                              _StatCardData(
                                item.readingCount,
                                "在读书籍",
                                Icons.book_rounded,
                                () {},
                                Colors.yellowAccent,
                              ),
                              _StatCardData(
                                item.loveSeriesCount,
                                "收藏系列",
                                Icons.star,
                                () {},
                                Colors.yellow,
                              ),
                              _StatCardData(
                                item.loveBookCount,
                                "收藏书籍",
                                Icons.favorite,
                                () {},
                                Colors.redAccent,
                              ),
                              _StatCardData(
                                item.unOverSeriesCount,
                                "连载系列",
                                Icons.autorenew,
                                () {},
                                Colors.blue,
                              ),
                              _StatCardData(
                                item.overSeriesCount,
                                "完结系列",
                                Icons.check_circle,
                                () {},
                                Colors.green,
                              ),
                              _StatCardData(
                                item.discardedSeriesCount,
                                "弃坑系列",
                                Icons.cancel,
                                    () {},
                                Colors.grey,
                              ),
                            ];
                            return SingleChildScrollView(
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                children: items.map((item) {
                                  return _StatCard(
                                    data: item,
                                    width: itemConstraints.maxWidth,
                                  );
                                }).toList(),
                              ),
                            );
                          },
                          error: (Object error, StackTrace stackTrace) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              height: 100,
                              child: Center(
                                child: Text(
                                  '加载失败: $error',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                          },
                          loading: () {
                            return const SizedBox(
                              width: 150,
                              height: 150,
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileHome extends ConsumerStatefulWidget {
  const MobileHome({super.key});

  @override
  ConsumerState<MobileHome> createState() => MobileHomeState();
}

class MobileHomeState extends ConsumerState<MobileHome> {
  late TimePeriod currTimeText;

  Widget titleWidget(String text, {Widget? action}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: Theme.of(context).textTheme.titleLarge),
          if (action != null) action,
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    currTimeText = TimePeriod.fromTimeOfDay(TimeOfDay.now());
  }

  @override
  Widget build(BuildContext context) {
    return TopTool(
      title: "首页",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${currTimeText.displayName}好，祝你今天愉快！"),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == "scan") {
                        // 执行扫描逻辑
                        ref
                            .read(filesListStateProvider(-1).notifier)
                            .scanning();
                      } else if (value == "logout") {
                        Global.logout(context);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: "scan", child: Text("扫描")),
                      const PopupMenuItem(value: "logout", child: Text("退出登录")),
                    ],
                  ),
                ],
              ),
              titleWidget("继续阅读"),
              Consumer(
                builder: (context, ref, child) {
                  final bookRecentState = ref.watch(bookRecentStateProvider);
                  return Container(
                    child: Center(
                      child: bookRecentState.when(
                        data: (FilesItem? item) {
                          if (item == null) {
                            return Text("暂无阅读记录");
                          }
                          return Container(
                            constraints: const BoxConstraints(maxWidth: 350),
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Card(
                              clipBehavior: Clip.hardEdge,
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 2 / 3,
                                    child: ImageModule.getImage(
                                      item.cover,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    item.name,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          );
                        },
                        error: (err, stack) => Text('加载失败: $err'),
                        loading: () => const CircularProgressIndicator(),
                      ),
                    ),
                  );
                },
              ),
              titleWidget(
                "书库一览",
                action: IconButton(
                  onPressed: () => ref.invalidate(overviewStateProvider),
                  icon: const Icon(Icons.refresh),
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final overviewState = ref.watch(overviewStateProvider);
                  return overviewState.when(
                    data: (FilesOverview item) {
                      final items = [
                        _StatCardData(
                          item.seriesCount,
                          "系列总数",
                          Icons.library_books,
                          () {},
                          Colors.blue,
                        ),
                        _StatCardData(
                          item.bookCount,
                          "书籍总数",
                          Icons.menu_book,
                          () {},
                          Colors.green,
                        ),
                        _StatCardData(
                          item.overCount,
                          "已读书籍",
                          Icons.check_circle,
                          () {},
                          Colors.teal,
                        ),
                        _StatCardData(
                          item.unreadCount,
                          "未读书籍",
                          Icons.pending_actions,
                          () {},
                          Colors.orange,
                        ),
                        _StatCardData(
                          item.readingCount,
                          "在读书籍",
                          Icons.book_rounded,
                          () {},
                          Colors.yellowAccent,
                        ),
                        _StatCardData(
                          item.loveSeriesCount,
                          "收藏系列",
                          Icons.star,
                          () {},
                          Colors.yellow,
                        ),
                        _StatCardData(
                          item.loveBookCount,
                          "收藏书籍",
                          Icons.favorite,
                          () {},
                          Colors.redAccent,
                        ),
                        _StatCardData(
                          item.unOverSeriesCount,
                          "连载系列",
                          Icons.autorenew,
                          () {},
                          Colors.blue,
                        ),
                        _StatCardData(
                          item.overSeriesCount,
                          "完结系列",
                          Icons.check_circle,
                          () {},
                          Colors.green,
                        ),
                        _StatCardData(
                          item.discardedSeriesCount,
                          "弃坑系列",
                          Icons.cancel,
                              () {},
                          Colors.grey,
                        ),
                      ];
                      return LayoutBuilder(
                        builder: (BuildContext context, constraints) {
                          int num = 1; // 默认值设为最小卡片数
                          if (constraints.maxWidth <= MyApp.width &&
                              constraints.maxWidth >= MyApp.width - 200) {
                            num = 4;
                          } else if (constraints.maxWidth < MyApp.width - 200 &&
                              constraints.maxWidth >= MyApp.width - 300) {
                            num = 3;
                          } else {
                            num = 2;
                          }
                          double width =
                              (constraints.maxWidth / num).clamp(0, 250) - 10;
                          return Wrap(
                            alignment: WrapAlignment.start,
                            children: items.map((item) {
                              return _StatCard(data: item, width: width);
                            }).toList(),
                          );
                        },
                      );
                    },
                    error: (Object error, StackTrace stackTrace) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 100,
                        child: Center(
                          child: Text(
                            '加载失败: $error',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    },
                    loading: () {
                      return const SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
