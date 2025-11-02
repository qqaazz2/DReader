import 'dart:convert';

import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/readLog/ReadLogListItem.dart';
import 'package:DReader/widgets/SideNotice.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'GetReadLogListState.g.dart';

@riverpod
class GetReadLogListState extends _$GetReadLogListState {
  @override
  Future<List<ReadLogListItem>> build(String date) async {
  BaseResult baseResult = await HttpApi.request(
      "/readLog/getReadLogListByTime",
          (json) => json.map((item) => ReadLogListItem.fromJson(item)).toList(),
      params: {
        'date': date
      }
  );

  if (baseResult.code == "2000") {
    return baseResult.result;
  }else{
    SideNoticeOverlay.error(text: baseResult.message);
    return [];
  }
}
}