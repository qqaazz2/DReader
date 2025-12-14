import 'package:DReader/main.dart';
import 'package:DReader/widgets/SetFileAdapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/Global.dart';
import '../state/ThemeState.dart';

class SettingsBar extends StatefulWidget {
  const SettingsBar({super.key});

  @override
  State<StatefulWidget> createState() => SettingsBarState();
}

class SettingsBarState extends State<SettingsBar> {
  @override
  Widget build(BuildContext context) {
    const List<Color> colors = [
      Colors.red,
      Colors.purple,
      Colors.indigo,
      Colors.blue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lime,
      Colors.amber,
      Colors.orange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(themeStateProvider);
        Color pickerColor = state.color;
        void changeColor(Color color) {
          ref.read(themeStateProvider.notifier).changeColor(color);
        }

        Widget pickerLayoutBuilder(
          BuildContext context,
          List<Color> colors,
          PickerItem child,
        ) {
          Orientation orientation = MediaQuery.of(context).orientation;

          return SizedBox(
            width: 250,
            height: 170,
            child: GridView.count(
              crossAxisCount: 5,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              children: [for (Color color in colors) child(color)],
            ),
          );
        }

        Widget pickerItemBuilder(
          Color color,
          bool isCurrentColor,
          void Function() changeColor,
        ) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.8),
                  offset: const Offset(1, 2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: changeColor,
                borderRadius: BorderRadius.circular(30),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: isCurrentColor ? 1 : 0,
                  child: Icon(
                    Icons.done,
                    size: 24,
                    color: useWhiteForeground(color)
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                direction: constraints.maxWidth > MyApp.width
                    ? Axis.vertical
                    : Axis.horizontal,
                children: [
                  IconButton(
                    tooltip: "主题模式切换",
                    onPressed: () =>
                        ref.read(themeStateProvider.notifier).changeTheme(),
                    icon: Icon(
                      state.light ? Icons.sunny : Icons.nightlight_round,
                    ),
                  ),
                  IconButton(
                    tooltip: "服务端链接",
                    onPressed: () => Global.showSetBaseUrlDialog(context),
                    icon: const Icon(Icons.link_outlined),
                  ),
                  IconButton(
                    tooltip: "图片适配器",
                    onPressed: () => showDialog(context: context, builder: (context) => const SetFileAdapter()),
                    icon: const Icon(Icons.transform),
                  ),
                  IconButton(
                    tooltip: "主题色选择",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("主题色选择"),
                            titlePadding: const EdgeInsets.only(
                              top: 5,
                              right: 10,
                              left: 10,
                              bottom: 10,
                            ),
                            contentPadding: const EdgeInsets.all(0),
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                pickerColor: pickerColor,
                                onColorChanged: changeColor,
                                availableColors: colors,
                                layoutBuilder: pickerLayoutBuilder,
                                itemBuilder: pickerItemBuilder,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.palette),
                  ),
                  // IconButton(onPressed: () => Global.logout(context), icon: const Icon(Icons.logout))
                ],
              );
            },
          ),
        );
      },
    );
  }
}
