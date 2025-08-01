import 'package:flutter/material.dart';

class RightDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class RightDrawerState extends State<RightDrawer>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    animation = Tween(begin: -250.0, end: 0.0).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Text("1"));
  }
}