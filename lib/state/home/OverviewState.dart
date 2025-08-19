import 'package:DReader/entity/ListData.dart';
import 'package:DReader/entity/book/BookItem.dart';
import 'package:DReader/entity/book/BookList.dart';
import 'package:DReader/entity/book/BookOverview.dart';
import 'package:DReader/entity/book/SeriesCover.dart';
import 'package:DReader/entity/book/SeriesCoverList.dart';
import 'package:DReader/entity/book/SeriesItem.dart';
import 'package:DReader/entity/book/SeriesContent.dart';
import 'package:DReader/entity/book/SeriesContent.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/HttpApi.dart';

part 'OverviewState.g.dart';

@riverpod
class OverviewState extends _$OverviewState {
  @override
  BookOverview build() {
    return BookOverview(0, 0, 0, 0);
  }

  void getOverview() async {
    BaseResult baseResult = await HttpApi.request(
      "/book/getOverview",
      (json) => BookOverview.fromJson(json),
      params: {},
    );

    // 如果请求成功，更新状态
    if (baseResult.code == "2000") {
      state = baseResult.result;
    }
  }
}
