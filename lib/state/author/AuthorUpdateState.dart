import 'dart:async';
import 'dart:convert';

import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/author/AuthorDetail.dart';
import 'package:DReader/entity/book/BookItem.dart';
import 'package:DReader/entity/book/FilesDetailsItem.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/entity/readLog/ReadLogListItem.dart';
import 'package:DReader/widgets/SideNotice.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'AuthorUpdateState.g.dart';

@riverpod
class AuthorUpdateState extends _$AuthorUpdateState {
  @override
  StreamController<AuthorDetail> build() {
    ref.keepAlive();
    StreamController<AuthorDetail> controller = StreamController<AuthorDetail>.broadcast();
    ref.onDispose(() => controller.close());
    return controller;
  }
}
