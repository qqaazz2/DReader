import 'dart:convert';

import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/UserInfo.dart';
import 'package:DReader/entity/readLog/ReadLog.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'UserInfoState.g.dart';

@riverpod
class UserInfoState extends _$UserInfoState {
  @override
  UserInfo? build() {
    ref.keepAlive();
    return null;
  }

  void getUserInfo() async {
    BaseResult baseResult = await HttpApi.request(
      "/user/info",
      (json) => UserInfo.fromJson(json),
    );

    if (baseResult.code == "2000") state = baseResult.result;
  }

  void changeMystery({required int mystery, String? mysteryPassword}) async {
    BaseResult baseResult = await HttpApi.request(
      params: {"mystery": mystery, "mysteryPassword": mysteryPassword},
      "/user/changeMystery",
      (json) => UserInfo.fromJson(json),
    );
    if ("2000" == baseResult.code) {
      state = state?.copyWith(mystery: mystery);
    }
  }

  void setUserInfo(UserInfo userInfo) => state = userInfo;

  void changeCover(String path) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(path, filename: "cover"),
    });
    BaseResult baseResult = await HttpApi.request(
      formData: formData,
      method: "post",
      "/user/uploadCover",
      (json) => json,
    );
    if ("2000" == baseResult.code) {
      state = state?.copyWith(cover: baseResult.result);
    }
  }
}
