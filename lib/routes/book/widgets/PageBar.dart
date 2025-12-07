import 'package:DReader/entity/book/FilesDetailsItem.dart';
import 'package:flutter/material.dart';
import 'package:DReader/entity/book/BookItem.dart';

class PageBar extends StatefulWidget {
  PageBar(
      {super.key, required this.item, required this.child, required this.count});

  final FilesDetailsItem item;
  final Widget child;
  final int count;

  @override
  State<PageBar> createState() => PageBarState();
}

class PageBarState extends State<PageBar> {
  final ValueNotifier<bool> currentValue = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
          onTap: () => currentValue.value = !currentValue.value,
          child: Stack(
            children: [
              widget.child,
              GestureDetector(child: ValueListenableBuilder(
                  valueListenable: currentValue,
                  builder: (context, value, child) {
                    return Positioned(
                        top: 0,
                        left: 0,
                        child: AnimatedOpacity(
                            opacity: value ? 1 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5),
                                color: Theme
                                    .of(context)
                                    .cardColor
                                    .withOpacity(0.8),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                            Icons.arrow_back_ios_new)),
                                    Expanded(
                                      child: Text(
                                        widget.item.name!,
                                        style: const TextStyle(fontSize: 18),
                                        maxLines: 2,
                                      ),
                                    )
                                  ],
                                ))));
                  }), onTap: () {},),
              GestureDetector(child: ValueListenableBuilder(
                  valueListenable: currentValue,
                  builder: (context, value, child) {
                    return Positioned(
                        bottom: 0,
                        left: 0,
                        child: AnimatedOpacity(
                            opacity: value ? 1 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                padding: const EdgeInsets.all(10),
                                color: Theme
                                    .of(context)
                                    .cardColor
                                    .withOpacity(0.8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Slider(value: 1, onChanged: (value) {}),
                                    Text("当前阅读进度:1/${widget.count}",
                                      style: const TextStyle(fontSize: 16),),
                                  ],
                                ))));
                  }),)
            ],
          ),
        ));
  }
}
