import 'package:DReader/entity/ListData.dart';
import 'package:DReader/entity/book/BookItem.dart';
import 'package:DReader/entity/book/BookList.dart';
import 'package:DReader/entity/book/FilesOverview.dart';
import 'package:DReader/entity/book/SeriesCover.dart';
import 'package:DReader/entity/book/SeriesCoverList.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/HttpApi.dart';

part 'OverviewState.g.dart';

@riverpod
class OverviewState extends _$OverviewState {
  @override
  Future<FilesOverview> build() async {
    BaseResult baseResult = await HttpApi.request(
      "/files/getOverview",
          (json) => FilesOverview.fromJson(json),
      params: {},
    );

    // 如果请求成功，更新状态
    if (baseResult.code == "2000") {
      return baseResult.result;
    }else{
      return FilesOverview(0, 0, 0, 0, 0, 0, 0, 0, 0,0);
    }
  }
}
