import 'dart:convert';

import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/author/AuthorDetail.dart';
import 'package:DReader/entity/book/FilesDetailsItem.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/entity/readLog/ReadLogListItem.dart';
import 'package:DReader/state/book/FilesGlobalUpdateState.dart';
import 'package:DReader/widgets/SideNotice.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../author/AuthorUpdateState.dart';
import 'FilesListState.dart';

part 'FilesDetailsItemState.g.dart';

@riverpod
class FilesDetailsItemState extends _$FilesDetailsItemState {
  @override
  Future<FilesDetailsItem?> build(int id) async {
    if (id == -1) return null;
    final updateStream = ref.watch(authorUpdateStateProvider).stream;
    final subscription = updateStream.listen(
      (AuthorDetail detail) => syncAuthor(detail),
    );
    ref.onDispose(() => subscription.cancel());
    BaseResult baseResult = await HttpApi.request("/files/getDetails", (json) {
      return FilesDetailsItem.fromJson(json);
    }, params: {'id': id});

    if (baseResult.code == "2000") {
      return baseResult.result;
    } else {
      SideNoticeOverlay.error(text: baseResult.message);
      return null;
    }
  }

  void updateData(FilesDetailsItem item) async {
    final Set<int> authorsToReload = {};
    if (state.value?.filesAuthors != null) authorsToReload.addAll(state.value!.filesAuthors.map((e) => e.authorId));
    authorsToReload.addAll(item.filesAuthors.map((e) => e.authorId));
    final List<int> list = authorsToReload.toList();
    BaseResult<FilesDetailsItem> baseResult =
        await HttpApi.request<FilesDetailsItem>(
          "/files/updateData",
          (json) => FilesDetailsItem.fromJson(json),
          method: "post",
          params: item.toJson(),
          isLoading: true,
        );
    if (baseResult.code == "2000" && ref.mounted) {
      state = AsyncData(baseResult.result);
      FilesItem filesItem = FilesItem(
        state.value!.id,
        state.value!.love,
        state.value!.cover,
        state.value!.name,
        state.value!.overStatus,
        state.value!.status,
        state.value!.filesId,
        state.value!.isFolder,
        state.value!.parentId,
        state.value!.filePath,
      );
      ref.read(filesGlobalUpdateStateProvider).add(filesItem);
      if (list.isNotEmpty) {
        for (int item in list) {
          final provider = filesListStateProvider(item);
          if (ref.exists(provider)) {
            ref.read(provider.notifier).clear();
            ref.read(provider.notifier).getListByAuthor();
          }
        }
      }
    }
  }

  void updateReadStatus(String? lastReadTime) async {
    if (lastReadTime == null || id == -1) return;
    BaseResult baseResult = await HttpApi.request(
      "/files/updateStatus",
      (json) => json,
      successMsg: true,
      params: {"id": id, "lastReadTime": lastReadTime},
    );
    if (baseResult.code == "2000" && ref.mounted) {
      final old = state.value!;
      state = AsyncData(
        old.copyWith(lastReadTime: lastReadTime, status: baseResult.result),
      );
    }
  }

  void setLove() async {
    int love = state.value!.love == 1 ? 2 : 1;
    BaseResult baseResult = await HttpApi.request(
      "/files/updateLove",
      () => {},
      params: {'id': state.value!.id, 'love': love},
    );
    if (baseResult.code == "2000") {
      final old = state.value!;
      state = AsyncData(old.copyWith(love: love));
    }
  }

  void updateCover(int childId) async {
    BaseResult baseResult = await HttpApi.request(
      "/files/updateCover",
      (json) => json,
      params: {'id': state.value!.id, 'childId': childId},
    );
    if (baseResult.code == "2000" && ref.mounted) {
      final old = state.value!;
      state = AsyncData(old.copyWith(cover: baseResult.result));
    }
  }

  void syncAuthor(AuthorDetail detail) {
    if (state.value == null ||
        state.value!.filesAuthors.isEmpty ||
        !ref.mounted)
      return;
    int index = state.value!.filesAuthors.indexWhere(
      (item) => item.authorId == detail.id,
    );
    if (index < 0) return;
    final old = state.value!;
    state.value!.filesAuthors[index].name = detail.name;
    state = AsyncData(old.copyWith(filesAuthors: state.value!.filesAuthors));
  }
}
