import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:popover/popover.dart';

class CheckHandleItem extends StatelessWidget {
  const CheckHandleItem({
    super.key,
    required this.map,
    required this.text,
    this.iconData,
    required this.onTap,
    this.width,
    this.height,
  });

  final Map map;
  final String text;
  final IconData? iconData;
  final Function(Object) onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => showPopover(
        context: context,
        backgroundColor: Theme.of(context).cardColor,
        direction: PopoverDirection.top,
        constraints: BoxConstraints(
          maxWidth: width ?? 150,
          maxHeight: height ?? 150,
          minWidth: width ?? 150,
        ),
        arrowHeight: 10,
        arrowWidth: 20,
        bodyBuilder: (context) {
          return Column(
            children: map.entries.map((e) {
              return ListTile(title: Text(e.value), onTap: () => onTap(e.key));
            }).toList(),
          );
        },
      ),
      icon: iconData == null ? null : Icon(iconData),
      label: Text(text),
    );
  }
}
