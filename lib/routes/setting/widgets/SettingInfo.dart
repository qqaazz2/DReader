import 'dart:convert';
import 'dart:io';

import 'package:DReader/state/setting/SettingCountState.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:DReader/routes/setting/SettingChart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/HttpApi.dart';
import '../../../entity/BaseResult.dart';
import 'SettingBox.dart';

class SettingInfo extends ConsumerStatefulWidget {
  const SettingInfo({super.key, this.isShow = false, this.width});

  final bool isShow;
  final double? width;

  @override
  ConsumerState<SettingInfo> createState() => SettingInfoState();
}

class SettingInfoState extends ConsumerState<SettingInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<Map> asyncValue = ref.watch(
      settingCountStateProvider,
    );
    return asyncValue.when(
      data: (Map map) {
        double size = map["size"] ?? 0;
        int count = map["count"]?.toInt() ?? 0;
        return _build(count: count, size: size);
      },
      error: (Object error, StackTrace stackTrace) {
        return Center(
          child: Text(
            '加载失败: $error',
            style: const TextStyle(color: Colors.red),
          ),
        );
      },
      loading: () {
        return const Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _build({required int count, required double size}) {
    if (widget.isShow) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BoxContainer(
            color: Colors.red,
            width: widget.width!,
            child: AspectRatio(
              aspectRatio: 3.5,
              child: SettingBox(
                title: "文件统计",
                text: "共$count个文件",
                icons: Icons.storage,
              ),
            ),
          ),
          BoxContainer(
            color: Colors.blue,
            width: widget.width!,
            child: AspectRatio(
              aspectRatio: 3.5,
              child: SettingBox(
                title: "文件大小",
                text: "共${size}GB",
                icons: Icons.insert_drive_file,
              ),
            ),
          ),
          BoxContainer(
            color: Colors.yellow,
            width: widget.width!,
            child: AspectRatio(aspectRatio: 3.5, child: checkPlatform()),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "基础信息",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.storage),
                  title: const Text("文件统计"),
                  trailing: Text("$count"),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.insert_drive_file),
                  title: const Text("文件总量"),
                  trailing: Text("${size}GB"),
                ),
                checkPlatform(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget checkPlatform() {
    String text = "未知";
    IconData iconData = Icons.device_unknown;
    if (kIsWeb) {
      text = "Web";
    } else {
      if (Platform.isAndroid) {
        text = "Android";
        iconData = Icons.android;
      } else if (Platform.isWindows) {
        text = "Windows";
        iconData = Icons.desktop_windows;
      }
    }

    if (widget.isShow) {
      return SettingBox(title: '运行平台', text: text, icons: iconData);
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(iconData),
      title: const Text("运行平台"),
      trailing: Text(text),
    );
  }
}
