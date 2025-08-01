import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:DReader/common/Global.dart';
import 'package:DReader/main.dart';

import 'SettingsBar.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({super.key, this.width = 300});

  final double width;

  @override
  State<StatefulWidget> createState() => LeftDrawerState();
}

class LeftDrawerState extends State<LeftDrawer> {
  int index = 0;
  late double width;
  late String current;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    width = MediaQuery.of(context).size.width;
    current = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .last
        .route
        .path;
  }

  void jump(String path) {
    GoRouter.of(context).pop();
    if (current != path) {
      GoRouter.of(context).go(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: widget.width,
        child: Container(
          width: double.infinity,
          padding: width < MyApp.width
              ? const EdgeInsets.only(top: 20, left: 0)
              : const EdgeInsets.only(top: 40, left: 0),
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 20),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    "DReader",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20),
                  )),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (content, index) {
                  Item item = Global.itemList[index];
                  return Padding(
                      padding: width < MyApp.width
                          ? EdgeInsets.zero
                          : const EdgeInsets.only(bottom: 20),
                      child: ListTile(
                        leading: item.icon,
                        title: Text(item.title),
                        onTap: () => jump(item.path),
                        selected: item.path ==
                            GoRouter.of(context)
                                .routerDelegate
                                .currentConfiguration
                                .last
                                .route
                                .path,
                        hoverColor: Colors.grey,
                      ));
                },
                itemCount: Global.itemList.length,
              )),
              const SettingsBar(),
              const SizedBox(height: 5),
            ],
          ),
        ));
  }
}

class Item {
  String title;
  String path;
  Icon icon;
  Widget? endDrawer;

  Item(
      {required this.title,
      required this.path,
      required this.icon,
      this.endDrawer});
}

// class Item extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return Row()
//   }
// }
