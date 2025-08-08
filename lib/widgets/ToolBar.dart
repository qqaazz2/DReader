import 'package:flutter/material.dart';
import 'package:DReader/main.dart';

class ToolBar extends StatefulWidget {
  const ToolBar({super.key, this.addButton, this.isShowList = true,this.widgetList,this.showBack = false,this.title});

  final Widget? addButton;
  final String? title;
  final bool isShowList;
  final List<Widget>? widgetList;
  final bool showBack;

  @override
  State<StatefulWidget> createState() => ToolBarState();
}

class ToolBarState extends State<ToolBar> {
  @override
  Widget build(BuildContext context) {
    WidgetStatePropertyAll<TextStyle> style = const WidgetStatePropertyAll<TextStyle>(TextStyle(fontSize: 14));
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(widget.showBack) IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back)),
          if(widget.title != null) Text(widget.title!,style: Theme.of(context).textTheme.titleLarge),
          Container(),
          // SearchBar(
          //   padding: const WidgetStatePropertyAll<EdgeInsets>(
          //       EdgeInsets.only(right: 0, left: 5)),
          //   leading: const Icon(
          //     Icons.search,
          //     size: 24,
          //   ),
          //   hintText: "请输入搜索内容",
          //   hintStyle: style,
          //   trailing: [
          //     TextButton(
          //         onPressed: () {
          //           print("search");
          //         },
          //         child: const Text(
          //           "搜索",
          //           style: TextStyle(fontSize: 14),
          //         ))
          //   ],
          //   textStyle: style,
          //   constraints: const BoxConstraints(
          //       maxWidth: 400, minWidth: 400, minHeight: 30),
          // ),
          Wrap(
            spacing: 8.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if(widget.widgetList != null) ...widget.widgetList!,
              widget.addButton != null ? widget.addButton! : Container(),
              // if (widget.isShowList)
              //   IconButton(
              //       icon: const Icon(Icons.list),
              //       onPressed: () {
              //         MyApp.scaffoldKey.currentState!.openEndDrawer();
              //       }),
            ],
          )
        ],
      ),
    );
  }
}
