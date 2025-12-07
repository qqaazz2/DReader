import 'package:DReader/main.dart';
import 'package:DReader/widgets/ScanningIndicator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/entity/book/FilesList.dart';
import 'package:DReader/entity/book/FilesList.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../widgets/SideNotice.dart';

part 'RecentlyAddsState.g.dart';

@riverpod
class RecentlyAddsState extends _$RecentlyAddsState {
  @override
  FilesList build() {
    return FilesList(50, 1, 0, 0, []);
  }

  void getList() async {
    BaseResult baseResult = await HttpApi.request(
      "/series/getList",
      (json) => FilesList.fromJson(json),
      params: {
        "page": 1,
        "limit": 20,
        "sortField": "createTime",
        "sortOrder": "desc",
      },
    );

    // 如果请求成功，更新状态
    if (baseResult.code == "2000") {
      FilesList seriesList = FilesList(10, 1, baseResult.result!.pages, baseResult.result!.count, baseResult.result!.data);
      state = seriesList;
    }
  }
}