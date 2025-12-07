import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/HttpApi.dart';

part 'BookRecentState.g.dart';

@riverpod
class BookRecentState extends _$BookRecentState {
  @override
  Future<FilesItem?> build() async {
    BaseResult<FilesItem> baseResult = await HttpApi.request<FilesItem>(
      "/files/getRecent",
      (json) => FilesItem.fromJson(json),
      params: {},
    );

    if (baseResult.code == "2000" && ref.mounted) return baseResult.result;
    return null;
  }

  void setData(FilesItem item) => state = AsyncData(item);
}
