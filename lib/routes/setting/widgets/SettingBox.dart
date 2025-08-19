import 'package:flutter/material.dart';

class SettingBox extends StatefulWidget {
  const SettingBox(
      {super.key,
      required this.title,
      required this.text,
      required this.icons});

  final String title;
  final String text;
  final IconData icons;

  @override
  State<SettingBox> createState() => SettingBoxState();
}

class SettingBoxState extends State<SettingBox> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            FittedBox(
              fit: BoxFit.cover,
              child: Text(widget.text),
            )
          ],
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: FittedBox(
            child: Icon(
          widget.icons,
          size: 70,
        )),
      ),
    ]);
  }
}
