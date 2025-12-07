import 'dart:convert';

import 'package:DReader/entity/BaseListResult.dart';
import 'package:DReader/entity/ListData.dart';
import 'package:DReader/entity/author/AuthorDetail.dart';
import 'package:DReader/entity/author/AuthorItem.dart';
import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/state/author/AuthorUpdateState.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'AuthorListState.g.dart';

@riverpod
class AuthorListState extends _$AuthorListState {
  @override
  ListData<AuthorItem> build() {
    final updateStream = ref.watch(authorUpdateStateProvider).stream;
    final subscription = updateStream.listen((AuthorDetail detail) => syncAuthor(detail));
    ref.onDispose(() => subscription.cancel());
    return ListData<AuthorItem>(50, 1, 0, 0, []);
  }

  void reload() {
    clear();
    getList();
  }

  void clear() {
    state.page = 1;
    state.data = [];
  }

  void searchByName(String? name){
    clear();
    getList(name:name);
  }

  void getList({String? name}) async {
    BaseListResult<AuthorItem> baseListResult =
        await HttpApi.request<AuthorItem>(
          "/author/getAuthorList",
          (json) => AuthorItem.fromJson(json),
          params: {"page": state.page, "limit": state.limit, "name": name},
          isList: true,
        );

    // 如果请求成功，更新状态
    if (baseListResult.code == "2000") {
      state = baseListResult.result!;
    }
  }

  void addFirstItem(AuthorItem authorItem) {
    state.data?.insert(0, authorItem);
  }

  void syncAuthor(AuthorDetail detail){
    if(state.data == null || state.data!.isEmpty) return;
    int index = state.data!.indexWhere((item) => item.id == detail.id);
    if(index < 0) return;
    state.data![index].name = detail.name;
    state.data![index].avatar = detail.avatar;
    state = state.copyWith(data: state.data);
  }
  //
  // Future<void> updateData(FilesItem filesItem, int index) async {
  //   BaseResult baseResult = await HttpApi.request(
  //     "/series/updateData",
  //     () => {},
  //     method: "post",
  //     successMsg: true,
  //     params: filesItem.toJson(),
  //   );
  //   if (baseResult.code == "2000") {
  //     state.data[index] = filesItem;
  //     state = state.copyWith(
  //       data: state.data,
  //       page: state.page,
  //       limit: state.limit,
  //       pages: state.pages,
  //       count: state.count,
  //     );
  //   }
  // }
  //

  // void setData(FilesItem filesItem) {
  //   int index = 0;
  //   for (FilesItem item in state.data) {
  //     if (item.id == filesItem.id) break;
  //     index++;
  //   }
  //
  //   if (state.data.isEmpty) return;
  //   state.data[index] = filesItem;
  //   state = state.copyWith(
  //     data: state.data,
  //     page: state.page,
  //     limit: state.limit,
  //     pages: state.pages,
  //     count: state.count,
  //   );
  // }
}
