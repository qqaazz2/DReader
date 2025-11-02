import 'dart:convert';

import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/readLog/ReadLogListItem.dart';
import 'package:DReader/entity/setting/TimeCount.dart';
import 'package:DReader/widgets/SideNotice.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'TimeCountState.g.dart';

@riverpod
class TimeCountState extends _$TimeCountState {
  @override
  Future<List<TimeCount>> build() async {
    BaseResult<List<TimeCount>> baseResult = await HttpApi.request<List<TimeCount>>(
        "/setting/timeCount", (json) {
      if (json is List) {
        return json.map((e) => TimeCount.fromJson(e)).toList();
      } else {
        return [];
      }
    });
    if (baseResult.code == "2000") {
      return baseResult.result!;
    }
    return [];
  }
}