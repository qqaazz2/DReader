import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/author/AuthorDetail.dart';
import 'package:DReader/entity/book/FilesDetailsItem.dart';
import 'package:DReader/entity/book/FilesDownload.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/entity/book/ReadRecord.dart';
import 'package:DReader/entity/readLog/ReadLogListItem.dart';
import 'package:DReader/state/book/FilesGlobalUpdateState.dart';
import 'package:DReader/widgets/SideNotice.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:crypto/crypto.dart';

part 'FilesDownloadState.g.dart';

@riverpod
class FilesDownloadState extends _$FilesDownloadState {
  List<String> _ongoing = [];
  List<String> _pass = [];
  bool isReady = false;
  late Directory bookDirectory;
  late File jsonFile;
  late Directory coverDirectory;
  late Dio dio;

  @override
  List<FilesDownload> build() {
    ref.keepAlive();
    check();
    dio = Dio();
    return [];
  }

  void check() async {
    final directory = await getApplicationSupportDirectory();
    bookDirectory = Directory('${directory.path}/books');
    if (!await bookDirectory.exists())
      await bookDirectory.create(recursive: true);
    coverDirectory = Directory('${directory.path}/cover');
    if (!await coverDirectory.exists())
      await coverDirectory.create(recursive: true);
    jsonFile = File("${bookDirectory.path}/cache.jsonl");
    if (!await jsonFile.exists()) {
      await jsonFile.create(recursive: true);
    }
    await for (final file in bookDirectory.list()) {
      if (file is! File || !file.path.endsWith(".epub")) continue;
      String hash = file.uri.pathSegments.last.replaceFirst(".epub", "");
      _pass.add(hash);
    }
    isReady = true;
    state = List.empty();
  }

  void add(FilesItem item) {
    if (!isReady) {
      SideNoticeOverlay.warning(text: "缓存任务尚未就绪，请稍后再试");
      return;
    }
    if (state.any((element) => element.hash == item.hash) ||
        _pass.contains(item.hash)) {
      SideNoticeOverlay.warning(text: "${item.name}该文件已下载");
      return;
    }
    List<FilesDownload> list = [
      ...state,
      FilesDownload(item.hash, 3, item.cover, item.name, item.filesId, 0, 0, 1),
    ];
    state = list;
    checkListOver();
  }

  void checkListOver() {
    final list = state
        .asMap()
        .entries
        .where((entry) => entry.value.status == 3)
        .toList();
    for (final entry in list) {
      if (_ongoing.length >= 3) break;
      final index = entry.key;
      final item = entry.value;
      state[index].status = 1;
      state = [...state];
      _ongoing.add(item.hash);
      download(item);
    }
  }

  Future<void> download(FilesDownload item) async {
    File? file;
    IOSink? sink;
    try {
      file = File('${bookDirectory.path}/${item.hash}.epub');
      sink = file.openWrite();
      Response response = await HttpApi.request(
        "/files/download/${item.filesId}",
        () => {},
        responseType: ResponseType.stream,
        original: true,
      );

      if (response.statusCode != 200 ||
          (response.data is Map && response.data?["code"] != "2000")) {
        SideNoticeOverlay.error(text: "${item.name}，网络请求失败");
        throw Exception('网络请求失败');
      }
      final ResponseBody responseBody = response.data;
      await sink.addStream(responseBody.stream);
      await sink.flush();
      final etag = response.headers.value('etag');
      if (etag == null) {
        SideNoticeOverlay.error(text: "${item.name},服务器未返回 ETag");
        throw Exception('服务器未返回 ETag');
      }
      String headerHash = etag.replaceAll('"', '').toLowerCase();
      final bytes = await file.readAsBytes();
      String fileHash = sha256.convert(bytes).toString();
      if (headerHash != fileHash) {
        SideNoticeOverlay.error(text: "${item.name}文件完整性校验失败");
        throw Exception('文件完整性校验失败');
      }
      await jsonFile.writeAsString(
        '${jsonEncode(item)}\n',
        mode: FileMode.append,
        flush: true,
      );

      String? coverUrl = await _getImageUrl(item.cover);
      if (coverUrl == null) {
        SideNoticeOverlay.error(text: "${item.name}封面下载失败");
        throw Exception('封面下载失败');
      }
      await dio.download(
        coverUrl,
        '${coverDirectory.path}/${item.hash}.jpg',
        deleteOnError: true,
      );
      updateStatus(item.hash, 2);
      _pass.add(item.hash);
    } catch (e) {
      if (sink != null) await sink.close();
      if (file != null && await file.exists()) {
        await file.delete();
      }
      SideNoticeOverlay.error(text: e.toString());
      updateStatus(item.hash, 4);
    } finally {
      if (sink != null) await sink.close();
      _ongoing.remove(item.hash);
    }
  }

  void reDownload(int index) {
    state[index].status = 3;
    state = [...state];
    checkListOver();
  }

  void updateStatus(String hash, int status) {
    final index = state.indexWhere((element) => element.hash == hash);
    if (index == -1) return;
    state[index].status = status;
    state = [...state];
  }

  Future<String?> _getImageUrl(path) async {
    String? newPath;
    BaseResult baseResult = await HttpApi.request(
      "/image/getObject",
      (json) => json,
      params: {"objectName": path},
    );
    if (baseResult.code == "2000") newPath = baseResult.result;
    return newPath;
  }

  Future<void> removeItem(List<FilesDownload> removeData) async {
    if (!ref.mounted) return;
    final hashData = removeData.map((item) => item.hash).toSet();
    _pass.removeWhere((item) => hashData.contains(item));
    state = state.map((item) {
      if (hashData.contains(item.hash)) {
        item.status = 5;
      }
      return item;
    }).toList();
  }
}
