import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/setting/TimeCount.dart';
import 'package:DReader/widgets/ListTitleWidget.dart';

import '../../../common/HttpApi.dart';

class _BarChart extends StatelessWidget {
  const _BarChart(
      {required this.valueList, required this.titleMap, required this.count});

  final List<int> valueList;
  final Map<int, int> titleMap;
  final double count;
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        //头部的数字展示
        titlesData: titlesData,
        //是否展示标题
        borderData: borderData,
        barGroups: barGroups,
        //数据
        gridData: const FlGridData(show: false),
        //背景
        alignment: BarChartAlignment.spaceAround,
        maxY: count, //y轴最大数量（要为合计）
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = titleMap[value].toString();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        // rightTitles: const AxisTitles(
        //   sideTitles: SideTitles(showTitles: false),
        // ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.blue,
          Colors.cyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups {
    return valueList.asMap().entries.map((entry) {
      int index = entry.key;  // 获取当前项的索引
      int value = entry.value; // 获取当前项的值

      return BarChartGroupData(
        x: index, // 使用索引作为 x 轴值
        barRods: [
          BarChartRodData(
            toY: value.toDouble(),  // 设置条形图的高度为 value
            gradient: _barsGradient,
          )
        ],
      );
    }).toList();
  }
}

class SettingBarChart extends StatefulWidget {
  const SettingBarChart({super.key});

  @override
  State<StatefulWidget> createState() => SettingBarChartState();
}

class SettingBarChartState extends State<SettingBarChart> {
  int value = -1;
  List<TimeCount>? timeCountList;
  List<int> valueList = [];
  Map<int, int> titleMap = {};
  num count = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    BaseResult baseResult = await HttpApi.request("/setting/timeCount",
        (json) => (json as List).map((e) => TimeCount.fromJson(e)).toList());
    if (baseResult.code == "2000") {
      value = -1;
      getTitles(baseResult.result);
      setState(() {
        timeCountList = baseResult.result;
      });
    }
  }

  void getTitles(timeCounts) {
    int index = 0;
    titleMap.clear();
    valueList.clear();
    count = 0;
    timeCounts.forEach((value) {
      titleMap[index] = value.time;
      valueList.add(value.count);
      index++;
      count += value.count;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (timeCountList == null) {
      return const Center(
          child: SizedBox(
        width: 150,
        height: 150,
        child: CircularProgressIndicator(),
      ));
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text.rich(TextSpan(children: [
                  TextSpan(
                      text: "资源文件创建时间",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextSpan(text: "(单位:个)")
                ])),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: DropdownButton(
                        items: <DropdownMenuItem<int>>[
                          DropdownMenuItem(
                            value: -1,
                            child: Text(
                              "全部",
                              style: TextStyle(
                                  color:
                                      value == 1 ? Colors.cyan : Colors.grey),
                            ),
                          ),
                          ...timeCountList!.asMap().entries.map((entry) {
                            int index = entry.key; // 获取下标
                            return DropdownMenuItem(
                              value: index, // 将下标作为 value
                              child: Text(
                                "${entry.value.time}", // 显示对应的值
                                style: TextStyle(
                                  color: value == index
                                      ? Colors.cyan
                                      : Colors.grey, // 根据选中的下标调整颜色
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                        hint: const Text("提示信息"),
                        // 当没有初始值时显示
                        onChanged: (selectValue) {
                          if (selectValue! < 0) {
                            getTitles(timeCountList);
                          }else{
                            getTitles(timeCountList![selectValue].children);
                          }

                          //选中后的回调
                          setState(() {
                            value = selectValue;
                          });
                        },
                        value: value,
                        // 设置初始值，要与列表中的value是相同的
                        elevation: 10,
                        //设置阴影
                        style: const TextStyle(
                            //设置文本框里面文字的样式
                            color: Colors.blue,
                            fontSize: 12),
                        iconSize: 20,
                        //设置三角标icon的大小
                        underline: Container(
                          height: 1,
                          color: Colors.blue,
                        ), // 下划线
                      )),
                ),
                Expanded(
                  child: _BarChart(
                      valueList: valueList,
                      titleMap: titleMap,
                      count: count.toDouble()),
                )
              ]),
          Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                  onPressed: () => getData(), icon: const Icon(Icons.refresh)))
        ],
      ),
    );
  }
}
