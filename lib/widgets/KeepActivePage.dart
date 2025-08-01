import 'package:flutter/material.dart';

class KeepActivePage extends StatefulWidget{
  const KeepActivePage({super.key,required this.widget,this.keepActive = true});

  final bool keepActive;
  final Widget widget;

  @override
  State<StatefulWidget> createState() => KeepActivePageState();
}

class KeepActivePageState extends State<KeepActivePage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => widget.keepActive;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.widget;
  }

  @override
  void didUpdateWidget(covariant KeepActivePage oldWidget) {
    if(oldWidget.keepActive != widget.keepActive){
      updateKeepAlive();
    }
    super.didUpdateWidget(oldWidget);
  }
}