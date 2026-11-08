import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/book/FilesDownload.dart';
import 'package:DReader/entity/book/ReadRecord.dart';
import 'package:DReader/entity/book/SyncProgressItem.dart';
import 'package:DReader/state/book/FilesDownloadState.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'LocalState.g.dart';

@riverpod
class LocalState extends _$LocalState {
  late Directory bookDirectory;
  late File jsonFile;
  late Directory coverDirectory;
  late Dio dio;
  bool isReady = false;

  @override
  List<FilesDownload> build() {
    return [];
  }

  void getList() async {
    final directory = await getApplicationSupportDirectory();
    bookDirectory = Directory('${directory.path}/books');
    if (!await bookDirectory.exists()) await bookDirectory.create(recursive: true);
    coverDirectory = Directory('${directory.path}/cover');
    if (!await coverDirectory.exists()) await coverDirectory.create(recursive: true);
    jsonFile = File("${bookDirectory.path}/cache.jsonl");
    if (!await jsonFile.exists()) {
      await jsonFile.create(recursive: true);
    }
    List<String> list = await jsonFile.readAsLines();
    List<String> validList = [];
    for (String json in list) {
      FilesDownload item = FilesDownload.fromJson(jsonDecode(json));
      state.add(item);
      validList.add(json);
    }
    if (validList.length != list.length) unawaited(jsonFile.writeAsString(validList.join('\n'), flush: false));
    isReady = true;
    state = [...state];
  }

  Future<void> removeItem(List<FilesDownload> removeData) async {
    final hashData = removeData.map((item) => item.hash).toSet();
    for (String hash in hashData) {
      File file = File("${bookDirectory.path}/$hash.epub");
      if (await file.exists()) {
        await file.delete();
      }
    }
    state.removeWhere((item) => hashData.contains(item.hash));
    String json = state.map((item) => jsonEncode(item)).toList().join("\n");
    await jsonFile.writeAsString(state.isEmpty ? "" : "$json\n", flush: true);
    const provider = filesDownloadStateProvider;
    if (ref.exists(provider)) ref.read(provider.notifier).removeItem(removeData);
    state = [...state];
  }

  Future<void> updateProgress(
    String hash,
    ReadRecord readRecord,
    bool isBack,
  ) async {
    for (FilesDownload filesDownload in state) {
      if (filesDownload.hash != hash) continue;
      filesDownload.progress = readRecord.progress;
      filesDownload.readTagNum = readRecord.readTagNum;
      filesDownload.readStatus = filesDownload.progress == 0 ? 1 : (filesDownload.progress >= 1 ? 2 : 3);
    }
    if (isBack) {
      String json = state.map((item) => jsonEncode(item)).toList().join("\n");
      await jsonFile.writeAsString(state.isEmpty ? "" : "$json\n",flush: true);
      state = [...state];
    }
  }

  Future<void> syncProgress() async {
    List<SyncProgressItem> list = state.map((item) => SyncProgressItem(progress: item.progress, readTagNum: item.readStatus, hash: item.hash)).toList();
    BaseResult base = await HttpApi.request(
      "/book/syncProgress",
          (json) => json,
      method: "post",
      paramsList: list.map((item) => item.toJson()).toList(),
      successMsg: true,
    );
  }
}