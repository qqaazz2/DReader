import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:DReader/routes/setting/SettingChart.dart';

import '../../../common/HttpApi.dart';
import '../../../entity/BaseResult.dart';
import 'SettingBox.dart';

class SettingInfo extends StatefulWidget {
  const SettingInfo({super.key, this.isShow = false, this.width});

  final bool isShow;
  final double? width;

  @override
  State<SettingInfo> createState() => SettingInfoState();
}

class SettingInfoState extends State<SettingInfo> {
  double size = 0;
  int count = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    BaseResult baseResult =
        await HttpApi.request("/setting/count", (json) => json);
    if (baseResult.code == "2000") {
      setState(() {
        size = baseResult.result["size"];
        count = baseResult.result["count"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isShow) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
          child: AspectRatio(
            aspectRatio: 3.5,
            child: checkPlatform(),
          ),
        ),
      ]);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("基础信息",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Expanded(
          child: SingleChildScrollView(
        child: Column(children: [
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
        ]),
      ))
    ]);
  }

  Widget checkPlatform() {
    String text = "未知";
    IconData iconData = Icons.device_unknown;
    if (Platform.isAndroid) {
      text = "Android";
      iconData = Icons.android;
    } else if (Platform.isWindows) {
      text = "Windows";
      iconData = Icons.desktop_windows;
    }

    if (widget.isShow) {
      return SettingBox(
        title: '运行平台',
        text: text,
        icons: iconData,
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(iconData),
      title: const Text("运行平台"),
      trailing: Text(text),
    );
  }
}
