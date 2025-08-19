import 'dart:math';

import 'package:DReader/main.dart';
import 'package:flutter/material.dart';

enum SideNoticeLevel {
  info, // 普通信息
  warning, // 警告
  error, // 错误
  success // 成功
}

class SideNoticeLevelUtils {
  static Icon getIcon(SideNoticeLevel level) {
    switch (level) {
      case SideNoticeLevel.info:
        return const Icon(Icons.info, color: Colors.blue);
      case SideNoticeLevel.warning:
        return const Icon(Icons.warning, color: Colors.orange);
      case SideNoticeLevel.error:
        return const Icon(Icons.error, color: Colors.red);
      case SideNoticeLevel.success:
        return const Icon(Icons.check_circle, color: Colors.green);
    }
  }
}

class SideNoticeOverlay {
  static final Map<String, OverlayEntry> _map = {};
  static final Map<String, double> _heightMap = {};
  static final List<String> _order = [];

  static void success({String text = "", int seconds = 5}) {
    open(text: text, seconds: seconds, level: SideNoticeLevel.success);
  }

  static void warning({String text = "", int seconds = 5}) {
    open(text: text, seconds: seconds, level: SideNoticeLevel.warning);
  }

  static void error({String text = "", int seconds = 5}) {
    open(text: text, seconds: seconds, level: SideNoticeLevel.error);
  }

  static void info({String text = "", int seconds = 5}) {
    open(text: text, seconds: seconds, level: SideNoticeLevel.info);
  }

  static String _generateRandomString() {
    final random = Random();
    const availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(
            5, (index) => availableChars[random.nextInt(availableChars.length)])
        .join();

    return randomString;
  }

  static void open(
      {required SideNoticeLevel level, String text = "", int seconds = 5}) {
    String key = _generateRandomString();
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      double top = 40;
      int currentIndex = _order.indexOf(key);
      for (int i = 0; i < currentIndex; i++) {
        top += _heightMap[_order[i]] ?? 0.0; // 累加前面通知的高度
      }
      return AnimatedPositioned(
          top: top,
          right: 0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: SideNotice(
            noticeKey: key,
            text: text,
            level: level,
            seconds: seconds,
            onHeightCalculated: (double value) {
              _heightMap[key] = value;
            },
          ));
    });
    Overlay.of(MyApp.rootNavigatorKey.currentContext!).insert(overlayEntry);
    _map[key] = overlayEntry;
    _order.add(key);
  }

  static void close(String noticeKey) {
    OverlayEntry? overlayEntry = _map[noticeKey];
    if (overlayEntry != null) {
      overlayEntry.remove();
      _map.remove(overlayEntry);
      _heightMap.removeWhere((key, value) => key == noticeKey);
      _order.remove(noticeKey);
      _map.forEach((key, overlayEntry) => overlayEntry.markNeedsBuild());
    }
  }
}

class SideNotice extends StatefulWidget {
  const SideNotice({
    super.key,
    required this.noticeKey,
    required this.level,
    required this.text,
    required this.seconds,
    required this.onHeightCalculated,
  });

  final String noticeKey;
  final SideNoticeLevel level;
  final String text;
  final int seconds;
  final ValueChanged<double> onHeightCalculated;

  @override
  State<StatefulWidget> createState() => SideNoticeState();
}

class SideNoticeState extends State<SideNotice>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> animation;
  final GlobalKey _containerKey = GlobalKey();
  bool isClosed = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    animation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.linear));

    animationController.forward();

    Future.delayed(Duration(seconds: widget.seconds), () => close());
  }

  void close() async {
    if (isClosed) return;
    isClosed = true;
    await animationController.reverse();
    SideNoticeOverlay.close(widget.noticeKey);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox =
          _containerKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        double height = renderBox.size.height;
        widget.onHeightCalculated(height);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        key: _containerKey,
        position: animation,
        child: FadeTransition(
            opacity: animationController,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double width =
                    MyApp.width < constraints.maxWidth ? 400 : MyApp.width;
                return Card(
                  clipBehavior: Clip.hardEdge,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Container(
                      width: width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SideNoticeLevelUtils.getIcon(widget.level),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.text,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () => close(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 24, minHeight: 24),
                            splashRadius: 20,
                          ),
                        ],
                      )),
                );
              },
            )));
  }
}
