import 'dart:async';
import 'dart:convert';

import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/book/BookItem.dart';
import 'package:DReader/entity/book/FilesDetailsItem.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/entity/readLog/ReadLogListItem.dart';
import 'package:DReader/widgets/SideNotice.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'FilesDetailsItemState.dart';
import 'FilesListState.dart';

part 'FilesGlobalUpdateState.g.dart';

@riverpod
class FilesGlobalUpdateState extends _$FilesGlobalUpdateState {
  @override
  StreamController<FilesItem> build() {
    ref.keepAlive();
    StreamController<FilesItem> controller = StreamController<FilesItem>.broadcast();
    ref.onDispose(() => controller.close());
    return controller;
  }
}
