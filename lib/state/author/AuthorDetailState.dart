import 'dart:convert';

import 'package:DReader/entity/BaseListResult.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/ListData.dart';
import 'package:DReader/entity/author/AuthorDetail.dart';
import 'package:DReader/entity/author/AuthorItem.dart';
import 'package:DReader/common/HttpApi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'AuthorUpdateState.dart';

part 'AuthorDetailState.g.dart';

@riverpod
class AuthorDetailState extends _$AuthorDetailState {
  @override
  Future<AuthorDetail?> build(id) async {
    final updateStream = ref.watch(authorUpdateStateProvider).stream;
    final subscription = updateStream.listen((AuthorDetail detail) => syncAuthor(detail));
    ref.onDispose(() => subscription.cancel());
    BaseResult<AuthorDetail> baseResult = await HttpApi.request<AuthorDetail>(
      "/author/getAuthorDetail",
      (json) => AuthorDetail.fromJson(json),
      params: {"id": id},
    );
    if (baseResult.code == "2000") {
      return baseResult.result;
    }
    return null;
  }

 void syncAuthor(AuthorDetail detail){
    state = AsyncData(detail);
 }
}
