import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/readLog/ReadLog.dart';
import 'package:DReader/routes/book/widgets/SettingPanel.dart';
import 'package:DReader/state/ThemeState.dart';
import 'package:DReader/theme/extensions/ReaderTheme.dart';
import 'package:DReader/widgets/SideNotice.dart';
import 'package:csslib/visitor.dart' hide MediaQuery;
import 'package:dio/dio.dart';

// import 'package:epub_view/epub_view.dart' hide Image;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart' hide Element;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:DReader/common/EpubParsing.dart';
import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/book/BookItem.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:csslib/parser.dart' as css_parser;
import 'package:html/dom.dart' hide Text;
import 'package:DReader/epub/DomRendering.dart';
import 'package:DReader/epub/Node/ImageNode.dart';
import 'package:DReader/epub/PageNodes.dart';
import 'package:DReader/epub/ReaderNode.dart';
import 'package:DReader/epub/ReaderPainter.dart';
import 'package:DReader/main.dart';
import 'package:DReader/routes/book/widgets/BookPcPage.dart';
import 'package:DReader/routes/book/widgets/PageBar.dart';

// import 'package:DReader/routes/book/widgets/TextPcPage.dart';
import 'package:DReader/state/book/SeriesContentState.dart';

class BookRead extends ConsumerStatefulWidget {
  const BookRead({
    super.key,
    required this.bookItem,
    this.textSize = 15,
    required this.seriesId,
  });

  final BookItem bookItem;
  final int seriesId;
  final int textSize;

  @override
  ConsumerState<BookRead> createState() => BookReadState();
}

class BookReadState extends ConsumerState<BookRead> {
  bool isLoading = true;
  bool isError = false;

  late String temporaryFolder;
  late Directory folder;
  late int charsPerLine;
  late int linesPerPage;
  List<List<ReaderNode>> _list = [];
  final ValueNotifier<bool> currentValue = ValueNotifier<bool>(false);
  final ValueNotifier<int> currentPage = ValueNotifier<int>(1);
  PageController pageController = PageController();
  List<int> bytes = [];
  late final AppLifecycleListener appLifecycleListener;
  late PageNodes pageNodes;
  double? lastMaxWidth;
  Timer? debounceTimer;

  Timer? _timer;

  late int readTagNum;
  late double progress;

  ReaderTheme? lastReaderTheme;
  late ReaderTheme currentReaderTheme;

  late ReadLog readLog;
  late DateTime recordDateTime;
  @override
  void initState() {
    super.initState();
    temporaryFolder = "${widget.bookItem.id}";
    readTagNum = widget.bookItem.readTagNum;
    progress = widget.bookItem.progress;
    startReadLog();
    HardwareKeyboard.instance.addHandler(_handleEvent);
    appLifecycleListener = AppLifecycleListener(
      onResume: () => startReadLog(),
      onHide: () => updateProgress(), //隐藏了程序会触发
      onInactive: () => updateProgress(), //失去了焦点，但是页面还在后台（PC） 分屏、画中画（Android）
    );
  }

  void startReadLog() async {
    recordDateTime = DateTime.now();
    BaseResult baseResult = await HttpApi.request(
      "/readLog/start",
      (json) => ReadLog.fromJson(json),
      params: {"bookId": widget.bookItem.id},
    );
    if (baseResult.code == "2000") {
      readLog = baseResult.result;
    }
  }

  void recordReadLog() async {
    BaseResult baseResult = await HttpApi.request(
      "/readLog/record",
      (json) => ReadLog.fromJson(json),
      params: {"readLogId": readLog.id},
    );
    if (baseResult.code == "2000") {
      readLog = baseResult.result;
    }
  }

  bool _handleEvent(event) {
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

  void getEpub(
    double maxWidth,
    double maxHeight, {
    isColumn = false,
    columnNum = 2,
  }) async {
    try {
      // Directory directory = await getTemporaryDirectory();
      // folder = Directory("${directory.path}/$temporaryFolder");
      // if (!folder.existsSync()) folder.createSync();

      if (bytes.isEmpty) {
        String encodedFilePath = Uri.encodeFull(
          widget.bookItem.filePath.replaceAll('\\', '/').substring(1),
        );
        bytes = await HttpApi.request(
          "/$encodedFilePath",
          responseType: ResponseType.bytes,
          () => {},
          isLoading: false,
        );
      }

      _list = await DomRendering(readerTheme: currentReaderTheme).start(bytes);
      pageNodes = PageNodes(
        _list,
        maxWidth,
        maxHeight,
        isColumn: isColumn,
        columnNum: columnNum,
        readRecodesIndex: readTagNum,
      );
      currentPage.value = pageNodes.readPage;
      pageController = PageController(initialPage: currentPage.value);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      SideNoticeOverlay.error(text: e.toString());
    }
  }

  void updateProgress() {
    if(DateTime.now().difference(recordDateTime).inSeconds < 5){
      SideNoticeOverlay.warning(text: "本次阅读时长不足五秒，不予计入");
      return;
    }
    BookItem item = widget.bookItem;
    item.readTagNum = readTagNum;
    item.progress = progress;
    recordReadLog();
    ref
        .read(seriesContentStateProvider(widget.seriesId).notifier)
        .updateProgress(item);
  }

  // 关闭 Isolate
  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleEvent);
    appLifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: PopScope(
        onPopInvokedWithResult: (bool didPop, Object? result) {
          updateProgress();
        },
        child: buildWidget(),
      ),
    );
  }

  Widget buildWidget() {
    final state = ref.watch(themeStateProvider);
    currentReaderTheme = state.readerTheme;
    final hasReaderThemeChanged =
        lastReaderTheme != null && currentReaderTheme != lastReaderTheme!;
    return SafeArea(
      child: Container(
        color: currentReaderTheme.backgroundColor,
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (lastMaxWidth == null) {
              lastMaxWidth = constraints.maxWidth;
              constraintsPage(constraints);
            } else if (lastMaxWidth != constraints.maxWidth || hasReaderThemeChanged) {
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
        ),
      ),
    );
  }

  Widget getPc(BoxConstraints constraints) {
    List<Widget> widgetList = [];
    for (int i = 0; i < pageNodes.pageCount; i++) {
      List<ReaderNode> content1 = pageNodes.list[i * 2];

      List<ReaderNode> content2 = [];
      if (i + 1 < pageNodes.pageCount) {
        content2 = pageNodes.list[i * 2 + 1];
      }

      widgetList.add(BookPcPage(list: content1, list2: content2));
    }
    return Listener(
      onPointerHover: (value) {
        currentValue.value = true;
        _resetIdleTimer();
      },
      onPointerMove: (value) {
        currentValue.value = true;
      },
      onPointerSignal: (PointerSignalEvent event) {
        if (event is PointerScrollEvent) {
          // 判断鼠标滚动
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: PageView(
            controller: pageController,
            onPageChanged: (value) {
              currentPage.value = value + 1;
              readTagNum = getReadTagNum(pageNodes.list[value * 2].first);
              progress = currentPage.value / widgetList.length;
            },
            children: widgetList,
          ),
        ),
        constraints.maxWidth,
      ),
    );
  }

  Widget getMobile(BoxConstraints constraints) {
    return GestureDetector(
      onTap: () => currentValue.value = !currentValue.value,
      child: pageWidget(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: PageView(
            controller: pageController,
            onPageChanged: (value) {
              currentPage.value = value + 1;
              readTagNum = getReadTagNum(pageNodes.list[value].first);
              progress = currentPage.value / pageNodes.pageCount;
            },
            children: pageNodes.list
                .map((value) => CustomPaint(painter: ReaderPainter(value)))
                .toList(),
          ),
        ),
        constraints.maxWidth,
      ),
    );
  }

  void _resetIdleTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      currentValue.value = false;
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

  void constraintsPage(BoxConstraints constraints) {
    lastMaxWidth = constraints.maxWidth;
    getEpub(
      constraints.maxWidth > MyApp.width
          ? constraints.maxWidth / 2 - 20
          : constraints.maxWidth,
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

  Widget pageWidget(Widget contentChild, double maxWidth) {
    return Stack(
      children: [
        contentChild,
        Positioned(
          top: 0,
          left: 0,
          child: GestureDetector(
            child: ValueListenableBuilder(
              valueListenable: currentValue,
              builder: (context, value, child) {
                return AnimatedOpacity(
                  opacity: value ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
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
                            widget.bookItem.name!,
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
            onTap: () {},
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: GestureDetector(
            child: ValueListenableBuilder(
              valueListenable: currentValue,
              builder: (context, value, child) {
                return AnimatedOpacity(
                  opacity: value ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: maxWidth,
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
                                  child: Listener(
                                    child: Slider(
                                      value: currentPage.value.toDouble(),
                                      onChanged: (value) {
                                        pageController.jumpToPage(
                                          value.toInt(),
                                        );
                                      },
                                      max: pageNodes.pageCount.toDouble(),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => pageController.jumpToPage(
                                    pageNodes.pageCount,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => showSettingPanel(),
                                          icon: const Icon(Icons.settings),
                                        ),
                                        // if(constraints.maxWidth > MyApp.width)
                                      ],
                                    ),
                                    Text(
                                      "当前阅读进度:${currentPage.value}/${pageNodes.pageCount}",
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
          ),
        ),
      ],
    );
  }
}
