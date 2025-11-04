import 'package:DReader/entity/ListData.dart';
import 'package:DReader/entity/book/BookItem.dart';
import 'package:DReader/entity/book/BookList.dart';
import 'package:DReader/entity/book/SeriesCover.dart';
import 'package:DReader/entity/book/SeriesCoverList.dart';
import 'package:DReader/entity/book/SeriesItem.dart';
import 'package:DReader/entity/book/SeriesContent.dart';
import 'package:DReader/entity/book/SeriesContent.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/state/book/SeriesContentState.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/HttpApi.dart';

part 'BookRecentState.g.dart';

@riverpod
class BookRecentState extends _$BookRecentState {
  @override
  BookItem? build() {
    return null;
  }

  void getData() async {
    BaseResult baseResult = await HttpApi.request(
      "/book/getRecent",
      (json) => BookItem.fromJson(json),
      params: {},
    );

    // 如果请求成功，更新状态
    if (baseResult.code == "2000") {
      state = baseResult.result;
    }
  }

  void setData(BookItem bookItem) {
    state = bookItem;
  }

  void read(context) async {
    BaseResult baseResult = await HttpApi.request(
        "/series/getIdByFilesId", (json) => json,
        params: {"id": state!.parentId});
    if (baseResult.code == "2000") {
      int seriesId = baseResult.result;
      ref.read(seriesContentStateProvider(seriesId).notifier).updateLastReadTime(seriesId);
      GoRouter.of(context).push("/read?seriesId=$seriesId", extra: state);
    }
  }
}
