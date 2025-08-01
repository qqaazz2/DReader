import 'package:flutter/material.dart';

class ListTitleWidget extends StatelessWidget {
  final Icon icon;
  final Widget title;
  final Widget content;

  const ListTitleWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.titleHeight,
        titleTextStyle: const TextStyle(fontSize: 15),
        // subtitleTextStyle: const TextStyle(color: Colors.white),
        // iconColor: Colors.white,
        // textColor: Colors.white,

        leading: icon,
        subtitle: content,
        title: title,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  static List<DropdownMenuEntry<int>> buildMenuList(map) {
    List<DropdownMenuEntry<int>> list = [];
    map.forEach((v, k) {
      list.add(DropdownMenuEntry(value: v, label: k));
    });
    return list;
  }
}