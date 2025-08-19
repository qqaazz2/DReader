import 'package:flutter/material.dart';

import '../../../widgets/PlaceholderWidget.dart';

class SettingTags extends StatefulWidget {
  const SettingTags({super.key});

  @override
  State<SettingTags> createState() => SettingTagsState();
}

class SettingTagsState extends State<SettingTags> {
  @override
  Widget build(BuildContext context) {
    return PlaceholderWidget(
        icon: Icons.local_fire_department_outlined,
        title: "一个强大的魔法正在酝酿...",
        message: "别急，让魔法药水再多熬一会儿！新功能即将出炉。");
  }
}