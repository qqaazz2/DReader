import 'dart:async';
import 'dart:convert';

import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:http/http.dart' as http;
import '../common/Global.dart';

class ScanningIndicatorOverlay {
  static OverlayEntry? _overlayEntry;

  static void open() {
    if (_overlayEntry != null) {
      close();
    }
    _overlayEntry = OverlayEntry(
        builder: (BuildContext context) =>
            const Positioned(bottom: 5, right: 0, child: ScanningIndicator()));
    Overlay.of(MyApp.rootNavigatorKey.currentContext!).insert(_overlayEntry!);
  }

  static void close() {
    _overlayEntry!.remove();
    _overlayEntry = null;
  }
}

class ScanningIndicator extends StatefulWidget {
  const ScanningIndicator({super.key});

  @override
  State<ScanningIndicator> createState() => ScanningIndicatorState();
}

class ScanningIndicatorState extends State<ScanningIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> animation;
  final client = http.Client();
  String id = "";
  String? data;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    animation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.linear));

    animationController.forward();

    final request = http.Request('GET',
        Uri.parse('${HttpApi.options.baseUrl}/sse/createSse')); // 替换为你的SSE服务器地址
    request.headers.addAll({
      "Authorization": "Bearer ${Global.token}",
      'Accept': 'text/event-stream'
    });

    client.send(request).then((response) {
      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen((res) {
          final lines = res.split('\n');
            for (final line in lines) {
            if (line.startsWith('id:')) {
              id = line.substring(3).trim();
            } else  {
              if(line.trim().isNotEmpty) data = line.trim();
            }
          }
          setState(() {});
        }, onDone: () {
          close();
        }, onError: (error) {
          print('SSE error: $error');
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    });
    // stream = SSEClient.subscribeToSSE(
    //     method: SSERequestType.GET,
    //     url: "${HttpApi.options.baseUrl}sse/createSse",
    //     header: {
    //       "Authorization": "Bearer ${Global.token}",
    //       "Accept": "text/event-stream",
    //     }).listen((event) {
    //   // setState(() {
    //   //   sseModel = event;
    //   // });
    // });
  }

  void close() async {
    await animationController.reverse();
    ScanningIndicatorOverlay.close();
  }

  @override
  void dispose() async {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: animation,
        child: FadeTransition(
            opacity: animationController,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Card(
                  clipBehavior: Clip.hardEdge,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Container(
                      width: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          id == "task-finished"
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green)
                              : const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5),
                                ),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              data ?? "正在检查是否有任务",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () {
                              client.close();
                              close();
                            },
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
