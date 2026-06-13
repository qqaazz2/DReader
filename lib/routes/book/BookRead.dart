import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:DReader/common/ComputeLock.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/book/FilesDetailsItem.dart';
import 'package:DReader/entity/readLog/ReadLog.dart';
import 'package:DReader/routes/book/widgets/ReaderView.dart';
import 'package:DReader/routes/book/widgets/SettingPanel.dart';
import 'package:DReader/state/ThemeState.dart';
import 'package:DReader/state/book/BookProgressState.dart';
import 'package:DReader/state/book/FilesDetailsItemState.dart';
import 'package:DReader/state/book/FilesListState.dart';
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

import '../../entity/book/FilesItem.dart';

class BookRead extends ConsumerStatefulWidget {
  const BookRead({super.key, required this.item});

  final FilesItem item;

  @override
  ConsumerState<BookRead> createState() => BookReadState();
}

class BookReadState extends ConsumerState<BookRead> {
  final ValueNotifier<int> currentPage = ValueNotifier<int>(1);

  late final AppLifecycleListener appLifecycleListener;

  late ReadRecord readRecord;

  BookItem? bookItem;
  late ReadLog readLog;
  late DateTime recordDateTime;

  @override
  void initState() {
    super.initState();
    appLifecycleListener = AppLifecycleListener(
      onResume: () => startReadLog(),
      onHide: () => updateProgress(), //隐藏了程序会触发
      onInactive: () => updateProgress(), //失去了焦点，但是页面还在后台（PC） 分屏、画中画（Android）
    );
  }

  void startReadLog() async {
    if (bookItem == null) return;
    recordDateTime = DateTime.now();
    BaseResult baseResult = await HttpApi.request(
      "/readLog/start",
      (json) => ReadLog.fromJson(json),
      params: {"filesId": bookItem!.filesId},
    );
    if (baseResult.code == "2000") {
      readLog = baseResult.result;
    }
  }

  Future getData() async {
    recordDateTime = DateTime.now();
    BaseResult baseResult = await HttpApi.request(
      "/book/getData",
      (json) => BookItem.fromJson(json),
      params: {"filesId": widget.item.filesId},
    );
    if (baseResult.code == "2000") {
      bookItem = baseResult.result;
      readRecord = ReadRecord(progress: bookItem!.progress, readTagNum: bookItem!.readTagNum);
      startReadLog();
    }
  }

  void recordReadLog() async {
    if (bookItem == null) return;
    if (DateTime.now().difference(recordDateTime).inSeconds < 5) {
      SideNoticeOverlay.warning(text: "本次阅读时长不足五秒，不予计入");
      return;
    }
    HttpApi.request(
      "/readLog/record",
      (json) => ReadLog.fromJson(json),
      params: {"readLogId": readLog.id},
    );
  }

  void updateProgress({isBack = false}) async {
    if (bookItem == null) return;
    recordReadLog();
    if (bookItem!.progress == readRecord.progress) return;
    bookItem!.progress = readRecord.progress;
    bookItem!.readTagNum = readRecord.readTagNum;
    ref
        .read(bookProgressStateProvider.notifier)
        .updateProgress(bookItem!, widget.item, isBack: isBack);
  }

  // 关闭 Isolate
  @override
  void dispose() {
    appLifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: PopScope(
        onPopInvokedWithResult: (bool didPop, Object? result) {
          updateProgress(isBack: true);
        },
        child: buildWidget(),
      ),
    );
  }

  Widget buildWidget() {
    final state = ref.watch(themeStateProvider);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: state.readerTheme.backgroundColor,
        child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return LayoutBuilder(
              builder: (context, constraints) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    return ReaderView(item: widget.item, readRecord: readRecord);
                  }
                } else {
                  // 请求未结束，显示loading
                  return const Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class ReadRecord {
  int readTagNum = 0;
  double progress = 0;

  ReadRecord({required this.progress, required this.readTagNum});
}
