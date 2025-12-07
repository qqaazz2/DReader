import 'package:DReader/entity/ListData.dart';
import 'package:DReader/entity/LogData.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/entity/book/FilesList.dart';
import 'package:DReader/entity/book/FilesList.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entity/BaseListResult.dart';

part 'LogState.g.dart';

@riverpod
class LogState extends _$LogState {
  late LogParam logParam;

  @override
  ListData<LogData> build() {
    logParam = LogParam();
    return ListData<LogData>(50, 1, 0, 0, []);
  }

  void reload() {
    clear();
    getList();
  }

  void clear() {
    state.page = 1;
    state.data = [];
  }

  void getList() async {
    BaseListResult<LogData> baseResult = await HttpApi.request<LogData>(
        "/log/getLogList", (json) => LogData.fromJson(json),
        params: {
          "page": state.page,
          "limit": state.limit,
          "levels": logParam.levels
        },
        isList: true);

    // 如果请求成功，更新状态
    if (baseResult.code == "2000") {
      state.data?.addAll(baseResult.result?.data as Iterable<LogData>);
      state = state.copyWith(
          page: baseResult.result?.page += 1,
          limit: baseResult.result?.limit,
          pages: baseResult.result?.pages,
          count: baseResult.result?.count,
          data: state.data);
    }
  }
}

class LogParam {
  List<String>? levels;

  LogParam({this.levels});

  LogParam copyWith({
    List<String>? levels,
  }) {
    return LogParam(
      levels: levels ?? this.levels,
    );
  }
}
