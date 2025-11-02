import 'dart:convert';

import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/readLog/ReadLog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ReadLogState.g.dart';

@riverpod
class ReadLogState extends _$ReadLogState{
  @override
  ReadLog? build() {
    return null;
  }

  void start(int bookId) async{
    BaseResult baseResult = await HttpApi.request("/readLog/start", (json) => ReadLog.fromJson(json));
  }
}