import 'package:DReader/entity/book/FilesOverview.dart';
import 'package:DReader/state/home/OverviewState.dart';
import 'package:DReader/state/setting/GetOverviewState.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/common/HttpApi.dart';

import '../../../entity/BaseResult.dart';

class SettingPieChart extends ConsumerStatefulWidget {
  const SettingPieChart({super.key});

  @override
  ConsumerState<SettingPieChart> createState() => SettingPieChartState();
}

class SettingPieChartState extends ConsumerState<SettingPieChart> {
  int touchedIndex = 0;
  int count = 0;

  Map<String, Color> colors = {
    "未读": Colors.deepOrange,
    "已读": Colors.greenAccent,
    "在读": Colors.lightBlueAccent,
  };

  @override
  void initState() {
    super.initState();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<FilesOverview> asyncValue = ref.watch(overviewStateProvider);
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "阅读情况",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => ref.invalidate(overviewStateProvider),
                    icon: const Icon(Icons.refresh),
                    tooltip: "刷新图表",
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: asyncValue.when(
                    data: (FilesOverview overview) {
                      return getPicChart(overview);
                    },
                    error: (Object error, StackTrace stackTrace) {
                      return Center(
                        child: Text(
                          '加载失败: $error',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    },
                    loading: () {
                      return const Center(
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ), // 确保中心对齐
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: colors.keys.map((value) {
                    return Indicator(
                      index: touchedIndex,
                      color: colors[value]!,
                      text: value,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getPicChart(FilesOverview overview) {
    return AspectRatio(
      aspectRatio: 1, // 强制宽高比为 1:1
      child: LayoutBuilder(
        builder: (context, constraints) {
          return PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 0,
              sections: showingSections(constraints.maxWidth, overview),
            ),
          );
        },
      ),
    );
  }

  List<PieChartSectionData>? showingSections(double width, FilesOverview overview) {
    int index = 0;
    Map<String,int> map = {
      "未读":overview.unreadCount,
      "已读":overview.overCount,
      "在读":overview.readingCount,
    };
    return map.keys.map((value) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? width / 2 : width / 2 - 10;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      index++;

      double num = map[value]! / overview.bookCount;
      return PieChartSectionData(
        color: colors[value],
        value: num,
        title: '${(num * 100).toStringAsFixed(2)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
        badgePositionPercentageOffset: .98,
      );
    }).toList();
  }

  // void getData() async {
  //   BaseResult baseResult = await HttpApi.request("/book/getOverview", (json) => json);
  //   if (baseResult.code == "2000") {
  //     map["已读"] = baseResult.result['overCount'];
  //     map["未读"] = baseResult.result['unreadCount'];
  //     map["在读"] = baseResult.result['readingCount'];
  //     count = baseResult.result['bookCount'];
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.index,
  });

  final Color color;
  final String text;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: color,
          width: 15,
          height: 15,
          margin: const EdgeInsets.only(right: 10),
        ),
        Text(text),
      ],
    );
  }
}
