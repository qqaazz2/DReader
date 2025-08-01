import 'package:flutter/material.dart';
import 'package:DReader/common/Global.dart';
import 'package:DReader/models/PlaceholderWidget.dart';
import 'package:DReader/widgets/SetBaseUrl.dart';

import '../widgets/TopTool.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (Global.setting.serverConfig.baseUrl.isEmpty) {
      // 这里使用 WidgetsBinding 来延迟执行 showDialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Global.showSetBaseUrlDialog(context);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const TopTool(
        title: "首页",
        child: PlaceholderWidget(
            icon: Icons.local_fire_department_outlined,
            title: "一个强大的魔法正在酝酿...",
            message: "别急，让魔法药水再多熬一会儿！新功能即将出炉。"));
  }
}
