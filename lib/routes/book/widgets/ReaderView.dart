import 'dart:async';

import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/routes/book/BookRead.dart';
import 'package:DReader/routes/book/widgets/DirectoryWidget.dart';
import 'package:DReader/routes/book/widgets/SettingPanel.dart';
import 'package:DReader/state/ThemeState.dart';
import 'package:DReader/theme/extensions/ReaderTheme.dart';
import 'package:DReader/widgets/SideNotice.dart';
import 'package:csslib/visitor.dart' hide MediaQuery;
import 'package:dio/dio.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart' hide Element;
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/common/HttpApi.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:csslib/parser.dart' as css_parser;
import 'package:html/dom.dart' hide Text;
import 'package:DReader/epub/DomRendering.dart';
import 'package:DReader/epub/PageNodes.dart';
import 'package:DReader/epub/ReaderNode.dart';
import 'package:DReader/epub/ReaderPainter.dart';
import 'package:DReader/main.dart';
import 'package:DReader/routes/book/widgets/BookPcPage.dart';

class ReaderView extends ConsumerStatefulWidget {
  const ReaderView({super.key, required this.item, required this.readRecord});

  final FilesItem item;
  final ReadRecord readRecord;

  @override
  ConsumerState<ReaderView> createState() => ReaderViewState();
}

class ReaderViewState extends ConsumerState<ReaderView> {
  bool isLoading = true;
  bool isError = false;

  final ValueNotifier<bool> showActionBar = ValueNotifier<bool>(false);
  final ValueNotifier<int> currentPage = ValueNotifier<int>(1);
  PageController pageController = PageController();

  Completer<bool> init = Completer<bool>();
  List<int> bytes = [];
  PageNodes? pageNodes;
  double? lastMaxWidth;
  Timer? debounceTimer;

  Timer? _timer;

  ReaderTheme? lastReaderTheme;
  late ReaderTheme currentReaderTheme;

  final ValueNotifier<bool> showDirectoryWidget = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleEvent);
    getEpubBytes();
  }

  bool _handleEvent(event) {
    if (isLoading || isError || pageController.positions.isEmpty) return false;
    if (HardwareKeyboard.instance.logicalKeysPressed.contains(
      LogicalKeyboardKey.arrowLeft,
    )) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
      return false;
    } else if (HardwareKeyboard.instance.logicalKeysPressed.contains(
      LogicalKeyboardKey.arrowRight,
    )) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
      return false;
    }

    return false;
  }

  void getEpubBytes() async{
    final encodedPath = Uri.encodeFull(
      widget.item.filePath.replaceAll('\\', '/').substring(1),
    );
    bytes = await HttpApi.request(
      "/$encodedPath",
      responseType: ResponseType.bytes,  () => {},
      isLoading: false,
    );
    init.complete(true);
  }

  void getEpub(
    double maxWidth,
    double maxHeight, {
    bool isColumn = false,
    int columnNum = 2,
  }) async {
    // setState(() => isLoading = true);
    try {
      await init.future;
      showDirectoryWidget.value = false;
      Map<String, List<ReaderNode>> _map = await DomRendering(readerTheme: currentReaderTheme).start(bytes);
      if(!mounted) return;
      pageNodes = PageNodes(
        _map,
        maxWidth,
        maxHeight,
        isColumn: isColumn,
        columnNum: columnNum,
        readRecodesIndex: widget.readRecord.readTagNum,
      );
      currentPage.value = pageNodes!.readPage;
      pageController = PageController(initialPage: currentPage.value);
      if(!mounted) return;
      setState(() => isLoading = false);
    } catch (e, s) {
      if (!mounted) return;
      debugPrint("EPUB 打开失败: $e\n$s");
      setState(() {
        isLoading = false;
        isError = true;
      });
      SideNoticeOverlay.error(text: "打开失败：$e");
    }
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(themeStateProvider);
    currentReaderTheme = state.readerTheme;
    final hasReaderThemeChanged =
        lastReaderTheme != null && currentReaderTheme != lastReaderTheme!;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (lastMaxWidth == null) {
          lastMaxWidth = constraints.maxWidth;
          constraintsPage(constraints);
        } else if (lastMaxWidth != constraints.maxWidth ||
            hasReaderThemeChanged) {
          isLoading = true;
          _resetDebounceTimer(constraints);
        }

        lastReaderTheme = currentReaderTheme;
        if (isLoading) {
          return const Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (isError) return errorWidget();
        return constraints.maxWidth < MyApp.width
            ? getMobile(constraints)
            : getPc(constraints);
      },
    );
  }

  Widget getPc(BoxConstraints constraints) {
    List<Widget> widgetList = [];
    for (int i = 0; i < pageNodes!.pageCount; i++) {
      List<ReaderNode> content1 = pageNodes!.list[i * 2];

      List<ReaderNode> content2 = [];
      if (i + 1 < pageNodes!.pageCount) {
        content2 = pageNodes!.list[i * 2 + 1];
      }

      widgetList.add(BookPcPage(list: content1, list2: content2));
    }
    return Listener(
      onPointerHover: (value) {
        showActionBar.value = true;
        _resetIdleTimer();
      },
      onPointerMove: (value) {
        showActionBar.value = true;
      },
      onPointerSignal: (PointerSignalEvent event) {
        if (event is PointerScrollEvent) {
          // 判断鼠标滚动
          if (showDirectoryWidget.value) return;
          if (event.scrollDelta.dy < 0) {
            pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
            );
          } else if (event.scrollDelta.dy > 0) {
            pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
            );
          }
        }
      },
      child: pageWidget(
        PageView(
          controller: pageController,
          onPageChanged: (value) {
            currentPage.value = value + 1;
            widget.readRecord.readTagNum = getReadTagNum(
              pageNodes!.list[value * 2].first,
            );
            widget.readRecord.progress = currentPage.value / widgetList.length;
          },
          children: widgetList,
        ),
        constraints,
      ),
    );
  }

  Widget getMobile(BoxConstraints constraints) {
    return GestureDetector(
      onTap: () => showActionBar.value = !showActionBar.value,
      child: pageWidget(
        PageView(
          controller: pageController,
          onPageChanged: (value) {
            currentPage.value = value + 1;
            widget.readRecord.readTagNum = getReadTagNum(
              pageNodes!.list[value].first,
            );
            widget.readRecord.progress =
                currentPage.value / pageNodes!.pageCount;
          },
          children: pageNodes!.list
              .map((value) => CustomPaint(painter: ReaderPainter(value)))
              .toList(),
        ),
        constraints,
      ),
    );
  }

  void _resetIdleTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      showActionBar.value = false;
    });
  }

  void _resetDebounceTimer(BoxConstraints constraints) {
    debounceTimer?.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 2000), () {
      constraintsPage(constraints);
    });
  }

  Widget errorWidget() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 50),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text("解析错误"),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            label: const Text("返回"),
            icon: const Icon(Icons.arrow_back_sharp),
          ),
        ],
      ),
    );
  }

  int getReadTagNum(ReaderNode node) {
    if (node.children.isEmpty) return node.uniqueId;
    return getReadTagNum(node.children.first);
  }

  bool checkVisibility() {
    StatefulNavigationShellState shellState = StatefulNavigationShell.of(
      context,
    );
    bool isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    return (shellState.currentIndex == 1 || shellState.currentIndex == 0) &&
        isCurrent;
  }

  void constraintsPage(BoxConstraints constraints) {
    // if(!checkVisibility()) return;
    lastMaxWidth = constraints.maxWidth;
    getEpub(
      constraints.maxWidth,
      constraints.maxHeight,
      isColumn: constraints.maxWidth > MyApp.width,
    );
  }

  void showSettingPanel() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const SettingPanel();
      },
    );
  }

  void showDirectory() {
    // if (MediaQuery.of(context).size.width > MyApp.width) {
    showDirectoryWidget.value = true;
    // } else {
    //   showModalBottomSheet(
    //     context: context,
    //     builder: (context) => DirectoryWidget(pageNodes: pageNodes!),
    //   );
    // }
  }

  Widget pageWidget(Widget contentChild, BoxConstraints constraints) {
    return Stack(
      children: [
        contentChild,
        ValueListenableBuilder(
          valueListenable: showActionBar,
          builder: (context, value, child) {
            return AnimatedPositioned(
              top: value ? 0 : -50,
              duration: const Duration(milliseconds: 300),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                color: Theme.of(context).cardColor.withOpacity(0.8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                    Expanded(
                      child: Text(
                        widget.item.name,
                        style: const TextStyle(fontSize: 18),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: showActionBar,
          builder: (context, value, child) {
            return AnimatedPositioned(
              bottom: value ? 0 : -100,
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: constraints.maxWidth,
                padding: const EdgeInsets.all(10),
                color: Theme.of(context).cardColor.withOpacity(0.8),
                child: ValueListenableBuilder(
                  valueListenable: currentPage,
                  builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IconButton(
                              onPressed: () => pageController.jumpToPage(0),
                              icon: const Icon(
                                Icons.keyboard_double_arrow_left_outlined,
                              ),
                            ),
                            Expanded(
                              child: Focus(
                                canRequestFocus: false,
                                descendantsAreFocusable: false,
                                child: Slider(
                                  value: currentPage.value.toDouble(),
                                  onChanged: (value) {
                                    pageController.jumpToPage(value.toInt());
                                  },
                                  max: pageNodes!.pageCount.toDouble(),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => pageController.jumpToPage(
                                pageNodes!.pageCount,
                              ),
                              icon: const Icon(
                                Icons.keyboard_double_arrow_right_outlined,
                              ),
                            ),
                          ],
                        ),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => showSettingPanel(),
                                      icon: const Icon(Icons.settings),
                                      tooltip: "设置",
                                    ),
                                    IconButton(
                                      onPressed: () => showDirectory(),
                                      icon: const Icon(Icons.menu),
                                      tooltip: "目录",
                                    ),
                                  ],
                                ),
                                Text(
                                  "当前阅读进度:${currentPage.value}/${pageNodes!.pageCount}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: showDirectoryWidget,
          builder: (context, show, child) {
            return IgnorePointer(
              ignoring: !show,
              child: AnimatedOpacity(
                opacity: show ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: GestureDetector(
                  onTap: () => showDirectoryWidget.value = false,
                  child: Container(
                    color: Colors.black.withAlpha(100),
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                  ),
                ),
              ),
            );
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: showDirectoryWidget,
          builder: (context, show, child) {
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: show ? 0 : (constraints.maxWidth > MyApp.width ? -300 : 0),
              bottom: show
                  ? 0
                  : (constraints.maxWidth > MyApp.width ? 0 : -500),
              height: constraints.maxWidth > MyApp.width
                  ? constraints.maxHeight
                  : 500,
              width: constraints.maxWidth > MyApp.width
                  ? 300
                  : constraints.maxHeight,
              child: DirectoryWidget(
                pageNodes: pageNodes!,
                currentPage: currentPage.value,
                clickFunc: (index) => pageController.jumpToPage(index),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ParseTask {
  final double maxWidth;
  final double maxHeight;
  final bool isColumn;
  final int columnNum;
  final int readTagNum;
  final List<List<ReaderNode>> list;

  ParseTask({
    required this.maxWidth,
    required this.maxHeight,
    required this.isColumn,
    required this.columnNum,
    required this.readTagNum,
    required this.list,
  });
}

class ListTask {
  final String filePath;
  final ReaderTheme theme;

  ListTask({required this.filePath, required this.theme});
}
