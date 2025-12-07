import 'dart:convert';

import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/book/BookItem.dart';
import 'package:DReader/entity/book/FilesDetailsItem.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/entity/readLog/ReadLogListItem.dart';
import 'package:DReader/state/book/FilesGlobalUpdateState.dart';
import 'package:DReader/state/home/BookRecentState.dart';
import 'package:DReader/widgets/SideNotice.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'FilesDetailsItemState.dart';
import 'FilesListState.dart';

part 'BookProgressState.g.dart';

@riverpod
class BookProgressState extends _$BookProgressState {
  @override
  void build() {}
  void updateProgress(
    BookItem bookItem,
    FilesItem filesItem, {
    isBack = false,
  }) async {
    final link = ref.keepAlive();
    try {
      BaseResult baseResult = await HttpApi.request(
        method: "post",
        "/book/updateProgress",
        (json) => json,
        params: bookItem.toJson(),
      );
      if (baseResult.code == "2000") {
        if (isBack) {
          int readStatus = baseResult.result["status"];
          FilesItem item = filesItem.copyWith();
          item.status = readStatus;
          ref.read(filesGlobalUpdateStateProvider).add(item);
          final provider = filesDetailsItemStateProvider(item.parentId);
          if (ref.exists(provider)) {
            String lastReadTime = baseResult.result["lastReadTime"];
            ref.read(provider.notifier).updateReadStatus(lastReadTime);
          }
          ref.read(bookRecentStateProvider.notifier).setData(item);
        }
      }
    }catch(e){
      print(e.toString());
    } finally {
      link.close();
    }
  }
}
