import 'package:DReader/entity/book/BookItem.dart';
import 'package:DReader/main.dart';
import 'package:DReader/state/book/FilesGlobalUpdateState.dart';
import 'package:DReader/widgets/ScanningIndicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/entity/book/FilesList.dart';
import 'package:DReader/entity/book/FilesList.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http_parser/http_parser.dart';

import '../../widgets/SideNotice.dart';

part 'FilesListState.g.dart';

@riverpod
class FilesListState extends _$FilesListState {
  late SeriesParam seriesParam;
  late int patentId;

  @override
  FilesList build(int id) {
    patentId = id;
    seriesParam = SeriesParam();
    final updateStream = ref.watch(filesGlobalUpdateStateProvider).stream;
    final subscription = updateStream.listen((FilesItem updatedItem) {
      print('id$id');
      syncItem(updatedItem);
    });
    ref.onDispose((){
      print('id$id');
      subscription.cancel();
    });
    return FilesList(50, 1, 0, 0, []);
  }

  void reload() {
    clear();
    getList();
  }

  void clear() {
    state.page = 1;
    state.data = [];
  }

  void getListByCreateTime() {
    seriesParam.sortField = "createTime";
    seriesParam.sortOrder = "desc";
    getList();
  }

  void getList() async {
    BaseResult baseResult = await HttpApi.request(
      "/files/getList",
      (json) => FilesList.fromJson(json),
      params: {
        "page": state.page,
        "limit": state.limit,
        "parentId": patentId,
        "name": seriesParam.name,
        "overStatus": seriesParam.overStatus,
        "love": seriesParam.love,
        "status": seriesParam.status,
        "sortField": seriesParam.sortField,
        "sortOrder": seriesParam.sortOrder,
        "flattening": seriesParam.flattening,
      },
    );

    // 如果请求成功，更新状态
    if (baseResult.code == "2000") {
      List<FilesItem> newList = [];
      newList.addAll(state.data);
      newList.addAll(baseResult.result!.data);

      FilesList seriesList = FilesList(
        50,
        state.page + 1,
        baseResult.result!.pages,
        baseResult.result!.count,
        newList,
      );
      state = seriesList;
    }
  }

  void getListByAuthor() async {
    BaseResult baseResult = await HttpApi.request(
      "/files/getList",
      (json) => FilesList.fromJson(json),
      params: {"page": state.page, "limit": state.limit, "authorId": patentId},
    );

    // 如果请求成功，更新状态
    if (baseResult.code == "2000") {
      List<FilesItem> newList = [];
      newList.addAll(state.data);
      newList.addAll(baseResult.result!.data);

      FilesList seriesList = FilesList(
        50,
        state.page + 1,
        baseResult.result!.pages,
        baseResult.result!.count,
        newList,
      );
      state = seriesList;
    }
  }

  void setLove(index) async {
    int love = state.data[index].love == 1 ? 2 : 1;
    BaseResult baseResult = await HttpApi.request(
      "/files/updateLove",
      () => {},
      params: {'id': state.data[index].id, 'love': love},
    );
    if (baseResult.code == "2000") {
      ref
          .read(filesGlobalUpdateStateProvider)
          .add(state.data[index].copyWith(love: love));
      // state = state.copyWith(
      //   data: state.data,
      //   page: state.page,
      //   limit: state.limit,
      //   pages: state.pages,
      //   count: state.count,
      // );
    }
  }

  void scanning() async {
    BaseResult baseResult = await HttpApi.request(
      "/book/scanning",
      () => {},
      params: {},
    );
    if (baseResult.code == "2000") {
      SideNoticeOverlay.success(text: "开始扫描图书文件");
      ScanningIndicatorOverlay.open();
    }
  }

  void syncItem(FilesItem files) {
    if (!ref.mounted) return;
    int index = state.data.indexWhere((item) => item.id == files.id);
    if (index < 0 || state.data[index] == files) return;
    state.data[index] = files;
    state = state.copyWith(
      data: state.data,
      page: state.page,
      limit: state.limit,
      pages: state.pages,
      count: state.count,
    );
    print('6');
  }

  Future<void> updateData(FilesItem filesItem, int index) async {
    BaseResult baseResult = await HttpApi.request(
      "/series/updateData",
      () => {},
      method: "post",
      successMsg: true,
      params: filesItem.toJson(),
    );
    if (baseResult.code == "2000") {
      ref.read(filesGlobalUpdateStateProvider).add(filesItem);
      // state = state.copyWith(
      //   data: state.data,
      //   page: state.page,
      //   limit: state.limit,
      //   pages: state.pages,
      //   count: state.count,
      // );
    }
  }

  Future<FilesItem?> randomData() async {
    BaseResult<FilesItem> baseResult = await HttpApi.request<FilesItem>(
      "/series/randomData",
      (json) => FilesItem.fromJson(json),
    );

    if (baseResult.code == "2000") {
      return baseResult.result;
    }
    return null;
  }

  void changeCover(int id, List<int> bytes, int index) async {
    FormData formData = FormData.fromMap({
      "id": id,
      "file": MultipartFile.fromBytes(
        bytes,
        filename: "cover.jpg",
        contentType: MediaType('image', 'jpeg'),
      ),
    });
    BaseResult baseResult = await HttpApi.request(
      "/files/changeCover",
      method: "post",
      (json) => json,
      isLoading: true,
      successMsg: true,
      formData: formData,
    );
    if (baseResult.code == "2000") {
      ref
          .read(filesGlobalUpdateStateProvider)
          .add(state.data[index].copyWith(cover: baseResult.result));
      // state = state.copyWith(
      //   data: state.data,
      //   page: state.page,
      //   limit: state.limit,
      //   pages: state.pages,
      //   count: state.count,
      // );
    }
  }

  void setData(FilesItem filesItem) {
    int index = 0;
    for (FilesItem item in state.data) {
      if (item.id == filesItem.id) break;
      index++;
    }

    if (state.data.isEmpty) return;
    state.data[index] = filesItem;
    state = state.copyWith(
      data: state.data,
      page: state.page,
      limit: state.limit,
      pages: state.pages,
      count: state.count,
    );
  }
}

class SeriesParam {
  String? name;
  int? overStatus;
  int? love;
  int? status;
  String? sortField;
  String? sortOrder;
  bool flattening;

  SeriesParam({
    this.name,
    this.overStatus,
    this.love,
    this.status,
    this.sortField,
    this.sortOrder,
    this.flattening = false,
  });

  SeriesParam copyWith({
    String? name,
    int? overStatus,
    int? love,
    int? status,
    String? sortField,
    String? sortOrder,
    bool? flattening,
  }) {
    return SeriesParam(
      name: name ?? this.name,
      overStatus: overStatus ?? this.overStatus,
      love: love ?? this.love,
      status: status ?? this.status,
      sortField: sortField ?? this.sortField,
      sortOrder: sortOrder ?? this.sortOrder,
      flattening: flattening ?? this.flattening,
    );
  }
}
