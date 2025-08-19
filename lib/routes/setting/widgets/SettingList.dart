import 'package:DReader/widgets/PlaceholderWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingList extends StatefulWidget {
  const SettingList({super.key});

  @override
  State<SettingList> createState() => SettingListState();
}

class SettingListState extends State<SettingList> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return PlaceholderWidget(
          icon: Icons.local_fire_department_outlined,
          title: "一个强大的魔法正在酝酿...",
          message: "别急，让魔法药水再多熬一会儿！新功能即将出炉。");
    });
  }
}
