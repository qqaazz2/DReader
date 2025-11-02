import 'dart:convert';

import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/readLog/ReadLogListItem.dart';
import 'package:DReader/entity/readLog/ReadLogStatisticsItem.dart';
import 'package:DReader/widgets/SideNotice.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'StatisticsReadLogState.g.dart';

@riverpod
class StatisticsReadLogState extends _$StatisticsReadLogState {
  @override
  Future<List<ReadLogStatisticsItem>> build(
    String stratDate,
    String endDate,
  ) async {
    BaseResult<List<ReadLogStatisticsItem>> baseResult =
        await HttpApi.request<List<ReadLogStatisticsItem>>(
          "/readLog/statisticsReadLog",
          (json) {
            if (json is List) {
              return json
                  .map((item) => ReadLogStatisticsItem.fromJson(item))
                  .toList();
            }
              return [];
          },
          params: {"start": stratDate, "end": endDate},
        );

    if (baseResult.code == "2000") {
      return baseResult.result!;
    } else {
      SideNoticeOverlay.error(text: baseResult.message);
      return [];
    }
  }
}
