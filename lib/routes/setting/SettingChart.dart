import 'dart:io';

import 'package:DReader/routes/setting/widgets/SettingList.dart';
import 'package:DReader/routes/setting/widgets/SettingList.dart';
import 'package:DReader/routes/setting/widgets/SettingList.dart';
import 'package:DReader/routes/setting/widgets/SettingList.dart';
import 'package:DReader/routes/setting/widgets/SettingList.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:DReader/routes/setting/widgets/SettingBarChart.dart';
import 'package:DReader/routes/setting/widgets/SettingBox.dart';
import 'package:DReader/routes/setting/widgets/SettingInfo.dart';
import 'package:DReader/routes/setting/widgets/SettingPieChart.dart';
import 'package:DReader/routes/setting/widgets/SettingList.dart';
import 'package:DReader/routes/setting/widgets/SettingTags.dart';

class SettingChart extends StatefulWidget {
  const SettingChart({super.key,required this.constraints});

  final BoxConstraints constraints;
  @override
  State<SettingChart> createState() => SettingChartState();
}

class SettingChartState extends State<SettingChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(right: 20,left: 20),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: LayoutBuilder(builder: (context, constraints) {
          double width = constraints.maxWidth / 3 - 20;
          double height = MediaQuery.of(context).size.height;
          if (constraints.maxWidth <= 750 && constraints.maxWidth > 600) {
            return getMedium(width, height, constraints);
          }else if(constraints.maxWidth <= 600  && constraints.maxWidth > 500){
            return getSmall(width, height, constraints);
          }else if(constraints.maxWidth <= 500){
            return getMini(constraints.maxWidth, height, constraints);
          }
          return getLargest(width, height, constraints);
        })));
  }

  Widget checkPlatform() {
    String text = "未知";
    IconData iconData = Icons.device_unknown;
    if(kIsWeb){
      text = "Web";
    }else{
      if (Platform.isAndroid) {
        text = "Android";
        iconData = Icons.android;
      } else if (Platform.isWindows) {
        text = "Windows";
        iconData = Icons.desktop_windows;
      }
    }


    return SettingBox(
      title: '运行平台',
      text: text,
      icons: iconData,
    );
  }

  Widget getMini(width, height, constraints){
    return Wrap(
      runSpacing: 30, // 纵向间距
      alignment: WrapAlignment.spaceBetween,
      children: [
        BoxContainer(
          color: Colors.green,
          width: width,
          height: height * 0.32,
          child: SettingInfo(),
        ),
        BoxContainer(
          color: Colors.green,
          width: width,
          height: height * 0.4,
          child: const SettingTags(),
        ),
        BoxContainer(
          width: width,
          height: height * 0.5,
          child: SettingPieChart(
            boxConstraints: constraints,
          ),
        ),
        BoxContainer(
          color: Colors.purple,
          width: width,
          height: height * 0.5,
          child: const SettingBarChart(),
        ),
        BoxContainer(
          color: Colors.pink,
          width: width ,
          child: const SettingList(),
        ),
      ],
    );
  }

  Widget getSmall(width, height, constraints){
    return Wrap(
      runSpacing: 30, // 纵向间距
      alignment: WrapAlignment.spaceBetween,
      children: [
        BoxContainer(
          color: Colors.green,
          width: width * 2 - 20,
          height: height * 0.4,
          child: const SettingTags(),
        ),
        BoxContainer(
          color: Colors.green,
          width: width + 60,
          height: height * 0.4,
          child: SettingInfo(),
        ),
        BoxContainer(
          width: width * 3 + 60,
          height: height * 0.4,
          child: SettingPieChart(
            boxConstraints: constraints,
          ),
        ),
        BoxContainer(
          color: Colors.pink,
          width: width * 3 + 60,
          height: height * 0.4,
          child: const SettingList(),
        ),
        BoxContainer(
          color: Colors.purple,
          width: width * 3 + 60,
          height: height * 0.4,
          child: SettingBarChart(),
        ),
      ],
    );
  }

  Widget getMedium(width, height, constraints){
    return Wrap(
      runSpacing: 30, // 纵向间距
      alignment: WrapAlignment.spaceBetween,
      children: [
        BoxContainer(
          color: Colors.green,
          width: width,
          height: height * 0.4,
          child: SettingInfo(),
        ),
        BoxContainer(
          color: Colors.green,
          width: width,
          height: height * 0.4,
          child: const SettingTags(),
        ),
        BoxContainer(
          width: width,
          height: height * 0.4,
          child: SettingPieChart(
            boxConstraints: constraints,
          ),
        ),
        BoxContainer(
          color: Colors.pink,
          width: width * 3 + 60,
          height: height * 0.4,
          child: const SettingList(),
        ),
        BoxContainer(
          color: Colors.purple,
          width: width * 3 + 60,
          height: height * 0.4,
          child: SettingBarChart(),
        ),
      ],
    );
  }

  Widget getLargest(width, height, constraints) {
    return Wrap(
      runSpacing: 30, // 纵向间距
      alignment: WrapAlignment.spaceBetween,
      children: [
        SettingInfo(isShow:true,width: width,),
        BoxContainer(
          color: Colors.pink,
          width: width * 2 + 30,
          height: height * 0.4,
          child: const SettingList(),
        ),
        BoxContainer(
          color: Colors.green,
          width: width,
          height: height * 0.4,
          child: const SettingTags(),
        ),
        BoxContainer(
          width: width,
          height: height * 0.4,
          child: SettingPieChart(
            boxConstraints: constraints,
          ),
        ),
        BoxContainer(
          color: Colors.purple,
          width: width * 2 + 30,
          height: height * 0.4,
          child: SettingBarChart(),
        ),
      ],
    );
  }
}

class BoxContainer extends StatelessWidget {
  const BoxContainer(
      {super.key, required this.width, this.height, this.color, this.child});

  final double width;
  final double? height;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(context).shadowColor.withOpacity( 0.2), // 阴影颜色
              blurRadius: 10, // 阴影模糊半径
              offset: const Offset(0, 5), // 阴影偏移
            )
          ]),
      child: child,
    );
  }
}
