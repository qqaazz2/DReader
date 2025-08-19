import 'package:DReader/main.dart';
import 'package:DReader/widgets/ScanningIndicator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/book/SeriesItem.dart';
import 'package:DReader/entity/book/SeriesList.dart';
import 'package:DReader/entity/book/SeriesList.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../widgets/SideNotice.dart';

part 'SeriesListState.g.dart';

@riverpod
class SeriesListState extends _$SeriesListState {
  late SeriesParam seriesParam;

  @override
  SeriesList build() {
    seriesParam = SeriesParam();
    return SeriesList(50, 1, 0, 0, []);
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
      "/series/getList",
      (json) => SeriesList.fromJson(json),
      params: {
        "page": state.page,
        "limit": state.limit,
        "id": -1,
        "name": seriesParam.name,
        "overStatus": seriesParam.overStatus,
        "love": seriesParam.love,
        "status": seriesParam.status,
        "sortField": seriesParam.sortField,
        "sortOrder": seriesParam.sortOrder,
      },
    );

    // 如果请求成功，更新状态
    if (baseResult.code == "2000") {
      List<SeriesItem> newList = [];
      newList.addAll(state.data);
      newList.addAll(baseResult.result!.data);

      SeriesList seriesList = SeriesList(50, state.page + 1,
          baseResult.result!.pages, baseResult.result!.count, newList);
      state = seriesList;
    }
  }

  void setLove(index) async {
    int love = state.data[index].love == 1 ? 2 : 1;
    BaseResult baseResult =
        await HttpApi.request("/series/updateLove", () => {}, params: {
      'id': state.data[index].id,
      'love': love,
    });
    if (baseResult.code == "2000") {
      state.data[index].love = love;
      state = state.copyWith(
          data: state.data,
          page: state.page,
          limit: state.limit,
          pages: state.pages,
          count: state.count);
    }
  }

  void scanning() async {
    BaseResult baseResult =
        await HttpApi.request("/book/scanning", () => {}, params: {});
    if (baseResult.code == "2000") {
      SideNoticeOverlay.success(text: "开始扫描图书文件");
      ScanningIndicatorOverlay.open();
    }
  }

  Future<void> updateData(SeriesItem seriesItem, int index) async {
    BaseResult baseResult = await HttpApi.request(
        "/series/updateData", () => {},
        method: "post", successMsg: true, params: seriesItem.toJson());
    if (baseResult.code == "2000") {
      state.data[index] = seriesItem;
      state = state.copyWith(
          data: state.data,
          page: state.page,
          limit: state.limit,
          pages: state.pages,
          count: state.count);
    }
  }

  Future<SeriesItem?> randomData() async {
    BaseResult<SeriesItem> baseResult = await HttpApi.request<SeriesItem>(
      "/series/randomData",
      (json) => SeriesItem.fromJson(json),
    );

    if (baseResult.code == "2000") {
      return baseResult.result;
    }
    return null;
  }

  void setData(SeriesItem seriesItem) {
    int index = 0;
    for (SeriesItem item in state.data) {
      if (item.id == seriesItem.id) break;
      index++;
    }

    if(state.data.isEmpty) return;
    state.data[index] = seriesItem;
    state = state.copyWith(
        data: state.data,
        page: state.page,
        limit: state.limit,
        pages: state.pages,
        count: state.count);
  }
}

class SeriesParam {
  String? name;
  int? overStatus;
  int? love;
  int? status;
  String? sortField;
  String? sortOrder;

  SeriesParam(
      {this.name,
      this.overStatus,
      this.love,
      this.status,
      this.sortField,
      this.sortOrder});

  SeriesParam copyWith({
    String? name,
    int? overStatus,
    int? love,
    int? status,
    String? sortField,
    String? sortOrder,
  }) {
    return SeriesParam(
        name: name ?? this.name,
        overStatus: overStatus ?? this.overStatus,
        love: love ?? this.love,
        status: status ?? this.status,
        sortField: sortField ?? this.sortField,
        sortOrder: sortOrder ?? this.sortOrder);
  }
}
