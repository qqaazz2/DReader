// import 'package:DReader/widgets/PlaceholderWidget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class SettingList extends StatefulWidget {
//   const SettingList({super.key});
//
//   @override
//   State<SettingList> createState() => SettingListState();
// }
//
// class SettingListState extends State<SettingList> {
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       return PlaceholderWidget(
//           icon: Icons.local_fire_department_outlined,
//           title: "一个强大的魔法正在酝酿...",
//           message: "别急，让魔法药水再多熬一会儿！新功能即将出炉。");
//     });
//   }
// }

import 'package:intl/intl.dart';
import 'package:DReader/entity/readLog/ReadLogStatisticsItem.dart';
import 'package:DReader/state/ReadLogState.dart';
import 'package:DReader/state/readLog/GetReadLogListState.dart';
import 'package:DReader/state/readLog/StatisticsReadLogState.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingList extends ConsumerStatefulWidget {
  const SettingList({super.key});

  @override
  ConsumerState<SettingList> createState() => SettingListState();
}

class SettingListState extends ConsumerState<SettingList> {
  String dateFormat(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    String endOfWeek = DateFormat(
      'yyyy-MM-dd',
    ).format(startOfWeek.add(const Duration(days: 6)));
    final provider = statisticsReadLogStateProvider(
      DateFormat('yyyy-MM-dd').format(startOfWeek),
      endOfWeek,
    );
    AsyncValue<List<ReadLogStatisticsItem>> asyncValue = ref.watch(provider);
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "阅读时长记录",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => ref.invalidate(provider),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          Expanded(
            child: asyncValue.when(
              data: (List<ReadLogStatisticsItem> list) {
                return list.isNotEmpty
                    ? LineChart(mainData(list))
                    : const Align(
                        alignment: Alignment.center,
                        child: Text("暂无数据"),
                      );
              },
              error: (Object error, StackTrace stackTrace) {
                return Center(
                  child: Text(
                    '加载失败: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              },
              loading: () => const Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData mainData(List<ReadLogStatisticsItem> list) {
    return LineChartData(
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) {
              const style = TextStyle(fontSize: 10);
              int index = value.toInt();
              if (index < 0 || index >= list.length) return const SizedBox();
              String text = list[index].date;
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Transform.rotate(
                  angle: -45 * 3.14 / 180,
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minY: 0,
      lineBarsData: [
        LineChartBarData(
          spots: list
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value.minutes.toDouble()))
              .toList(),
          barWidth: 5,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(show: true),
        ),
      ],
    );
  }
}
