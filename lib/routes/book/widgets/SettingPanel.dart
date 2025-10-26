import 'dart:ffi';

import 'package:DReader/main.dart';
import 'package:DReader/state/ThemeState.dart';
import 'package:DReader/theme/extensions/ReaderTheme.dart';
import 'package:DReader/widgets/ListTitleWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingPanel extends ConsumerStatefulWidget {
  const SettingPanel({super.key});

  @override
  ConsumerState<SettingPanel> createState() => SettingPanelState();
}

class SettingPanelState extends ConsumerState<SettingPanel> {
  late ReaderTheme readerTheme;
  late Color textColor;
  late TextEditingController _textSizeController;
  late TextEditingController _lineMarginController;

  @override
  void initState() {
    super.initState();
    readerTheme = ref.read(themeStateProvider).readerTheme.copy();
    _textSizeController = TextEditingController(
      text: "${readerTheme.textSize}",
    );
    _lineMarginController = TextEditingController(
      text: "${readerTheme.lineMargin ?? 12}",
    );
  }

  Future<Color?> showColorPicker(Color color) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        Color pickerColor = color;
        return AlertDialog(
          scrollable: true,
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          content: Column(
            children: [
              ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (value) => pickerColor = value,
                colorPickerWidth: 300,
                pickerAreaHeightPercent: 0.7,
                enableAlpha: true,
                // hexInputController will respect it too.
                displayThumbColor: true,
                paletteType: PaletteType.hsvWithHue,
                labelTypes: const [],
                pickerAreaBorderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
                // hexInputController: textController, // <- here
                portraitOnly: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(pickerColor);
                  },
                  child: const Text("确认"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void changeTextColor() async {
    Color? color = await showColorPicker(readerTheme.textColor!);
    if (color != null) setState(() => readerTheme.textColor = color);
  }

  void changeBgColor() async {
    Color? color = await showColorPicker(readerTheme.backgroundColor!);
    if (color != null) setState(() => readerTheme.backgroundColor = color);
  }

  void saveReaderConfig() {
    ref.read(themeStateProvider.notifier).changeReaderTheme(readerTheme);
  }

  @override
  void dispose() {
    _textSizeController.dispose();
    _lineMarginController.dispose();
    super.dispose();
  }

  void changeTextSize(String value) {
    int? num = int.tryParse(value.trim());
    if (num == null) {
      _textSizeController.text = "${readerTheme.textSize}";
    } else {
      final clampedValue = num.clamp(10, 50);
      _textSizeController.text = "$clampedValue";
      if (clampedValue != readerTheme.textSize) {
        setState(() {
          readerTheme.textSize = clampedValue;
        });
      }
    }
  }

  void changeLineMargin(String value) {
    double? num = double.tryParse(value.trim());
    if (num == null) {
      _lineMarginController.text = "${readerTheme.lineMargin}";
    } else {
      final double clampedValue = num.clamp(10, 50);
      _lineMarginController.text = "$clampedValue";
      if (clampedValue != readerTheme.lineMargin) {
        setState(() {
          readerTheme.lineMargin = clampedValue;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth > MyApp.width
                ? 500
                : constraints.maxWidth,
            height: 500,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, size: 25),
                      ),
                      const Text("阅读设置", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListTitleWidget(
                            icon: const Icon(Icons.toggle_on, size: 40),
                            title: const Text("是否跟随APP主题"),
                            content: const Text("开启时使用主题背景，关闭时自定义阅读背景和文本颜色"),
                            trailing: Switch(
                              value: readerTheme.followThemeColor,
                              onChanged: (value) {
                                setState(
                                  () => readerTheme.followThemeColor = value,
                                );
                              },
                            ),
                          ),
                          ListTitleWidget(
                            trailing: RawChip(
                              avatar: ClipOval(
                                child: Container(
                                  color: readerTheme.backgroundColor,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              onPressed: readerTheme.followThemeColor
                                  ? null
                                  : () => changeBgColor(),
                              label: Text(
                                "#${readerTheme.backgroundColor!.toHexString()}",
                              ),
                            ),
                            icon: const Icon(Icons.color_lens, size: 40),
                            title: const Text("背景颜色"),
                            content: const Text("阅读界面背景颜色"),
                          ),
                          ListTitleWidget(
                            trailing: RawChip(
                              avatar: ClipOval(
                                child: Container(
                                  color: readerTheme.textColor,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              onPressed: readerTheme.followThemeColor
                                  ? null
                                  : () => changeTextColor(),
                              label: Text(
                                "#${readerTheme.textColor!.toHexString()}",
                              ),
                            ),
                            icon: const Icon(Icons.format_color_text, size: 40),
                            title: const Text("文本颜色"),
                            content: const Text("修改文本颜色"),
                          ),
                          ListTitleWidget(
                            trailing: SizedBox(
                              width: 100,
                              child: Focus(
                                child: TextFormField(
                                  readOnly: readerTheme.followThemeColor,
                                  controller: _textSizeController,
                                  textAlign: TextAlign.center,
                                  onFieldSubmitted: (String value) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 1.2,
                                      ),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                onFocusChange: (hasFocus) {
                                  if (!hasFocus) {
                                    changeTextSize(_textSizeController.text);
                                  }
                                },
                              ),
                            ),
                            icon: const Icon(Icons.text_fields, size: 40),
                            title: const Text("文本大小"),
                            content: const Text("阅读器文本默认大小（初始值与缩放基准）"),
                          ),
                          const Divider(),
                          ListTitleWidget(
                            trailing: Switch(
                              value: readerTheme.useLinePreset,
                              onChanged: (value) {
                                setState(
                                  () => readerTheme.useLinePreset = value,
                                );
                              },
                            ),
                            icon: const Icon(Icons.adjust, size: 40),
                            title: const Text("行间距控制"),
                            content: const Text("开启为使用书籍预设间距，关闭为自定义间距"),
                          ),
                          ListTitleWidget(
                            trailing: SizedBox(
                              width: 100,
                              child: Focus(
                                child: TextFormField(
                                  readOnly: readerTheme.useLinePreset,
                                  textAlign: TextAlign.center,
                                  controller: _lineMarginController,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 1.2,
                                      ),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                onFocusChange: (hasFocus) {
                                  if (!hasFocus) {
                                    changeLineMargin(_lineMarginController.text);
                                  }
                                },
                              ),
                            ),
                            icon: const Icon(
                              Icons.format_line_spacing,
                              size: 40,
                            ),
                            title: const Text("行间距离"),
                            content: const Text("控制段落垂直间隔，区分层次"),
                          ),
                          ListTitleWidget(
                            trailing: Switch(
                              value: readerTheme.useLineSpacing,
                              onChanged: (value) {
                                if (readerTheme.useLinePreset) return;
                                setState(
                                  () => readerTheme.useLineSpacing = value,
                                );
                              },
                            ),
                            icon: const Icon(
                              Icons.vertical_align_center,
                              size: 40,
                            ),
                            title: const Text("行距开关"),
                            content: const Text("控制句子分行时是否添加间距"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      if (readerTheme.followThemeColor) {
                        readerTheme.textColor = Colors.white;
                        readerTheme.backgroundColor = Theme.of(
                          context,
                        ).colorScheme.onPrimary;
                        readerTheme.textSize = 16;
                      }

                      if(readerTheme.useLinePreset){
                        readerTheme.lineMargin = 12;
                        readerTheme.useLineSpacing = false;
                      }
                      ref
                          .read(themeStateProvider.notifier)
                          .changeReaderTheme(readerTheme);
                      Navigator.of(context).pop();
                    },
                    label: const Text("确认"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
