import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/HttpApi.dart';

part 'BookRecentState.g.dart';

@riverpod
class BookRecentState extends _$BookRecentState {
  int currentCheckId = 0;

  @override
  Future<List<FilesItem>?> build() async {
    currentCheckId = 0;
    BaseResult<List<FilesItem>> baseResult =
        await HttpApi.request<List<FilesItem>>("/files/getRecent", (json) {
          return (json as List)
              .map((item) => FilesItem.fromJson(item))
              .toList();
        }, params: {});

    if (baseResult.code == "2000" && ref.mounted) return baseResult.result;
    return null;
  }

  void setData(FilesItem item) {
    currentCheckId = 0;
    final list = [...?state.value];
    final index = list.indexWhere((e) => e.id == item.id);
    if(index != -1)  list.removeAt(index);
    list.insert(0,item);
    state = AsyncData(list);
  }

  void updateCheckId(int index) {
    currentCheckId = index;
    state = AsyncData([...?state.value]);
  }
}
