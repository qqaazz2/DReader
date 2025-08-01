import 'package:flutter/material.dart';
import 'package:DReader/main.dart';
import 'LeftDrawer.dart';

class TopTool extends StatefulWidget {
  const TopTool(
      {super.key,
      required this.child,
      required this.title,
      this.show = true,
      this.floatingActionButton,
      this.endDrawer});

  final Widget child;
  final String title;
  final bool show;
  final Widget? endDrawer;
  final Widget? floatingActionButton;

  @override
  State<StatefulWidget> createState() => TopToolState();
}

class TopToolState extends State<TopTool> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: (widget.show && width < MyApp.width)
            ? AppBar(
                actions: const [
                  Offstage(
                    offstage: true,
                  )
                  // Icon(Icons.filter_list)
                ],
                title: Text(widget.title),
                centerTitle: true,
              )
            : null,
        drawer: const LeftDrawer(
          width: 250,
        ),
        endDrawer: widget.endDrawer,
        body: widget.child,
        floatingActionButton: widget.floatingActionButton);
  }
}
